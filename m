Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaCTIhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:37:51 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59280 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaCTIhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <532AA7A8.3040508@linux.vnet.ibm.com>
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
	<532840FD.308@linux.vnet.ibm.com>
	<CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com>
	<53296870.5010505@linux.vnet.ibm.com>
	<CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
	<53298A7D.3080400@linux.vnet.ibm.com>
	<CAKohpon=VLfPiukzrtQOSVAQg-Z-Aq3+AkZ1myrE6XtVRMY8mQ@mail.gmail.com>
	<532AA7A8.3040508@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 14:07:47 +0530
Message-ID: <CAKohpon-i7LUqALr3Bi1Sn02m93YZpBn3sjmDdo3VQCuW5bNYw@mail.gmail.com>
Subject: Re: [RFC v3] cpufreq: Make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2014 14:02, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 199b52b..5283f10 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -349,6 +349,39 @@ void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>  EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>
>
> +void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
> +               struct cpufreq_freqs *freqs, unsigned int state)
> +{
> +wait:
> +       wait_event(&policy->transition_wait, !policy->transition_ongoing);
> +
> +       mutex_lock(&policy->transition_lock);
> +
> +       if (policy->transition_ongoing) {
> +               mutex_unlock(&policy->transition_lock);
> +               goto wait;
> +       }
> +
> +       policy->transition_ongoing = true;
> +
> +       mutex_unlock(&policy->transition_lock);
> +
> +       cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
> +}
> +
> +void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
> +               struct cpufreq_freqs *freqs, unsigned int state)
> +{
> +       cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
> +
> +       mutex_lock(&policy->transition_lock);

Why do we need locking here? You explained that earlier :)

Also, I would like to add this here:

    WARN_ON(policy->transition_ongoing);

> +       policy->transition_ongoing = false;
> +       mutex_unlock(&policy->transition_lock);
> +
> +       wake_up(&policy->transition_wait);
> +}
