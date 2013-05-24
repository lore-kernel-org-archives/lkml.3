Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab3EXJFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:05:08 -0400
Received: from mailhost-x5-p4.nerim-networks.com ([195.5.209.107]:37011 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758612Ab3EXJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:05:05 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 05:05:05 EDT
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
X-MimeOLE: Produced By Microsoft Exchange V6.5.7235.2
Content-class: urn:content-classes:message
Subject: Re: [I2C] informations + advice about messages handling
Date: Fri, 24 May 2013 10:54:11 +0200
Message-ID: <CA78C307B8F06747967D122FC656B15398644A@SERVEUR0.nvp.local>
In-Reply-To: <20130524094407.61d0ec42@endymion.delvare>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [I2C] informations + advice about messages handling
thread-index: Ac5YXEQfQTbHRfKnQ0yPq6SlBKaUdg==
References: <CA78C307B8F06747967D122FC656B153986448@SERVEUR0.nvp.local> <CAK7N6vpg6QUAKODKO2Msr4+GTASLDpA2cG1teQV3yiwt7D4SSw@mail.gmail.com> <20130524094407.61d0ec42@endymion.delvare>
From: "Mylene Josserand" <Mylene.Josserand@navocap.com>
To: "Jean Delvare" <khali@linux-fr.org>,
        "anish singh" <anish198519851985@gmail.com>
Cc: "kernelnewbies" <kernelnewbies@kernelnewbies.org>,
        "Linux I2C" <linux-i2c@vger.kernel.org>,
        "linux-kernel-mail" <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4O95E93010413

Thanks, both of you, for your answers ! It helps me a lot to understand it !

Le 24/05/2013 09:22, anish singh a Ã©crit :
 > On Fri, May 24, 2013 at 12:41 PM, Mylene Josserand
 > <Mylene.Josserand@navocap.com>  wrote:
 >> Hi all,
 >>
 >>
 >> I am learning how i2c is working and I read that, to write in an i2c
 >> register, I need to use the function "i2c_smbus_write_byte_data".
 > Only in case your device is smbus compliant.

Ah okay ! And if there are not SMBus compliant, what function I will 
have to use ?
What is it doing if I use this function and that my device is not SMbus 
compliant ? I have some difficulties to understand the differences 
between SMbus and I2C :(


Le 24/05/2013 09:44, Jean Delvare a Ã©crit :
 > Hi Anish, MylÃ¨ne,
 >
 > On Fri, 24 May 2013 12:52:40 +0530, anish singh wrote:
 >> On Fri, May 24, 2013 at 12:41 PM, Mylene Josserand
 >> <Mylene.Josserand@navocap.com>  wrote:
 >>> I have read that this function "i2c_smbus_write_byte_data" uses
 >>> "i2c_smbus_xfer" which uses "i2c_lock_adapter".
 >>> In this function, there is a mutex so I thought that it will handle it
 >>> but it says "Get exclusive access to an I2C bus segment". What is
 >>> exactly an I2C segment ? Is it the device we are talking about ? Or is
 >>> it the use of the i2c bus ?
 >> Don't know what you are referring here.
 >
 > In the most simple case, your I2C bus has a single segment so "segment"
 > or "bus" mean the same thing.
 >
 > It only starts mattering when I2C bus multiplexing comes into play.
 > Then your bus is split into segments, with one segment (trunk) between
 > the master (controller) and the multiplexer, and one or more segments
 > (branches) hanging off the multiplexer.
 >
 > Take look at
 > https://i2c.wiki.kernel.org/index.php/I2C_bus_multiplexing
 > for a sample topology.
 >
 > But anyway the comment in front of i2c_lock_adapter() is somewhat
 > misleading. If you read the code you'll see that it always locks the
 > whole bus tree, because it uses the root segment's mutex.


Thanks ! I understand now.
In my case, I have 2 segments but if I understand, the bus will not be 
used at the same time.


 >>> I will certainly have to create an i2c driver and I would like to know
 >>> if this "collision" handling (if it is handled) is done in old kernel
 >>> (2.6.32) or is it handled only in new kernel versions ?
 >> AFAIK collision handling and detection was not supported till now
 >> in linux kernel until recently but I think this patch is doing that.
 >> I may be wrong but I didn't see collision handling in earlier linux
 >> kernels.
 >> http://thread.gmane.org/gmane.linux.kernel/1410276
 >
 > This is for a specific case. The general case is handled by the
 > per-adapter mutex for years now. 2.6.32 should be just fine in this
 > respect.

Okay. So the mutex blocks the I2C bus. And is it locking the bus at the 
beginning of a message (so when a START is send) and unlocking it after 
the STOP ?
So a complete message will be sent to a same device (the one which 
address is in the data frame) ? A device can not receive a beginning of 
one message (so with his address) and the end of another message 
destined to another device [because of "collision"], for example ?


 >>> If you have any documentation on how the i2c messages are handled in
 >>> case of different devices uses, it will help me a lot ! I will 
search in
 >>> the kernel documentation but there is many files about i2c.
 >>> And if you know a good i2c driver that I can use as an example to 
design
 >>> mine, it will be great !
 >
 > Best is to look at a driver for a device which is similar in
 > functionality to yours.

I will search that, thanks for the advice.


-- 
MylÃ¨ne JOSSERAND
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
