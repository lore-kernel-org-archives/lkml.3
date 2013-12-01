Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab3LACsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 21:48:38 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61285 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3LACse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 21:48:34 -0500
MIME-Version: 1.0
In-Reply-To: <15590294.HtstlaFcjF@vostro.rjw.lan>
References: <0d635c6701654a75f6d25dd435705dc1ede3e19c.1385826776.git.viresh.kumar@linaro.org>
	<15590294.HtstlaFcjF@vostro.rjw.lan>
Date: Sun, 1 Dec 2013 08:18:34 +0530
Message-ID: <CAKohpokRkQn7zQhOVQQmuGZ+QygcwPH1b9z0XmZWgGCjpxk7RA@mail.gmail.com>
Subject: Re: [PATCH 1/5] cpufreq: Introduce cpufreq_notify_post_transition()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 December 2013 01:50, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Saturday, November 30, 2013 09:26:19 PM Viresh Kumar wrote:
>> This introduces another routine cpufreq_notify_post_transition() which can be
>> used to send POSTCHANGE notification for new freq with or without both
>> {PRE|POST}CHANGE notifications for last freq in case of failures. This is useful
>> at multiple places, specially for sending transition failure notifications.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>
>> Hi Rafael,
>>
>> Please see if you want to take it for 3.13 or 14, as this fixes bugs which are
>> partly introduced in 3.13..
>
> Which ones?

Patch:

commit d4019f0a92ab802f385cc9c8ad3ab7b5449712cb
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Wed Aug 14 19:38:24 2013 +0530

    cpufreq: move freq change notifications to cpufreq core

adds:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
+               retval = cpufreq_driver->target_index(policy, index);
+               if (retval)
+                       pr_err("%s: Failed to change cpu frequency: %d\n",
+                                       __func__, retval);
+
+               if (notify) {
+                       /*
+                        * Notify with old freq in case we failed to change
+                        * frequency
+                        */
+                       if (retval)
+                               freqs.new = freqs.old;
+
+                       cpufreq_notify_transition(policy, &freqs,
+                                       CPUFREQ_POSTCHANGE);
+               }


And I thought it might go in 3.13, but surely it doesn't fix any
obvious kernel crashes. It only fixes stuff when target_index() fails.
