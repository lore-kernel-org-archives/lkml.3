Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaCTEj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:39:58 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43271 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaCTEj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:39:27 -0400
MIME-Version: 1.0
In-Reply-To: <53298A7D.3080400@linux.vnet.ibm.com>
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
	<532840FD.308@linux.vnet.ibm.com>
	<CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com>
	<53296870.5010505@linux.vnet.ibm.com>
	<CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
	<53298A7D.3080400@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 10:09:26 +0530
Message-ID: <CAKohpon=VLfPiukzrtQOSVAQg-Z-Aq3+AkZ1myrE6XtVRMY8mQ@mail.gmail.com>
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

On 19 March 2014 17:45, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 199b52b..e90388f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -349,6 +349,38 @@ void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>  EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>
>
> +void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
> +               struct cpufreq_freqs *freqs, unsigned int state)
> +{
> +wait:
> +       wait_event(&policy->transition_wait, !policy->transition_ongoing);

I think its broken here. At this point another thread can come take lock,
update transition_ongoing, send notification and finally unlock..

And after that we can take the lock and send another notification..

Correct?

> +       if (!mutex_trylock(&policy->transition_lock))
> +               goto wait;
> +
> +       policy->transition_ongoing++;

s/++/ = true

> +       cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
> +
> +       mutex_unlock(&policy->transition_lock);

We can release the lock before sending notifications, its there just to
protect transition_ongoing.
