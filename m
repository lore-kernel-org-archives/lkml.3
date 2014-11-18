Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaKRSX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:23:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:6817 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbaKRSX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:23:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,411,1413270000"; 
   d="scan'208";a="634016175"
Subject: [PATCH 1/3] x86 mpx: change return type of get_reg_offset()
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Tue, 18 Nov 2014 10:23:43 -0800
References: <20141118182342.64D1B3A5@viggo.jf.intel.com>
In-Reply-To: <20141118182342.64D1B3A5@viggo.jf.intel.com>
Message-Id: <20141118182343.C3E0C629@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

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
Cc: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
---

 b/arch/x86/mm/mpx.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/mpx.c~mpx_get_addr_ref-as-int arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~mpx_get_addr_ref-as-int	2014-11-18 09:14:18.630053592 -0800
+++ b/arch/x86/mm/mpx.c	2014-11-18 09:14:18.633053728 -0800
@@ -102,8 +102,8 @@ enum reg_type {
 	REG_TYPE_BASE,
 };
 
-static unsigned long get_reg_offset(struct insn *insn, struct pt_regs *regs,
-				    enum reg_type type)
+static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
+			  enum reg_type type)
 {
 	int regno = 0;
 
@@ -174,9 +174,8 @@ static unsigned long get_reg_offset(stru
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
_
