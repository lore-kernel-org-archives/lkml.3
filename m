Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaHYGnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:43:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:54886 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbaHYGnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:43:09 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7P6h24P027704, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 0/4] r8152: firmware support
Thread-Topic: [PATCH net-next 0/4] r8152: firmware support
Thread-Index: AQHPvFUGvJCSNb1dlUOr/EZt9Z/MxJvc+J+AgAO4krD//4lyAIAAqupQ
Date: Mon, 25 Aug 2014 06:43:02 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB25161DF@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
	<20140822.194111.760144805197214266.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2516177@RTITMBSV03.realtek.com.tw>
 <20140824.212614.2300459100680592586.davem@davemloft.net>
In-Reply-To: <20140824.212614.2300459100680592586.davem@davemloft.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: David Miller [mailto:davem@davemloft.net] 
[...]
> That still doesn't convince me.
> 
> The functions I see you removing are just programming a set of
> registers in some way.

That is to clear the break point of the firmware. If a firmware exists,
you should clear it before updating a new one.

> And the firmware that is replacing those functions is just going to be
> causing the same register writes, just even more obfuscated than it is
> now.
> 
> You should keep the C functions which document and show clearly what
> is being programmed in each chip.
> 
> Don't hide register programming behind firmware files, please.

Excuse me. Some settings are relative the content of the firmware.
How should I deal with that parts. Take 8153 (RTL_VER_03) for
example.

	1. wait PLA 0xb800 bit 6 = 1.
	2. set patch key = 0x7000.
	3. update the PHY firmware.
	4. enable the firmware.
	5. set USB 0xcfca bit 14 = 0.
	6. clear break point (That is r8153_clear_bp()).
	7. load the firmware about PLA and USB parts.
	8. set the break point of the firmware.
	9. set USB 0xcfca bit 14 = 1.

Except the step 3, 4, 6 and 7, the other steps depend on the
context of the firmware. That is, for different firmware, some
actions would be removed or added, and some settings would be
different. Especially the step 8, it often different for
different firmwares. Should I add some firmware version check
in the source code? Such as

	if (fw_version == v1) {
		...
		load firmware
		set break point of the firmware
		...
	} else if (fw_version == v2) {
	...