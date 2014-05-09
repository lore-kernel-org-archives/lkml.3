Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaEIEHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 00:07:50 -0400
Received: from [133.145.228.42] ([133.145.228.42]:58581 "EHLO
	mail7.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaEIEHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 00:07:48 -0400
Message-ID: <536C547A.40304@hitachi.com>
Date: Fri, 09 May 2014 13:07:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Lang <david@lang.hm>
Cc: Ingo Molnar <mingo@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
References: <cover.1398958771.git.jpoimboe@redhat.com> <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz> <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz> <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz> <20140506073228.GA26271@gmail.com> <20140506122302.GC4125@treble.redhat.com> <20140507121924.GA12234@gmail.com> <alpine.DEB.2.02.1405081840580.17457@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1405081840580.17457@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/09 10:46), David Lang wrote:
> On Wed, 7 May 2014, Ingo Molnar wrote:
> 
>> * Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>>
>>> On Tue, May 06, 2014 at 09:32:28AM +0200, Ingo Molnar wrote:
>>>>
>>>> * Jiri Kosina <jkosina@suse.cz> wrote:
>>>>
>>>>> On Mon, 5 May 2014, David Lang wrote:
>>>>>
>>>>>> how would you know that all instances of the datastructure in memory
>>>>>> have= been touched? just because all tasks have run and are outside the
>>>>>> function in question doesn't tell you data structures have been
>>>>>> converted. You have n= o way of knowing when (or if) the next call to
>>>>>> the modified function will take place on any potential in-memory
>>>>>> structure.
>>>>>
>>>>> The problem you are trying to avoid here is functions expecting to read
>>>>> "v2" format of the data from memory, while there are still tasks that are
>>>>> unpredictably writing "v1" format of the data to the memory.
>>>>>
>>>>> There are several ways to attack this problem:
>>>>>
>>>>> - stop the whole system, convert all the existing data structures to new
>>>>>   format (which might potentially be non-trivial, mostly because you
>>>>>   have to *know* where all the data structures have been allocated), apply
>>>>>   patch, resume operation [ksplice, probably kpatch in future]
>>>>> - restrict the data format to be backwards compatible [to be done
>>>>>   manually during patch creation, currently what kGraft needs to do in
>>>>>   such case]
>>>>> - have a proxy code which can read both "v1" and "v2" formats, and writes
>>>>>   back in the same format it has seen the data structure on input
>>>>> - once all the *code* has been converted, it still has to understand "v1"
>>>>>   and "v2", but it can now start writing out "v2" format only [possible
>>>>>   with kGraft, not implemented in automated fashion]
>>>>>
>>>>> Ideas are of course more than welcome.
>>>>
>>>> So what I'm curious about, what is the actual 'in the field' distro
>>>> experience, about the type of live-patches that get pushed with
>>>> urgency?
>>>>
>>>> My guess would be that the overwhelming majority of live-patches don't
>>>> change data structures - and hence the right initial model would be to
>>>> ensure (via tooling, and via review) that 'v1' and 'v2' data is
>>>> exactly the same.
>>>
>>> Yes, in general we want to avoid data changes.  In practice, we expect
>>> most patches to be small, localized security fixes, so it shouldn't be
>>> an issue in most cases.
>>>
>>> Currently the kpatch tooling detects any compile-time changes to
>>> static data and refuses to build the patch module in that case.
>>>
>>> But there's no way to programmatically detect changes to dynamic
>>> data. Which is why the user always has to be very careful when
>>> selecting a patch.
>>
>> And since this is about the system kernel it's dead easy to mess up a
>> new kernel function and make the system unbootable - so it's not like
>> 'be careful' isn't something implied already.
> 
> It's possible to have two versions of code that each work independently, but 
> that you can't switch between easily on the fly.
> 
> If the new code assumes a lock is held that the old code didn't take, then when 
> you switch, you are eventually going to hit a case where the new code trys to 
> release a lock it doesn't hold.
> 
> detecting all possible cases progromatically seems close to impossible.

Agreed. Perhaps, spinlock or locks which have small critical section are
usually able to make safe, because a lock caller also does unlock.
But mutex etc. usually have different locker/unlocker function.
In that case, we'll need to check running all functions which is in the
critical region.

> but this means that there are two categories of patches
> 
> 1. patches that are safe to put in a kernel that you are going to boot from
> 
> 2. patches that are able to be applied on the fly
> 
> and the tool isn't going to be able to tell you which category the patch is in. 
> It can identify some of the items that make it unlikely or impossible for the 
> patch to belong to #2, but don't rely on the tool catching all of them

Yeah, I think we'd better start with heuristic decision. Most of the
cases, it could be applied.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


