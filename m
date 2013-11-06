Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3KFDXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:23:05 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38446 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3KFDXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:23:03 -0500
MIME-Version: 1.0
In-Reply-To: <20131106004058.GU16735@n2100.arm.linux.org.uk>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
 <CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com> <20131106004058.GU16735@n2100.arm.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 5 Nov 2013 19:22:42 -0800
Message-ID: <CALCETrXd7SknNCptTTojBzOo+RNzPwGrgjigVdVeOkGMAtajWg@mail.gmail.com>
Subject: Re: ARM audit, seccomp, etc are broken wrt OABI syscalls
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>,
        Richard Weinberger <richard@nod.at>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 4:40 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 05, 2013 at 04:14:49PM -0800, Kees Cook wrote:
>> I would agree: option 1 seems cleanest of the 3. 3 is sort of like a
>> built-in automatic check for a mismatched arch, so maybe that works
>> better?
>>
>> Alternatively, CONFIG_SECCOMP_FILTER could depend on
>> !CONFIG_OABI_COMPAT. That seems like the least work, given the desire
>> to kill OABI in the real world. (Though I would note that at least
>> Ubuntu's ARM kernels build with CONFIG_OABI_COMPAT; Chrome OS does
>> not.)
>
> OABI compat is really only something you want to deal with if you have
> a reason to run OABI programs on the kernel; it is in no way guaranteed
> that the OABI programs will run properly (many ALSA programs will not
> because of different layouts with ioctls).
>
> OABI compat was meant to allow a transition from OABI to EABI.  While
> a lot of effort went in to the kernel side of that, which does allow
> OABI based userspace to boot with an EABI kernel, and allows OABI built
> test programs to run under an EABI kernel, actually being able to
> migrate userland is far from trivial - and something that I've never
> been able to do.  Hence, virtually all my long-running ARM machines
> here are stuck with OABI, and I don't see that situation ever changing.
>
> As a rule, distros should not be enabling OABI compat.  OABI compat
> is more something that a developer (like me) who has a reason to enable
> it turns it on.

So I guess that audit, ptrace, etc. work on OABI because the userspace
tools expect the OABI syscall conventions and they work on EABI for
the same reason, everything is subtly broken on OABI compat.  Adding a
new AUDIT_ARCH_ARMOABI is probably bad, then, unless it only applies
to OABI compat kernels.  Similarly, bumping the syscall numbers is
probably also bad.  (Arguably the audit arch should have been
AUDIT_ARCH_ARMEABI from the beginning -- too late now.)

Maybe the thing to do is to put a warning in the config text for
CONFIG_OABI_COMPAT that describes the problems (malicious userspace
can confuse syscall auditors, strace, etc.), change the "if in doubt"
part to N, and disable seccomp filters if CONFIG_OABI_COMPAT.  That
might even get Debian to change their default.

--Andy
