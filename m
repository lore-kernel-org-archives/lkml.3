Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaLRMAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 07:00:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:13434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaLRMAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 07:00:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,600,1413270000"; 
   d="scan'208";a="649812301"
From: "Du, Changbin" <changbin.du@intel.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [DISCUSSION] USB device remote wakeup is not working for S3 case
Thread-Topic: [DISCUSSION] USB device remote wakeup is not working for S3
 case
Thread-Index: AdAaujexwQVjoEsORCWW3pR7AJbQmQ==
Date: Thu, 18 Dec 2014 12:00:30 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01C428B4@SHSMSX103.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I am checking usb remote wakeup code, I found that usb remote wakeup will not work after system going to S3 sate and I confirmed with my PC.
During enumeration, usb device will be set as wakeup capable by usb_set_device_state if it supports. Whether usb driver send SET_FEATURE(REMOTE_WAKUP) usb request when suspending on S3  depend on do_remote_wakeup flag which is set by choose_wakeup(). It can be simply presented as below.
       do_remote_wakeup  = device_may_wakeup(&udev->dev);
The return value is always false since usb device is not marked as wakeup enabled(that is no one call device_set_wakeup_enable() for usb device). As a result, usb device will not signal wakeup event to host.

Maybe we should not allow all remote wakeup supported device can wakeup system by default. But for usb keyboard/mouse, I think it is not reasonable to disable it by default.

A simple way to fix this is that replace the device_may_wakeup by device_can_wakeup in choose_wakeup() function, just like on auto suspend case (usb remote wakeup works for rpm). Another way is to make usb device wakeup able  by default. But both of them will make all usb devices can wakeup system. Have any better idea?
