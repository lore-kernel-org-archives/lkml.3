Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbaCDUN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:13:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbaCDUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.10 85/97] ARM64: unwind: Fix PC calculation
Date: Tue,  4 Mar 2014 12:04:38 -0800
Message-Id: <20140304200348.803488131@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/stacktrace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -48,7 +48,11 @@ int unwind_frame(struct stackframe *fram
 
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


