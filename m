Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab3BRFBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:01:00 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:60983 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab3BRFA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:00:59 -0500
Message-ID: <5121B585.10703@kernel.org>
Date: Mon, 18 Feb 2013 00:00:53 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: cpuidle sizes (Re: [PATCH 14/16] intel_idle: remove use and definition
 of MWAIT_MAX_NUM_CSTATES)
References: <1360372100-28482-1-git-send-email-lenb@kernel.org> <137ecc779c80138723677209730738d76262e810.1360371180.git.len.brown@intel.com> <5118B16E.6010709@linaro.org> <511982C6.7080505@kernel.org> <511AC5A8.4030509@linaro.org>
In-Reply-To: <511AC5A8.4030509@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 05:43 PM, Daniel Lezcano wrote:
> On 02/12/2013 12:46 AM, Len Brown wrote:
>> On 02/11/2013 03:53 AM, Daniel Lezcano wrote:
>>> On 02/09/2013 02:08 AM, Len Brown wrote:
>>
>>>> The reason to change is that intel_idle will soon be able
>>>> to export more than the 8 "major" states supported by MWAIT.
>>>> When we hit that limit, it is important to know
>>>> where the limit comes from.
>>>
>>> Does it mean CPUIDLE_STATE_MAX may increase in a near future ?
>>
>> Yes, perhaps to 10.
>> Let me know if you anticipate issues with doing that.
> 
> No, I don't see any issue so far. Maybe the array state is increasing
> more and more, so for most architecture it is a waste of memory, but
> anyway ...

aking a quick look at data structure sizes...

struct cpuidle_device{} is allocated per cpu --
so if we have a lot of cpus, that gets multiplied out.
But it doesn't grow much with growing CPUIDLE_STATE_MAX:

cpuidle_state_usage states_usage[CPUIDLE_STATE_MAX];
	we just shrunk to 24 bytes from 32 bytes/entry.
	(and 240 < 256, so we're still shrinking:-)

plus it contains cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
	which is a set of pointers per cpu - so with 8-byte
	pointers, that would be 64->80 bytes/cpu.

The other sizes that vary with CPUIDLE_STATE_MAX
seem to be static allocations per driver --
and so they don't grow much.  Did I miss something?

thanks,
Len Brown, Intel Open Source Technology Center

ps. I can easily offer an arch-specific CPUIDLE_STATE_MAX over-ride
if you want to squeeze bytes per-arch.

