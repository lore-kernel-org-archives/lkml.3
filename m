Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaFDIw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:52:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaFDIwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:52:25 -0400
Message-ID: <538EDE1A.8060305@redhat.com>
Date: Wed, 04 Jun 2014 10:51:38 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chema Gonzalez <chema@google.com>
CC: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 net-next 1/4] net: flow_dissector: avoid multiple calls
 in eBPF
References: <1398882591-30422-1-git-send-email-chema@google.com> <1401389758-13252-1-git-send-email-chema@google.com> <5387C8AD.6000909@redhat.com> <CA+ZOOTNobzzJPgQnVVZ+b6rRD=0_pdjUB8q5FQVkbO+dob0BSg@mail.gmail.com> <538C6FD8.9040305@redhat.com> <CAMEtUuyduk1sHBeVm=d5GYEgB4ma7sVFYeBLdapbeEpQY9nA1Q@mail.gmail.com> <538D884E.5030007@redhat.com> <CAMEtUuxK5hV_eORRLaSHSiwF5X82Ae91vL6W0-6au48v8H6bAA@mail.gmail.com> <CA+ZOOTPdDDeGxZVGXVRZmjkxqkGefgDLrawo_9YXbjwTQ_FLzA@mail.gmail.com>
In-Reply-To: <CA+ZOOTPdDDeGxZVGXVRZmjkxqkGefgDLrawo_9YXbjwTQ_FLzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 11:12 PM, Chema Gonzalez wrote:
...
> Your approach needs it too. Citing from your pseudo-code:
>
>> ld #5     <-- indicates to fill the first 5 slots of M[], so M[0] to M[4]
>> ld #keys  <-- triggers the extension to fill the M[] slots
>> ld M[0]   <-- loads nhoff from M[0] into accu
>
> How does the "ld M[0]" know that the actual flow dissector has already
> been called? What if the insn just before the "ld #5" was "jmp +2" ?
> In that case, the "ld #keys" would have never been called.

But that case would be no different from doing something like ...

[...]
   jmp foo
   ldi #42
   st M[0]
foo:
   ld M[0]
[...]

... and would then not pass the checker in check_load_and_stores(),
which, as others have already stated, would need to be extended,
of course. It's one possible approach.

>> Anyway as I said before I'm not excited about either.
>> I don't think we should be adding classic BPF extensions any more.
>> The long term headache of supporting classic BPF extensions
>> outweighs the short term benefits.
...
> I see a couple of issues with (effectively) freezing classic BPF
> development while waiting for direct eBPF access to happen. The first
> one is that the kernel has to accept it. I can see many questions
> about this, especially security and usability (I'll send an email
> about the "split BPF out of core later"). Now, the main issue is
> whether/when the tools will support it. IMO, this is useful iff I can
> quickly write/reuse filters and run tcpdump filters based on them. I'm
> trying to get upstream libpcap to accept support for raw (classic) BPF
> filters, and it's taking a long time. I can imagine how they may be
> less receptive about supporting a Linux-only eBPF mechanism. Tools do
> matter.

Grepping through libpcap code, which tries to be platform independent,
it seems after all the years, the only thing where you can see support
for in their code is SKF_AD_PKTTYPE and SKF_AD_PROTOCOL. Perhaps they
just don't care, perhaps they do, who knows, but it looks to me a bit
that they are reluctant to these improvements, maybe for one reason
that other OSes don't support it. That was also one of the reasons that
led me to start writing bpf_asm (net/tools/) for having a small DSL
for more easily trying out BPF code while having _full_ control over it.

Maybe someone should start a binary-compatible Linux-only version of
libpcap, where tcpdump will transparently make use of these low level
improvements eventually. </rant> ;)

Thanks,

Daniel
