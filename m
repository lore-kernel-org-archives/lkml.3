Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaKOB76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:59:58 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:48937 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbaKOB75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:59:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411142326510.3909@nanos>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<alpine.DEB.2.11.1411142326510.3909@nanos>
Date: Fri, 14 Nov 2014 17:59:56 -0800
X-Google-Sender-Auth: _XiK3XtO-_5LJ4dwH2hqIgqx6mQ
Message-ID: <CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 2:55 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> This stale entry is not relevant here because the thing is stuck in
> generic_exec_single().

That wasn't really my argument. The fact that "do_flush_tlb_all()" was
left over on the stack frame implies that we're not doing the
range-flush, and if it was some odd bug with a negative range or
something like that (due to the fix in commit ce9ec37bddb6), I'd
expect the lockup to be due to a hung do_kernel_range_flush() or
something. But the range flushing never even happens.

> So from smp_call_function_many() we end up via
> smp_call_function_single() in generic_exec_single().
>
> So the only ways to get stuck there are:
>
>      csd_lock(csd);
> and
>      csd_lock_wait(csd);

Judging by the code disassembly, it's the "csd_lock_wait(csd)" at the
end. The disassembly looks like

  29: f3 90                 pause
  2b:* f6 43 18 01           testb  $0x1,0x18(%rbx) <-- trapping instruction
  2f: 75 f8                 jne    0x29
  31: 31 c0                 xor    %eax,%eax

and that "xor %eax,%eax" seems to be part of the "return 0"
immediately afterwards.

But that's not entirely conclusive, it's just a strong hint.

It does sound like there might be some IPI issue. I just don't see
*any* changes in this area since 3.17. Some unrelated APIC change? I
don't see that either. As you noted, there are KVM changes, but
apparently that isn't involved either.

                 Linus
