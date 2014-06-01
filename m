Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaFABnC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 21:43:02 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51258 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaFABm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 21:42:59 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 2/2] bluetooth: raise HCI_CMD_TIMEOUT from 2s to 8s
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <53897886.3020200@ahsoftware.de>
Date: Sun, 1 Jun 2014 03:42:55 +0200
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6A170CD1-B27C-4EAA-9D7C-3F8E6F88D7D8@holtmann.org>
References: <1400076025-5103-1-git-send-email-holler@ahsoftware.de> <1400076025-5103-2-git-send-email-holler@ahsoftware.de> <B76D7881-8AE8-480D-A53B-B300DDEEBC47@holtmann.org> <53897886.3020200@ahsoftware.de>
To: Alexander Holler <holler@ahsoftware.de>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

>>> The reasoning to do this is the following:
>>> 
>>> - If a timeout occurs, the HCI-communication is broken afterwards and the
>>> dongle isn't usable anymore.
>>> - If it works after e.g. waiting 4s everyone is still happy but if it
>>> just breaks after only waiting 2s nothing is gained.
>>> - Having to wait some more seconds until an error occurs doesn't change
>>> anything.
>>> 
>>> So there is no disadvantage in rasing the timeout but a great advantage
>>> in case the dongle needs more than 2s to process an HCI command.
>>> E.g. I had sometimes HCI command timeouts at boot (but never after the BT stack
>>> was successfull started). I assume the reason might be the USB-probing which
>>> happend before through the bootloader, which might have confused the dongle
>>> such that it needs a bit more time, but I'm not sure.
>>> 
>>> Together with the patch which limits the timeout only to the actual time the
>>> dongle needs to process an HCI command (and doesn't include the time the
>>> kernel needs to process the answer to an HCI command), my problems were gone.
>>> 
>>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>>> ---
>>> include/net/bluetooth/hci.h | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
>>> index be150cf..d50fd34 100644
>>> --- a/include/net/bluetooth/hci.h
>>> +++ b/include/net/bluetooth/hci.h
>>> @@ -180,7 +180,7 @@ enum {
>>> #define HCI_DISCONN_TIMEOUT	msecs_to_jiffies(2000)	/* 2 seconds */
>>> #define HCI_PAIRING_TIMEOUT	msecs_to_jiffies(60000)	/* 60 seconds */
>>> #define HCI_INIT_TIMEOUT	msecs_to_jiffies(10000)	/* 10 seconds */
>>> -#define HCI_CMD_TIMEOUT		msecs_to_jiffies(2000)	/* 2 seconds */
>>> +#define HCI_CMD_TIMEOUT		msecs_to_jiffies(8000)	/* 8 seconds */
>>> #define HCI_ACL_TX_TIMEOUT	msecs_to_jiffies(45000)	/* 45 seconds */
>>> #define HCI_AUTO_OFF_TIMEOUT	msecs_to_jiffies(2000)	/* 2 seconds */
>>> #define HCI_POWER_OFF_TIMEOUT	msecs_to_jiffies(5000)	/* 5 seconds */
>> 
>> I think moving the command timeout handling into a delayed work struct might actually solve this problem nicely and does not force us to increase the timeout. A chip that does not respond for 8 seconds is a pretty bad chip.
> 
> As I said in another mail, I don't think it is the chip. On the system
> where I'm experiencing these timeouts there's still the USB-subsysten
> inbetween. And this system boots from USB too, which means there's a lot
> of other traffic on the USB-bus besides the one for the USB-BT-dongle.
> And I don't know how the USB-stack (and hw) schedules the traffic, if he
> is able to schedule that at all.

I posted an experimental patch for changing cmd_timer into a delayed_work item and this might solve your scheduling problem. However that patch is untested and might needs some additional thinking on which queue the delayed work should be scheduled on. Nevertheless, you see the direction that we should explore first.

The L2CAP layer is not using struct timer_list at all anymore and in general we should remove timer_list usage from the Bluetooth subsystem since we do all our command processing in a workqueue. At least for lower protocols like HCI, L2CAP, SMP and A2DP.

Regards

Marcel

