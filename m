Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3JXSmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 14:42:00 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:45006 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754844Ab3JXSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 14:41:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2525:2560:2563:2682:2685:2731:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:7652:7807:7903:8531:9025:10004:10400:10848:11026:11232:11473:11658:11854:11914:12043:12296:12438:12517:12519
X-HE-Tag: bells66_10cad0301f00e
X-Filterd-Recvd-Size: 4032
Message-ID: <1382640113.22433.69.camel@joe-AO722>
Subject: Re: [PATCH] Bluetooth: Add hci_h4p driver
From: Joe Perches <joe@perches.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        =?UTF-8?Q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE_?=
	 =?UTF-8?Q?=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Thu, 24 Oct 2013 11:41:53 -0700
In-Reply-To: <201310181230.45351@pali>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
	 <201310172225.33343@pali>
	 <3B0F039C-4680-46FF-A654-48D6A28B9B5E@holtmann.org>
	 <201310181230.45351@pali>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 12:30 +0200, Pali Rohár wrote:

> I rebased patch on top of https://git.kernel.org/cgit/linux/kernel/git/bluetooth/bluetooth-next.git branch master

Hi Pali, just some trivial notes:

[]

+static ssize_t hci_h4p_show_bdaddr(struct device *dev,
> +                                  struct device_attribute *attr, char *buf)
> +{
> +       struct hci_h4p_info *info = dev_get_drvdata(dev);
> +
> +       return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
> +                      info->bd_addr[0], info->bd_addr[1], info->bd_addr[2],
> +                      info->bd_addr[3], info->bd_addr[4], info->bd_addr[5]);

sprintf(buf, "%pM", info->bd_addr)

and if this is really bluetooth, does the output need to
be emitted in reverse order?  ie: %pMR

[]

> +#define NBT_DBG(fmt, arg...) \
> +               pr_debug("%s: " fmt "" , __func__ , ## arg)
> +
> +#define NBT_DBG_FW(fmt, arg...) \
> +               pr_debug("%s: " fmt "" , __func__ , ## arg)
> +
> +#define NBT_DBG_POWER(fmt, arg...) \
> +               pr_debug("%s: " fmt "" , __func__ , ## arg)
> +
> +#define NBT_DBG_TRANSFER(fmt, arg...) \
> +               pr_debug("%s: " fmt "" , __func__ , ## arg)
> +
> +#define NBT_DBG_TRANSFER_NF(fmt, arg...) \
> +               pr_debug(fmt "" , ## arg)
> +
> +#define NBT_DBG_DMA(fmt, arg...) \
> +               pr_debug("%s: " fmt "" , __func__ , ## arg)

The "" isn't useful.

dynamic_debugging can add __func__ to each message output
with +f.

I think all of these should be converted to pr_debug
where used or consolidated into a single
#define nbt_dbg(mask, fmt, ...)			\
do {						\
	if (mask & debug)			\
		pr_debug(fmt, ##__VA_ARGS__);
} while (0)

and used like:
	nbt_dbg(TRANSFER, fmt, etc...);
where debug is some static.

Also there are many uses missing "\n" which can
cause interleaving problems with other printks.

[]

> +int hci_h4p_wait_for_cts(struct hci_h4p_info *info, int active,
> +                        int timeout_ms)
> +{
> +       unsigned long timeout;
> +       int state;
> +
> +       timeout = jiffies + msecs_to_jiffies(timeout_ms);
> +       for (;;) {

	while (time_before(jiffies, timeout)) {

> +               state = hci_h4p_inb(info, UART_MSR) & UART_MSR_CTS;
> +               if (active) {
> +                       if (state)
> +                               return 0;
> +               } else {
> +                       if (!state)
> +                               return 0;
> +               }
> +               if (time_after(jiffies, timeout))
> +                       return -ETIMEDOUT;

> +               msleep(1);
> +       }

	return -ETIMEDOUT;

> +}



