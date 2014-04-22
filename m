Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbaDVK6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:58:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47133 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754432AbaDVK6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:58:14 -0400
Date: Tue, 22 Apr 2014 07:57:44 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH 04/28] nios2: Exception handling
Message-ID: <20140422105744.GA589@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-4-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397824031-4892-4-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ley Foon,

On Apr 18, Ley Foon Tan wrote:
> +
> +	/* Get thread info pointer */
> +	movi	r11, %lo(0xfffff000)
> +	and	r11, sp, r11
> +	ldw	r11, TI_FLAGS(r11)
> +
> +	/* If someone is ptrace:ing us, take the long way. */
> +	BTBNZ	r11, r11, TIF_SYSCALL_TRACE, traced_system_call
> +

Are you sure this is correct? Have you tested this works correctly?

Last time I tested this, it caused the traced_system_call to be taken
for every system call. I already reported and provided a patch a few
months ago:

http://lists.rocketboards.org/pipermail/nios2-dev/2014-January/006968.html

Here's my proposed fix:

diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
index 9cf2bac..3798008 100644
--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -204,13 +204,10 @@ ENTRY(handle_system_call)
 	ldw	r1, %lo(sys_call_table)(r1)
 	beq	r1, r0, ret_invsyscall
 
-	/* Get thread info pointer */
-	movi	r11, %lo(0xfffff000)
-	and	r11, sp, r11
-	ldw	r11, TI_FLAGS(r11)
-
-	/* If someone is ptrace:ing us, take the long way. */
-	BTBNZ	r11, r11, TIF_SYSCALL_TRACE, traced_system_call
+	/* Check if we are being traced */
+	GET_THREAD_INFO r11
+	ldw	r11,TI_FLAGS(r11)
+	BTBNZ	r11,r11,TIF_SYSCALL_TRACE,traced_system_call
 
 	/* Execute the system call */
 	callr	r1
-- 
1.9.1

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
