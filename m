Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaFBPfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:35:41 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:43409 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaFBPfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:35:38 -0400
Date: Mon, 2 Jun 2014 12:36:45 -0300
From: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        Ezequiel =?iso-8859-1?Q?Garc=EDa?= 
	<ezequiel@vanguardiasur.com.ar>,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/3] drivers: input: keyboard: adp5589: add DT support
Message-ID: <20140602153645.GA26073@fox>
References: <1399467644-27222-1-git-send-email-guido@vanguardiasur.com.ar>
 <1399467644-27222-2-git-send-email-guido@vanguardiasur.com.ar>
 <20140518204009.GB13276@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140518204009.GB13276@core.coreip.homeip.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, sorry for the terribly late reply.

On Sun, May 18, 2014 at 01:40:09PM -0700, Dmitry Torokhov wrote:
> Hi Guido,
> 
> On Wed, May 07, 2014 at 10:00:42AM -0300, Guido Martínez wrote:
> > Add DT support for the Analog ADP5589 matrix keypad decoding functions.
> > 
> > Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
> > ---
> >  drivers/input/keyboard/adp5589-keys.c | 207 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 206 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
> > index 6329549..2b232c0 100644
> > --- a/drivers/input/keyboard/adp5589-keys.c
> > +++ b/drivers/input/keyboard/adp5589-keys.c
> > @@ -18,7 +18,10 @@
> >  #include <linux/i2c.h>
> >  #include <linux/gpio.h>
> >  #include <linux/slab.h>
> > +#include <linux/of.h>
> > +#include <linux/err.h>
> >  
> > +#include <linux/input/matrix_keypad.h>
> >  #include <linux/input/adp5589.h>
> >  
> >  /* ADP5589/ADP5585 Common Registers */
> > @@ -246,6 +249,14 @@ struct adp5589_kpad {
> >  #endif
> >  };
> >  
> > +static struct of_device_id adp5589_of_match[] = {
> > +	{
> > +		.compatible = "adi,adp5589",
> > +		.data = (void *)ADP5589
> > +	},
> > +	{ },
> > +};
> > +
> >  /*
> >   *  ADP5589 / ADP5585 derivative / variant handling
> >   */
> > @@ -858,6 +869,188 @@ static void adp5589_report_switch_state(struct adp5589_kpad *kpad)
> >  	input_sync(kpad->input);
> >  }
> >  
> > +#ifdef CONFIG_OF
> > +static int adp5589_key(int row, int col)
> > +{
> > +	return col + row * 11;
> > +}
> > +
> > +static int adp5589_dt_read_keymap(struct device *dev,
> > +				  struct adp5589_kpad_platform_data *pdata,
> > +				  const struct device_node *node)
> > +{
> > +	int i;
> > +	const u32 *dt_keymap;
> > +	unsigned short *keymap;
> > +	int keymap_len;
> > +
> > +	dt_keymap = of_get_property(node, "linux,keymap", &keymap_len);
> > +	if (!dt_keymap) {
> > +		dev_err(dev, "missing dt keymap\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (keymap_len % sizeof(u32)) {
> > +		dev_err(dev, "malformed keymap (len=%i)\n", keymap_len);
> > +		return -EINVAL;
> > +	}
> > +
> > +	keymap_len /= sizeof(u32);
> > +
> > +	keymap = devm_kzalloc(dev, ADP5589_KEYMAPSIZE * sizeof(u32),
> > +			      GFP_KERNEL);
> > +	if (!keymap)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < keymap_len; i++) {
> > +		u32 val;
> > +		u16 key;
> > +		u8 row, col;
> > +
> > +		val = be32_to_cpup(&dt_keymap[i]);
> > +
> > +		row = KEY_ROW(val);
> > +		col = KEY_COL(val);
> > +		key = KEY_VAL(val);
> > +
> > +		if (row > ADP5589_MAX_ROW_NUM) {
> > +			dev_err(dev, "invalid row number (%i)\n", row);
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (col > ADP5589_MAX_COL_NUM) {
> > +			dev_err(dev, "invalid column number (%i)\n", col);
> > +			return -EINVAL;
> > +		}
> > +
> > +		pdata->keypad_en_mask |= ADP_ROW(row);
> > +		pdata->keypad_en_mask |= ADP_COL(col);
> > +
> > +		keymap[adp5589_key(row, col)] = key;
> > +	}
> > +
> > +	pdata->keymap = keymap;
> > +	pdata->keymapsize = ADP5589_KEYMAPSIZE;
> 
> I was wondering if we could also move non-DT variant to matrix-keypad
> infrastructure and use matrix_keypad_build_keymap and friends to handle
> this uniformly.

Seems like a good idea, I'll look into it.

Thanks for reviewing this!

-- 
Guido Martínez, VanguardiaSur
www.vanguardiasur.com.ar
