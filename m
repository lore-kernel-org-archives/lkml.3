Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaCHFYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:24:14 -0500
Received: from science.horizon.com ([71.41.210.146]:59991 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750953AbaCHFYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:24:13 -0500
Date: 8 Mar 2014 00:24:10 -0500
Message-ID: <20140308052410.14411.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@zytor.com
Subject: Re: [GIT PULL] x86 fixes for v3.14-rc6
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, sbsiddha@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The FPU stuff is still pending, I fear.  I haven't heard anything from
> Suresh so I suspect I'm going to have to dig into the init specifics
> myself and fix up the patchset.

As I mentioned a couple of weeks ago in the "[PATCH] Make
math_state_restore() save and restore the interrupt flag" thread,
I've been running with just Suresh's second patch for the last month,
and it's cured all my symptoms.

Although, just as a minor style point, I might reduce the
number of levels if indentation by rewriting it as:

 void __kernel_fpu_end(void)
 {
-	if (use_eager_fpu())
-		math_state_restore();
-	else
+	if (!use_eager_fpu()) {
 		stts();
+	} else if (likely(tsk_used_math(current)))
+		math_state_restore();
+	}
+	/*
+	 * When using eager fpu, tsk_used_math() is almost always true,
+	 * and we restore the user math state eagerly. In some special
+	 * cases during thread exit, signal handling etc, tsk_used_math()
+	 * is false. Those few places will take proper actions, so we
+	 * don't need to restore the math here.
+	 */
 }
 EXPORT_SYMBOL(__kernel_fpu_end);

Truthfully, the idea I like best is Linus's proposal to postpone all
such adjustments to the processor state until the return to user space,
so multiple kernel_fpu_begin()/_end() pairs become much cheaper:
http://marc.info/?l=linux-kernel&m=139128398717816

Hoerver, that deep into Here Be Dragons code is somewhere I fear to tread,
so I'm hoping someone braver than I is inspired.
