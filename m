Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaDGSQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:16:04 -0400
Received: from www312.your-server.de ([188.40.30.91]:59211 "EHLO
	www312.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbaDGSQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:16:00 -0400
X-Greylist: delayed 1020 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2014 14:16:00 EDT
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1085)
Subject: [PATCH] microblaze: restore r4 in sys_rt_sigreturn to fix corruption after signal
From: Richard Theil <linux@rdtheil.de>
Date: Mon, 7 Apr 2014 19:58:51 +0200
Cc: linux-kernel@vger.kernel.org,
        Wolfgang Steinebach <wolfgang.steinebach@siemens.com>,
        Endric Schubert <endric@missinglinkelectronics.com>,
        Uwe Gertheinrich <uwe.gertheinrich@xilinx.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <7C4D11B3-1F5C-4061-8D4E-5AF64C09936E@rdtheil.de>
To: Michal Simek <monstr@monstr.eu>
X-Mailer: Apple Mail (2.1085)
X-Authenticated-Sender: linux@rdtheil.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Theil <linux@rdtheil.de>

As already identified in http://marc.info/?l=microblaze-uclinux&m=126203029729306 ,
the Microblaze signal handling code will corrupt r4 on a signal return. This was never
fixed upstream. ret_from_trap in entry.S expects both r3 and r4, but sys_rt_sigreturn
will only provide r3 by means of a 32-bit return value. The patch explicitly loads r4 instead
of returning a 64 bit compound to avoid surprises from the compiler. Applicable at least
from 3.6 on to today's git master.

Signed-off-by: Richard Theil <linux@rdtheil.de>
---
--- linux-3.13.5/arch/microblaze/kernel/signal.c.orig	2014-02-22 22:35:30.000000000 +0100
+++ linux-3.13.5/arch/microblaze/kernel/signal.c	2014-04-07 19:20:54.282023372 +0200
@@ -105,6 +105,10 @@ asmlinkage long sys_rt_sigreturn(struct
 	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
+	/* after signal, ret_from_trap needs r3 _and_ r4 from context */
+	__asm__ __volatile__("lwi r4,%0,%1"::
+		"r"(regs),"i"(offsetof(struct pt_regs,r4)));
+
 	return rval;
 
 badframe:

