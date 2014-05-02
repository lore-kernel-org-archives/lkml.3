Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaEBQ1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:27:34 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:51828 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbaEBQZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:25:36 -0400
Date: Fri, 2 May 2014 18:25:30 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <80394451.20140502182530@eikelenboom.it>
To: Takashi Iwai <tiwai@suse.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>, <linux-sound@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Sound USB: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
In-Reply-To: <s5hppjwqhuy.wl%tiwai@suse.de>
References: <1399036167-6203-1-git-send-email-linux@eikelenboom.it> <1399036167-6203-2-git-send-email-linux@eikelenboom.it> <s5hppjwqhuy.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Friday, May 2, 2014, 6:13:09 PM, you wrote:

> At Fri,  2 May 2014 15:09:27 +0200,
> Sander Eikelenboom wrote:
>> 
>> This (widely used) construction:
>> 
>> if(printk_ratelimit())
>>       dev_dbg()
>> 
>> Causes the ratelimiting to spam the kernel log with the "callbacks suppressed"
>> message below, even while the dev_dbg it is supposed to rate limit wouldn't
>> print anything because DEBUG is not defined for this device.
>> 
>> [  533.803964] retire_playback_urb: 852 callbacks suppressed
>> [  538.807930] retire_playback_urb: 852 callbacks suppressed
>> [  543.811897] retire_playback_urb: 852 callbacks suppressed
>> [  548.815745] retire_playback_urb: 852 callbacks suppressed
>> [  553.819826] retire_playback_urb: 852 callbacks suppressed
>> 
>> So use dev_dbg_ratelimited() instead of this construction.
>> 
>> Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>

> Thanks, applied.  This is a result of the recent rewrite to dev_dbg()
> from plain printk(), I suppose.

Yes that patch (https://lkml.org/lkml/2014/4/9/457) prevented spamming the kernel log when debugging was enabled ..
but  now the rate limiting code starts spamming the kernel log instead :-)

I must say i wasn't very aware of that effect either and also used this construction on 
debug patches.


> Takashi

>> ---
>>  sound/usb/pcm.c |    5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>> 
>> diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
>> index 131336d..c62a165 100644
>> --- a/sound/usb/pcm.c
>> +++ b/sound/usb/pcm.c
>> @@ -1501,9 +1501,8 @@ static void retire_playback_urb(struct snd_usb_substream *subs,
>>        * The error should be lower than 2ms since the estimate relies
>>        * on two reads of a counter updated every ms.
>>        */
>> -     if (printk_ratelimit() &&
>> -         abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
>> -             dev_dbg(&subs->dev->dev,
>> +     if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
>> +             dev_dbg_ratelimited(&subs->dev->dev,
>>                       "delay: estimated %d, actual %d\n",
>>                       est_delay, subs->last_delay);
>>  
>> -- 
>> 1.7.10.4
>> 


