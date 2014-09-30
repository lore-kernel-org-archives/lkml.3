Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaI3HmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:42:16 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:56230 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaI3HmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:42:15 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "dsd@gentoo.org" <dsd@gentoo.org>,
        "kune@deine-taler.de" <kune@deine-taler.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] zd1211rw: replace ZD_ASSERT with
 lockdep_assert_held()
Thread-Topic: [PATCH v2] zd1211rw: replace ZD_ASSERT with
 lockdep_assert_held()
Thread-Index: AQHPzaji67ru1uysWEKojhy3lQjAn5v7vMNQgAXsTACAF73wAA==
Date: Tue, 30 Sep 2014 07:42:11 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE950E5F3DF@EU-MBX-04.mgc.mentorg.com>
References: <1410418407.1825.0.camel@jlt4.sipsolutions.net>
 <1410430179-19944-1-git-send-email-sanjeev_sharma@mentor.com>
 <1410430345.22863.0.camel@jlt4.sipsolutions.net>
 <FDC088D3B5555644AE135ED28A7ABDE94DF5256D@EU-MBX-02.mgc.mentorg.com>
 <CAGRGNgWOkzbu7sUxOqpgK_rzw1Xzny4aVFYOO6Rqd09-CpfvJA@mail.gmail.com>
In-Reply-To: <CAGRGNgWOkzbu7sUxOqpgK_rzw1Xzny4aVFYOO6Rqd09-CpfvJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8U7gM9s020036

-----Original Message-----
From: Julian Calaby [mailto:julian.calaby@gmail.com] 
Sent: Monday, September 15, 2014 11:32 AM
To: Sharma, Sanjeev
Cc: Johannes Berg; dsd@gentoo.org; kune@deine-taler.de; linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: Re: [PATCH v2] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()

Hi Sanjeev,

On Thu, Sep 11, 2014 at 8:36 PM, Sharma, Sanjeev <Sanjeev_Sharma@mentor.com> wrote:
> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net]
> Sent: Thursday, September 11, 2014 3:42 PM
> To: Sharma, Sanjeev
> Cc: dsd@gentoo.org; kune@deine-taler.de; 
> linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org; 
> netdev@vger.kernel.org
> Subject: Re: [PATCH v2] zd1211rw: replace ZD_ASSERT with 
> lockdep_assert_held()
>
> On Thu, 2014-09-11 at 15:39 +0530, Sanjeev Sharma wrote:
>> on some architecture spin_is_locked() always return false in 
>> uniprocessor configuration and therefore it would be advise to 
>> replace with lockdep_assert_held().
>>
>> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
>> ---
>> Changes in v2:
>>   - corrected the typo
>
>> Now it compiles, but you got the logic wrong.
>
>> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
>> @@ -235,7 +235,7 @@ void zd_mac_clear(struct zd_mac *mac)  {
>>       flush_workqueue(zd_workqueue);
>>       zd_chip_clear(&mac->chip);
>> -     ZD_ASSERT(!spin_is_locked(&mac->lock));
>> +     lockdep_assert_held(&mac->lock);
>>       ZD_MEMCLEAR(mac, sizeof(struct zd_mac));  }
>
>>Look closely at this again.
>
> I didn't understand where I  put wrong logic  ?

I find it helps to spell out what code is doing in words.

E.g. the line you're removing is:
ZD_ASSERT(!spin_is_locked(&mac->lock));

So, we'll assert when spin_is_locked(&mac->lock) is false, i.e. when
mac->lock is not spin locked.

This isn't the same as what you're replacing it with.

 I  feel logic is absolutely correct and if you expand it will looks like ..

+#define lockdep_assert_held(l)	do {	\ 
+	WARN_ON(debug_locks && !lockdep_is_held(l));	\ 
+	} while (0)

Please refer http://lkml.iu.edu/hypermail/linux/kernel/1203.2/00369.html and also see include/linux/lockdep.h for more detail.

Thanks
Sanjeev Sharma
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
