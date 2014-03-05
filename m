Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbaCEPDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:03:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41194 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbaCEO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olof Johansson <olof@lixom.net>, Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 097/131] ARM64: unwind: Fix PC calculation
Date: Wed,  5 Mar 2014 14:23:41 +0000
Message-Id: <1394029455-23128-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olof Johansson <olof@lixom.net>

commit e306dfd06fcb44d21c80acb8e5a88d55f3d1cf63 upstream.

The frame PC value in the unwind code used to just take the saved LR
value and use that.  That's incorrect as a stack trace, since it shows
the return path stack, not the call path stack.

In particular, it shows faulty information in case the bl is done as
the very last instruction of one label, since the return point will be
in the next label. That can easily be seen with tail calls to panic(),
which is marked __noreturn and thus doesn't have anything useful after it.

Easiest here is to just correct the unwind code and do a -4, to get the
actual call site for the backtrace instead of the return site.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/stacktrace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d25459f..048334b 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -48,7 +48,11 @@ int unwind_frame(struct stackframe *frame)
 
 	frame->sp = fp + 0x10;
 	frame->fp = *(unsigned long *)(fp);
-	frame->pc = *(unsigned long *)(fp + 8);
+	/*
+	 * -4 here because we care about the PC at time of bl,
+	 * not where the return will go.
+	 */
+	frame->pc = *(unsigned long *)(fp + 8) - 4;
 
 	return 0;
 }
-- 
1.9.0

