Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3FYRqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:46:52 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37807 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3FYRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:46:50 -0400
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
To: tony.luck@intel.com, bp@alien8.de
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Date: Tue, 25 Jun 2013 23:16:32 +0530
Message-ID: <20130625174536.5226.66421.stgit@localhost.localdomain>
In-Reply-To: <20130621174057.GI22006@pd.tnic>
References: <20130621174057.GI22006@pd.tnic>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062517-1618-0000-0000-000004269BE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony, Boris,
Can you please see if the comments in the below patch include the details you
were expecting?

Thanks,
Naveen

--
Add comments to clarify usage of the various bitfields in the MCA subsystem

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c       |    5 ++++-
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    9 +++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

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
index ae1697c..2816f53 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -24,6 +24,15 @@
  * Also supports reliable discovery of shared banks.
  */
 
+/*
+ * Indicates MCA banks controlled by the current cpu for CMCI. Note that this
+ * can change when a cpu is offlined or brought online since some MCA banks
+ * are shared across cpus. When a cpu is offlined, cmci_clear() disables CMCI
+ * on all banks owned by the cpu and clears this bitfield. At this point,
+ * cmci_rediscover() kicks in and a different cpu may end up taking
+ * ownership of some of the shared MCA banks that were previously owned
+ * by the offlined cpu.
+ */
 static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
 
 /*

