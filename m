Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaFLRVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:21:00 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:50700 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaFLRU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:20:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 10:20:38 -0700
Message-ID: <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com>
Subject: Re: Segmentation fault on all golang executables
To: Kui Zhang <kuizhang@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 9:59 AM, Kui Zhang <kuizhang@gmail.com> wrote:
> Hello,
>
> This commit seem to cause Segmentation fault on any of my golang executables.

Well, crap.  It looks like the Go people took my sample vDSO parser...
and broke it.  WTF were they thinking?  I should have noticed that
they screwed it up when I was cc'd on this thing:

https://code.google.com/p/go/source/detail?r=56ea40aac72b

but I didn't.  Sorry, everyone.  And the issue isn't even something
sensibly broken like trying to find vdso symbols in the symbol table.
No, they're using the size of the SHT_DYNSYM section to deduce the
number of entries *in the dynamic table*.  This is just completely
wrong.

But even that's not all.  They borrowed by error handling, so they
should have silently failed to parse the vdso instead of crashing.
But then they broke it completely by failing to zero the state, so
they're just reading from initialized memory.  Grr.

The current offending code is here:

https://code.google.com/p/go/source/browse/src/pkg/runtime/vdso_linux_amd64.c

Since we don't get to break all Go executables, here are two options:

1. Try to keep the whole symbol table intact.  This is annoying:
there's a reason I removed it.  The linker script doesn't know how big
it is, so it's hard to make it compatible with the vvar table.

2. Write a dummy section table that contains a single empty section of
type SHT_DYNSYM.  Hopefully the Go runtime will then get far enough to
fail cleanly.  And they can go and write a real ELF parser or copy my
reference parser correctly.  (hpa, can you apply my patches to make
the reference parser 32-bit clean?)

--Andy
