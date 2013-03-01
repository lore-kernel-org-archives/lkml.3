Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab3CAN1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:27:32 -0500
Received: from mx.mcc-med.de ([213.148.153.242]:52963 "EHLO mx.mcc-med.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3CAN1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:27:31 -0500
From: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
To: "'Richard Genoud'" <richard.genoud@gmail.com>
CC: Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
Date: Fri, 1 Mar 2013 14:27:20 +0100
Subject: AW: Bug in mtd_get_device_size()?
Thread-Topic: Bug in mtd_get_device_size()?
Thread-Index: Ac4Wdb2rFA0BrwcRQgSLeQUX70KhLAABJ4UA
Message-ID: <BAF0C2081321BA469F9ADF648F97D9B04C78FA607E@MCC023.weinmann.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com>
 <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
 <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
 <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
 <BAF0C2081321BA469F9ADF648F97D9B04C78FA607C@MCC023.weinmann.com>
 <CACQ1gAg=L7ru5J4C7OQN0r-c2VN3baKX1qqty8Z0ObS5Wk48yg@mail.gmail.com>
In-Reply-To: <CACQ1gAg=L7ru5J4C7OQN0r-c2VN3baKX1qqty8Z0ObS5Wk48yg@mail.gmail.com>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalRecipient: RPFD:richard.genoud@gmail.com
X-OriginalRecipient: RPFD:computersforpeace@gmail.com
X-OriginalRecipient: RPFD:artem.bityutskiy@linux.intel.com
X-OriginalRecipient: RPFD:linux-mtd@lists.infradead.org
X-OriginalId: qfr21DRK2C015521
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r21DRfj9020757

Hi Richard,

>And if you want to tweak the BEB_LIMIT for each of your UBI partition, it's possible, via the ubiattach call ( get the master branchof of git://git.infradead.org/mtd-utils.git ) cf http://git.infradead.org/mtd-utils.git/commit/878e06ea555ba5dbfb974b3904d1a86a9a0e20f5

Aha! I didn't see that before. In my case will be useful. Thanks for idea! 

Let I ask you one more question, probably you have better idea how to resolve it. If you have no other solution as my, should not answer. Also: as I mentioned before, I have one big partition with 4 UBI volumes on it: one of volumes will contain extreme important data (for example device type and serial number) and data on this volume will be written only several times for whole device life; and on other volume will be stored patient data that will be written relative often. Now in my SW that runs as init process I call ubiatach+mount. If ubiattach or mount for any of UBI volumes returns error, I call ubiformat+ubimkvol+mount again. This is normal use case when the device booted first time after production. With 2.6.38 and 3.3 kernel I had no problems but after update on 3.7 I got reported 2 cases when devices lost all their data. Unfortunately I have no additional information why it happened, but anyway is it really necessary to runs ubiformat+ubimkvol for such cases? Or is it possible to recover data? Since my solution for this case is to put the device data in separate MTD with one single UBI volume. But you know how much space I should reserve on NAND MTD for single XML-File with 200Bytes :-). Alternative is to try to mount only device volume, copy data in tmpfs, run ubiformat+ubimkvol+mount and copy the data back to the device volume. Or you have other idea?

Thanks a lot,
Best regards,
Sergey





-----UrsprÃ¼ngliche Nachricht-----
Von: Richard Genoud [mailto:richard.genoud@gmail.com] 
Gesendet: Freitag, 1. MÃ¤rz 2013 13:10
An: Velykokhatko, Sergey
Cc: Brian Norris; linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org; artem.bityutskiy@linux.intel.com
Betreff: Re: Bug in mtd_get_device_size()?

2013/3/1 Velykokhatko, Sergey <Sergey.Velykokhatko@mcc-med.de>:
> Hi Richard,
>
> Thanks a lot for your explanations. Now at least I understand your logic. And it seems to be reasonable. Your start point that all bad blocks for flash chip could be placed in single MTD. This is really worst worst case, but... Theoretically it could happened. And you should take care of it.
> And you are right again in things about my chip. I interpreted that up to 40 blocks could be bad from chip production. But now found on side 104 of 125 one note (sometimes I like datasheets :-) ):
>
> "
> Notes:
>  1. Invalid blocks are blocks that contain one or more bad bits. The 
> device may contain bad blocks upon shipment. Additional bad blocks may 
> develop over time; however, the total number of available blocks will 
> not drop below NVB during the endurance life of the device. Do not erase or program blocks marked invalid by the factory.
> "
>
> Also I should expect up to 40 bad blocks. Nearly 1%.  No more for endurance case.
That less than many NAND device, so in your case, you should set CONFIG_MTD_UBI_BEB_LIMIT to 10 (40 bad blocks on a total of 4096)

>
> Independing from this I wanted to make my kernel partition bigger. Now just no time for this, we are still in developing with our device.
>
>
>>If not, we have to accept to loose some space for bad blocks, or use 
>>NOR :)
> :) NOR is expensive. And UBI takes a lot of space since based on worst 
> case estimation of NAND features. I have to find compromise
yes... may be one day we will have cheap, reliable and fast flash storage.
(and at least your nand is SLC, not MLC !)

And if you want to tweak the BEB_LIMIT for each of your UBI partition, it's possible, via the ubiattach call ( get the master branchof of git://git.infradead.org/mtd-utils.git ) cf http://git.infradead.org/mtd-utils.git/commit/878e06ea555ba5dbfb974b3904d1a86a9a0e20f5
and via the ubi module parameter :
mtd=<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024]]

with that, you won't need your kernel patch anymore !

Regards,
Richard.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
