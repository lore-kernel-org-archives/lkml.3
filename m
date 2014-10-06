Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaJFQjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:39:23 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33619 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaJFQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1412189265.git.luto@amacapital.net>
References: <cover.1412189265.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 6 Oct 2014 09:39:00 -0700
Message-ID: <CALCETrVmoNP-vXVv_EpFtccsqjDMnUN9cxJc4pNU=Nb1_ekMZg@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] x86_64,entry: Clear NT on entry and speed up switch_to
To: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 11:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Anish Bhatt noticed that user programs can set RFLAGS.NT before
> syscall or sysenter, and the kernel entry code doesn't filter out
> NT.  This causes kernel C code and, depending on thread flags, the
> exit slow path to run with NT set.
>

Quick ping: now that the merge window is (sort of) open, what's
happening with these patches?

Thanks,
Andy

> The former is a little bit scary (imagine calling into EFI with NT
> set), and the latter will fail with #GP and send a spurious SIGSEGV.
>
> One answer would be "don't do that".  But the kernel can do better
> here.
>
> These patches filter NT on all kernel entries.  For syscall (both
> bitnesses), this is free.  For sysenter, it seems to cost very
> little (less than my ability to measure, although I didn't try that
> hard).  Patch 2, which isn't tagged for -stable, speeds up context
> switches by avoiding saving and restoring flags, so this series
> should be a decent overall performance win.
>
> See: https://bugs.winehq.org/show_bug.cgi?id=33275
>
> Note to bikeshedders: I have no desire to go crazy micro-optimizing
> the sysenter path. :) This version seems to be good enough (and
> should be a performance *increase* for most workloads).
>
> Changes from v3:
>  - Added a better description of the impact in patch 1
>
> Changes from v2:
>  - Move the flag fixup out of line
>  - Fix a CFI buglet
>
> Changes from v1:
>  - Spell stable@vger.kernel.org correctly
>  - Tidy up changelog text
>  - Actually commit an asm constraint fix in patch 2 (egads!)
>  - Replace the unconditional popfq with a branch
>
> Andy Lutomirski (2):
>   x86_64,entry: Filter RFLAGS.NT on entry from userspace
>   x86_64: Don't save flags on context switch
>
>  arch/x86/ia32/ia32entry.S        | 18 +++++++++++++++++-
>  arch/x86/include/asm/switch_to.h | 12 ++++++++----
>  arch/x86/kernel/cpu/common.c     |  2 +-
>  3 files changed, 26 insertions(+), 6 deletions(-)
>
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
