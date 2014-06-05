Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaFEGvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 02:51:50 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:17683 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbaFEGvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 02:51:47 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Ulf Hansson'" <ulf.hansson@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "len.brown@intel.com" <len.brown@intel.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Date: Thu, 5 Jun 2014 14:51:41 +0800
Subject: RE: autosleep suspend too frquent problem
Thread-Topic: autosleep suspend too frquent problem
Thread-Index: Ac9/dkEfm6YcZSSIQSWBWFvVAsWmbgBE8UVA
Message-ID: <35FD53F367049845BC99AC72306C23D1029A27656A38@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1029A27656A2D@CNBJMBX05.corpusers.net>
	<20140603120128.GA5080@amd.pavel.ucw.cz>
 <CAPDyKFqnC1u_Nhe7sJrAzBc8YktDUJC4KAKTPtYVK-Qk6mmk0A@mail.gmail.com>
In-Reply-To: <CAPDyKFqnC1u_Nhe7sJrAzBc8YktDUJC4KAKTPtYVK-Qk6mmk0A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s556q2Jb024245

Hi  

Thanks for your clarification.

One problem is the sd card driver itself .

In addition, I also think kernel's autosleep.c module
Have problem too.
It just test wake up count ,if the count is zero, then enter suspend.

This will result in frequent suspend / resume problems sometimes,
It is not acceptable, I think also need to be fixed to 
Avoid this special scenario .

Thanks


-----Original Message-----
From: Ulf Hansson [mailto:ulf.hansson@linaro.org] 
Sent: Wednesday, June 04, 2014 5:53 AM
To: Pavel Machek
Cc: Wang, Yalin; len.brown@intel.com; rjw@sisk.pl; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; linux-mmc
Subject: Re: autosleep suspend too frquent problem

On 3 June 2014 14:01, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>
>> I found sd card sometimes are damaged/ destroyed On our devices .
>> And seems it is caused by kernel's frequently suspend/resume, Because 
>> during suspend/resume, the driver will suspend/resume sdcard Very 
>> frequently, this will damaged the sdcard sometimes, and the damage is 
>> not recoverable ..
>>
>> Sometimes kernel will enter suspend and exit suspend very frequently, 
>> Especially when the system is in idle, but some driver is not idle, 
>> And it will  wake up the system by irq frequently.
>> By our power test result, if system enter suspend /resume very 
>> frequently, Will consume more power , because it will enable /disable 
>> many devices During a short time .
>>
>> I make a patch to prevent the system to enter suspend/resume state 
>> More than one time during 2 secondsï¼š
>
> It is good you managed to diagnose the problem, but this si not the 
> right solution.
>
> Either:
>
> 1) don't power down SD card during system suspend

NAK. The amount of power a card (even if there are good behaving cards as well) may utilize, in powered but idle state could be significant.
I have seen cases of constant power consumption of several mA here.

>
> or maybe even better
>
> 2) don't power _up_ SD card during system resume. Let it be powered 
> down until the first access.

Good news! This is "almost" supported already by the mmc subsystem.

If your mmc host has set the capability flag MMC_CAP_RUNTIME_RESUME, that means the card won't be powered up (and initialized) until the next request.

However, for removable cards (!MMC_CAP_NONREMOVABLE), during system resume phase, the mmc core will trigger a "rescan" of the card, to verify it has not been removed. Thus, unfortunate for this use case, the first request (for removable cards) will be triggered during the system resume phase.

I suppose we should add some extra conditions/flags which makes the mmc core to handle the above scenario. Actually I have been thinking of putting together a patch for this, but it never pops up on the top of my TODO list. :-)

Additionally, I wonder if this bouncing up and down from suspend to resume, could have other negative impact for other subsystems? Is it just a mmc subsystem problem? I am not so sure.

Kind regards
Ulf Hansson

>
> Thanks,
>                                                                         
> Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) 
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
