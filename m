Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaJBO6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:58:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39100 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaJBO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:58:33 -0400
Message-ID: <542D680E.8010909@oracle.com>
Date: Thu, 02 Oct 2014 10:58:22 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org> <542C749B.1040103@oracle.com> <alpine.LSU.2.11.1410020154500.6444@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1410020154500.6444@eggly.anvils>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 05:23 AM, Hugh Dickins wrote:
> On Wed, 1 Oct 2014, Sasha Levin wrote:
>> On 10/01/2014 05:07 PM, Andrew Morton wrote:
>>> On Mon, 29 Sep 2014 21:47:14 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
>>>
>>>> Currently we're seeing a few issues which are unexplainable by looking at the
>>>> data we see and are most likely caused by a memory corruption caused
>>>> elsewhere.
>>>>
>>>> This is wasting time for folks who are trying to figure out an issue provided
>>>> a stack trace that can't really point out the real issue.
>>>>
>>>> This patch introduces poisoning on struct page, vm_area_struct, and mm_struct,
>>>> and places checks in busy paths to catch corruption early.
>>>>
>>>> This series was tested, and it detects corruption in vm_area_struct. Right now
>>>> I'm working on figuring out the source of the corruption, (which is a long
>>>> standing bug) using KASan, but the current code is useful as it is.
>>>
>>> Is this still useful if/when kasan is in place?
>>
>> Yes, the corruption we're seeing happens inside the struct rather than around it.
>> kasan doesn't look there.
>>
>> When kasan is merged, we could complement this patchset by making kasan trap on
>> when the poison is getting written, rather than triggering a BUG in some place
>> else after we saw the corruption.
>>
>>> It looks fairly cheap - I wonder if it should simply fall under
>>> CONFIG_DEBUG_VM rather than the new CONFIG_DEBUG_VM_POISON.
>>
>> Config options are cheap as well :)
>>
>> I'd rather expand it further and add poison/kasan trapping into other places such
>> as the vma interval tree rather than having to keep it "cheap".
> 
> I like to run with CONFIG_DEBUG_VM, and would not want this stuff
> turned on in my builds (especially not the struct page enlargement);
> so I'm certainly with you in preferring a separate option.
> 
> But it all seems very ad hoc to me.  Are people going to be adding
> more and more mm structures into it, ad infinitum?  And adding
> CONFIG_DEBUG_SCHED_POISON one day when someone notices corruption
> of a scheduler structure? etc etc.

That was my plan, yes.

> What does this add on top of slab poisoning?  Some checks in some
> mm places while the object is active, I guess: why not base those
> on slab poisoning?  And add them in as appropriate to the problem
> at hand, when a problem is seen.

The extra you're getting is detecting corruption that happened
inside the object rather than around it. In the case of poisoning
working along with kasan you don't have to limit it to slab either,
so you can detect issues in static objects as well.

fwiw, there's currently a long standing issue with corruption inside
spinlocks in sched code. This sort of issues always exist, so (at least)
my kernel would always have poisoning in some form from now on.

> I think these patches are fine for investigating whatever is the
> problem currently afflicting you and mm under trinity; but we all
> have our temporary debugging patches, I don't think all deserve
> preservation in everyone else's kernel, that amounts to far more
> clutter than any are worth.

If the issue is lines of code we can look into making it cleaner.

> I'm glad to hear they've confirmed some vm_area_struct corruption:
> any ideas on where that's coming from?

Nope, I've added kasan poisoning to vm_area_struct but it has not
reproduced since then, I've just hit bunch of different issues.


Thanks,
Sasha

