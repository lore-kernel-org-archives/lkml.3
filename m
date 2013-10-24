Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3JXTLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:11:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab3JXTLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:11:31 -0400
From: Paul Moore <pmoore@redhat.com>
To: libseccomp-discuss@lists.sourceforge.net
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [libseccomp-discuss] ARM seccomp filters and EABI/OABI
Date: Thu, 24 Oct 2013 15:11:19 -0400
Message-ID: <1393414.jBrsFW4xK5@sifl>
Organization: Red Hat
User-Agent: KMail/4.11.2 (Linux/3.10.13-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CALCETrXyLBXmimjLepU=y1igmWpwcdWUNCqNjMHi_jyLw0pHMA@mail.gmail.com>
References: <CALCETrXyLBXmimjLepU=y1igmWpwcdWUNCqNjMHi_jyLw0pHMA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 02:02:00 PM Andy Lutomirski wrote:
> I'm looking at the seccomp code, the ARM entry code, and the
> syscall(2) manpage, and I'm a bit lost.  (The fact that I don't really
> speak ARM assembly doesn't help.)

I suspect Kees, and perhaps Will, will be able to provide the best answers, 
but my thoughts are below.

> My basic question is: what happens if an OABI syscall happens?

Well, libseccomp doesn't support ARM OABI and since all the new ARM stuff is 
EABI I don't think there is much reason to worry about OABI.  I know this 
doesn't answer your question, but perhaps this provides some context.

> AFAICS, the syscall arguments for EABI are r0..r5, although their
> ordering is a bit odd*.

Hmmm, that could complicate things a bit - do you know if they are put in a 
more "standard" order by the time they are accessed in seccomp_bpf_load() via 
task_pt_regs()?  If not, we likely need to come up with some special handling 
in libseccomp to account for this.

> For OABI, r6 seems to play some role, but I'm
> lost as to what it is.  The seccomp_bpf_load function won't load r6,
> so there had better not be anything useful in there...  (Also, struct
> seccomp_data will have issues with a seventh "argument".)
> 
> But what happens to the syscall number?  For an EABI syscall, it's in
> r7.  For an OABI syscall, it's in the swi instruction and gets copied
> to r7 on entry.  If a debugger changes r7, presumably the syscall
> number changes.
> 
> Oddly, there are two different syscall tables.  The major differences
> seem to be that some of the OABI entries have their argument order
> changed.  But there's also a magic constant 0x900000 added to the
> syscall number somewhere -- is it reflected in _sigsys._syscall?  Is
> it reflected in ucontext's r7?

Thankfully, I've been able to ignore most of this.

> I'm a bit surprised to see that both the EABI and OABI ABIs show up as
> AUDIT_ARCH_ARM.

Yeah, the usage of AUDIT_ARCH_* is not really ideal for seccomp.  There are 
similar issues with x32; not quite as bad as with ARM, but still ... 

> Can any of you shed some light on this?  I don't have an ARM system I
> can test on, but if one of you can point me at a decent QEMU image, I
> can play around.

I know Kees had one at one point, although I remember him commenting that it 
was painfully slow under QEMU.

> For reference, I'm working on userspace code to decode a TRAP and
> eventually to allow syscall emulation (either by emulating the syscall
> inside the signal handler and setting the return value or (egads!) by
> changing the syscall and restarting it -- the latter is probably
> impossible if the original syscall came in through OABI and may be
> generally impossible if userspace expects any of the argument
> registers to be preserved).
> 
> 
> * I think that a syscall with signature long func(int a, long long b,
> int c, int d, int e) ends up with c in r1 and b in r2/r3.  The
> syscall(2) manpage appears to be entirely wrong.

-- 
paul moore
security and virtualization @ redhat

