Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaCJDTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:19:16 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64447 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaCJDTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <531D044C.2090303@linux.intel.com>
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net>
 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
 <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
 <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 9 Mar 2014 20:18:54 -0700
Message-ID: <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 5:16 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/09/2014 12:47 AM, Stefani Seibold wrote:
>>
>> But let me ask an other question: Is the compat mode still needed
>> anymore?
>>
>> Since Lguest, XEN, OPLC and the reservetop kernel parameter will change
>> the __FIXADDR_TOP, there is no fix place for the VDSO page. Also in the
>> 32 bit emulation layer the address is not fix.
>>
>> So all applications can fail when try directly access the VDSO page with
>> a hard coded address 0xffffe000.
>>
>> IMHO this is broken. So an other solution is to remove the whole VDSO
>> compat code.
>>
>
> Lguest, Xen, OLPC and reservetop are corner cases.  My understanding is
> that at least one widely used distro actually cared about this, and
> Linus especially is adamant that "we don't break userspace."

OK, I did some research.  I think that the commit that fixed the glibc bug was:

commit 49ad572a70b8aeb91e57483a11dd1b77e31c4468
Author: Ulrich Drepper <drepper@redhat.com>
Date:   Sat Feb 28 17:56:22 2004 +0000

    Update.

        * elf/rtld.c (dl_main): Adjust l->l_ld of the vDSO by l->l_addr.
        * sysdeps/generic/dl-sysdep.c (_dl_sysdep_start): Only set
        GL(dl_sysinfo) if non-zero.

I don't think that the actual load address of the VDSO matters at all.
 Here's what I think is going on:

When the kernel is built, vdso32-int80.so looks like this (excerpted
from objdump -T):

DYNAMIC SYMBOL TABLE:
00000420 g    DF .text  00000003  LINUX_2.5   __kernel_vsyscall
00000000 g    DO *ABS*  00000000  LINUX_2.5   LINUX_2.5
00000410 g    DF .text  00000008  LINUX_2.5   __kernel_rt_sigreturn
00000400 g    DF .text  00000009  LINUX_2.5   __kernel_sigreturn

When the kernel is run, the kernel "relocates" the vdso, generating
something more like:

DYNAMIC SYMBOL TABLE:
ffffe420 g    DF .text  00000014  LINUX_2.5   __kernel_vsyscall
00000000 g    DO *ABS*  00000000  LINUX_2.5   LINUX_2.5
ffffe410 g    DF .text  00000008  LINUX_2.5   __kernel_rt_sigreturn
ffffe400 g    DF .text  00000009  LINUX_2.5   __kernel_sigreturn

That magic 0xffffe000 offset comes from VDSO_HIGH_BASE - VDSO_PRELINK,
and VDSO_PRELINK seems like an amazingly complicated way to say
"zero".

Before the fix, it looks like glibc couldn't handle a vdso that was
mapped in such a way that its ELF headers didn't match its actual
location.  Now it can.  This is borne out by this message:

commit d4f7a2c18e59e0304a1c733589ce14fc02fec1bd
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Wed May 2 19:27:12 2007 +0200

    [PATCH] i386: Relocate VDSO ELF headers to match mapped location with COMPAT

    Some versions of libc can't deal with a VDSO which doesn't have its
    ELF headers matching its mapped address.  COMPAT_VDSO maps the VDSO at
    a specific system-wide fixed address.  Previously this was all done at
    build time, on the grounds that the fixed VDSO address is always at
    the top of the address space.  However, a hypervisor may reserve some
    of that address space, pushing the fixmap address down.

I suspect that it's entirely safe to map the 32-bit vdso wherever the
hell we want, so long as it's relocated to match the actual mapping
address.  In principle it could even live outside the fixmap, as long
as the actual binary that gets run doesn't end up on top of it.

So... I propose that we get rid of all the madness.  Fix the vdso32
setup code to stop being insane.  That means: stop memcpying the vdso
image anywhere and get rid of all references to the magical and wrong
number "3".  Just map it wherever it needs to be mapped and relocate
the damn think *in place*.  If some RODATA crud gets in the way,
twiddle the protection bits as needed.  That means that all this
"vvars before vdso" nonsense can go away.

(Of course, I haven't the faintest idea what l_addr in glibc means.
If there was a way to arrange for l_addr to be zero, then maybe none
of this would matter.  Hmm, I wonder if just not relocating the vdso
at all would have the desired effect.  Anyone out there understand
glibc?)

--Andy
