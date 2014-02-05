Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaBEEQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:16:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaBEEQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:16:38 -0500
Date: Tue, 4 Feb 2014 20:16:00 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-b399fe355b30d0102e7690c99e6f764ddfd32ec3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, matz@suse.de, tglx@linutronix.de, bp@suse.de,
        mhocko@suse.cz
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, matz@suse.de, tglx@linutronix.de, bp@suse.de,
        mhocko@suse.cz
In-Reply-To: <1391561711-3023-1-git-send-email-bp@alien8.de>
References: <1391561711-3023-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86:
  Disable generation of traditional x87 instructions
Git-Commit-ID: b399fe355b30d0102e7690c99e6f764ddfd32ec3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 04 Feb 2014 20:16:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b399fe355b30d0102e7690c99e6f764ddfd32ec3
Gitweb:     http://git.kernel.org/tip/b399fe355b30d0102e7690c99e6f764ddfd32ec3
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 5 Feb 2014 01:55:11 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 Feb 2014 20:00:35 -0800

x86: Disable generation of traditional x87 instructions

We recently had the case where wrongly used floating-constant 'E' caused
the generation of traditional x87 instructions in kernel code and
wreaking all kinds of havoc.

Disable the generation of those too. This will save people a lot of time
when trying to debug such issues by erroring out of the build instead of
let them manifest themselves in very spectacular and happy-crappy ways
at runtime.

We're using -mno-fp-ret-in-387 in addition to -mno-80387 (which is ==
-msoft-float) because, as the gcc manpage says:

  On machines where a function returns floating-point results in the
  80387 register stack, some floating-point opcodes may be emitted even
  if -msoft-float is used.

so we want to turn off *all* non-integer instructions involving any
architectural FPU state, unless it is absolutely necessary (and those
cases need special handling anyway).

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Matz <matz@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1391561711-3023-1-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eeda43a..a414b14 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -82,8 +82,8 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
-        # Don't autogenerate MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse
+        # Don't autogenerate traditional x87, MMX or SSE instructions
+        KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387
 
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
