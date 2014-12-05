Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaLEXv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:51:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaLEWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 004/122] MIPS: tlb-r4k: Add missing HTW stop/start sequences
Date: Fri,  5 Dec 2014 14:42:58 -0800
Message-Id: <20141205223306.211709248@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 6a8dff6ab16c903b0d8ef5fbf21543f39bf5d675 upstream.

HTW needs to stop and start again whenever the EntryHI register
changes otherwise an inflight HTW operation might use the new
EntryHI register for updating an old entry and that could lead
to crashes or even a machine check exception. We fix this by
ensuring the HTW has stop whenever the EntryHI register is about
to change

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8511/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/tlb-r4k.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -299,6 +299,7 @@ void __update_tlb(struct vm_area_struct
 
 	local_irq_save(flags);
 
+	htw_stop();
 	pid = read_c0_entryhi() & ASID_MASK;
 	address &= (PAGE_MASK << 1);
 	write_c0_entryhi(address | pid);
@@ -346,6 +347,7 @@ void __update_tlb(struct vm_area_struct
 			tlb_write_indexed();
 	}
 	tlbw_use_hazard();
+	htw_start();
 	flush_itlb_vm(vma);
 	local_irq_restore(flags);
 }
@@ -422,6 +424,7 @@ __init int add_temporary_entry(unsigned
 
 	local_irq_save(flags);
 	/* Save old context and create impossible VPN2 value */
+	htw_stop();
 	old_ctx = read_c0_entryhi();
 	old_pagemask = read_c0_pagemask();
 	wired = read_c0_wired();
@@ -443,6 +446,7 @@ __init int add_temporary_entry(unsigned
 
 	write_c0_entryhi(old_ctx);
 	write_c0_pagemask(old_pagemask);
+	htw_start();
 out:
 	local_irq_restore(flags);
 	return ret;


