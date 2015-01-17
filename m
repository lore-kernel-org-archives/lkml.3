Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbbAQPSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:18:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51985 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbbAQPS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:18:29 -0500
Message-ID: <54BA7D3A.40100@codeaurora.org>
Date: Sat, 17 Jan 2015 20:48:18 +0530
From: Vinayak Menon <vinmenon@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov@parallels.com,
        mgorman@suse.de, minchan@kernel.org, Christoph Lameter <cl@gentwo.org>
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in too_many_isolated
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150114165036.GI4706@dhcp22.suse.cz> <54B7F7C4.2070105@codeaurora.org> <20150116154922.GB4650@dhcp22.suse.cz>
In-Reply-To: <20150116154922.GB4650@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 09:19 PM, Michal Hocko wrote:
> On Thu 15-01-15 22:54:20, Vinayak Menon wrote:
>> On 01/14/2015 10:20 PM, Michal Hocko wrote:
>>> On Wed 14-01-15 17:06:59, Vinayak Menon wrote:
>>> [...]
>>>> In one such instance, zone_page_state(zone, NR_ISOLATED_FILE)
>>>> had returned 14, zone_page_state(zone, NR_INACTIVE_FILE)
>>>> returned 92, and GFP_IOFS was set, and this resulted
>>>> in too_many_isolated returning true. But one of the CPU's
>>>> pageset vm_stat_diff had NR_ISOLATED_FILE as "-14". So the
>>>> actual isolated count was zero. As there weren't any more
>>>> updates to NR_ISOLATED_FILE and vmstat_update deffered work
>>>> had not been scheduled yet, 7 tasks were spinning in the
>>>> congestion wait loop for around 4 seconds, in the direct
>>>> reclaim path.
>>>
>>> Not syncing for such a long time doesn't sound right. I am not familiar
>>> with the vmstat syncing but sysctl_stat_interval is HZ so it should
>>> happen much more often that every 4 seconds.
>>>
>>
>> Though the interval is HZ, since the vmstat_work is declared as a
>> deferrable work, IIUC the timer trigger can be deferred to the next
>> non-defferable timer expiry on the CPU which is in idle. This results
>> in the vmstat syncing on an idle CPU delayed by seconds. May be in
>> most cases this behavior is fine, except in cases like this.
>
> I am not sure I understand the above because CPU being idle doesn't
> seem important AFAICS. Anyway I have checked the current code which has
> changed quite recently by 7cc36bbddde5 (vmstat: on-demand vmstat workers
> V8). Let's CC Christoph (the thread starts here:
> http://thread.gmane.org/gmane.linux.kernel.mm/127229).
>

I will try to explain the exact observations. All the cases which I had 
encountered, had similar symptoms. In one of the cases, it was CPU3 
alone which had not updated the vmstat_diff. This CPU was in idle for 
around 30 secs. When I looked at the tvec base for this CPU, the timer 
associated with vmstat_update had its expiry time less than current 
jiffies. This timer had its deferrable flag set, and was tied to the 
next non-deferrable timer in the list. Since deferrable timers can't 
wake up the CPU, the vmstat sync for this CPU was deferred for a long 
time i.e. till the expiry of next non-deferrable timer. The issue was 
caught because, one of the tasks which was in reclaim path and in the 
congestion_wait loop had an associated watchdog, which resulted in a 
panic after 4secs. So 4 secs is actually the watchdog expiry, and the 
time we can get blocked in the congestion loop can be even more.



-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
