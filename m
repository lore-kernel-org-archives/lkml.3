Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaGCOel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:34:41 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:45813 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaGCOej convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 3 Jul 2014 10:34:39 -0400
Message-Id: <53B5861E02000078000204D1@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Thu, 03 Jul 2014 15:34:38 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix vDSO build
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain ld versions (observed with 2.20.0) put an empty .rela.dyn
section into shared object files, breaking the assumption on the number
of sections to be copied to the final output. Simply discard any empty
SHT_REL and SHT_RELA sections to address this.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso2c.h |    3 +++
 1 file changed, 3 insertions(+)

--- 3.16-rc3/arch/x86/vdso/vdso2c.h
+++ 3.16-rc3-x86-vdso-build/arch/x86/vdso/vdso2c.h
@@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struc
 	uint64_t flags = GET_LE(&in->sh_flags);
 
 	bool copy = flags & SHF_ALLOC &&
+		(GET_LE(&in->sh_size) ||
+		 (GET_LE(&in->sh_type) != SHT_RELA &&
+		  GET_LE(&in->sh_type) != SHT_REL)) &&
 		strcmp(name, ".altinstructions") &&
 		strcmp(name, ".altinstr_replacement");
 



