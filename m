Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3KHQbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:31:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525Ab3KHQbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:31:02 -0500
From: Paul Moore <pmoore@redhat.com>
To: libseccomp-discuss@lists.sourceforge.net
Cc: Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>,
        James Hogan <james.hogan@imgtec.com>, Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [libseccomp-discuss] [PATCH v2] seccomp: not compatible with ARM OABI
Date: Fri, 08 Nov 2013 11:29:58 -0500
Message-ID: <1464650.041viV29xe@sifl>
Organization: Red Hat
User-Agent: KMail/4.11.2 (Linux/3.10.13-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CALCETrVgwMto=5Rn34dDOLrmzLargvs4QxCdPWdEvd=UZhg_Jg@mail.gmail.com>
References: <20131107174746.GA22344@www.outflux.net> <1383850597.2938.52.camel@localhost> <CALCETrVgwMto=5Rn34dDOLrmzLargvs4QxCdPWdEvd=UZhg_Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 07, 2013 11:05:26 AM Andy Lutomirski wrote:
> On Thu, Nov 7, 2013 at 10:56 AM, Eric Paris <eparis@redhat.com> wrote:
>
> > Isn't x32 similarly screwy?  Does it work because the syscall numbers
> > are different?
> 
> Yes (from reading the code -- I haven't actually tried it).

I've got a x32 VM that I boot occasionally to test seccomp/libseccomp.  For 
the purposes of seccomp it looks exactly like x86_64, including sharing the 
same AUDIT_ARCH_X86_64 value, the only difference being the syscall number 
offset ... Assuming you're using kernel 3.9 or later.  Previous kernels had a 
bug which stripped the x32 syscall offset so it was impossible to distinguish 
from x86_64 and x32 with seccomp.  See the following commit for the details:

 commit 8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1
 Author: Paul Moore <pmoore@redhat.com>
 Date:   Fri Feb 15 12:21:43 2013 -0500

    x86: remove the x32 syscall bitmask from syscall_get_nr()
    
    Commit fca460f95e928bae373daa8295877b6905bc62b8 simplified the x32
    implementation by creating a syscall bitmask, equal to 0x40000000, that
    could be applied to x32 syscalls such that the masked syscall number
    would be the same as a x86_64 syscall.  While that patch was a nice
    way to simplify the code, it went a bit too far by adding the mask to
    syscall_get_nr(); returning the masked syscall numbers can cause
    confusion with callers that expect syscall numbers matching the x32
    ABI, e.g. unmasked syscall numbers.
    
    This patch fixes this by simply removing the mask from syscall_get_nr()
    while preserving the other changes from the original commit.  While
    there are several syscall_get_nr() callers in the kernel, most simply
    check that the syscall number is greater than zero, in this case this
    patch will have no effect.  Of those remaining callers, they appear
    to be few, seccomp and ftrace, and from my testing of seccomp without
    this patch the original commit definitely breaks things; the seccomp
    filter does not correctly filter the syscalls due to the difference in
    syscall numbers in the BPF filter and the value from syscall_get_nr().
    Applying this patch restores the seccomp BPF filter functionality on
    x32.
    
    I've tested this patch with the seccomp BPF filters as well as ftrace
    and everything looks reasonable to me; needless to say general usage
    seemed fine as well.
    
    Signed-off-by: Paul Moore <pmoore@redhat.com>
    Link: http://lkml.kernel.org/r/20130215172143.12549.10292.stgit@localhost
    Cc: <stable@vger.kernel.org>
    Cc: Will Drewry <wad@chromium.org>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

> I've always interpreted the AUDIT_ARCH stuff as meaning that
> (audit_arch, nr) uniquely identifies a syscall and that (audit_arch,
> nr, argument registers) identifies a syscall and its arguments.

That matches my own experience working with seccomp.

> On x32, the syscall invocation instruction is identical to x86_64 and
> the mode of the process has nothing to do with which syscall is
> invoked, so having a different audit_arch is unnecessary (as long as
> the x32 bit in nr is preserved).

-- 
paul moore
security and virtualization @ redhat

