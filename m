Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaLIUNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:13:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40643 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaLIUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:13:31 -0500
Date: Tue, 9 Dec 2014 21:13:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, sre@debian.org,
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
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
Message-ID: <20141209201328.GA18003@amd>
References: <20141209190210.GA15641@amd>
 <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Major problem with Nokia H4P driver was, that it uses custom functions
> > instead of __hci_cmd_sync().

>  the __hci_cmd_sync is for sending HCI commands and not low-level
> protocol transports like H:4 or similar. So you want to separate the
> actual transport of HCI from the firmware loading.

The TODO file says:

# > +
# > +     skb_queue_tail(&info->txq, fw_skb);
# > +     spin_lock_irqsave(&info->lock, flags);
# > +     hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
# > +                     UART_IER_THRI);
# > +     spin_unlock_irqrestore(&info->lock, flags);
# > +}
# 
# and as I explained before, this crazy can not continue. Bluetooth drivers can provide a
# +hdev->setup callback for loading firmware and doing other setup details. You can just
# +bring up the HCI transport. We are providing __hci_cmd_sync for easy loading of the
# +firmware. Especially if the firmware just consists of HCI commands. Which is clearly the
# +case with the Nokia firmware files.

...so I take it you (and thus TODO) were wrong and __hci_cmd_sync is
not suitable after all?

But I don't understand what you want me to do at this point. I guess
skb_queue_tail+hci_h4p_outb should be moved to a helper function
(that's easy), and I already moved initialization to hci_setup().

nokia_core.c uses test_bit(HCI_RUNNING, &info->hdev->flags) to tell
between initialization and data traffic, but I guess that's fine?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
