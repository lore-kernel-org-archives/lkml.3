Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3F3S4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 14:56:21 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42393 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3F3S4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 14:56:18 -0400
Message-ID: <51D07E7F.2030709@linux.vnet.ibm.com>
Date: Mon, 01 Jul 2013 00:22:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
References: <51C08370.4050906@gmx.de> <CAKohpok1gThXL925Yz5UgC54vTVQgymBA1cLGER_g-dgZu0JLA@mail.gmail.com> <51CF1E53.6060902@gmx.de> <8029836.CFiJCXmRQ0@vostro.rjw.lan> <51D05DF4.50704@linux.vnet.ibm.com> <51D06556.7080204@gmx.de>
In-Reply-To: <51D06556.7080204@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13063018-0260-0000-0000-0000033DB5E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2013 10:35 PM, Toralf Förster wrote:
> On 06/30/2013 06:33 PM, Srivatsa S. Bhat wrote:
>> Toralf, can you please
>> try out the below patch and see if it improves anything? (Don't revert anything,
>> just apply the below diff on a problematic kernel and see if it solves your
>> issue).
> 
> applied on top of a66b2e5 - issue went away (either fixed or hidden now)
> 

Cool! So here is the proper patch, with changelog added.

Regards,
Srivatsa S. Bhat


-----------------------------------------------------------------------------

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume

Toralf Förster reported that the cpufreq ondemand governor behaves erratically
(doesn't scale well) after a suspend/resume cycle. The problem was that the
cpufreq subsystem's idea of the cpu frequencies differed from the actual
frequencies set in the hardware after a suspend/resume cycle. Toralf bisected
the problem to commit a66b2e5 (cpufreq: Preserve sysfs files across
suspend/resume).

Among other (harmless) things, that commit skipped the call to
cpufreq_update_policy() in the resume path. But cpufreq_update_policy() plays
an important role during resume, because it is responsible for checking if
the BIOS changed the cpu frequencies behind our back and resynchronize the
cpufreq subsystem's knowledge of the cpu frequencies, and update them
accordingly.

So, restore the call to cpufreq_update_policy() in the resume path to fix
the cpufreq regression.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq_stats.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index fb65dec..591b6fb 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -349,6 +349,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:


