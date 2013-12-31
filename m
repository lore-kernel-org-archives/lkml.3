Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab3LaI4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 03:56:30 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18661 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3LaI43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 03:56:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 31 Dec 2013 00:57:33 -0800
From: Manoj Chourasia <mchourasia@nvidia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Tue, 31 Dec 2013 14:26:41 +0530
Subject: [PATCH] usb: hub: Avoid tight loop holding hdev lock
Thread-Topic: [PATCH] usb: hub: Avoid tight loop holding hdev lock
Thread-Index: Ac8GBiiEsarYrb5KSmC3nq+L5ejVYg==
Message-ID: <F1F6C959961EA744BBD5B8EEF8B8FEA16DDFCA6A2E@BGMAIL02.nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I was facing an issue bad usb device which was affecting other system. Kernel was trying to enumerate the device but it was failing continuously. Unfortunately that device was on mounted onboard in the platform so I cannot remove it.
The continuous re-enumeration of the device causing other application malfunctioning which were using libusb. I found that usb_find_devices() call was stuck in usb_open for very long time. It was stuck in getting device lock which was taken in hub_event thread.
Solution was to add msleep in the loop to prevent is spinning tightly. 

---------------------------------------------------------------------------
usb: hub: Avoid tight loop holding hdev lock

   Other system call(like usb_open) to root port device
    starved in getting device lock when the while loop
    in hub_event loops tightly because of misbehaving device.

    Adding a small msleep provides chance to system calls to
    schedule.

    The issue was returning -EPROTO and re-enumerating with
    continuous hub_events. That was makes the while loop in
    hub_event to spin tightly.

    usb_find_devices call from libusb tries to open all devices
    including root hub. The call to usb_open stuck for very
    long time(sometimes forever) because the priority of
    kernel thread is higher than that system call in this case.

    Signed-off-by: Manoj Chourasia <mchourasia@nvidia.com>  

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index c5c3667..b968fd5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4899,6 +4899,9 @@ static void hub_events(void)
                usb_unlock_device(hdev);
                kref_put(&hub->kref, hub_release);

+               /* preventing tight loop holding hdev lock */
+               msleep(20);
+
         } /* end while (1) */
 }

-Regards
Manoj

