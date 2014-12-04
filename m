Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbaLDWoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:44:06 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:54877 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709AbaLDWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:44:03 -0500
MIME-Version: 1.0
Date: Thu, 4 Dec 2014 14:44:01 -0800
Message-ID: <CAADnVQJ8CinXDXDGsPjd++Ru+sun81eygGnW58NKAuR2xh6KEA@mail.gmail.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: David Laight <David.Laight@aculab.com>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 10:05 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-12-04 at 07:56 -0800, Alexei Starovoitov wrote:
>> On Thu, Dec 4, 2014 at 1:26 AM, Joe Perches <joe@perches.com> wrote:
>> > On Thu, 2014-11-27 at 10:49 -0800, Joe Perches wrote:
>> >> On Thu, 2014-11-27 at 12:25 +0000, David Laight wrote:
>> >> > Why the change in data?
>> >>
>> >> btw: without gcov and using -O2
>> >>
>> >> $ size arch/x86/net/bpf_jit_comp.o*
>> >>    text          data     bss     dec     hex filename
>> >>    9671             4       0    9675    25cb arch/x86/net/bpf_jit_comp.o.new
>> >>   10679             4       0   10683    29bb arch/x86/net/bpf_jit_comp.o.old
>> >
>> > Alexei?
>> >
>> > Is this 10% reduction in size a good reason to change the code?
>>
>> yes.
>> I believe you're seeing it with gcc 4.9. I wanted to double
>> check what 4.6 and 4.7 are doing. If they're not suddenly
>> increase code size then resubmit it for inclusion please.
>
> I get these sizes for these compilers
> (x86-64, -O2, without profiling)
>
> $ size arch/x86/net/bpf_jit_comp.o*
>    text    data     bss     dec     hex filename
>    9266       4       0    9270    2436 arch/x86/net/bpf_jit_comp.o.4.4.new
>   10042       4       0   10046    273e arch/x86/net/bpf_jit_comp.o.4.4.old
>    9109       4       0    9113    2399 arch/x86/net/bpf_jit_comp.o.4.6.new
>    9717       4       0    9721    25f9 arch/x86/net/bpf_jit_comp.o.4.6.old
>    8789       4       0    8793    2259 arch/x86/net/bpf_jit_comp.o.4.7.new
>   10245       4       0   10249    2809 arch/x86/net/bpf_jit_comp.o.4.7.old
>    9671       4       0    9675    25cb arch/x86/net/bpf_jit_comp.o.4.9.new
>   10679       4       0   10683    29bb arch/x86/net/bpf_jit_comp.o.4.9.old
>
> I am a bit surprised by the size variations

yeah. the difference is surprising.
Just tried with 4.7 and my regular config and I see the same difference.
Looks like gcc wasn't able to fold conditions into cmov
and used a bunch of cmp/jmp
Since is_ereg() was inlined ~70 times on its own and as
part of other functions, the difference of 3-4 instructions
may a large difference in total size.
test_bpf also passes, so please resubmit properly.
