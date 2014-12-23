Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbaLWMlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:41:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37818 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaLWMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:41:07 -0500
Date: Tue, 23 Dec 2014 13:41:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH]  bluetooth: Add hci_h4p driver
Message-ID: <20141223124103.GA28178@amd>
References: <20141213223727.GA13894@amd>
 <20141220202314.GA8484@amd>
 <D5E3AD8F-9122-49FE-B932-F9DDBB89840F@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5E3AD8F-9122-49FE-B932-F9DDBB89840F@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Add hci_h4p bluetooth driver. This device is used for example on Nokia N900 cell phone.
> 
> the driver is called nokia_h4p. And you could be a little bit more verbose here explaining where the driver came from.


> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > Thanks-to: Sebastian Reichel <sre@debian.org>
> > Thanks-to: Joe Perches <joe@perches.com>
> > 
> > ---
> > 
> > Please apply,
> 
> If you refuse to use git check-patch, then manually include a
> diffstat.

> > +#include "nokia_h4p.h"
> > +
> > +#undef TEST
> 
> What is the TEST undef doing here?

Waiting to be removed. I did, and cleaned the other small stuff.

> > +static void h4p_lazy_clock_release(unsigned long data)
> > +{
> 
> What is the reason this is unsigned long and not just struct h4p_info?

That's what struct timer_list expects.

> > +static void h4p_disable_tx(struct h4p_info *info)
> > +{
> > +	if (!info->pm_enabled)
> > +		return;
> > +
> > +	/* Re-enable smart-idle */
> > +	h4p_smart_idle(info, 1);
> > +
> > +	gpio_set_value(info->bt_wakeup_gpio, 0);
> > +	mod_timer(&info->lazy_release, jiffies + msecs_to_jiffies(100));
> 
> How many lazy_release functions do you have? Why is this a callback anyway. If not needed, then please simplify this.
>

You don't want to spend power trying to save power, that's why it is
done lazily.

> > +static unsigned int h4p_get_data_len(struct h4p_info *info,
> > +					 struct sk_buff *skb)
> 
> Indentation.

I'm not sure what indentation you want here. net/ uses different
coding style, not a consistent one, and it is not documented. I tried

static unsigned int
h4p_get_data_len(struct h4p_info *info, struct sk_buff *skb)

as seen net/.

> > +	if (info->rx_count == 0) {
> > +		/* H4+ devices should always send word aligned packets */
> > +		if (!(info->rx_skb->len % 2))
> > +			info->garbage_bytes++;
> > +		h4p_recv_frame(info, info->rx_skb);
> 
> I still do not get why the functionality of h4p_recv_frame is not
 > just inlined here.

I took a look at h4p_recv_frame, and decided it would hurt the
readability due to control flow.

> And more importantly, are we doing something about this word alignment here. What are these garbage_bytes for?
> 

For skipping and completely ignoring bytes, see h4p_rx_tasklet.

> > +	h4p_hci_flush(hdev);
> > +	h4p_deinit(hdev);
> > +	return err;
> > +}
> > +
> > +static int h4p_hci_setup(struct hci_dev *hdev)
> > +{
> > +	return h4p_setup(hdev);
> 
> Why are we doing this?

Removed indirection.

> This also seems wrong. You should enable the hardware within the probe function that registers the hci_dev or from a rfkill switch. Not from the hdev->setup callback. This callback is for running HCI commands that handle firmware loading and general configuration of the controller over HCI. If it is not HCI based, then it does belong there.
>

I tried that, and spent really lot of time trying to get something
working and clear, and this is the best match I could find. Problem is
I need skb_queue_tail() to send management frames, too.

> > +struct h4p_neg_cmd {
> > +	u8	ack;
> > +	u16	baud;
> > +	u16	unused1;
> > +	u8	proto;
> > +	u16	sys_clk;
> > +	u16	unused2;
> 
> If these are little endian, the __le16 here. And most likely also
> __u8

Why would I want to do __u8? This is kernel code, no need to make it
more ugly with __s. (And yes, you have patch to remove some extra __s
from bluetooth core in your inbox.).

> > +void h4p_parse_fw_event(struct h4p_info *info, struct sk_buff *skb);
> 
> And neither does this one.
> 
> Seriously here, why do I have to play janitor and look all these up
> :(

It has something to do with vetoing staging merge, and mixing cleanups
with "big" changes. Getting "rewrite this because it does not work" is
fair, getting "to these 1000 cleanups and oh btw you have to rewrite
it because XYZ" does not work as well. Plus, consistent coding style
between net/ and rest of kernel would help. Sorry about that, and
trust me, it sucks on my side, too.

static struct platform_driver can't be const, because rest of kernel
does not expect that and it causes warnings.

> > +	h4p_outb(info, UART_LCR, UART_LCR_WLEN8);
> > +	h4p_outb(info, UART_IER, UART_IER_RDI);
> > +	h4p_outb(info, UART_OMAP_SYSC, (1 << 0) | (1 << 2) | (2 << 3));
> > +}
> 
> And you should run sparse before submitting patches.
> 
>   CHECK   drivers/bluetooth/nokia_core.c
> drivers/bluetooth/nokia_core.c:130:6: warning: symbol 'h4p_enable_tx_nopm' was not declared. Should it be static?
> drivers/bluetooth/nokia_core.c:282:23: warning: incorrect type in assignment (different base types)
> drivers/bluetooth/nokia_core.c:282:23:    expected unsigned short [unsigned] [usertype] baud
> drivers/bluetooth/nokia_core.c:282:23:    got restricted __le16 [usertype] <noident>
> drivers/bluetooth/nokia_core.c:284:26: warning: incorrect type in assignment (different base types)
> drivers/bluetooth/nokia_core.c:284:26:    expected unsigned short [unsigned] [usertype] sys_clk
> drivers/bluetooth/nokia_core.c:284:26:    got restricted __le16 [usertype] <noident>
> 

make C=... does not seem to work well with cross-compilation. AFAICT
these should be due to missing static and le16 annotations, should be
fixed.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
