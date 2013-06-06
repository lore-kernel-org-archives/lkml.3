Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3FFTRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:17:00 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:42165 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3FFTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:16:58 -0400
MIME-Version: 1.0
In-Reply-To: <1370185130-15332-2-git-send-email-oliver+list@schinagl.nl>
References: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl>
	<1370185130-15332-2-git-send-email-oliver+list@schinagl.nl>
Date: Thu, 6 Jun 2013 22:16:56 +0300
Message-ID: <CAHp75Vdqc9xiPBvQUB3Hfb4EBFUsoVxyuH8MK=9spJ4+rieoDQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: maxime.ripard@free-electrons.com, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Oliver Schinagl <oliver@schinagl.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 2, 2013 at 5:58 PM, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>
> Allwinner has electric fuses (efuse) on their line of chips. This driver
> reads those fuses, seeds the kernel entropy and exports them as a sysfs node.
>
> These fuses are most likly to be programmed at the factory, encoding
> things like Chip ID, some sort of serial number etc and appear to be
> reasonable unique.
> While in theory, these should be writeable by the user, it will probably
> be inconvinient to do so. Allwinner recommends that a certain input pin,
> labeled 'efuse_vddq', be connected to GND. From the name however it is
> highly likly that this name is the programming voltage, required to
> write these fuses.
> Even so, they can still be used to generate a board-unique mac from, board
> unique RSA key and seed the kernel RNG.
>
> Currently supported are the following known chips:
> Allwinner sun4i (A10)
> Allwinner sun5i (A13)

Few commets below.

> +++ b/drivers/misc/eeprom/sunxi_sid.c
> @@ -0,0 +1,172 @@

> +#define DRV_NAME "sunxi-sid"
> +#define DRV_VERSION "1.0"


> +static void __iomem *p_sid_reg_base;
So, why it's global?


> +/* We read the entire key, but only return the requested byte. This is of
> + * course slower then it could be and uses 4 times more reads as needed but
> + * keeps code a simpler.
> + */
> +u8 sunxi_sid_read_byte(const int offset)
> +{
> +       u32 sid_key;
> +       u8 ret;
> +
> +       ret = 0;

ret is redundant variable in this function.

> +       if (likely((SID_SIZE))) {

Extra braces.
Use antipattern here.

> +               sid_key = ioread32be(p_sid_reg_base + round_down(offset, 4));
> +               sid_key >>= (offset % 4) * 8;
> +               ret = sid_key & 0xff;

No need to do & 0xff, since return type is byte.

> +static ssize_t sid_read(struct file *fd, struct kobject *kobj,
> +                       struct bin_attribute *attr, char *buf,
> +                       loff_t pos, size_t size)
> +{
> +       ssize_t ret;
> +       int i;
> +
> +       ret = -EPERM;

When will it happen?
Moreover, ret is redundant.

> +
> +       if ((likely(size > 0)) && ((size + pos) <= SID_SIZE)) {

Extra braces in second part of condition.
Use antipattern.

> +static int __init sunxi_sid_probe(struct platform_device *pdev)
> +{
> +       int entropy[SID_SIZE], i, ret;

Usually ret variable is located at the end of definition block.
Moreover, there is no relationship between those three. It means one
line per variable.

> +       struct device *dev;
> +       struct resource *res;
> +       void __iomem *sid_reg_base;
> +
> +       dev = &pdev->dev;

Please, be consistent, somewhere you still use &pdev->dev.
I recomend to use &pdev->dev everywhere in probe(), since we don't
know if the device will be probed successfully.

> +       if (unlikely(!pdev->dev.of_node)) {
> +               dev_err(dev, "No devicetree data available\n");
> +               ret = -EFAULT;
> +               goto exit;

Plain return here and in entire function where it applies.

> +       }
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(sid_reg_base)) {
> +               dev_err(dev, "Unable to obtain resource\n");

Redundant message. You have not to duplicate this.

> +               ret = PTR_ERR(sid_reg_base);
> +               goto exit;
> +       }
> +       platform_set_drvdata(pdev, sid_reg_base);
> +       p_sid_reg_base = sid_reg_base;
> +
> +       ret = device_create_bin_file(dev, &sid_bin_attr);
> +       if (unlikely(ret)) {

Any benifit of (un)likely in probe()?

> +
> +
> +exit:
> +       return ret;

Remove those two and empty lines.

--
With Best Regards,
Andy Shevchenko
