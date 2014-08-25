Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaHYKlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:41:23 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:54595 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaHYKlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:41:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokMXSC_oTbg1b0adPxFsht7aZJd61YwSpzqsUi=KOAwXw@mail.gmail.com>
References: <1408015178-21745-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
	<CAKohponDNHYrD9b==cp+pVmAi2ygA9-HcLZWqr4w3DDivB=-Ng@mail.gmail.com>
	<53F57E51.4060200@gmail.com>
	<CAKohpon8ANWoy52B=_nSuNyHALrsQOLX4cA+690E=CifnVRFtg@mail.gmail.com>
	<53F6AF66.10204@linux.vnet.ibm.com>
	<CAKohpokMXSC_oTbg1b0adPxFsht7aZJd61YwSpzqsUi=KOAwXw@mail.gmail.com>
Date: Mon, 25 Aug 2014 16:11:21 +0530
Message-ID: <CAKohponpWL1Wjo=HcDrwDYvuykRVPMVSeEzKDWg1Mi075c8KEA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: powernv: Register the driver with reboot notifier
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Shilpasri G Bhat <shilpabhatppc@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 August 2014 16:00, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Its not that I am doubting if this will work or not. But this Hack is using
> routines not meant for this purpose. And that being a core routine,
> things aren't that straightforward anymore.

Well if you want a working HACK for solving this, what about following ?

diff --git a/drivers/cpufreq/powernv-cpufreq.c
b/drivers/cpufreq/powernv-cpufreq.c
index af49688..d6a1742 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -34,6 +34,7 @@
 #define POWERNV_MAX_PSTATES    256

 static struct cpufreq_frequency_table powernv_freqs[POWERNV_MAX_PSTATES+1];
+static bool rebooting;

 /*
  * Note: The set of pstates consists of contiguous integers, the
@@ -283,6 +284,9 @@ static int powernv_cpufreq_target_index(struct
cpufreq_policy *policy,
 {
        struct powernv_smp_call_data freq_data;

+       if (unlikely(rebooting))
+               return -EBUSY;
+
        freq_data.pstate_id = powernv_freqs[new_index].driver_data;

        /*
@@ -317,6 +321,19 @@ static struct cpufreq_driver powernv_cpufreq_driver = {
        .attr           = powernv_cpu_freq_attr,
 };

+static int powernv_cpufreq_reboot_notifier(struct notifier_block *nb,
+               unsigned long action, void *unused)
+{
+       /* TODO: Get policy & index */
+       powernv_cpufreq_target_index(policy, index);
+       rebooting = true;
+       return NOTIFY_DONE;
+}
+
+static struct notifier_block powernv_cpufreq_reboot_nb = {
+       .notifier_call = powernv_cpufreq_reboot_notifier,
+};
+
 static int __init powernv_cpufreq_init(void)
 {
        int rc = 0;
@@ -328,12 +345,15 @@ static int __init powernv_cpufreq_init(void)
                return rc;
        }

-       return cpufreq_register_driver(&powernv_cpufreq_driver);
+       rc = cpufreq_register_driver(&powernv_cpufreq_driver);
+       register_reboot_notifier(&powernv_cpufreq_reboot_nb);
+       return rc;
 }
 module_init(powernv_cpufreq_init);

 static void __exit powernv_cpufreq_exit(void)
 {
+       unregister_reboot_notifier(&powernv_cpufreq_reboot_nb);
        cpufreq_unregister_driver(&powernv_cpufreq_driver);
 }
 module_exit(powernv_cpufreq_exit);
