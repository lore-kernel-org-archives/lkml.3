Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaKGX6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:58:25 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45018 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaKGX6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:58:23 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/3] x86_64,entry: Rearrange the syscall exit optimizations
Date: Fri,  7 Nov 2014 15:58:16 -0800
Message-Id: <cover.1415403984.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
X-Spam-Warning: HELO: vger.kernel.org not a valid domain

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

Andy Lutomirski (3):
  x86_64,entry: Fix RCX for traced syscalls
  x86_64,entry: Use sysret to return to userspace when possible
  x86_64,entry: Remove the syscall exit audit and schedule optimizations

 arch/x86/kernel/entry_64.S | 103 ++++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 48 deletions(-)

-- 
1.9.3

