Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaAJRdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:33:11 -0500
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:50036 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751512AbaAJRdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:33:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:2:41:355:379:541:599:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3866:3867:3868:3870:3871:4049:4119:4321:4385:4605:5007:6119:7652:7903:10004:10226:10848:11026:11232:11233:11473:11658:11876:11914:12043:12296:12438:12517:12519:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hose73_1af26b1a49b5f
X-Filterd-Recvd-Size: 8232
Message-ID: <1389375184.2537.31.camel@joe-AO722>
Subject: Re: [PATCH v5] Bluetooth: Add hci_h4p driver
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?UTF-8?Q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE_?=
	 =?UTF-8?Q?=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Date: Fri, 10 Jan 2014 09:33:04 -0800
In-Reply-To: <20140110145207.GB12048@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
	 <1727897.LBX8128hIo@izba> <20140102161824.GA8204@amd.pavel.ucw.cz>
	 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
	 <20140103001753.GA21023@amd.pavel.ucw.cz>
	 <20140110145207.GB12048@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 15:52 +0100, Pavel Machek wrote:
> Add hci_h4p bluetooth driver to bluetooth-next. This device is used
> for example on Nokia N900 cell phone.

some mostly trivial comments:

> diff --git a/drivers/bluetooth/nokia_core.c b/drivers/bluetooth/nokia_core.c
[]
> +static void hci_h4p_disable_tx(struct hci_h4p_info *info)
> +{
> +	BT_DBG("\n");

function tracers aren't generally useful.

> +void hci_h4p_enable_tx(struct hci_h4p_info *info)
> +{
> +	unsigned long flags;
> +	BT_DBG("\n");

etc...

> +static int hci_h4p_send_negotiation(struct hci_h4p_info *info)
> +{

> +	BT_DBG("Negotiation succesful\n");

3 s's in successful

[]

> +static inline void hci_h4p_handle_byte(struct hci_h4p_info *info, u8 byte)

pretty big function to be inline

> +{
> +	switch (info->rx_state) {
[]
> +	case WAIT_FOR_HEADER:
> +		info->rx_count--;
> +		*skb_put(info->rx_skb, 1) = byte;
> +		if (info->rx_count == 0) {
> +			info->rx_count = hci_h4p_get_data_len(info,
> +							      info->rx_skb);
> +			if (info->rx_count > skb_tailroom(info->rx_skb)) {
> +				dev_err(info->dev, "Too long frame.\n");
> +				info->garbage_bytes = info->rx_count -
> +					skb_tailroom(info->rx_skb);
> +				kfree_skb(info->rx_skb);
> +				info->rx_skb = NULL;
> +				break;
> +			}
> +			info->rx_state = WAIT_FOR_DATA;
> +
> +		}
> +		break;

Perhaps better to write with fewer indentations:

	case WAIT_FOR_HEADER:
		info->rx_count--;
		*skb_put(info->rx_skb, 1) = byte;
		if (info->rx_count != 0)
			break;
		info->rx_count = hci_h4p_get_data_len(info, info->rx_skb);
		if (info->rx_count > skb_tailroom(info->rx_skb)) {
			dev_err(info->dev, "frame too long\n");
			info->garbage_bytes = info->rx_count
					      - skb_tailroom(info->rx_skb);
			kfree_skb(info->rx_skb);
			info->rx_skb = NULL;
			break;
		}
		info->rx_state = WAIT_FOR_DATA;
		break;
 
[]

> +	if (info->rx_count == 0) {
> +		/* H4+ devices should allways send word aligned
> +		 * packets */

s/allways/always/

80 columns are available and this could be a single line comment
		/* H4+ devices should always send word aligned packets */

[]

> +static void hci_h4p_rx_tasklet(unsigned long data)
> +{
[]
> +	while (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR) {
[]
> +		pr_debug("0x%.2x  ", byte);

pr_debug is prefixed by a newline if necessary
and then <7>, one for each use.

This will produce a lot of dmesg output lines
(1 for each byte) and isn't in my opinion
necessary/useful.

> +		hci_h4p_handle_byte(info, byte);
> +	}
> +
> +	if (!info->rx_enabled) {
> +		if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT &&
> +						  info->autorts) {
> +			__hci_h4p_set_auto_ctsrts(info, 0 , UART_EFR_RTS);
> +			info->autorts = 0;
> +		}
> +		/* Flush posted write to avoid spurious interrupts */
> +		hci_h4p_inb(info, UART_OMAP_SCR);
> +		hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
> +	}
> +
> +finish_rx:
> +	pr_debug("\n");

here too.

> +static void hci_h4p_tx_tasklet(unsigned long data)
> +{
[]
> +	if (!skb) {
> +		/* No data in buffer */
> +		BT_DBG("skb ready\n");
> +		if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT) {
> +			hci_h4p_outb(info, UART_IER,
> +				     hci_h4p_inb(info, UART_IER) &
> +				     ~UART_IER_THRI);
> +			hci_h4p_inb(info, UART_OMAP_SCR);
> +			hci_h4p_disable_tx(info);
> +			return;
> +		} else

unnecessary else

> +			hci_h4p_outb(info, UART_OMAP_SCR,
> +				     hci_h4p_inb(info, UART_OMAP_SCR) |
> +				     UART_OMAP_SCR_EMPTY_THR);

and unnecessary indentation

> +		goto finish_tx;
> +	}
> +
> +	/* Copy data to tx fifo */
> +	while (!(hci_h4p_inb(info, UART_OMAP_SSR) & UART_OMAP_SSR_TXFULL) &&
> +	       (sent < skb->len)) {
> +		pr_debug("0x%.2x ", skb->data[sent]);

More unnecessary pr_debug

> +static inline void hci_h4p_set_pm_limits(struct hci_h4p_info *info, bool set)
> +{
> +	struct hci_h4p_platform_data *bt_plat_data = info->dev->platform_data;
> +	char *sset = set ? "set" : "clear";

const?

> +
> +	if (unlikely(!bt_plat_data || !bt_plat_data->set_pm_limits))
> +		return;
> +
> +	if (set != !!test_bit(H4P_ACTIVE_MODE, &info->pm_flags)) {
> +		bt_plat_data->set_pm_limits(info->dev, set);
> +		if (set)
> +			set_bit(H4P_ACTIVE_MODE, &info->pm_flags);
> +		else
> +			clear_bit(H4P_ACTIVE_MODE, &info->pm_flags);
> +		BT_DBG("Change pm constraints to: %s", sset);

missing newline

> +		return;
> +	}
> +
> +	BT_DBG("pm constraints remains: %s", sset);

here too

[]

> +static int hci_h4p_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct hci_h4p_info *info;
> +	int err = 0;
> +
> +	if (!hdev) {
> +		printk(KERN_WARNING "hci_h4p: Frame for unknown device\n");
> +		return -ENODEV;
> +	}

Is this possible?

> +static ssize_t hci_h4p_store_bdaddr(struct device *dev,
> +				    struct device_attribute *attr,
> +				    const char *buf, size_t count)
> +{
> +	struct hci_h4p_info *info = dev_get_drvdata(dev);
> +	unsigned int bdaddr[6];
> +	int ret, i;
> +
> +	ret = sscanf(buf, "%2x:%2x:%2x:%2x:%2x:%2x\n",
> +			&bdaddr[0], &bdaddr[1], &bdaddr[2],
> +			&bdaddr[3], &bdaddr[4], &bdaddr[5]);
> +
> +	if (ret != 6)
> +		return -EINVAL;
> +
> +	for (i = 0; i < 6; i++)
> +		info->bd_addr[i] = bdaddr[i] & 0xff;

This could also return -EINVAL if bdaddr[i] > 0xff

> +static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info, struct sk_buff *skb)
> +{
> +	int i;
> +	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
> +	int not_valid;
> +
> +	not_valid = 1;
> +	for (i = 0; i < 6; i++) {
> +		if (info->bd_addr[i] != 0x00) {
> +			not_valid = 0;
> +			break;
> +		}
> +	}
> +
> +	if (not_valid) {
> +		dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
> +		/* When address is not valid, use some random but Nokia MAC */
> +		memcpy(info->bd_addr, nokia_oui, 3);
> +		get_random_bytes(info->bd_addr + 3, 3);
> +	}

This seems wrong as addresses can have valid 0 bytes.
Perhaps use:

	if (!is_valid_ether_addr(info->bd_addr))

[]

> +int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
> +			struct sk_buff_head *fw_queue)
> +{
[]
> +	/* Check if this is bd_address packet */
> +	if (skb->data[15] == 0x01 && skb->data[16] == 0x00) {
> +		offset = 21;
> +		skb->data[offset + 1] = 0x00;
> +		skb->data[offset + 5] = 0x00;
> +
> +		not_valid = 1;
> +		for (i = 0; i < 6; i++) {
> +			if (info->bd_addr[i] != 0x00) {
> +				not_valid = 0;
> +				break;
> +			}
> +		}
> +
> +		if (not_valid) {
> +			dev_info(info->dev, "Valid bluetooth address not found,"
> +					" setting some random\n");

!is_valid_ether_addr() here too


