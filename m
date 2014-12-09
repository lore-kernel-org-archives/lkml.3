Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaLIVUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:20:16 -0500
Received: from [87.106.208.187] ([87.106.208.187]:60865 "EHLO
	mail.holtmann.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaLIVUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:20:13 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141209201328.GA18003@amd>
Date: Tue, 9 Dec 2014 22:19:00 +0100
Cc: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>, sre@debian.org,
        Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, tony@atomide.com,
        khilman@kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<ivo.g.dimitrov.75@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7EFD3C33-E503-4FB6-BCCF-52836080ABD6@holtmann.org>
References: <20141209190210.GA15641@amd> <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org> <20141209201328.GA18003@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>> Major problem with Nokia H4P driver was, that it uses custom functions
>>> instead of __hci_cmd_sync().
> 
>> the __hci_cmd_sync is for sending HCI commands and not low-level
>> protocol transports like H:4 or similar. So you want to separate the
>> actual transport of HCI from the firmware loading.
> 
> The TODO file says:
> 
> # > +
> # > +     skb_queue_tail(&info->txq, fw_skb);
> # > +     spin_lock_irqsave(&info->lock, flags);
> # > +     hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
> # > +                     UART_IER_THRI);
> # > +     spin_unlock_irqrestore(&info->lock, flags);
> # > +}
> # 
> # and as I explained before, this crazy can not continue. Bluetooth drivers can provide a
> # +hdev->setup callback for loading firmware and doing other setup details. You can just
> # +bring up the HCI transport. We are providing __hci_cmd_sync for easy loading of the
> # +firmware. Especially if the firmware just consists of HCI commands. Which is clearly the
> # +case with the Nokia firmware files.
> 
> ...so I take it you (and thus TODO) were wrong and __hci_cmd_sync is
> not suitable after all?

__hci_cmd_sync is to be used in hdev->setup where you load the firmware. However when hdev->setup is run, we expect that the HCI transport is fully up and running and that the driver takes care of the transport. That is done via hdev->send and hci_recv_frame.

> But I don't understand what you want me to do at this point. I guess
> skb_queue_tail+hci_h4p_outb should be moved to a helper function
> (that's easy), and I already moved initialization to hci_setup().
> 
> nokia_core.c uses test_bit(HCI_RUNNING, &info->hdev->flags) to tell
> between initialization and data traffic, but I guess that's fine?

I have no idea on how much more I can explain this. There should be code in the driver that handles the HCI transport. That means init of the transport and sending and receiving HCI frames. And then there is the piece to load the firmware etc. These are two independent things.

Look at how btusb.c is doing this. We only run __hci_cmd_sync there. The details on how commands and events are going over USB are not handling hdev->setup. That is done by the basics of the driver.

What needs to be done is the bring up of the device including the proper UART settings and speed and then just run the firmware downloads. All firmware files on the Nokia devices where just HCI commands with vendor specific details. Some from CSR, some from Broadcom and some from TI. You can actually decode them if you really want to. Shouldn't be that hard.

Regards

Marcel

