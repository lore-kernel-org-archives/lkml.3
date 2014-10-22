Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaJVVgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:36:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:39476 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbaJVVgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:36:08 -0400
Date: Wed, 22 Oct 2014 23:36:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Paris <eparis@redhat.com>
cc: Paulo Zanoni <przanoni@gmail.com>, Richard Guy Briggs <rgb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: Regression: audit: x86: drop arch from __audit_syscall_entry()
 interface
In-Reply-To: <1414002190.30946.95.camel@localhost>
Message-ID: <alpine.DEB.2.11.1410222323500.5308@nanos>
References: <CA+gsUGSiXf2gpB8QQOQOmgxFc8mx31V6qeRqow6aXO1195jWEA@mail.gmail.com> <1414002190.30946.95.camel@localhost>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Eric Paris wrote:

> That's really serious.  Looking now.

Indeed its serious. And it's even more serious as this masterpiece of
assembly wreckage was pulled in via your tree w/o having an acked-by
one of the x86 maintainers.

> On Wed, 2014-10-22 at 16:08 -0200, Paulo Zanoni wrote:
> > commit b4f0d3755c5e9cc86292d5fd78261903b4f23d4a
> > Author: Richard Guy Briggs
> > Date:   Tue Mar 4 10:38:06 2014 -0500
> >     audit: x86: drop arch from __audit_syscall_entry() interface
> > 
> > According to our QA, their i386 machine doesn't boot anymore. I tried
> > to write my own revert for the patch, asked QA to test, and they
> > confirmed it "solves" the problem.

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 0d0c9d4ab6d5..f9e3fabc8716 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -449,12 +449,11 @@ sysenter_audit:
 	jnz syscall_trace_entry
 	addl $4,%esp
 	CFI_ADJUST_CFA_OFFSET -4
-	/* %esi already in 8(%esp)	   6th arg: 4th syscall arg */
-	/* %edx already in 4(%esp)	   5th arg: 3rd syscall arg */
-	/* %ecx already in 0(%esp)	   4th arg: 2nd syscall arg */
-	movl %ebx,%ecx			/* 3rd arg: 1st syscall arg */
-	movl %eax,%edx			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_I386,%eax	/* 1st arg: audit arch */
+	movl %esi,4(%esp)		/* 5th arg: 4th syscall arg */
+	movl %edx,(%esp)		/* 4th arg: 3rd syscall arg */

Bilndly overwriting the stack which holds the syscall arguments is
really a brilliant way to ensure security.

Thanks,

	tglx


