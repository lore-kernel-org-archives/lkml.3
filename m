Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967341Ab3HIB6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967140Ab3HIB6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 001/102] ARM: poison the vectors page
Date: Thu,  8 Aug 2013 18:56:37 -0700
Message-Id: <20130809015010.545105906@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit f928d4f2a86f46b030fa0850385b4391fc2b5918 upstream.

Fill the empty regions of the vectors page with an exception generating
instruction.  This ensures that any inappropriate branch to the vector
page is appropriately trapped, rather than just encountering some code
to execute.  (The vectors page was filled with zero before, which
corresponds with the "andeq r0, r0, r0" instruction - a no-op.)

Acked-by Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/traps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -817,10 +817,20 @@ void __init early_trap_init(void *vector
 	extern char __vectors_start[], __vectors_end[];
 	extern char __kuser_helper_start[], __kuser_helper_end[];
 	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+	unsigned i;
 
 	vectors_page = vectors_base;
 
 	/*
+	 * Poison the vectors page with an undefined instruction.  This
+	 * instruction is chosen to be undefined for both ARM and Thumb
+	 * ISAs.  The Thumb version is an undefined instruction with a
+	 * branch back to the undefined instruction.
+	 */
+	for (i = 0; i < PAGE_SIZE / sizeof(u32); i++)
+		((u32 *)vectors_base)[i] = 0xe7fddef1;
+
+	/*
 	 * Copy the vectors, stubs and kuser helpers (in entry-armv.S)
 	 * into the vector page, mapped at 0xffff0000, and ensure these
 	 * are visible to the instruction stream.


