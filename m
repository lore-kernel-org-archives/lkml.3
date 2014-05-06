Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaEFVri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:47:38 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57614 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaEFVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140506163950.7e278f7c@gandalf.local.home>
References: <1397336454-13855-1-git-send-email-ddstreet@ieee.org>
 <1399057350-16300-1-git-send-email-ddstreet@ieee.org> <1399057350-16300-4-git-send-email-ddstreet@ieee.org>
 <20140505221846.4564e04d@gandalf.local.home> <CALZtONAr7XGMB8LHwKRjqeEaWTEKBbwkUuP1RAZd04YQiwxrGw@mail.gmail.com>
 <20140506163950.7e278f7c@gandalf.local.home>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 6 May 2014 17:47:16 -0400
X-Google-Sender-Auth: j3an7rTnMwq07b8myELHLqPjNJw
Message-ID: <CALZtONAUXiv6jfy8vW9NTotPR=V0q6Worcy9_rvou4A0s0whPw@mail.gmail.com>
Subject: Re: [PATCH 3/4] plist: add plist_rotate
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Weijie Yang <weijieut@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 4:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 6 May 2014 16:12:54 -0400
> Dan Streetman <ddstreet@ieee.org> wrote:
>
>> On Mon, May 5, 2014 at 10:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Fri,  2 May 2014 15:02:29 -0400
>> > Dan Streetman <ddstreet@ieee.org> wrote:
>> >
>> >> Add plist_rotate(), which moves the specified plist_node after
>> >> all other same-priority plist_nodes in the list.
>> >
>> > This is a little confusing? You mean it takes a plist_node from a plist
>> > and simply moves it to the end of the list of all other nodes of the
>> > same priority?
>>
>> yes, exactly
>>
>> > Kind of like what a sched_yield() would do with a
>> > SCHED_FIFO task? I wonder if we should call this "plist_yield()" then?
>>
>> I suppose it is similar, yes...I'll rename it in a v2 patch.
>
> I'm open to other suggestions as well. What else can give you the idea
> that it's putting a node at the end of its priority?

well the specific reason in swap's case is the need to use
same-priority entries in a round-robin basis, but I don't know if
plist_round_robin() is very clear.

Maybe plist_demote()?  Although demote might imply actually changing priority.

plist_shuffle()?  That might imply random shuffling though.

plist_readd() or plist_requeue()?  That might make sense since
technically the function could be replicated by just plist_del() and
plist_add(), based on the implementation detail that plist_add()
inserts after all other same-priority entries, instead of before.

Or add priority into the name explicitly, like plist_priority_yield(),
or plist_priority_rotate(), plist_priority_requeue()?

>
> I added Peter to the Cc list because I know how much he loves
> sched_yield() :-)
>
>>
>> >
>> >>
>> >> This is needed by swap, which has a plist of swap_info_structs
>> >> and needs to use each same-priority swap_info_struct equally.
>> >
>> > "needs to use each same-priority swap_info_struct equally"
>> >
>> > -ENOCOMPUTE
>>
>> heh, yeah that needs a bit more explaining doesn't it :-)
>>
>> by "equally", I mean as swap writes pages out to its swap devices, it
>> must write to any same-priority devices on a round-robin basis.
>
> OK, I think you are suffering from "being too involved to explain
> clearly" syndrome. :)
>
> I still don't see the connection between swap pages and plist, and even
> more so, why something would already be in a plist and then needs to be
> pushed to the end of its priority.
>
>>
>> I'll update the comment in the v2 patch to try to explain clearer.
>>
>
> Please do. But explain it to someone that has no idea how plists are
> used by the swap subsystem, and why you need to move a node to the end
> of its priority.

Ok here's try 3, before I update the patch :)  Does this make sense?

This is needed by the next patch in this series, which changes swap
from using regular lists to track its available swap devices
(partitions or files) to using plists.  Each swap device has a
priority, and swap allocates pages from devices in priority order,
filling up the highest priority device first (and then removing it
from the available list), by allocating a page from the swap device
that is first in the priority-ordered list.  With regular lists, swap
was managing the ordering by priority, while with plists the ordering
is automatically handled.  However, swap requires special handling of
swap devices with the same priority; pages must be allocated from them
in round-robin order.  To accomplish this with a plist, this new
function is used; when a page is allocated from the first swap device
in the plist, that entry is moved to the end of any same-priority
entries.  Then the next time a page needs to be allocated, the next
swap device will be used, and so on.
