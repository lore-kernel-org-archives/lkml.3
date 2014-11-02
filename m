Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaKBR52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 12:57:28 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58802 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaKBR5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 12:57:25 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sA2HvG5B025237, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/3] r8152: clear the flagofSCHEDULE_TASKLET in tasklet
Thread-Topic: [PATCH net-next v2 2/3] r8152: clear the flag
 ofSCHEDULE_TASKLET in tasklet
Thread-Index: AQHP9Udo4LlOKAxBVEemSNs6Z//IppxNkcYF
Date: Sun, 2 Nov 2014 17:57:16 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ECD8A7@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-75-Taiwan-albertk@realtek.com>
	<1394712342-15778-79-Taiwan-albertk@realtek.com>
	<1394712342-15778-81-Taiwan-albertk@realtek.com>,<20141031.161520.3547230591227504.davem@davemloft.net>
In-Reply-To: <20141031.161520.3547230591227504.davem@davemloft.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.43.200.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 David Miller [davem@davemloft.net]

> This is racey.

> If another thread of control sets the bit between the test and the
> clear, you will lose an event.

It is fine. The flag is used to schedule a tasklet, so if the tasklet is
starting running, all the other plans for scheduling a tasklet could
be cleared.

Besides, the flag is only set when a transmission occurs and the
device is in autosuspend mode. Then the workqueue could wake
up the device and schedule the tasklet to make sure the tasklet
wouldn't be run when the device is in suspend mode. Therefore,
if the tasklet is running, it means something happens and the
device is waked up. And the queue for scheduling the tasklet is
unnecessary. We don't need the tasklet runs again after current
one except that the relative tx/rx flows schedule it.

> It really never makes sense to work with atomic bitops in a non-atomic
> test-and-whatever manner like this, it's always a red flag and
> indicates you're doing something very wrong.

I use atomic because I don't wish the different threads which
set the different flags would chang the other bits which they
don't interesting in.

Best Regards,
Hayes
