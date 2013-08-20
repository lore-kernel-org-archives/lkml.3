Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab3HTNgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:36:47 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:29471 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3HTNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:36:46 -0400
Message-ID: <1377005801.1862.10.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH-SR9700] Merge USB 1.1 Ethernet Adapter SR9700 Device
 Driver into the Linux Kernel
From: Ben Hutchings <bhutchings@solarflare.com>
To: liujunliang_ljl <liujunliang_ljl@163.com>
CC: gregkh <gregkh@linuxfoundation.org>, linux-usb <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        sunhecheng <sunhecheng@vip.126.com>
Date: Tue, 20 Aug 2013 14:36:41 +0100
In-Reply-To: <201308201850095789331@163.com>
References: <201308201850095789331@163.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20092.005
X-TM-AS-Result: No--20.938700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 18:50 +0800, liujunliang_ljl wrote:
> Dear Gregkh & all :
> 
> 		I am the software engineer Liu Junliang from ShenZhen CoreChips high technology company, on the market of SR9700 chip is designed and owned by us. 
>         SR9700 is a type of USB to Ethernet Converter and is compatible with USB 1.1 protocol, We want to merge SR9700 device driver into the Linux Kernel. The following is the Linux 3.10.7 version patch for SR9700, Please give us the assessment and support.
>         Thanks a lot.

As this is a net driver, the relevant maintainer is David Miller and not
Greg.

There are some style errors here which can be found using
scripts/checkpatch.pl.  You'll need to fix those and re-submit.  I'll
point out some more problems inline.

> --- /dev/null
> +++ b/drivers/net/usb/sr9700.c
[...]
> +static int sr9700_get_eeprom(struct net_device *net, struct ethtool_eeprom *eeprom, u8 * data)
> +{
> +	struct usbnet *dev = netdev_priv(net);
> +	__le16 *ebuf = (__le16 *) data;
> +	int i;
> +
> +	/* access is 16bit */
> +	if ((eeprom->offset % 2) || (eeprom->len % 2))
> +		return -EINVAL;

You're really supposed to handle these cases by shifting as necessary.

> +	for (i = 0; i < eeprom->len / 2; i++) {
> +		if (sr_read_eeprom_word(dev, eeprom->offset / 2 + i, &ebuf[i]) < 0)
> +			return -EINVAL;

You should pass up the error code, not substitute -EINVAL.

[...]
> +static void sr9700_get_drvinfo(struct net_device *net, struct ethtool_drvinfo *info)
> +{
> +	/* Inherit standard device info */
> +	usbnet_get_drvinfo(net, info);
> +	info->eedump_len = SR_EEPROM_LEN;

You don't need to set eedump_len; the ethtool core will set it after
calling sr9700_get_eeprom_len().  So you don't need your own
implementation of get_drvinfo at all.

[...]
> +static int sr9700_bind(struct usbnet *dev, struct usb_interface *intf)
> +{
[...]
> +	/* read MAC */
> +	if (sr_read(dev, PAR, ETH_ALEN, dev->net->dev_addr) < 0) {
> +		printk(KERN_ERR "Error reading MAC address\n");
> +		ret = -ENODEV;
> +		goto out;
> +	}
[...]

I think this should read the MAC address from EEPROM and copy it to both
dev_addr to perm_addr.  MAC address changes should not persist if the
driver is reloaded.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

