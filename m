Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3CALtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:49:36 -0500
Received: from mx.mcc-med.de ([213.148.153.242]:58511 "EHLO mx.mcc-med.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab3CALtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:49:35 -0500
From: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
To: "'Richard Genoud'" <richard.genoud@gmail.com>
CC: Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
Date: Fri, 1 Mar 2013 12:49:28 +0100
Subject: AW: Bug in mtd_get_device_size()?
Thread-Topic: Bug in mtd_get_device_size()?
Thread-Index: Ac4WaIbaZJSK1L9zQ7mSiCSTRi7cLAABmYqQ
Message-ID: <BAF0C2081321BA469F9ADF648F97D9B04C78FA607C@MCC023.weinmann.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com>
 <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
 <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
 <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
In-Reply-To: <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
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
X-OriginalId: qfr21BnTsJ030513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r21BnarK020415

Hi Richard,

Thanks a lot for your explanations. Now at least I understand your logic. And it seems to be reasonable. Your start point that all bad blocks for flash chip could be placed in single MTD. This is really worst worst case, but... Theoretically it could happened. And you should take care of it. 
And you are right again in things about my chip. I interpreted that up to 40 blocks could be bad from chip production. But now found on side 104 of 125 one note (sometimes I like datasheets :-) ):

"
Notes:
 1. Invalid blocks are blocks that contain one or more bad bits. The device may contain bad
blocks upon shipment. Additional bad blocks may develop over time; however, the total
number of available blocks will not drop below NVB during the endurance life of the
device. Do not erase or program blocks marked invalid by the factory.
"

Also I should expect up to 40 bad blocks. Nearly 1%.  No more for endurance case. 

Independing from this I wanted to make my kernel partition bigger. Now just no time for this, we are still in developing with our device. 


>If not, we have to accept to loose some space for bad blocks, or use NOR :)
:) NOR is expensive. And UBI takes a lot of space since based on worst case estimation of NAND features. I have to find compromise

Thanks a lot for your support,
Sergey



-----UrsprÃ¼ngliche Nachricht-----
Von: Richard Genoud [mailto:richard.genoud@gmail.com] 
Gesendet: Freitag, 1. MÃ¤rz 2013 11:35
An: Velykokhatko, Sergey
Cc: Brian Norris; linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org; artem.bityutskiy@linux.intel.com
Betreff: Re: Bug in mtd_get_device_size()?

2013/3/1 Velykokhatko, Sergey <Sergey.Velykokhatko@mcc-med.de>:
> Hi Brian,
>
> Thanks for your answer. Ok, I have nothing against that my interpretation of mtd_get_device_size() purpose is wrong. But what you mean under: "Because your BEB_LIMIT=100, you are reserving 100*size/1024 (that is 9.8% of your total size, or 400 blocks) in *every* partition." Looks for me a little bit strange. Why? Because I expected that UBI reserves the place for bad block handling pool depending on the size of MTD partition (on that it running) and not on the size of the whole chip. Actually I have 2 partitions with UBI (for rootfs and for data) and without my patch UBI tries to reserve nearly 400 blocks on each (see down).
Reserving bad blocks depending on the size of the MTD partition is wrong, and here is why:
I didn't checked the datasheet of your nand chipset (actually, I didn't found it).
But let's say it's a standard one : your chip has 4096 blocks, and the manufacturer says that there won't be more than 80 bad blocks (20/1024)on the device during its ENDURANCE LIFE (endurance life means something like 100000 program/erase cylcles).
Those 80 bad blocks could appear *everywhere*, they won't be equally disposed on the device.
=> If you have a small bare MTD partition of 16blocks, and do a lot of write/erase cycles on it, we can imagine that there will be some bad blocks on it, and maybe all those 16 blocks will turn bad.
If UBI takes the size of MTD partition to compute the maximum number of bad erase blocks, for a 16blocks MTD partition, this would be
16*20/1024 =0.31 => there will be a lack of reserved erase blocks.
said differently: if you want to be sure to have 2MB space (16blocks) to write on, you have to reserve 80 blocks more. This is the worst case scenario.
>
> Why I set CONFIG_MTD_UBI_BEB_LIMIT to such high limit? Well, you are right: our NAND from production could contain up to 40 bad blocks. That is 1% of whole chip size. But our medical device should work in worst case each night for 10 years. I expect that in whole device life more blocks will be defect. Of course 10% for rootfs MTD is overkill since it will be updated very very seldom, but for data partititon 10% is probably even too low.
"I expect that in whole device life more blocks will be defect."
you have to double check that.
In all nand datasheets that I've seen, the given number was for the endurance life.
>From a Micron Nand datasheet :
Micron NAND devices are specified to have a minimum of 2,008 (NVB) valid blocks out of every 2,048 total available blocks. This means the devices may have blocks that are invalid when they are shipped. An invalid block is one that contains one or more bad bits. Additional bad blocks may develop with use. However, the total number of avail- able blocks will not fall below NVB during the endurance life of the product.

As there's very little information on how bad blocks appear, we can suppose that even on the 1st erase cycle of a block, it can turn bad.
That's why we have to use the worst case scenario.
>
>>That would reserve only 80 blocks on your system, and you would not see these warnings/errors, since you already have 115 blocks reserved.
> You mean *not on my system* but on each MTD running with UBI? :) Well 
> I was thinking to divide my UBI volumes on UBI1 in small sub MTDs. 
> Since I had 2 times cases, when I couldn't mount my ubi1:ubivol_data 
> (I don't know why it happened, probably because of bugs in pretty new 
> NAND driver from Atmel) and I should ubiformat/ubimkvolume for my MTD 
> with loosing of extreme important data on ubi1:ubivol_device. If I 
> really make new small MTDs for ubi1:ubivol_device/ ubi1:ubivol_config 
> with the actual kernel state they will be completely used with poll 
> for reserved bad blocks. No room for my data :)

yes, using a lot of UBI partition is not space friendly.
The optimized way is one UBI partition, and many ubi volumes...

By the way,  even your kernel_a partition can be seen as undersized (3MB). if your kernel is 2MB, there's only 1MB (8) left for eventual bad blocks.
I understands that it's "unlikely" that more than 8 bad blocks appears on a partition where you do not write very often, that this would be "bad luck", but who knows...
That will depend on the criticality of your device, "do we accept to may be brick one product out of xxxxx or not ?". If not, we have to accept to loose some space for bad blocks, or use NOR :)

Best regards,
Richard.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
