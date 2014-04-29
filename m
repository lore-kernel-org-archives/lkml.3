Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbaD2PvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:51:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:14458 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbaD2PvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:51:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,951,1389772800"; 
   d="scan'208";a="502987086"
Message-ID: <535FC688.4090502@intel.com>
Date: Tue, 29 Apr 2014 17:34:32 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zdenek Herman <zdenek@ille.cz>, linux-kernel@vger.kernel.org
Subject: Re: usermodehelper lock error at resume
References: <s5h8ur3ujmy.wl%tiwai@suse.de> <s5hwqe888wv.wl%tiwai@suse.de>
In-Reply-To: <s5hwqe888wv.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2014 5:14 PM, Takashi Iwai wrote:
> At Fri, 18 Apr 2014 10:28:05 +0200,
> Takashi Iwai wrote:
>> [my previous post didn't seem to go out by some reason, so I just
>>   resend this; please disregard if you already received it.]
> Hmm, I still can't see this in LKML archives...
> Did you guys receive my previous post below?
>

I did, sorry for not responding, I'm buried under stuff at the moment.

Rafael


>> Hi,
>>
>> we've received a bug report with 3.14.x kernel regarding the firmware
>> loading of intel BT device at suspend/resume:
>>    https://bugzilla.novell.com/show_bug.cgi?id=873790
>>
>> It's a WARN_ON() that was recently introduced.  And, it turned out
>> that the problem basically comes from a small window between the
>> process resume and the clear of usermodehelper lock.
>>
>> The request_firmware() function checks the UMH lock and gives up when
>> it's in DISABLE state.  This is for avoiding the invalid  f/w loading
>> during suspend/resume phase.  The problem is that
>> usermodehelper_enable() is called at the end of thaw_processes().
>> Thus, a thawed process in between can kick off the f/w loader code
>> path (in this case, via btusb_setup_intel()) even before the call of
>> usermodehelper_enable().  Then usermodehelper_read_trylock() returns
>> an error and request_firmware() spews WARN_ON() in the end.
>>
>> The oneliner patch below seems fixing the problem.  But, I'm not quite
>> sure whether it's the best; rather usermodehelper_enable() can be
>> moved there, or better to define yet another state, e.g. UMH_THAWING,
>> instead of reusing UMH_FREEZING?
>>
>> Suggestions?
>>
>> Once when we agree, I'll cook up a proper patch.
>>
>>
>> thanks,
>>
>> Takashi
>>
>> ---
>> diff --git a/kernel/power/process.c b/kernel/power/process.c
>> index 06ec8869dbf1..9c7552f092f2 100644
>> --- a/kernel/power/process.c
>> +++ b/kernel/power/process.c
>> @@ -181,6 +181,8 @@ void thaw_processes(void)
>>   	pm_nosig_freezing = false;
>>   
>>   	oom_killer_enable();
>> +	/* allow request_firmare() at this point */
>> +	__usermodehelper_set_disable_depth(UMH_FREEZING);
>>   
>>   	printk("Restarting tasks ... ");
>>   

