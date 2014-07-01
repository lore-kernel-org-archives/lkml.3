Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbaGAHTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:19:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaGAHTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:19:00 -0400
Message-ID: <53B260B3.4040108@redhat.com>
Date: Tue, 01 Jul 2014 09:18:11 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 00/14] BPF syscall, maps, verifier, samples
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com> <CAGXu5jK9Bwocjz8y26=GEk0qg5ru1Mu7j9FVuu20KfTDUrSkuQ@mail.gmail.com>
In-Reply-To: <CAGXu5jK9Bwocjz8y26=GEk0qg5ru1Mu7j9FVuu20KfTDUrSkuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 01:09 AM, Kees Cook wrote:
> On Fri, Jun 27, 2014 at 5:05 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> Hi All,
>>
>> this patch set demonstrates the potential of eBPF.
>>
>> First patch "net: filter: split filter.c into two files" splits eBPF interpreter
>> out of networking into kernel/bpf/. The goal for BPF subsystem is to be usable
>> in NET-less configuration. Though the whole set is marked is RFC, the 1st patch
>> is good to go. Similar version of the patch that was posted few weeks ago, but
>> was deferred. I'm assuming due to lack of forward visibility. I hope that this
>> patch set shows what eBPF is capable of and where it's heading.
>>
>> Other patches expose eBPF instruction set to user space and introduce concepts
>> of maps and programs accessible via syscall.
>>
>> 'maps' is a generic storage of different types for sharing data between kernel
>> and userspace. Maps are referrenced by global id. Root can create multiple
>> maps of different types where key/value are opaque bytes of data. It's up to
>> user space and eBPF program to decide what they store in the maps.
>>
>> eBPF programs are similar to kernel modules. They live in global space and
>> have unique prog_id. Each program is a safe run-to-completion set of
>> instructions. eBPF verifier statically determines that the program terminates
>> and safe to execute. During verification the program takes a hold of maps
>> that it intends to use, so selected maps cannot be removed until program is
>> unloaded. The program can be attached to different events. These events can
>> be packets, tracepoint events and other types in the future. New event triggers
>> execution of the program which may store information about the event in the maps.
>> Beyond storing data the programs may call into in-kernel helper functions
>> which may, for example, dump stack, do trace_printk or other forms of live
>> kernel debugging. Same program can be attached to multiple events. Different
>> programs can access the same map:
>>
>>    tracepoint  tracepoint  tracepoint    sk_buff    sk_buff
>>     event A     event B     event C      on eth0    on eth1
>>      |             |          |            |          |
>>      |             |          |            |          |
>>      --> tracing <--      tracing       socket      socket
>>           prog_1           prog_2       prog_3      prog_4
>>           |  |               |            |
>>        |---  -----|  |-------|           map_3
>>      map_1       map_2
>>
>> User space (via syscall) and eBPF programs access maps concurrently.
>>
>> Last two patches are sample code. 1st demonstrates stateful packet inspection.
>> It counts tcp and udp packets on eth0. Should be easy to see how this eBPF
>> framework can be used for network analytics.
>> 2nd sample does simple 'drop monitor'. It attaches to kfree_skb tracepoint
>> event and counts number of packet drops at particular $pc location.
>> User space periodically summarizes what eBPF programs recorded.
>> In these two samples the eBPF programs are tiny and written in 'assembler'
>> with macroses. More complex programs can be written C (llvm backend is not
>> part of this diff to reduce 'huge' perception).
>> Since eBPF is fully JITed on x64, the cost of running eBPF program is very
>> small even for high frequency events. Here are the numbers comparing
>> flow_dissector in C vs eBPF:
>>    x86_64 skb_flow_dissect() same skb (all cached)         -  42 nsec per call
>>    x86_64 skb_flow_dissect() different skbs (cache misses) - 141 nsec per call
>> eBPF+jit skb_flow_dissect() same skb (all cached)         -  51 nsec per call
>> eBPF+jit skb_flow_dissect() different skbs (cache misses) - 135 nsec per call
>>
>> Detailed explanation on eBPF verifier and safety is in patch 08/14
>
> This is very exciting! Thanks for working on it. :)
>
> Between the new eBPF syscall and the new seccomp syscall, I'm really
> looking forward to using lookup tables for seccomp filters. Under
> certain types of filters, we'll likely see some non-trivial
> performance improvements.

Well, if I read this correctly, the eBPF syscall lets you set up maps, etc,
but the only way to attach eBPF is via setsockopt for network filters right
now (and via tracing). Seccomp will still make use of classic BPF, so you
won't be able to use it there.
