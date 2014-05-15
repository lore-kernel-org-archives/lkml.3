Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaEOIqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:46:05 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:43054 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaEOIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:46:01 -0400
Date: Thu, 15 May 2014 12:45:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
Message-ID: <20140515084558.GI28328@moon>
References: <53739201.6080604@oracle.com>
 <20140514132312.573e5d3cf99276c3f0b82980@linux-foundation.org>
 <5373D509.7090207@oracle.com>
 <20140514140305.7683c1c2f1e4fb0a63085a2a@linux-foundation.org>
 <5373DBE4.6030907@oracle.com>
 <20140514143124.52c598a2ba8e2539ee76558c@linux-foundation.org>
 <CALCETrXQOPBOBOgE_snjdmJM7zi34Ei8-MUA-U-YVrwubz4sOQ@mail.gmail.com>
 <20140514221140.GF28328@moon>
 <CALCETrUc2CpTEeo=NjLGxXQWHn-HG3uYUo-L3aOU-yVjVx3PGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUc2CpTEeo=NjLGxXQWHn-HG3uYUo-L3aOU-yVjVx3PGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 03:23:27PM -0700, Andy Lutomirski wrote:
> I can summarize:
> 
> On 3.14 and before, the vdso is just a bunch of ELF headers and
> executable data.  When executed by 64-bit binaries, it reads from the
> fixmap to do its thing.  That is, it reads from kernel addresses that
> don't have vmas.  When executed by 32-bit binaries, it doesn't read
> anything, since there was no 32-bit timing code.
> 
> On 3.15, the x86_64 vdso is unchanged.  The 32-bit vdso is preceded by
> a separate vma containing two pages worth of time-varying read-only
> data.  The vdso reads those pages using PIC references.

Andy, could you please point me where is the code which creates a second vma?
latest 3.15 master branch

[root@fc ~]# cat /proc/self/maps
...
7fff57b6e000-7fff57b8f000 rw-p 00000000 00:00 0                          [stack]
7fff57bff000-7fff57c00000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
[root@fc ~]#

Or you mean vsyscall area? If yes, then in criu we don't dump vsyscall zone.
On restore we don't touch  vsyscall either but for vdso there are two cases

 - if there were no kernel change on vdso contents we simply use vdso provided
   by the kernel at the moment of criu startup

 - if vdso has been changed and looks different from one saved in image during
   checkpoint, we map it from image but then patch (push jmp instruction) so
   when application calls for some of vdso function it jumps into vdso code
   saved in image and then jumps into vdso mapped by the kernel (ie kind of
   proxy calls) This force us to do own Elf parsing inside criu to calculate
   proper offsets.

We don't support (and have no plans to support) x86-32 kernels but there
left a case with compatible mode (32bit app on 64bit kernel) which has
not yet been implemented though.

> On linux-next, all vdsos work the same way.  There are two vmas.  The
> first vma is executable text, which can be poked at by ptrace, etc
> normally.  The second vma contains time-varying state, should not
> allow poking, and is accessed by PIC references.
> 
> What does CRIU do to restore the vdso?  Will 3.15 and/or linux-next
> need to make some concession for CRIU?
