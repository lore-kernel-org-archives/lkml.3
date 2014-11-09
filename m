Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaKIJnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:43:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaKIJnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:43:08 -0500
Message-ID: <545F3724.7070502@suse.cz>
Date: Sun, 09 Nov 2014 10:43:00 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "P. Christeas" <xrg@linux.gr>, linux-mm@kvack.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Norbert Preining <preining@logic.at>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
References: <12996532.NCRhVKzS9J@xorhgos3.pefnos> <3583067.00bS4AInhm@xorhgos3.pefnos> <545BEA3B.40005@suse.cz> <3443150.6EQzxj6Rt9@xorhgos3.pefnos> <545E96BD.5040103@suse.cz> <20141109082746.GA3402@amd>
In-Reply-To: <20141109082746.GA3402@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 09:27 AM, Pavel Machek wrote:
> Hi!
> 
>>>> Oh and did I ask in this thread for /proc/zoneinfo yet? :)
>>>
>>> Using that same kernel[1], got again into a race, gathered a few more data.
>>>
>>> This time, I had 1x "urpmq" process [2] hung at 100% CPU , when "kwin" got 
>>> apparently blocked (100% CPU, too) trying to resize a GUI window. I suppose 
>>> the resizing operation would mean heavy memory alloc/free.
>>>
>>> The rest of the system was responsive, I could easily get a console, login, 
>>> gather the files.. Then, I have *killed* -9 the "urpmq" process, which solved 
>>> the race and my system is still alive! "kwin" is still running, returned to 
>>> regular CPU load.
>>>
>>> Attached is traces from SysRq+l (pressed a few times, wanted to "snapshot" the 
>>> stack) and /proc/zoneinfo + /proc/vmstat
>>>
>>> Bisection is not yet meaningful, IMHO, because I cannot be sure that "good" 
>>> points are really free from this issue. I'd estimate that each test would take 
>>> +3days, unless I really find a deterministic way to reproduce the issue .
>>
>> Hi,
>>
>> I think I finally found the cause by staring into the code... CCing
>> people from all 4 separate threads I know about this issue.
>> The problem with finding the cause was that the first report I got from
>> Markus was about isolate_freepages_block() overhead, and later Norbert
>> reported that reverting a patch for isolate_freepages* helped. But the
>> problem seems to be that although the loop in isolate_migratepages exits
>> because the scanners almost meet (they are within same pageblock), they
>> don't truly meet, therefore compact_finished() decides to continue, but
>> isolate_migratepages() exits immediately... boom! But indeed e14c720efdd7
>> made this situation possible, as free scaner pfn can now point to a
>> middle of pageblock.
> 
> Ok, it seems it happened second time now, again shortly after
> resume. I guess I should apply your patch after all.

Thanks.

> (Or... instead it should go to Linus ASAP -- it fixes known problem
> that is affected people, and we want it in soon in case it is not
> complete fix.)

I don't want to send untested fix, and wasn't able to reproduce the bug
myself. I think Norbert could do it rather quickly so I hope he can tell
us soon.

> Dmesg is in the attachment, perhaps it helps.
> 									Pavel

It looks the same as before, so no surprises there, which is good.

