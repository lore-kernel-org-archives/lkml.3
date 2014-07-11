Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaGKQ3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:29:34 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56378 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaGKQ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:29:33 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86_64,signal: Fix the set of saved segment registers
Date: Fri, 11 Jul 2014 09:29:21 -0700
Message-Id: <cover.1405095200.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86_64 signal code claims to save and restore CS, FS, and GS,
and it further claims that this is the minimal set that's needed.

Neither of these claims is true.  The code does not, and AFAICT
never has, saved or restored FS and GS, nor does it need to.  On the
other hand, all 64-bit syscalls (and rt_sigreturn in particular)
clobber SS, making it impossible for signal handlers to correctly
restore SS without using a trampoline or ptracing themselves.

This patchset saves and restores SS in the __pad0 slot and renames
the FS and GS slots __pad1 and __pad2 to more accurately document
their purpose.

I discovered this while writing a test for espfix64.

Andy Lutomirski (2):
  x86_64,signal: Save and restore SS in signal frames
  x86_64,signal: Remove 'fs' and 'gs' from sigcontext

 arch/x86/include/asm/sigcontext.h      |  6 +++---
 arch/x86/include/uapi/asm/sigcontext.h |  6 +++---
 arch/x86/kernel/signal.c               | 12 +++---------
 3 files changed, 9 insertions(+), 15 deletions(-)

-- 
1.9.3

