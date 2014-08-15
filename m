Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaHOTTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:19:17 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:64450 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaHOTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuwF2_+qzkaW6rkw9cyYJ2eb01B_ZyBcwrJ7nd+GqN5-mQ@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
 <1407916658-8731-18-git-send-email-ast@plumgrid.com> <CAE40pdf0pNYyazjpdkzxNJi7iC4LOOr_XEu078OUqP_uoCXnHg@mail.gmail.com>
 <CAMEtUuymPDhYBe42i4DJNXsdgZRaq9LuEU_nGSsqrY1FcFHqhQ@mail.gmail.com>
 <CALCETrVH8KXr8uSHAVy5eBsqmi1LjB5QZpboAGcjYswXvW1opA@mail.gmail.com>
 <CAMEtUuzey7PanznrAguOpvPLxyhgJB++ovE8RNys7srs=EY1qg@mail.gmail.com>
 <CALCETrVhjO5c7ob1vntx031c5RmxRHimkRt1F2EsmzdKB53_NA@mail.gmail.com>
 <CAMEtUuzT53jeH-L+saW-RopSR2EERO5UKVHyeORTGHVMCHbYag@mail.gmail.com>
 <CALCETrUNvg88_VrwE+9RKnSgts=3zVcXbX6tuNLgUxJU436CrQ@mail.gmail.com> <CAMEtUuwF2_+qzkaW6rkw9cyYJ2eb01B_ZyBcwrJ7nd+GqN5-mQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 12:18:53 -0700
Message-ID: <CALCETrUqop+UB-BhyX4Y41kELO+6kcFdS1F7ZyN0CzRwg4UGhA@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kees Cook <keescook@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 12:16 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Fri, Aug 15, 2014 at 12:02 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>> correct. eBPF program would be using 8-byte read on 64-bit kernel
>>> and 4-byte read on 32-bit kernel. Same with access to ptrace fields
>>> and pretty much all other fields in the kernel. The program will be
>>> different on different kernels.
>>> Say, this bpf_context struct doesn't exist at all. The programs would
>>> still need to be different to walk in-kernel data structures...
>>
>> Hmm.  I guess this isn't so bad.
>>
>> What's the actual difficulty with using u64?  ISTM that, if the clang
>> front-end can't deal with u64, there's a bigger problem.  Or is it
>> something else I don't understand.
>
> clang/llvm has no problem with u64 :)
> This bpf_context struct for tracing is trying to answer the question:
>  'what's the most convenient way to access tracepoint arguments
> from a script'.
> When kernel code has something like:
>  trace_kfree_skb(skb, net_tx_action);
> the script needs to be able to access this 'skb' and 'net_tx_action'
> values through _single_ data structure.
> In this proposal they are ctx->arg1 and ctx->arg2.
> I've considered having different bpf_context's for every event, but
> the complexity explodes. I need to hack all event definitions and so on.
> imo it's better to move complexity to userspace, so program author
> or high level language abstracts these details.

I still don't understand why making them long instead of u64 is
helpful, though.  I feel like I'm missing obvious here.

-- 
Andy Lutomirski
AMA Capital Management, LLC
