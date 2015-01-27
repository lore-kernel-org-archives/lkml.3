Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbbA0KeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:34:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46909 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbbA0KeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:34:06 -0500
Message-ID: <54C76995.70501@codeaurora.org>
Date: Tue, 27 Jan 2015 16:03:57 +0530
From: Vinayak Menon <vinmenon@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in too_many_isolated
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150114165036.GI4706@dhcp22.suse.cz> <54B7F7C4.2070105@codeaurora.org> <20150116154922.GB4650@dhcp22.suse.cz> <54BA7D3A.40100@codeaurora.org> <alpine.DEB.2.11.1501171347290.25464@gentwo.org> <20150126172832.GC22681@dhcp22.suse.cz>
In-Reply-To: <20150126172832.GC22681@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 10:58 PM, Michal Hocko wrote:
> On Sat 17-01-15 13:48:34, Christoph Lameter wrote:
>> On Sat, 17 Jan 2015, Vinayak Menon wrote:
>>
>>> which had not updated the vmstat_diff. This CPU was in idle for around 30
>>> secs. When I looked at the tvec base for this CPU, the timer associated with
>>> vmstat_update had its expiry time less than current jiffies. This timer had
>>> its deferrable flag set, and was tied to the next non-deferrable timer in the
>>
>> We can remove the deferrrable flag now since the vmstat threads are only
>> activated as necessary with the recent changes. Looks like this could fix
>> your issue?
>
> OK, I have checked the history and the deferrable behavior has been
> introduced by 39bf6270f524 (VM statistics: Make timer deferrable) which
> hasn't offered any numbers which would justify the change. So I think it
> would be a good idea to revert this one as it can clearly cause issues.
>
> Could you retest with this change? It still wouldn't help with the
> highly overloaded workqueues but that sounds like a bigger change and
> this one sounds like quite safe to me so it is a good start.

Sure, I can retest.
Even without highly overloaded workqueues, there can be a delay of HZ in 
updating the counters. This means reclaim path can be blocked for a 
second or more, when there aren't really any isolated pages. So we need 
the fix in too_many_isolated also right ?


-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
