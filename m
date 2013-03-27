Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3C0AcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:32:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42143 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3C0AcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:32:22 -0400
Message-ID: <51523C9C.1010806@linaro.org>
Date: Tue, 26 Mar 2013 17:26:04 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@lge.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, Arun Sharma <asharma@fb.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jason Evans <je@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC v7 00/11] Support vrange for anonymous page
References: <1363073915-25000-1-git-send-email-minchan@kernel.org> <514A6282.8020406@linaro.org> <20130322060113.GA4802@blaptop> <514C8FB0.4060105@linaro.org> <20130325084217.GC2348@blaptop>
In-Reply-To: <20130325084217.GC2348@blaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 01:42 AM, Minchan Kim wrote:
> On Fri, Mar 22, 2013 at 10:06:56AM -0700, John Stultz wrote:
>> So, if I understand you properly, its more an issue of the the added 
>> cost of making the purged range non-volatile, and re-faulting in the 
>> pages if we purge them all, when we didn't actually have the memory 
>> pressure to warrant purging the entire range? Hrm. Ok, I can sort of 
>> see that. So if we do partial-purging, all the data in the range is 
>> invalid - since we don't know which pages in particular were purged, 
>> but the costs when marking the range non-volatile and the costs of 
>> over-writing the pages with the re-created data will be slightly 
>> cheaper. 
> It could be heavily cheaper with my experiment in this patchset.
> Allocator could avoid minor fault from 105799867 to 9401.
>
>> I guess the other benefit is if you're using the SIGBUS semantics,
>> you might luck out and not actually touch a purged page. Where as if
>> the entire range is purged, the process will definitely hit the
>> SIGBUS if its accessing the volatile data.
> Yes. I guess that's why Taras liked it.
> Quote from old version
> "
> 4) Having a new system call makes it easier for userspace apps to
>     detect kernels without this functionality.
>
> I really like the proposed interface. I like the suggestion of having
> explicit FULL|PARTIAL_VOLATILE. Why not include PARTIAL_VOLATILE as a
> required 3rd param in first version with expectation that
> FULL_VOLATILE will be added later(and returning some not-supported error
> in meantime)?
> "

Thanks again for the clarifications on your though process here!

I'm currently trying to rework your patches so we can reuse this for 
file data as well as pure anonymous memory. The idea being that we add 
one level of indirection: a vrange_root structure, which manages the 
root of the rb interval tree as well as the lock. This vrange_root can 
then be included in the mm_struct as well as address_space structures 
depending on which type of memory we're dealing with. That way most of 
the same infrastructure can be used to manage per-mm volatile ranges as 
well as per-inode volatile ranges.

Sorting out how to handle vrange() calls that cross both anonymous and 
file vmas will be interesting, and may have some of the drawbacks of the 
vma based approach, but I think it will still be simpler.  To start we 
may just be able to require that any vrange() calls don't cross vma 
types (possibly using separate syscalls for file and anonymous vranges).

Anyway, that's my current thinkig. You can preview my current attempt here:
http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/vrange-minchan

Thanks so much again for your moving this work forward!
-john
