Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaKSK5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:57:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKSK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:57:51 -0500
Date: Wed, 19 Nov 2014 02:57:30 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-68c009c4137927fd4ffd3e653bb5209d752c1d42@git.kernel.org>
Cc: dave@sr71.net, dave.hansen@linux.intel.com, tglx@linutronix.de,
        hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org
Reply-To: dave@sr71.net, hpa@zytor.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org
In-Reply-To: <20141118182343.C3E0C629@viggo.jf.intel.com>
References: <20141118182343.C3E0C629@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86 mpx: Change return type of get_reg_offset()
Git-Commit-ID: 68c009c4137927fd4ffd3e653bb5209d752c1d42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68c009c4137927fd4ffd3e653bb5209d752c1d42
Gitweb:     http://git.kernel.org/tip/68c009c4137927fd4ffd3e653bb5209d752c1d42
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Tue, 18 Nov 2014 10:23:43 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Nov 2014 11:54:12 +0100

x86 mpx: Change return type of get_reg_offset()

get_reg_offset() used to return the register contents themselves
instead of the register offset.  When it did that, it was an
unsigned long.  I changed it to return an integer _offset_
instead of the register.  But, I neglected to change the return
type of the function or the variables in which we store the
result of the call.

This fixes up the code to clear up the warnings from the smatch
bot:

New smatch warnings:
arch/x86/mm/mpx.c:178 mpx_get_addr_ref() warn: unsigned 'addr_offset' is never less than zero.
arch/x86/mm/mpx.c:184 mpx_get_addr_ref() warn: unsigned 'base_offset' is never less than zero.
arch/x86/mm/mpx.c:188 mpx_get_addr_ref() warn: unsigned 'indx_offset' is never less than zero.
arch/x86/mm/mpx.c:196 mpx_get_addr_ref() warn: unsigned 'addr_offset' is never less than zero.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141118182343.C3E0C629@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/mpx.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
index f30b48e..67ebf57 100644
--- a/arch/x86/mm/mpx.c
+++ b/arch/x86/mm/mpx.c
@@ -102,8 +102,8 @@ enum reg_type {
 	REG_TYPE_BASE,
 };
 
-static unsigned long get_reg_offset(struct insn *insn, struct pt_regs *regs,
-				    enum reg_type type)
+static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
+			  enum reg_type type)
 {
 	int regno = 0;
 
@@ -174,9 +174,8 @@ static unsigned long get_reg_offset(struct insn *insn, struct pt_regs *regs,
  */
 static void __user *mpx_get_addr_ref(struct insn *insn, struct pt_regs *regs)
 {
-	unsigned long addr, addr_offset;
-	unsigned long base, base_offset;
-	unsigned long indx, indx_offset;
+	unsigned long addr, base, indx;
+	int addr_offset, base_offset, indx_offset;
 	insn_byte_t sib;
 
 	insn_get_modrm(insn);
