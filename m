Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3FYS3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:29:13 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:60595 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3FYS3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:29:11 -0400
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
To: tony.luck@intel.com
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de,
        ying.huang@intel.com
Date: Tue, 25 Jun 2013 23:58:59 +0530
Message-ID: <20130625182754.5766.81754.stgit@localhost.localdomain>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C54AF9@ORSMSX106.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F31C54AF9@ORSMSX106.amr.corp.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062518-5490-0000-0000-000003B50E61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,
Thanks - I have included your text in the patch. I wasn't sure if I should add
your Signed-off-by. Kindly review and do the needful.

Thanks,
Naveen

--
Add comments to clarify usage of the various bitfields in the MCA subsystem

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c       |    5 ++++-
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   12 ++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9239504..bf49cdb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -89,7 +89,10 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
-/* MCA banks polled by the period polling timer for corrected events */
+/*
+ * MCA banks polled by the period polling timer for corrected events.
+ * With Intel CMCI, this only has MCA banks which do not support CMCI (if any).
+ */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
 };
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index ae1697c..d5640530 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -24,6 +24,18 @@
  * Also supports reliable discovery of shared banks.
  */
 
+/*
+ * CMCI can be delivered to multiple cpus that share a machine check bank
+ * so we need to designate a single cpu to process errors logged in each bank
+ * in the interrupt handler (otherwise we would have many races and potential
+ * double reporting of the same error).
+ * Note that this can change when a cpu is offlined or brought online since
+ * some MCA banks are shared across cpus. When a cpu is offlined, cmci_clear()
+ * disables CMCI on all banks owned by the cpu and clears this bitfield. At
+ * this point, cmci_rediscover() kicks in and a different cpu may end up
+ * taking ownership of some of the shared MCA banks that were previously
+ * owned by the offlined cpu.
+ */
 static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
 
 /*

