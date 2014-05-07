Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaEGVF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:05:59 -0400
Received: from ns.horizon.com ([71.41.210.147]:56247 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750793AbaEGVFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:05:54 -0400
Date: 7 May 2014 17:05:52 -0400
Message-ID: <20140507210552.7581.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: arjan@linux.intel.com, hpa@linux.intel.com, tj@kernel.org, x86@kernel.org
Subject: [PATCH RESEND] Fix stack protector Makefile breakage on x86_64
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
In-Reply-To: <20140319104323.517.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are using a 64-bit kernel with 32-bit userland, then
scripts/gcc-x86_64-has-stack-protector.sh invokes 32-bit gcc
with -mcmodel=kernel, which produces:

<stdin>:1:0: error: code model 'kernel' not supported in the 32 bit mode

and trips the "broken compiler" test at arch/x86/Makefile:120.

There are several places a fix is possible, but the following seems
cleanest.  (But it's minimal; it would also be possible to factor
out a bunch of stuff from the two branches of the if.)

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: <stable@vger.kernel.org> # 3.14.x
---
Originally sent March 19 (but elicited no response), this is still an
issue with 3.15-rc4, and still applies without changes.

Sending to some general Linux-x86 people as well as the authors of the
stack-protector patch that caused the problem.  Feel free to fix it a
different way, but could we please fix it?


diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eeda43abed..c6c61361c3 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -79,6 +79,7 @@ else
         UTS_MACHINE := x86_64
         CHECKFLAGS += -D__x86_64__ -m64
 
+        biarch := -m64
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64

