Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaFEOAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:00:16 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:59483 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaFEOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:00:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140605133747.GB2942@dhcp22.suse.cz>
References: <53905594d284f_71f12992fc6a@nysa.notmuch>
	<20140605133747.GB2942@dhcp22.suse.cz>
Date: Thu, 5 Jun 2014 09:00:10 -0500
Message-ID: <CAMP44s1kk8PyMd603g0C9yvHuuUZXzwwNQHpM8Abghvc_Os-SQ@mail.gmail.com>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 8:37 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Thu 05-06-14 06:33:40, Felipe Contreras wrote:

>> For a while I've noticed that my machine bogs down in certain
>> situations, usually while doing heavy I/O operations, it is not just the
>> I/O operations, but everything, including the graphical interface, even
>> the mouse pointer.
>>
>> As far as I can recall this did not happen in the past.
>>
>> I noticed this specially on certain operations, for example updating a
>> a game on Steam (to an exteranl USB 3.0 device), or copying TV episodes
>> to a USB memory stick (probably flash-based).
>
> We had a similar report for opensuse. The common part was that there was
> an IO to a slow USB device going on.

Well, it's a USB 3.0 device, I can write at 250 MB/s, so it's not
really that slow.

And in fact, when I read and write to and from the same USB 3.0
device, I don't see the issue.

>> Then I went back to the latest stable version (v3.14.5), and commented
>> out the line I think is causing the slow down:
>>
>>   if (nr_unqueued_dirty == nr_taken || nr_immediate)
>>         congestion_wait(BLK_RW_ASYNC, HZ/10);
>
> Yes, I came to the same check. I didn't have any confirmation yet so
> thanks for your confirmation. I've suggested to reduce this
> congestion_wait only to kswapd:
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 32c661d66a45..ef6a1c0e788c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1566,7 +1566,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
>                  * implies that pages are cycling through the LRU faster than
>                  * they are written so also forcibly stall.
>                  */
> -               if (nr_unqueued_dirty == nr_taken || nr_immediate)
> +               if ((nr_unqueued_dirty == nr_taken || nr_immediate) && current_is_kswapd())
>                         congestion_wait(BLK_RW_ASYNC, HZ/10);
>         }

Unfortunately that doesn't fix the issue for me.

-- 
Felipe Contreras
