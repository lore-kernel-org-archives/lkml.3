Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3J2ULx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:11:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab3J2ULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:11:51 -0400
From: Paul Moore <pmoore@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: libseccomp-discuss@lists.sourceforge.net,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [libseccomp-discuss] ARM seccomp filters and EABI/OABI
Date: Tue, 29 Oct 2013 16:11:39 -0400
Message-ID: <8046881.Z9XKnZ7ANH@sifl>
Organization: Red Hat
User-Agent: KMail/4.11.2 (Linux/3.10.13-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CABqD9hbw8CmLum7U5ZFopfmTLWBOCfWOc0ndRwm5xByQt4Ycjw@mail.gmail.com>
References: <CALCETrXyLBXmimjLepU=y1igmWpwcdWUNCqNjMHi_jyLw0pHMA@mail.gmail.com> <1994117.6hW3PylSoC@sifl> <CABqD9hbw8CmLum7U5ZFopfmTLWBOCfWOc0ndRwm5xByQt4Ycjw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 29, 2013 12:48:45 PM Will Drewry wrote:
> On Mon, Oct 28, 2013 at 5:02 PM, Paul Moore <pmoore@redhat.com> wrote:
> > On Thursday, October 24, 2013 02:14:15 PM Andy Lutomirski wrote:
> >> On Thu, Oct 24, 2013 at 12:11 PM, Paul Moore <pmoore@redhat.com> wrote:
> >> > On Wednesday, October 23, 2013 02:02:00 PM Andy Lutomirski wrote:
> >> >> I'm looking at the seccomp code, the ARM entry code, and the
> >> >> syscall(2) manpage, and I'm a bit lost.  (The fact that I don't really
> >> >> speak ARM assembly doesn't help.)
> >> > 
> >> > I suspect Kees, and perhaps Will, will be able to provide the best
> >> > answers, but my thoughts are below.
> >> > 
> >> >> My basic question is: what happens if an OABI syscall happens?
> >> > 
> >> > Well, libseccomp doesn't support ARM OABI and since all the new ARM
> >> > stuff is EABI I don't think there is much reason to worry about OABI. 
> >> > I know this doesn't answer your question, but perhaps this provides
> >> > some context.
> >> 
> >> Are you sure you don't support it?
> > 
> > Yep, I said libseccomp doesn't support it so we don't ;)
> > 
> > It may build and function to some extent, but I'm making no claims for
> > OABI support; if someone tries it on a OABI system they do so as their own
> > risk.
> > 
> >> What actually happens if someone writes an EABI program that issues an
> >> OABI syscall?  (I'm hoping that the syscall nr ends up offset by
> >> 0x900000, but I'm not sure.)
> > 
> > Like you, I expect there would be a syscall mismatch but I can't say for
> > certain.
> 
> It looks like entry-common.S masks off the 0x900000 so that the
> numbers are the same, but the entry path is determined by the software
> interrupt instruction (SWI) 8-bit immediate which indicates the type
> (which it looks like is read by loading the address(-4) in the link
> register).
> 
> http://lxr.free-electrons.com/source/arch/arm/kernel/entry-common.S?a=arm#L4
> 20
> 
> Then it just swaps the call table if the immediate is non-zero and
> uses the arg to call into the oabi version of the syscall table.
> 
> I don't think there's a clear way to detect if the oabi table has been
> swapped in.  I think that the reason that the AUDIT_ARCH is the same
> for OABI compat/not compat is that there is no argument ordering or
> syscall numbering difference.  I'm not 100% though.

I'm now also suspicious of what ends up being returned from syscall_get_nr(), 
is the 0x900000 masked out for OABI or not?  We had a similar problem with the 
x32 stuff and had to fix the kernel to get things working correctly.

> >> >> AFAICS, the syscall arguments for EABI are r0..r5, although their
> >> >> ordering is a bit odd*.
> >> > 
> >> > Hmmm, that could complicate things a bit - do you know if they are put
> >> > in a more "standard" order by the time they are accessed in
> >> > seccomp_bpf_load() via task_pt_regs()?  If not, we likely need to come
> >> > up with some special handling in libseccomp to account for this.
> >> 
> >> I don't think that such a think is possible.  It depends on the
> >> signature of the particular syscall, and I don't know if there's any
> >> table of these things.
> > 
> > Oh, that's all sorts of awesome.
> > 
> > Well, at least in libseccomp we do have a syscall table for each arch so
> > it should be possible to track what per-syscall fixups are needed
> > (assuming some augmentation of our syscall table structures) and apply
> > them at runtime.  The hard part is going to be determining what fixups are
> > needed and recording them in the table.
> > 
> > Grrrrr.
> 
> From looking at the oabi compat calls, it may be that no fixup is
> really needed in the BPF side, but only in places where other argument
> introspection occurs -- ptrace or sigsys handlers.

Better I suppose, still not great.  It frees us up a bit from needing to do in 
special ARM handling when generating the filter, but it does make it harder to 
do the stuff that Andy is trying to do.

> >> >> I'm a bit surprised to see that both the EABI and OABI ABIs show up as
> >> >> AUDIT_ARCH_ARM.
> >> > 
> >> > Yeah, the usage of AUDIT_ARCH_* is not really ideal for seccomp.  There
> >> > are similar issues with x32; not quite as bad as with ARM, but still
> >> > ...
> >> 
> >> As long as the combination of AUDIT_ARCH and nr uniquely identifies a
> >> syscall and its ABI, life should be good.
> > 
> > Ha!  Life may be good, but the code to handle it was annoying* ;)
> > 
> > Largely because I made the assumption (which turned out to be a bad) that
> > an AUDIT_ARCH_* value uniquely identified a single ABI.  Removing that
> > assumption was both annoying and painful; the code still isn't very good
> > in dealing with multiple ABIs sharing a single AUDIT_ARCH_* token but it
> > works.
> 
> It seems like a problem for the audit infrastucture if the calling
> conventions are yielding improper system call information -- but I
> don't think it is in this case (which is why it seemed to make sense
> to connect the two subsystems...).

The problem I've been bumping into with libseccomp is that the AUDIT_ARCH_* 
values are really only useful in pointing you at the right syscall table, and 
not necessarily the ABI.  The x86_64/x32 (and possibly ARM OABI/EABI) issue is 
a good example of this limitation.  I suppose for audit this may not be a 
major concern, but when you are writing a seccomp BPF filter and you want to 
allow x86_64 but not x32 you have to examine both the AUDIT_ARCH_* value and 
the syscall number, looking at the AUDIT_ARCH_* value is not sufficient.

> The calls don't seem different, but the structs are organized, aligned, or
> padded differently (which shouldn't matter _too_ much to the seccomp filter
> unless the arg ordering is different, etc).  Bleh.
> [ http://lxr.free-electrons.com/source/arch/arm/kernel/sys_oabi-compat.c ]

That's a pretty strong argument for not supporting ARM OABI in libseccomp, 
especially since everything seems to be going towards EABI.

> I'm not sure if pt_regs ends up looking the same, but I was hoping it
> did.  I realize that the seventh argument is dropped for OABI, but
> IIRC, the only call that used it was the syscall() syscall:
> 
>   http://lxr.free-electrons.com/source/arch/arm/kernel/entry-common.S#L524
> 
> which is marked as obsolete in calls.S.  I don't think any other OABI
> calls (or any other calls in general) pass a seventh argument. *think*
> is the operative word though.
> 
> Maybe someone who's a bit more confident with the ARM syscall path can weigh
> in!
>
> > Also, on a related note, does anyone have any experience with any of the
> > cheap PC-esque ARM boards/systems that are floating around?  I'm to the
> > point of considering picking one up for libseccomp development if I can
> > find one that supports a standard development environment, decently
> > responsive, and is relatively cheap ... anyone?
> 
> I might have a spare, not-too-old board around - I'll take a look.

That would be great, but I was really just looking for recommendations.  I 
don't mind buying some ARM hardware, I just would like to find something that 
I can treat like a normal PC (or close to it), e.g. limited bootloader hacks 
needed, SATA port, working display, network, etc.

-- 
paul moore
security and virtualization @ redhat

