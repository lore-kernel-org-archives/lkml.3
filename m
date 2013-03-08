Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab3CHPBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:01:07 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:52504 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab3CHPBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:01:06 -0500
Message-ID: <5139FD27.1030208@symas.com>
Date: Fri, 08 Mar 2013 07:00:55 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19a1
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <20130307154312.GG6723@quack.suse.cz> <20130308020854.GC23767@cmpxchg.org> <5139975F.9070509@symas.com> <20130308084246.GA4411@shutemov.name> <5139B214.3040303@symas.com> <5139FA13.8090305@genband.com>
In-Reply-To: <5139FA13.8090305@genband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> On 03/08/2013 03:40 AM, Howard Chu wrote:
>
>> There is no way that a process that is accessing only 30GB of a mmap
>> should be able to fill up 32GB of RAM. There's nothing else running on
>> the machine, I've killed or suspended everything else in userland
>> besides a couple shells running top and vmstat. When I manually
>> drop_caches repeatedly, then eventually slapd RSS/SHR grows to 30GB and
>> the physical I/O stops.
>
> Is it possible that the kernel is doing some sort of automatic
> readahead, but it ends up reading pages corresponding to data that isn't
> ever queried and so doesn't get mapped by the application?

Yes, that's what I was thinking. I added a posix_madvise(..POSIX_MADV_RANDOM) 
but that had no effect on the test.

First obvious conclusion - kswapd is being too aggressive. When free memory 
hits the low watermark, the reclaim shrinks slapd down from 25GB to 18-19GB, 
while the page cache still contains ~7GB of unmapped pages. Ideally I'd like a 
tuning knob so I can say to keep no more than 2GB of unmapped pages in the 
cache. (And the desired effect of that would be to allow user processes to 
grow to 30GB total, in this case.)

I mentioned this "unmapped page cache control" post already 
http://lwn.net/Articles/436010/ but it seems that the idea was ultimately 
rejected. Is there anything else similar in current kernels?

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
