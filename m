Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaK1CWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:22:04 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41443 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaK1CWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:22:02 -0500
Message-ID: <5477DC41.8090509@hitachi.com>
Date: Fri, 28 Nov 2014 11:21:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Petr Mladek <pmladek@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCHv4 0/3] Kernel Live Patching
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <547596C6.2050303@hitachi.com> <alpine.LNX.2.00.1411261014510.23174@pobox.suse.cz> <20141126152759.GA29079@treble.hsd1.ky.comcast.net> <5476F7AD.3020601@hitachi.com> <20141127105233.GA5998@pathway.suse.cz>
In-Reply-To: <20141127105233.GA5998@pathway.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/27 19:52), Petr Mladek wrote:
> On Thu 2014-11-27 19:06:37, Masami Hiramatsu wrote:
>> (2014/11/27 0:27), Josh Poimboeuf wrote:
>>> On Wed, Nov 26, 2014 at 10:18:24AM +0100, Jiri Kosina wrote:
>>>> On Wed, 26 Nov 2014, Masami Hiramatsu wrote:
>>>>
>>>>>> Note to Steve:
>>>>>> Masami's IPMODIFY patch is heading for -next via your tree.  Once it arrives,
>>>>>> I'll rebase and make the change to set IPMODIFY.  Do not pull this for -next
>>>>>> yet.  This version (v4) is for review and gathering acks.
>>>>>
>>>>> BTW, as we discussed IPMODIFY is an exclusive flag. So if we allocate 
>>>>> ftrace_ops for each function in each patch, it could be conflict each 
>>>>> other.
>>>>
>>>> Yup, this corresponds to what Petr brought up yesterday. There are cases 
>>>> where all solutions (kpatch, kgraft, klp) would allocate multiple 
>>>> ftrace_ops for a single function entry (think of patching one function 
>>>> multiple times in a row).
>>>>
>>>> So it's not as easy as just setting the flag.
>>>>
>>>>> Maybe we need to have another ops hashtable to find such conflict and 
>>>>> new handler to handle it.
>>>>
>>>> If I understand your proposal correctly, that would sound like a hackish 
>>>> workaround, trying to basically trick the IPMODIFY flag semantics you just 
>>>> implemented :)
>>>
>>> I think Masami may be proposing something similar to what we do in
>>> kpatch today.  We have a single ftrace_ops and handler which is used for
>>> all functions.  The handler accesses a global hash of kpatch_func
>>> structs which is indexed by the original function's IP address.
>>
>> Hmm, I think both is OK. kpatch method is less memory consuming and
>> will have a bigger overhead. However, as Steven talked at Plumbers Conf.,
>> he will introduce a direct code modifying interface for ftrace. After
>> that is introduced, we don't need to care about performance degradation
>> by patching :)
> 
> Yup, I would prefer to have ftrace_ops per (original) function entry. I mean
> that new patches will reuse the existing ftrace_ops for already
> patched functions. They will just create new ftrace_ops from the
> not-yet-patched symbols.

However, too many ftrace_ops will get bigger overhead if conflicts
happened on any entry, since on such entry ftrace walks through
all registered ftrace_ops and checks its filter. It's a downside.
Perhaps, ftrace needs to have 2 different ftrace_ops lists, one
is for managing, and one is for walk through. And the latter list
drops the ftrace_ops which has trampoline and whose all filtered ip
is exclusively used (iow, such ftrace_ops never be hit in the walk
through).

> Using a single ftrace_ops everywhere would kill the win from
> Steven's direct ftrace optimization.

It depends on the implementation and interface. E.g. an explicit
path-change optimization interface for each address with ftrace_ops,
like as
  ftrace_change_path_ip(ftrace_ops *ops, unsigned long old_addr,
			unsigned long new_addr);

This checks ftrace_ops is already registered and has given old_addr
in filter, ensures no other ftrace_ops are registered on given address,
and then optimizes the fentry call to jump to the new_addr.

Anyway, at this point it is not a major discussion point, it's a
kind of minor implementation issue for performance and memory consuming.
We can switch it without changing API.

Thank you,

>>> It actually works out pretty well because it nicely encapsulates the
>>> knowledge about which functions are patched in a single place.  And it
>>> makes it easy to track function versions (for incremental patching and
>>> rollback).
>>>
>>>> What I'd propose instead is to make sure that we always have 
>>>> just a ftrace_ops per function entry, and only update the pointers there 
>>>> as necessary. Fortunately we can do the switch atomically, by making use 
>>>> of ->private.
>>>
>>> But how would you update multiple functions atomically, to enforce
>>> per-thread consistency?
>>
>> At this point, both can do it atomically. We just need an atomic flag
>> for applying patches.
> 
> By other words, we would need something like the "kgr_immutable" flag from
> kGraft. It will make sure that everybody stays with the current code until
> all function entries are updated.
> 
> Best Regards,
> Petr


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


