Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbbAQATi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:19:38 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37504 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbAQATg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:19:36 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/3] x86_64,entry: Rearrange the syscall exit optimizations
Date: Fri, 16 Jan 2015 16:19:26 -0800
Message-Id: <cover.1421453410.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, I suspect you'll either like or hate this series.  Or maybe
you'll think it's crazy but you'll like it anyway.  I'm curious
which of those is the case. :)

The syscall exit asm is a big mess.  There's a really fast path, some
kind of fast path code (with a hard-coded optimization for audit), and
the really slow path.  The result is that it's very hard to work with
this code.  There are some asm paths that are much slower than they
should be (context tracking is a major offender), but no one really
wants to add even more asm to speed them up.

This series takes a different, unorthodox approach.  Rather than trying
to avoid entering the very slow iret path, it adds a way back out of the
iret path.  The result is a dramatic speedup for context tracking, user
return notification, and similar code, as the cost of a few lines of
tricky asm.  Nonetheless, it's barely a net addition of asm code,
because we get to remove the fast path optimizations for audit and
rescheduling.

Thoughts?  If this works, it opens the door for a lot of further
consolidation of the exit code.

Note: patch 1 in this series has been floating around on the list
for quite a while.  It's mandatory for this series to work, because
the buglet that it fixes almost completely defeats the optimization
that I'm introducing.

Note: Some optimization along these lines is probably certainly needed
to get anything resembling acceptable performance out of the FPU changes
that Rik is working on.

Andy Lutomirski (3):
  x86_64,entry: Fix RCX for traced syscalls
  x86_64,entry: Use sysret to return to userspace when possible
  x86_64,entry: Remove the syscall exit audit and schedule optimizations

 arch/x86/kernel/entry_64.S | 109 +++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 48 deletions(-)

-- 
2.1.0

