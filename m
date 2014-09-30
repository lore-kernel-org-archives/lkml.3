Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaI3Tks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:40:48 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35306 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaI3Tkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:40:47 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86_64,entry: Clear NT on entry and speed up switch_to
Date: Tue, 30 Sep 2014 12:40:34 -0700
Message-Id: <cover.1412105369.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anish Bhatt noticed that user programs can set RFLAGS.NT before
syscall or sysenter, and the kernel entry code doesn't filter out
NT.  This causes kernel C code and, depending on thread flags, the
exit slow path to run with NT set.

The former is a little bit scary (imagine calling into EFI with NT
set), and the latter will fail with #GP and send a spurious SIGSEGV.

One answer would be "don't do that".  But the kernel can do better
here.

These patches, which I'm not completely thrilled by, filter NT on
all kernel entries.  For syscall (both bitnesses), this is free.
For sysenter, it costs 15 cycles or so.  As a consolation prize, we
can speed up context switches by avoiding saving and restoring flags.

If we don't like the added sysenter overhead, there are few other
options:

 - Try to optimize it by folding it with other flag manipulations
   (my attempt to do that didn't end up being any faster).

 - Only do the syscall part.  That's free, but it serves little
   purpose other than being polite to buggy userspace code.

 - Don't filter NT on sysenter.  Instead, filter it on EFI entry
   and modify the IRET code to retry without NT set if NT was set.

 - Don't filter NT on sysenter.  Instead, only filter it when
   sysenter jumps to the slow path.  (This is trivial, but it does
   nothing to reduce the chance that evil user code can cause
   trouble by, say, reading from sysfs with NT set using sysenter.)

See: https://bugs.winehq.org/show_bug.cgi?id=33275

Andy Lutomirski (2):
  x86_64,entry: Filter RFLAGS.NT on entry from userspace
  x86_64: Don't save flags on context switch

 arch/x86/ia32/ia32entry.S        | 10 +++++++++-
 arch/x86/include/asm/switch_to.h | 10 +++++++---
 arch/x86/kernel/cpu/common.c     |  2 +-
 3 files changed, 17 insertions(+), 5 deletions(-)

-- 
1.9.3

