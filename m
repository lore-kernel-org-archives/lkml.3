Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3KNQqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:46:33 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:36854 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab3KNQqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:46:07 -0500
Message-ID: <5284FE48.8040802@linaro.org>
Date: Thu, 14 Nov 2013 22:16:00 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with
 regulators suspended
References: <1382638087-32054-1-git-send-email-nm@ti.com> <CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com> <52824522.7020401@ti.com> <CAKohpomB=wnct88wrTvW-qixLQPQGjVrCVF3V-BSbY7mhsSYQg@mail.gmail.com> <20131113151645.GA17828@kahuna> <52842671.40703@linaro.org> <5284DDB9.7040502@ti.com>
In-Reply-To: <5284DDB9.7040502@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 November 2013 07:57 PM, Nishanth Menon wrote:
> I am guessing this is a little too early for restarting policy here
> considering syscore_ops->resume is pretty early..

Yeah, looks like that..

> http://pastebin.mozilla.org/3602746 is the equivalent patch for v3.12
> http://pastebin.mozilla.org/3602747 is the result.

Can you try this instead of last diff I sent?


diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index dc67fa0..e70e906 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1324,6 +1324,15 @@ static void handle_update(struct work_struct *work)
                container_of(work, struct cpufreq_policy, update);
        unsigned int cpu = policy->cpu;
        pr_debug("handle_update for cpu %u called\n", cpu);
+
+       if (has_target() && !policy->governor_enabled) {
+               if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
+                       (ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
+                       pr_err("%s: Failed to start governor\n", __func__);
+                       goto fail;
+               }
+       }
+
        cpufreq_update_policy(cpu);
 }


