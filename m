Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3EGEbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:31:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598Ab3EGEZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:56 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BjsHdr9HZGUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=LMQehNpP4YgA:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=nud6eEneM3EXIc4brzAA:9 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rCkspBme_VY6GRCP:21 a=Dz-jmAMIEImGTFPJ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035852.437907349@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Honig <ahonig@google.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [069/126] KVM: Fix bounds checking in ioapic indirect register reads
 (CVE-2013-1798)
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0069-KVM-Fix-bounds-checking-in-ioapic-indirect-register-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

[ Upstream commit a2c118bfab8bc6b8bb213abfc35201e441693d55 ]

If the guest specifies a IOAPIC_REG_SELECT with an invalid value and follows
that with a read of the IOAPIC_REG_WINDOW KVM does not properly validate
that request.  ioapic_read_indirect contains an
ASSERT(redir_index < IOAPIC_NUM_PINS), but the ASSERT has no effect in
non-debug builds.  In recent kernels this allows a guest to cause a kernel
oops by reading invalid memory.  In older kernels (pre-3.3) this allows a
guest to read from large ranges of host memory.

Tested: tested against apic unit tests.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 virt/kvm/ioapic.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index ef61d52..92b1e28 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -73,9 +73,12 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 			u32 redir_index = (ioapic->ioregsel - 0x10) >> 1;
 			u64 redir_content;
 
-			ASSERT(redir_index < IOAPIC_NUM_PINS);
+			if (redir_index < IOAPIC_NUM_PINS)
+				redir_content =
+					ioapic->redirtbl[redir_index].bits;
+			else
+				redir_content = ~0ULL;
 
-			redir_content = ioapic->redirtbl[redir_index].bits;
 			result = (ioapic->ioregsel & 0x1) ?
 			    (redir_content >> 32) & 0xffffffff :
 			    redir_content & 0xffffffff;
-- 
1.7.10.4


