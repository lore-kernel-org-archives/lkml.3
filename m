Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaDCQ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:28:51 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:23906 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaDCQ2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:28:46 -0400
X-AuditID: cbfec372-b7fa96d000006a7b-af-533d8c3d25c8
Date: Thu, 03 Apr 2014 13:28:38 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL for v3.15-rc1] sb_edac patches
Message-id: <20140403132838.32db1794@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/hQF3bHttgg99ThSzmrF/DZvF5wz82
	i6vLzjJZXDjVwGRxedccNotHfW/ZHdg8vrf2sXicmPGbxePzJjmPKYfaWQJYorhsUlJzMstS
	i/TtErgyGnsfMhacEq9YffMxUwPjMeEuRk4OCQETid/NHawQtpjEhXvr2boYuTiEBJYwShw5
	e5wNJCEk0Mck0bQ8t4uRg4NFQFXi8zUnkDCbgJHEq8YWsF4RIPvziyusIL3MAu8YJa7duQaW
	EBYwlGhc084I0ssLZM+bVQuxy0ni1evJTCA2r4CgxI/J91hAbGYBLYnN25pYIWxtiSfvLrBO
	YOSbhaRsFpKyWUjKFjAyr2IULS1OLihOSs811CtOzC0uzUvXS87P3cQICc+iHYzPNlgdYhTg
	YFTi4eVItw0WYk0sK67MPcQowcGsJMLb2gYU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwHiRwaDo
	waNo/e0frNUay3L/WR1Uaa6eYe3+ucn0iGpGjEEoy2wu5eMiV5/OyCuqejrvOnPcU18JJTZO
	zzC95i/FxuFlE+7nTjwwO6Nu1s82vZ7/NdEnau6fP6+54V2VnVe7wtmoHostAtpuxyekxAcf
	yjATL/NsvnnrxN6p58t262p8k+PqUWIpzkg01GIuKk4EANUIf/8tAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

>From a couple sb_edac driver improvements, cleaning a little bit the
amount of data sent to dmesg, and fixing one error message.

Thanks!
Mauro

- 

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

for you to fetch changes up to 49856dc973cd95d85ac1cab6c70410d8331e5c04:

  sb_edac: mark MCE messages as KERN_DEBUG (2014-03-13 09:52:09 -0300)

----------------------------------------------------------------
Aristeu Rozanski (2):
      sb_edac: use "event" instead of "exception" when MC wasnt signaled
      sb_edac: mark MCE messages as KERN_DEBUG

 drivers/edac/sb_edac.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

As the changes are small, I'm adding also the full diff.

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 54e2abe671f7..7b128e447965 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1828,6 +1828,7 @@ static int sbridge_mce_check_error(struct notifier_block *nb, unsigned long val,
 	struct mce *mce = (struct mce *)data;
 	struct mem_ctl_info *mci;
 	struct sbridge_pvt *pvt;
+	char *type;
 
 	if (get_edac_report_status() == EDAC_REPORTING_DISABLED)
 		return NOTIFY_DONE;
@@ -1846,17 +1847,23 @@ static int sbridge_mce_check_error(struct notifier_block *nb, unsigned long val,
 	if ((mce->status & 0xefff) >> 7 != 1)
 		return NOTIFY_DONE;
 
-	printk("sbridge: HANDLING MCE MEMORY ERROR\n");
+	if (mce->mcgstatus & MCG_STATUS_MCIP)
+		type = "Exception";
+	else
+		type = "Event";
+
+	sbridge_mc_printk(mci, KERN_DEBUG, "HANDLING MCE MEMORY ERROR\n");
 
-	printk("CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
-	       mce->extcpu, mce->mcgstatus, mce->bank, mce->status);
-	printk("TSC %llx ", mce->tsc);
-	printk("ADDR %llx ", mce->addr);
-	printk("MISC %llx ", mce->misc);
+	sbridge_mc_printk(mci, KERN_DEBUG, "CPU %d: Machine Check %s: %Lx "
+			  "Bank %d: %016Lx\n", mce->extcpu, type,
+			  mce->mcgstatus, mce->bank, mce->status);
+	sbridge_mc_printk(mci, KERN_DEBUG, "TSC %llx ", mce->tsc);
+	sbridge_mc_printk(mci, KERN_DEBUG, "ADDR %llx ", mce->addr);
+	sbridge_mc_printk(mci, KERN_DEBUG, "MISC %llx ", mce->misc);
 
-	printk("PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
-		mce->cpuvendor, mce->cpuid, mce->time,
-		mce->socketid, mce->apicid);
+	sbridge_mc_printk(mci, KERN_DEBUG, "PROCESSOR %u:%x TIME %llu SOCKET "
+			  "%u APIC %x\n", mce->cpuvendor, mce->cpuid,
+			  mce->time, mce->socketid, mce->apicid);
 
 	/* Only handle if it is the right mc controller */
 	if (cpu_data(mce->cpu).phys_proc_id != pvt->sbridge_dev->mc)


-- 

Regards,
Mauro
