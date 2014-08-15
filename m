Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaHOGk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:40:57 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41977 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHOGkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:40:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAE40pdcCqu6zBqDgAXBpKHzX=y7hXtz83yEadYTE2yACiqyT3g@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-4-git-send-email-ast@plumgrid.com>
	<CAE40pdcCqu6zBqDgAXBpKHzX=y7hXtz83yEadYTE2yACiqyT3g@mail.gmail.com>
Date: Thu, 14 Aug 2014 23:40:53 -0700
Message-ID: <CAMEtUux5UCxvJyVSXDixy2fjHOXhRFLipgN7aLj_ovYm2Svy9g@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 03/26] bpf: introduce syscall(BPF, ...)
 and BPF maps
From: Alexei Starovoitov <ast@plumgrid.com>
To: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 3:28 PM, Brendan Gregg
<brendan.d.gregg@gmail.com> wrote:
> On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> [...]
>> maps can have different types: hash, bloom filter, radix-tree, etc.
>>
>> The map is defined by:
>>   . type
>>   . max number of elements
>>   . key size in bytes
>>   . value size in bytes
>
> Can values be strings or byte arrays? How would user-level bpf read
> them? The two types of uses I'm thinking are:
>
> A. Constructing a custom string in kernel-context, and using that as
> the value. Eg, a truncated filename, or a dotted quad IP address, or
> the raw contents of a packet.
> B. I have a pointer to an existing buffer or string, eg a filename,
> that will likely be around for some time (>1s). Instead of the value
> storing the string, it could just be a ptr, so long as user-level bpf
> has a way to read it.
>
> Also, can keys be strings? I'd ask about multiple keys, but if they
> can be a string, I can delimit in the key (eg, "PID:filename").

Both map keys and values are opaque byte arrays. eBPF program
can decide to store strings in there. Or concatenate multiple
strings as long as sizes are bounded.
High level scripting languages are dazzling with native strings
support, but I'm trying to stay away from it in the kernel.
Scripting languages should be able to convert string operations
into low level eBPF primitives which are being worked on.
So far I've been able to use ids and pointers and concatenations
of binary things as keys and values, and have user space interpret
them. I agree that having a script that does map[probe_name()]++
is definitely more human readable than storing probe ip into
ebpf map and converting addresses to names in userspace.
I'm hoping that the urge to make cool scripting language will push
somebody to have a dtrace/ktap/stap language compiler into eBPF :)
That will also address your concern of embedded setup where
full llvm is too big, but dtrace_into_ebpf compiler may be just right.
At the same time people who care about last bit of performance
will be using C and llvm or ebpf assembler directly.
Anyway will share string related ebpf helpers soon (not in V5 though)
