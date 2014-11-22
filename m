Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaKVAlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 19:41:45 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:49006 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaKVAlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 19:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzC+PRnnT79OzQhoVBu+jtTH=QP+n_puB8Ti2T9wNo5-A@mail.gmail.com>
References: <20141119235033.GE11386@lerouge> <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos> <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos> <20141120230514.GB25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411210109460.6439@nanos> <20141121141332.GA8808@lerouge>
 <20141121162506.GA15461@htj.dyndns.org> <20141121214444.GB9198@lerouge>
 <20141122001111.GA26007@htj.dyndns.org> <CA+55aFzC+PRnnT79OzQhoVBu+jtTH=QP+n_puB8Ti2T9wNo5-A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 16:41:22 -0800
Message-ID: <CALCETrXXyrVbPD6MZHYu3K=sdvA=XH+Hgxy-hO9ZEoxO-gbmYg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 4:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 21, 2014 at 4:11 PM, Tejun Heo <tj@kernel.org> wrote:
>>
>> I don't think there's much percpu allocator itself can do.  The
>> ability to grow dynamically comes from being able to allocate
>> relatively consistent layout among areas for different CPUs and pretty
>> much requires vmalloc area and it'd generally be a good idea to take
>> out the vmalloc fault anyway.
>
> Why do you guys worry so much about the vmalloc fault?
>
> This started because of a very different issue: putting the actual
> stack in vmalloc space. Then it can cause nasty triple faults etc.
>
> But the normal vmalloc fault? Who cares, really? If that causes
> problems, they are bugs. Fix them.

Because of this in system_call_after_swapgs:

    movq    %rsp,PER_CPU_VAR(old_rsp)
    movq    PER_CPU_VAR(kernel_stack),%rsp

It occurs to me that, if we really want to change that, we could have
an array of syscall trampolines, one per CPU, that have the CPU number
hardcoded.  But I really don't think that's worth it.

Other than that, with your fix, vmalloc faults are no big deal :)

--Andy
