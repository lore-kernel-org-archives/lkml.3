Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbaEPQIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:08:49 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63852 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777AbaEPQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:08:46 -0400
Message-ID: <5376380C.8030607@lwfinger.net>
Date: Fri, 16 May 2014 11:08:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Chaoming Li <chaoming_li@realsil.com.cn>,
        Dmitry Semyonov <linulin@gmail.com>
Subject: Re: [PATCH 3.2 31/34] rtl8192ce: Fix null dereference in watchdog
References: <lsq.1400244441.849613969@decadent.org.uk>	 <53761EA9.6060508@lwfinger.net> <1400254689.2647.43.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1400254689.2647.43.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 10:38 AM, Ben Hutchings wrote:
> On Fri, 2014-05-16 at 09:20 -0500, Larry Finger wrote:
>> On 05/16/2014 07:47 AM, Ben Hutchings wrote:
>>> 3.2.59-rc1 review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Ben Hutchings <ben@decadent.org.uk>
>>>
>>> Dmitry Semyonov reported that after upgrading from 3.2.54 to
>>> 3.2.57 the rtl8192ce driver will crash when its interface is brought
>>> up.  The oops message shows:
>>>
>>> [ 1833.611397] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
>>> [ 1833.611455] IP: [<ffffffffa0410c6a>] rtl92ce_update_hal_rate_tbl+0x29/0x4db [rtl8192ce]
>>> ...
>>> [ 1833.613326] Call Trace:
>>> [ 1833.613346]  [<ffffffffa02ad9c6>] ? rtl92c_dm_watchdog+0xd0b/0xec9 [rtl8192c_common]
>>> [ 1833.613391]  [<ffffffff8105b5cf>] ? process_one_work+0x161/0x269
>>> [ 1833.613425]  [<ffffffff8105c598>] ? worker_thread+0xc2/0x145
>>> [ 1833.613458]  [<ffffffff8105c4d6>] ? manage_workers.isra.25+0x15b/0x15b
>>> [ 1833.613496]  [<ffffffff8105f6d9>] ? kthread+0x76/0x7e
>>> [ 1833.613527]  [<ffffffff81356b74>] ? kernel_thread_helper+0x4/0x10
>>> [ 1833.613563]  [<ffffffff8105f663>] ? kthread_worker_fn+0x139/0x139
>>> [ 1833.613598]  [<ffffffff81356b70>] ? gs_change+0x13/0x13
>>>
>>> Disassembly of rtl92ce_update_hal_rate_tbl() shows that the 'sta'
>>> parameter was null.  None of the changes to the rtlwifi family between
>>> 3.2.54 and 3.2.57 seem to directly cause this, and reverting commit
>>> f78bccd79ba3 ('rtlwifi: rtl8192ce: Fix too long disable of IRQs')
>>> doesn't fix it.
>>>
>>> rtl92c_dm_watchdog() calls rtl92ce_update_hal_rate_tbl() via
>>> rtl92c_dm_refresh_rate_adaptive_mask(), which does not appear in the
>>> call trace as it was inlined.  That function has been completely
>>> removed upstream which may explain why this crash wasn't seen there.
>>>
>>> I'm not sure that it is sensible to completely remove
>>> rtl92c_dm_refresh_rate_adaptive_mask() without making other
>>> compensating changes elsewhere, so try to work around this for 3.2 by
>>> checking for a null pointer in rtl92c_dm_refresh_rate_adaptive_mask()
>>> and then skipping the call to rtl92ce_update_hal_rate_tbl().
>>>
>>> References: https://bugs.debian.org/745137
>>> References: https://bugs.debian.org/745462
>>> Reported-by: Dmitry Semyonov <linulin@gmail.com>
>>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>>> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
>>> ---
>>
>> Ben,
>>
>> Your fix is a reasonable workaround. I have no explanation for this NULL pointer
>> dereference to suddenly appear; however, the pointer should have been checked
>> from the start.
>
> Are you saying this is also an upstream bug?

It is a possible upstream bug; however, crashes of the form reported by Dmitri 
have not been reported to me, but then I was not aware of his problem. A quick 
check shows that the pointers returned by ieee80211_find_sta() are checked in 
current mainline. There are some cases that need a second look. I will be 
submitting a patch to upstream and stable for any of them where the checking was 
missed.

Larry

