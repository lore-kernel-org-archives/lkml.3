Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab3EGNlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42381 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088Ab3EGNlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephan Schreiber <info@fs-driver.org>, Tony Luck <tony.luck@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 066/118] Wrong asm register contraints in the kvm implementation
Date: Tue,  7 May 2013 14:38:32 +0100
Message-Id: <1367933964-1564-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Schreiber <info@fs-driver.org>

commit de53e9caa4c6149ef4a78c2f83d7f5b655848767 upstream.

The Linux Kernel contains some inline assembly source code which has
wrong asm register constraints in arch/ia64/kvm/vtlb.c.

I observed this on Kernel 3.2.35 but it is also true on the most
recent Kernel 3.9-rc1.

File arch/ia64/kvm/vtlb.c:

u64 guest_vhpt_lookup(u64 iha, u64 *pte)
{
	u64 ret;
	struct thash_data *data;

	data = __vtr_lookup(current_vcpu, iha, D_TLB);
	if (data != NULL)
		thash_vhpt_insert(current_vcpu, data->page_flags,
			data->itir, iha, D_TLB);

	asm volatile (
			"rsm psr.ic|psr.i;;"
			"srlz.d;;"
			"ld8.s r9=[%1];;"
			"tnat.nz p6,p7=r9;;"
			"(p6) mov %0=1;"
			"(p6) mov r9=r0;"
			"(p7) extr.u r9=r9,0,53;;"
			"(p7) mov %0=r0;"
			"(p7) st8 [%2]=r9;;"
			"ssm psr.ic;;"
			"srlz.d;;"
			"ssm psr.i;;"
			"srlz.d;;"
			: "=r"(ret) : "r"(iha), "r"(pte):"memory");

	return ret;
}

The list of output registers is
			: "=r"(ret) : "r"(iha), "r"(pte):"memory");
The constraint "=r" means that the GCC has to maintain that these vars
are in registers and contain valid info when the program flow leaves
the assembly block (output registers).
But "=r" also means that GCC can put them in registers that are used
as input registers. Input registers are iha, pte on the example.
If the predicate p7 is true, the 8th assembly instruction
			"(p7) mov %0=r0;"
is the first one which writes to a register which is maintained by the
register constraints; it sets %0. %0 means the first register operand;
it is ret here.
This instruction might overwrite the %2 register (pte) which is needed
by the next instruction:
			"(p7) st8 [%2]=r9;;"
Whether it really happens depends on how GCC decides what registers it
uses and how it optimizes the code.

The attached patch  fixes the register operand constraints in
arch/ia64/kvm/vtlb.c.
The register constraints should be
			: "=&r"(ret) : "r"(iha), "r"(pte):"memory");
The & means that GCC must not use any of the input registers to place
this output register in.

This is Debian bug#702639
(http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=702639).

The patch is applicable on Kernel 3.9-rc1, 3.2.35 and many other versions.

Signed-off-by: Stephan Schreiber <info@fs-driver.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/ia64/kvm/vtlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index 4332f7e..a7869f8 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -256,7 +256,7 @@ u64 guest_vhpt_lookup(u64 iha, u64 *pte)
 			"srlz.d;;"
 			"ssm psr.i;;"
 			"srlz.d;;"
-			: "=r"(ret) : "r"(iha), "r"(pte):"memory");
+			: "=&r"(ret) : "r"(iha), "r"(pte) : "memory");
 
 	return ret;
 }
-- 
1.8.1.2

