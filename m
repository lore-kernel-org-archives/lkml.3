Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3HVLPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:15:25 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34749 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3HVLPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130820140406.694b248b41611883878f8245@linux-foundation.org>
References: <1376767883-4411-1-git-send-email-hannes@cmpxchg.org>
	<20130820140406.694b248b41611883878f8245@linux-foundation.org>
Date: Thu, 22 Aug 2013 14:15:20 +0300
Message-ID: <CAL1dPcdnq-aB0=PUH5w5Euk2mMKb-_yC7cheZdpGDjFGR+sV7Q@mail.gmail.com>
Subject: Re: [patch 9/9] mm: thrash detection-based file cache sizing v4
From: Metin Doslu <metin@citusdata.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey everbody,

I run following tests, and it shows in what cases this patch is
beneficial for us.

Test Environment:

* Ubuntu Server 12.04.2 LTS Linux 3.2.0-40-virtual #64-Ubuntu on EC2.
* 15 GB memory (DMA32 4GB + Normal 11GB).

Test Settings:

We have two PostgreSQL tables with same size of 9.75GB (65% of total
memory), where these tables contain clickstream events for March and
April. We call these two tables "events_march" and "events_april"
respectively.

Problem (Before Patch is Applied):

I pass over events_march data twice with an example query, such as
"select count(*) from events_march". This activates all of
events_march's pages.

I then pass over events_april dozens of times with a similar query. No
matter how many times I query events_april, I can't get completely get
this table's pages into memory. This happens even when events_march
isn't touched at all, events_april easily fits into memory, and
events_april has been referenced dozens of times.

After Patch is Applied:

This time, after three passes over events_april, all the pages are
cached in memory. (4th access is completely served from memory.)

I also repeated this test with a bigger dataset of size 12GB (80% of
total memory) for both events_march and events_april, and observed the
same results. (after 3rd pass, all of pages in events_april are
cached.)

Thank you,
Metin

On Wed, Aug 21, 2013 at 12:04 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 17 Aug 2013 15:31:14 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
>
>> This series solves the problem by maintaining a history of pages
>> evicted from the inactive list, enabling the VM to tell streaming IO
>> from thrashing and rebalance the page cache lists when appropriate.
>
> I can't say I'm loving the patchset.  It adds significant bloat to the
> inode (of all things!), seems to add some runtime overhead and
> certainly adds boatloads of complexity.
>
> In return for which we get...  well, I don't know what we get - no data
> was included.  It had better be good!
>
> To aid in this decision, please go through the patchset and calculate
> and itemize the overhead: increased inode size, increased radix-tree
> consumption, lengthier code paths, anything else I missed  Others can
> make their own judgements regarding complexity increase.
>
> Then please carefully describe the benefits, then see if you can
> convince us that one is worth the other!
>
