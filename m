Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaAHH4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:56:39 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:54249 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaAHH4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:56:31 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s087u5pi007468, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wei_wang <wei_wang@realsil.com.cn>
Date: Wed, 8 Jan 2014 15:56:05 +0800
Subject: RE: [PATCH 1/3] mfd: Add realtek USB card reader driver
Thread-Topic: [PATCH 1/3] mfd: Add realtek USB card reader driver
Thread-Index: Ac8Hn7x98MWTBFq9ThKLX7hyJeTgiwEoLdpK
Message-ID: <1121E117AD4ECE49880A389A396215BB939A5BD715@rtitmbs7.realtek.com.tw>
References: <1387792327-2511-1-git-send-email-rogerable@realtek.com>
 <1387792327-2511-2-git-send-email-rogerable@realtek.com>,<20140102094750.GZ28413@mwanda>
In-Reply-To: <20140102094750.GZ28413@mwanda>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

>> +int rtsx_usb_ep0_write_register(struct rtsx_ucr *ucr, u16 addr,
>> +             u8 mask, u8 data)
>> +{
>> +     u16 value = 0, index = 0;
>> +
>> +     value |= (u16)(3 & 0x03) << 14;
>> +     value |= (u16)(addr & 0x3FFF);
>
>Don't do pointless things:
>
>        value |= 0x03 << 14;
>        value |= addr & 0x3FFF;
>
>> +     value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);
>
>This is an endian conversion?  It is buggy.  Use the kernel endian
>conversion functions cpu_to_le16().

This is not a conversion for endianess with respect to CPU but for command format  of the device. It should always be performed regardless of platform.

In other words, it could be equivalent to:
        value |= 0x03 << 6; // lower byte
        value |= (addr & 0x3F00) >> 8; // lower byte
        value |= (addr & 0xFF) << 8; //higher byte

We think the previous form is easier to read. Should we keep it or change to the later one?