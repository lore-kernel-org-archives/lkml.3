Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbaAKAUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 19:20:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43561 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaAKAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 19:20:03 -0500
Date: Sat, 11 Jan 2014 01:19:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v5] Bluetooth: Add hci_h4p driver
Message-ID: <20140111001952.GA16306@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
 <20140110145207.GB12048@amd.pavel.ucw.cz>
 <1389375184.2537.31.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389375184.2537.31.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +static inline void hci_h4p_handle_byte(struct hci_h4p_info *info, u8 byte)
> 
> pretty big function to be inline

Called from just one place, so that should be ok.

> > +static void hci_h4p_rx_tasklet(unsigned long data)
> > +{
> []
> > +	while (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR) {
> []
> > +		pr_debug("0x%.2x  ", byte);
> 
> pr_debug is prefixed by a newline if necessary
> and then <7>, one for each use.
> 
> This will produce a lot of dmesg output lines
> (1 for each byte) and isn't in my opinion
> necessary/useful.

Ok, I just killed it.

> > +	if (set != !!test_bit(H4P_ACTIVE_MODE, &info->pm_flags)) {
> > +		bt_plat_data->set_pm_limits(info->dev, set);
> > +		if (set)
> > +			set_bit(H4P_ACTIVE_MODE, &info->pm_flags);
> > +		else
> > +			clear_bit(H4P_ACTIVE_MODE, &info->pm_flags);
> > +		BT_DBG("Change pm constraints to: %s", sset);
> 
> missing newline

Actually, it is the other way around. BT_DBG adds the newline. I'll
remove it from the rest.

> > +	if (!hdev) {
> > +		printk(KERN_WARNING "hci_h4p: Frame for unknown device\n");
> > +		return -ENODEV;
> > +	}
> 
> Is this possible?

Probably not, removed.

> > +	if (ret != 6)
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < 6; i++)
> > +		info->bd_addr[i] = bdaddr[i] & 0xff;
> 
> This could also return -EINVAL if bdaddr[i] > 0xff

Why not.

> > +static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info, struct sk_buff *skb)
> > +{
> > +	int i;
> > +	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
> > +	int not_valid;
> > +
> > +	not_valid = 1;
> > +	for (i = 0; i < 6; i++) {
> > +		if (info->bd_addr[i] != 0x00) {
> > +			not_valid = 0;
> > +			break;
> > +		}
> > +	}
> 
> This seems wrong as addresses can have valid 0 bytes.
> Perhaps use:
> 
> 	if (!is_valid_ether_addr(info->bd_addr))
> 

I am not sure bluetooth rules are same as ethernet. And notice that it
only errors out on 00:00:00:00:00:00 which seems like invalid address
to me.

I fixed the other ones.

Thanks,
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
