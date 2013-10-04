Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3JDNxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:53:09 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754917Ab3JDNxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:53:07 -0400
Message-ID: <524EC83C.9050309@nod.at>
Date: Fri, 04 Oct 2013 15:53:00 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dmitry Vyukov <dvyukov@google.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs: make sure we do not read beyond allocation
References: <20131003163411.GA17101@www.outflux.net> <20131003175824.GH13318@ZenIV.linux.org.uk> <CAGXu5j+8sxc8vc4bwv14nGNiOhq-ey2nxAK99LgMKO+Qmh1L6A@mail.gmail.com> <20131003182311.GI13318@ZenIV.linux.org.uk> <CAGXu5j+4NUKfgKiAK+w2MrsqRxHiYc62LBMx4UsfxUBSxNwNJA@mail.gmail.com> <20131003205706.GM13318@ZenIV.linux.org.uk> <CACT4Y+Z_hxVOqUeVtvOH-eCkTLveW3vsPtcXN-jhs7=cbd21Zw@mail.gmail.com> <CAFLxGvxo8bvg0Pn8z3qUENFNOUmNdfp5Cz_WP=H5G8kXubdR3A@mail.gmail.com> <CACT4Y+aYuVfe7-xjLC97SKpyFeO_6XeO1OjLMda58TfqxR_MMw@mail.gmail.com>
In-Reply-To: <CACT4Y+aYuVfe7-xjLC97SKpyFeO_6XeO1OjLMda58TfqxR_MMw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.10.2013 12:53, schrieb Dmitry Vyukov:
> On Fri, Oct 4, 2013 at 2:38 PM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
>>>>>> ...
>>>>>> [1] yes, yes, I know - the mere mention of security should've prevented such
>>>>>> arrogant requests.  It's an imperfect universe.
>>>>>
>>>>> I want to attempt to disassemble what you've communicating here:
>>>>>
>>>>> a) I'm not thinking.
>>>>> b) Requesting that someone think when they mention security is arrogant.
>>>>
>>>> Not really.
>>>>
>>>> It's just that all too often completely pointless changes are touted
>>>> as security hardening.  With replies along the lines of "it doesn't
>>>> really buy you anything" countered with indignant "but what if
>>>> <impossible situation>" and/or references to "defense in depth" (used
>>>> as a magical incantation), etc.
>>>>
>>>> You've posted a provably pointless patch.  Happens to all of us.  And in
>>>> reply to "it's pointless for the following reasons" (with moderate
>>>> level of sarcasm) you responded pretty much with "but what if allocator
>>>> changes?  It's more robust that way".  OK, but if you go for that
>>>> kind of arguments (and they can be valid), you'd better be correct.
>>>> You were not, and for very obvious reasons.  Let me repeat, this
>>>> time with sarcasm level down to zero:
>>>>
>>>> Let n be some integer between 32 and 4096 and N be equal to n rounded up
>>>> to word size.  If kmalloc(n) returns a pointer such that fetch from
>>>> (char *)p[N - 1] triggers an exception, we have a badly broken kernel.
>>>> It can happen only if there is a page boundary between p[n-1] and p[N-1],
>>>> which means that p is not word-aligned.
>>>> Consider the following code:
>>>>         struct foo {
>>>>                 unsigned long n;
>>>>                 char a[];
>>>>         } *p = kmalloc(offsetof(struct foo, a) + 33);
>>>>         if (p)
>>>>                 p->n = 1;
>>>> and note that it will result in an exception on any architecture that prohibits
>>>> unaligned accesses in the kernel.  Even on architectures where those are
>>>> allowed, misaligned structures mean serious correctness problems (atomicity of
>>>> stores, etc.)
>>>>
>>>> In other words, kmalloc() (or, indeed, userland malloc()) demonstrating
>>>> such behaviour would need immediate fixing.  The only exception I can
>>>> think of is something with byte granularity of memory protection; in such
>>>> case we can have that without unaligned return values returned by allocator.
>>>> Which would require a lot of changes in mm/*, at the very least, and probably
>>>> would violate a lot of assumptions elsewhere in the kernel (starting with
>>>> sizeof(void *) == sizeof(unsigned long)).
>>>>
>>>>> What the patch does help with, though, is dynamic analysis tools that
>>>>> are looking for out-of-bound reads, which this clearly is. It should
>>>>> be considered a violation of the API to attempt to access a range
>>>>> beyond what was requested for the allocation. Fixing this means lots
>>>>> of noise vanishes from such analysis of the allocation API, letting
>>>>> other tools besides just KASAN do work to find other more serious
>>>>> problems in heap usage.
>>>>>
>>>>> Does fixing this to help dynamic analysis tools somehow make the
>>>>> kernel worse? I think that fixing this makes it easier to find further
>>>>> bugs that might be much more serious.
>>>>
>>>> Possibly true.  But then I'd suggest wrapping that into a different ifdef;
>>>> grep for ifdef __CHECKER__, with comment along the lines of "to simplify
>>>> analysis of potential out-of-bounds accesses".
>>>
>>>
>>> Hi,
>>>
>>> Any single reason to not just fix the code?
>>>
>>> With this patch:
>>> + sticks with "do not access beyond request size", which is a good
>>> thing all others equal
>>> + makes static and dynamic verification tools happy
>>> - ???
>>
>> - It does not fix anything, it only shuts up the checker
>> - It adds another ifdef where it is not obvious why it's needed
>>
>> Therefore it makes more sense to add a ifdef __CHECKER__ such that
>> everyone immediately knows that the issue is only false positive.
> 
> 
> OK, is it explicitly documented somewhere that it's legal to access
> memory blocks beyond requested size? Is it a deliberate decision made
> by community? Or just an ad-hoc argument based on details of current
> implementation?

Al explained already why it is legal.

> If it's the former then we will need to teach the tools to understand
> it. But IMVHO it's a very unfortunate decision, because it will hide
> real harmful bugs. And this is the only place where I observed such
> out-of-bounds access after months of stress testing, so we are not
> talking about hundreds and thousands of precedents. We are talking
> about this particular case vs ability of tools to catch harmful
> off-by-one accesses to variable-length strings and buffers.

Have you ever used valgrind (or any other checkers in userspace)?
They all suffer from such issues.
If a checker reports a violation it is not always a real one and
you have to review it carefully.

Thanks,
//richard
