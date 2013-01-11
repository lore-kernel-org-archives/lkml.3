Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3AKL0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:26:00 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:39534 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab3AKLZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:25:56 -0500
X-Remote-IP: 213.191.128.133
Date: Fri, 11 Jan 2013 12:25:48 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <50EDE41C.7090107@iskon.hr> <1357867501.6568.19.camel@kernel.cn.ibm.com>
In-Reply-To: <1357867501.6568.19.camel@kernel.cn.ibm.com>
X-Spam-Score: ##
Message-ID: <50EFF6BC.4060200@iskon.hr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm: wait for congestion to clear on all zones
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20130111 #9018183, check: 20130111 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 41325 [Jan 11 2013]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.01.2013 02:25, Simon Jeons wrote:
> On Wed, 2013-01-09 at 22:41 +0100, Zlatko Calusic wrote:
>> From: Zlatko Calusic <zlatko.calusic@iskon.hr>
>>
>> Currently we take a short nap (HZ/10) and wait for congestion to clear
>> before taking another pass with lower priority in balance_pgdat(). But
>> we do that only for the highest zone that we encounter is unbalanced
>> and congested.
>>
>> This patch changes that to wait on all congested zones in a single
>> pass in the hope that it will save us some scanning that way. Also we
>> take a nap as soon as congested zone is encountered and sc.priority <
>> DEF_PRIORITY - 2 (aka kswapd in trouble).
> 
> But you still didn't explain what's the problem you meat and what
> scenario can get benefit from your change.
> 

I did in my reply to Andrew. Here's the relevant part:

> I have an observation that without it, under some circumstances that 
> are VERY HARD to repeat (many days need to pass and some stars to align
> to see the effect), the page cache gets hit hard, 2/3 of it evicted in
> a split second. And it's not even under high load! So, I'm still
> monitoring it, but so far the memory utilization really seems better
> with the patch applied (no more mysterious page cache shootdowns). 

The scenario that should get benefit is everyday. I observed problems during
light but constant reading from disk (< 10MB/s). And sending that data
over the network at the same time. Think backup that compresses data on the
fly before pushing it over the network (so it's not very fast).

The trouble is that you can't just fix up a quick benchmark and measure the
impact, because many days need to pass for the bug to show up in all it's beauty.

Is there anybody out there who'd like to comment on the patch logic? I.e. do
you think that waiting on every congested zone is the more correct solution
than waiting on only one (only the highest one, and ignoring the fact that
there may be other even more congested zones)?

Regards,
-- 
Zlatko
