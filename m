Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3J3RTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:19:36 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47322 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3J3RTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <1393414.jBrsFW4xK5@sifl>
References: <CALCETrXyLBXmimjLepU=y1igmWpwcdWUNCqNjMHi_jyLw0pHMA@mail.gmail.com>
	<1393414.jBrsFW4xK5@sifl>
Date: Wed, 30 Oct 2013 10:19:34 -0700
X-Google-Sender-Auth: 73AK3JDd-HMFs0OX2LqfZrUHZkk
Message-ID: <CAGXu5j+Q=mr5RdENnu8x+bjbwEeTV0i1aH=qK-puYxjwcKN8dQ@mail.gmail.com>
Subject: Re: [libseccomp-discuss] ARM seccomp filters and EABI/OABI
From: Kees Cook <keescook@chromium.org>
To: Paul Moore <pmoore@redhat.com>
Cc: libseccomp-discuss@lists.sourceforge.net,
        Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 12:11 PM, Paul Moore <pmoore@redhat.com> wrote:
> On Wednesday, October 23, 2013 02:02:00 PM Andy Lutomirski wrote:
>> I'm looking at the seccomp code, the ARM entry code, and the
>> syscall(2) manpage, and I'm a bit lost.  (The fact that I don't really
>> speak ARM assembly doesn't help.)
>
> I suspect Kees, and perhaps Will, will be able to provide the best answers,
> but my thoughts are below.
>
>> My basic question is: what happens if an OABI syscall happens?
>
> Well, libseccomp doesn't support ARM OABI and since all the new ARM stuff is
> EABI I don't think there is much reason to worry about OABI.  I know this
> doesn't answer your question, but perhaps this provides some context.

The original ARM seccomp patch had two SECCOMP_ARCH entries, but it
was a mistake as it was really a description of endianness:
https://lkml.org/lkml/2012/11/5/273

I also got the impression from another discussion I can't find that
when seccomp does its checks, the syscall offset has already been
dealt with. The best I could find discussing this was:
https://lkml.org/lkml/2012/11/1/383

>> AFAICS, the syscall arguments for EABI are r0..r5, although their
>> ordering is a bit odd*.
>
> Hmmm, that could complicate things a bit - do you know if they are put in a
> more "standard" order by the time they are accessed in seccomp_bpf_load() via
> task_pt_regs()?  If not, we likely need to come up with some special handling
> in libseccomp to account for this.
>
>> For OABI, r6 seems to play some role, but I'm
>> lost as to what it is.  The seccomp_bpf_load function won't load r6,
>> so there had better not be anything useful in there...  (Also, struct
>> seccomp_data will have issues with a seventh "argument".)
>>
>> But what happens to the syscall number?  For an EABI syscall, it's in
>> r7.  For an OABI syscall, it's in the swi instruction and gets copied
>> to r7 on entry.  If a debugger changes r7, presumably the syscall
>> number changes.
>>
>> Oddly, there are two different syscall tables.  The major differences
>> seem to be that some of the OABI entries have their argument order
>> changed.  But there's also a magic constant 0x900000 added to the
>> syscall number somewhere -- is it reflected in _sigsys._syscall?  Is
>> it reflected in ucontext's r7?
>
> Thankfully, I've been able to ignore most of this.
>
>> I'm a bit surprised to see that both the EABI and OABI ABIs show up as
>> AUDIT_ARCH_ARM.
>
> Yeah, the usage of AUDIT_ARCH_* is not really ideal for seccomp.  There are
> similar issues with x32; not quite as bad as with ARM, but still ...
>
>> Can any of you shed some light on this?  I don't have an ARM system I
>> can test on, but if one of you can point me at a decent QEMU image, I
>> can play around.
>
> I know Kees had one at one point, although I remember him commenting that it
> was painfully slow under QEMU.

Yeah, I set up an ARM emulator via QEMU. It is very slow, but it at
least gets me somewhere with testing when I don't have a real ARM
device handy. I followed the Debian ARM qemu instructions.

-Kees

-- 
Kees Cook
Chrome OS Security
