Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaCTIdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:33:11 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42086 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaCTIdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:33:07 -0400
Message-ID: <532AA7A8.3040508@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 14:02:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Subject: Re: [RFC v3] cpufreq: Make sure frequency transitions are serialized
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org> <532840FD.308@linux.vnet.ibm.com> <CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com> <53296870.5010505@linux.vnet.ibm.com> <CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com> <53298A7D.3080400@linux.vnet.ibm.com> <CAKohpon=VLfPiukzrtQOSVAQg-Z-Aq3+AkZ1myrE6XtVRMY8mQ@mail.gmail.com>
In-Reply-To: <CAKohpon=VLfPiukzrtQOSVAQg-Z-Aq3+AkZ1myrE6XtVRMY8mQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032008-3568-0000-0000-00000520D0A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 10:09 AM, Viresh Kumar wrote:
> On 19 March 2014 17:45, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 199b52b..e90388f 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -349,6 +349,38 @@ void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>>  EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>>
>>
>> +void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
>> +               struct cpufreq_freqs *freqs, unsigned int state)
>> +{
>> +wait:
>> +       wait_event(&policy->transition_wait, !policy->transition_ongoing);
> 
> I think its broken here. At this point another thread can come take lock,
> update transition_ongoing, send notification and finally unlock..
> 
> And after that we can take the lock and send another notification..
> 
> Correct?
> 

Good catch! I missed that yesterday. Please find the updated patch below,
with all your suggestions incorporated. Does this version look any better?

------------------------------------------------------------------------

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 199b52b..5283f10 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -349,6 +349,39 @@ void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
 EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
 
 
+void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, unsigned int state)
+{
+wait:
+	wait_event(&policy->transition_wait, !policy->transition_ongoing);
+
+	mutex_lock(&policy->transition_lock);
+
+	if (policy->transition_ongoing) {
+		mutex_unlock(&policy->transition_lock);
+		goto wait;
+	}
+
+	policy->transition_ongoing = true;
+
+	mutex_unlock(&policy->transition_lock);
+
+	cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
+}
+
+void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, unsigned int state)
+{
+	cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
+
+	mutex_lock(&policy->transition_lock);
+	policy->transition_ongoing = false;
+	mutex_unlock(&policy->transition_lock);
+
+	wake_up(&policy->transition_wait);
+}
+
+
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
@@ -968,6 +1001,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)
 
 	INIT_LIST_HEAD(&policy->policy_list);
 	init_rwsem(&policy->rwsem);
+	mutex_init(&policy->transition_lock);
+	init_waitqueue_head(&policy->transition_wait);
 
 	return policy;
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4d89e0e..8bded24 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -101,6 +101,11 @@ struct cpufreq_policy {
 	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
 	 */
 	struct rw_semaphore	rwsem;
+
+	/* Synchronization for frequency transitions */
+	bool			transition_ongoing; /* Tracks transition status */
+	struct mutex		transition_lock;
+	wait_queue_head_t	transition_wait;
 };
 
 /* Only for ACPI */

