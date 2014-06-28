Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaF1GVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:21:09 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40022 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaF1GVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWGUui53hpRYtA9zmLKLf-r-nC8urq_JgJoRnzRb1d_1w@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-14-git-send-email-ast@plumgrid.com>
	<CALCETrWGUui53hpRYtA9zmLKLf-r-nC8urq_JgJoRnzRb1d_1w@mail.gmail.com>
Date: Fri, 27 Jun 2014 23:21:05 -0700
Message-ID: <CAMEtUuyPF3KRLmJQ=_6nb4kBfc+nBdAyib_3VSgFZ8oSTgHXRg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 13/14] samples: bpf: example of stateful
 socket filtering
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 5:21 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jun 27, 2014 at 5:06 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> this socket filter example does:
>>
>> - creates a hashtable in kernel with key 4 bytes and value 8 bytes
>>
>> - populates map[6] = 0; map[17] = 0;  // 6 - tcp_proto, 17 - udp_proto
>>
>> - loads eBPF program:
>>   r0 = skb[14 + 9]; // load one byte of ip->proto
>>   *(u32*)(fp - 4) = r0;
>>   value = bpf_map_lookup_elem(map_id, fp - 4);
>>   if (value)
>>        (*(u64*)value) += 1;
>
> In the code below, this is XADD.  Is there anything that validates
> that shared things like this can only be poked at by atomic
> operations?

Correct. The asm code uses xadd to increment packet stats.
It's up to the program itself to decide what it's doing.
Some programs may prefer speed vs accuracy when counting
and they will be using regular "ld, add, st", instead of xadd.
Verifier checks that programs can only access a valid memory
region. The program itself needs to do something sensible with it.
Theoretically I can add a check to verifier that shared map elements
are read-only and xadd-only, but that limits usability and unnecessary.
We actually do have a use case when we do a regular add, since
'lock add' is too costly at high event rates.
