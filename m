Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbbAORYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:24:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53376 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbbAORY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:24:28 -0500
Message-ID: <54B7F7C4.2070105@codeaurora.org>
Date: Thu, 15 Jan 2015 22:54:20 +0530
From: Vinayak Menon <vinmenon@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov@parallels.com,
        mgorman@suse.de, minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in too_many_isolated
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150114165036.GI4706@dhcp22.suse.cz>
In-Reply-To: <20150114165036.GI4706@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 10:20 PM, Michal Hocko wrote:
> On Wed 14-01-15 17:06:59, Vinayak Menon wrote:
> [...]
>> In one such instance, zone_page_state(zone, NR_ISOLATED_FILE)
>> had returned 14, zone_page_state(zone, NR_INACTIVE_FILE)
>> returned 92, and GFP_IOFS was set, and this resulted
>> in too_many_isolated returning true. But one of the CPU's
>> pageset vm_stat_diff had NR_ISOLATED_FILE as "-14". So the
>> actual isolated count was zero. As there weren't any more
>> updates to NR_ISOLATED_FILE and vmstat_update deffered work
>> had not been scheduled yet, 7 tasks were spinning in the
>> congestion wait loop for around 4 seconds, in the direct
>> reclaim path.
>
> Not syncing for such a long time doesn't sound right. I am not familiar
> with the vmstat syncing but sysctl_stat_interval is HZ so it should
> happen much more often that every 4 seconds.
>

Though the interval is HZ, since the vmstat_work is declared as a 
deferrable work, IIUC the timer trigger can be deferred to the
next non-defferable timer expiry on the CPU which is in idle. This 
results in the vmstat syncing on an idle CPU delayed by seconds. May be 
in most cases this behavior is fine, except in cases like this. Even in 
usual cases were the timer triggers in 1-2 secs, is it fine to let the 
tasks in reclaim path wait that long unnecessarily when there isn't any 
real congestion?

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
