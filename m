Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3ERCVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:21:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9220 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab3ERCQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:54 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0PnfzttxBnAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=dRt1EtP7gYoA:10 a=D2qVnT_2AAAA:8 a=xNf9USuDAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=rsTyOSGELIYBeV9lphYA:9 a=vTgjaVwSMjsA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021648.546839127@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephan Schreiber <info@fs-driver.org>, Tony Luck <tony.luck@intel.com>
Subject: [ 042/136 ] Wrong asm register contraints in the kvm implementation
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0042-Wrong-asm-register-contraints-in-the-kvm-implementat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stephan Schreiber <info@fs-driver.org>

[ Upstream commit de53e9caa4c6149ef4a78c2f83d7f5b655848767 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/ia64/kvm/vtlb.c |    2 +-
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
1.7.10.4


