Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaIZXNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:13:52 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:49989 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaIZXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:13:49 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUP=LE2QNzYL8LCukeuWeumOn0bm0eqYscc7GJqq45oYA@mail.gmail.com>
References: <CALCETrVrHHxGo1RkPu+9LVnPo9XY9yYnJzg2ot0zOgoBspzbOQ@mail.gmail.com>
	<CAMEtUuyt9RASKZ4NeqK_OUYNN8QT6P20+kjcwywchur6QXSt0A@mail.gmail.com>
	<CALCETrXS5KBHm-3Fz031VFPpTHC_BDOLd_zNB6DjCidZa5-x2A@mail.gmail.com>
	<CAMEtUux-WFOGABTrWW=BGUstE=Zz6agXTGCGrRJtNXDfRmx-5A@mail.gmail.com>
	<CALCETrVLtJOYkHwsmwueZ7jsSgrNED564W+m4FmMZJZL-836mg@mail.gmail.com>
	<CAMEtUuxq7oNmDAHZ+1t4Vd-QhW6SV7eoM_juxXGEDJBF3Nfu6A@mail.gmail.com>
	<CALCETrWcmZVmRZARM_s9S-zZ4Xm_TcxRrzJWGwL0O9ySmVgr5A@mail.gmail.com>
	<CAMEtUuzQF+3uWFWmj5nSdYoJfo0W2F0wkvoyc4pP--EH3O_jYA@mail.gmail.com>
	<CALCETrUP=LE2QNzYL8LCukeuWeumOn0bm0eqYscc7GJqq45oYA@mail.gmail.com>
Date: Fri, 26 Sep 2014 16:13:47 -0700
Message-ID: <CAMEtUuw4-7GyjGUC4yfCCyQTVZAiG-Fxa5gRdj-UA1BJ2V381A@mail.gmail.com>
Subject: Re: eBPF verifier thoughts (Re: [PATCH v15 net-next 00/11] eBPF
 syscall, verifier, testsuite)
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
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

On Fri, Sep 26, 2014 at 3:41 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Sep 26, 2014 at 3:26 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Fri, Sep 26, 2014 at 3:07 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Sep 26, 2014 at 3:03 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>> On Fri, Sep 26, 2014 at 2:47 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>>
>>>>> Can't you just disallow the 1-byte write to the stack?
>>>>
>>>> of course not.
>>>> That would be extremely limiting to users.
>>>> Can you actually see yourself living with stack that only
>>>> allows 8-byte writes/reads?
>>>> The stack usage will increase a lot, since all char/short
>>>> stack variables will become 8-byte...
>>>
>>> How about requiring that sub-8-byte stack accesses only be to integer slots?
>>
>> you mean to reject the sub-8-byte write early if it's going
>> into space where pointers were stored?
>> That will limit stack reuse.
>> gcc/llvm generate code where the same stack location
>> is used by different variables during life of the function.
>> So if I reject the write early, it will break otherwise valid
>> programs.
>
> I think that a sub-8-byte write to an integer slot should leave it as
> an integer and a sub-8-byte write to a non-integer slot should turn
> that slot into an integer (if conversions to integer are permitted) or
> be rejected otherwise.  gcc/llvm could emit an 8-byte write first, as
> needed, to make this valid.

I don't think the above will work.

> Alternatively, an integer stack slot could have a bitmask indicating
> which bytes are valid.

but this one might. Let me think about it more.
Note verifier, as it stands, is using 12Kbyte of temporary
memory to track stack with byte granularity.
(it's freed as soon as verifier finishes)
This bitmask optimization, best case, will reduce it to 1.5Kbyte
at the cost of extra complexity. I'll play with this idea to
see whether this trade off is actually worth doing.
Also note that there are indirect stack reads
(see check_func_arg() -> check_stack_boundary())
used to verify that N bytes were initialized in stack
before calling into helper function.
Also in the future I was planning to allow
indirect stack write, so that helper function can
store stuff into program stack. This indirect accesses
are crossing 8-byte boundaries, so would need special
care with bitmask optimization.
We need to carefully weight all pros and cons.
imo this memory usage during verification is not a big deal,
but of course we should not waste it. I'll see what can be done.

In any case, we're talking about incremental improvements
on top of current stuff, right?
