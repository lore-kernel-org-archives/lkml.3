Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaJ0MnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:43:04 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:44289 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaJ0MnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <20141023151940.GA21210@localhost>
References: <1413384491-23703-1-git-send-email-octavian.purdila@intel.com>
	<1413384491-23703-3-git-send-email-octavian.purdila@intel.com>
	<20141023151940.GA21210@localhost>
Date: Mon, 27 Oct 2014 14:42:57 +0200
Message-ID: <CAMoF9u2S9ZbsgeVaBKhc0o5Zo2pz7naomUv2RbvN-G=0C2Dt9A@mail.gmail.com>
Subject: Re: [PATCH v8 2/4] i2c: add support for Diolan DLN-2 USB-I2C adapter
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>, linus.walleij@linaro.org,
        gnurou@gmail.com, wsa@the-dreams.de, sameo@linux.intel.com,
        lee.jones@linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 6:19 PM, Johan Hovold <johan@kernel.org> wrote:
>
> On Wed, Oct 15, 2014 at 05:48:09PM +0300, Octavian Purdila wrote:
>
> > +static int dln2_i2c_xfer(struct i2c_adapter *adapter,
> > +                      struct i2c_msg *msgs, int num)
> > +{
> > +     struct dln2_i2c *dln2 = i2c_get_adapdata(adapter);
> > +     struct i2c_msg *pmsg;
> > +     struct device *dev = &dln2->pdev->dev;
>
> You want to use the i2c-adapter device here (not the platform device).
>

You are right, I will fix in v9.

> > +     int i;
> > +
> > +     for (i = 0; i < num; i++) {
> > +             int ret;
> > +
> > +             pmsg = &msgs[i];
> > +
> > +             if (pmsg->len > DLN2_I2C_MAX_XFER_SIZE) {
> > +                     dev_warn(dev, "maximum transfer size exceeded\n");
> > +                     return -EOPNOTSUPP;
> > +             }
> > +
> > +             if (pmsg->flags & I2C_M_RD) {
> > +                     ret = dln2_i2c_read(dln2, pmsg->addr, pmsg->buf,
> > +                                         pmsg->len);
> > +                     if (ret < 0)
> > +                             return ret;
> > +
> > +                     pmsg->len = ret;
> > +             } else {
> > +                     ret = dln2_i2c_write(dln2, pmsg->addr, pmsg->buf,
> > +                                          pmsg->len);
> > +                     if (ret != pmsg->len)
> > +                             return -EPROTO;
> > +             }
> > +     }
> > +
> > +     return num;
> > +}
>
> [...]
>
> > +static int dln2_i2c_probe(struct platform_device *pdev)
> > +{
> > +     int ret;
> > +     struct dln2_i2c *dln2;
> > +     struct device *dev = &pdev->dev;
> > +     struct dln2_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > +
> > +     dln2 = devm_kzalloc(dev, sizeof(*dln2), GFP_KERNEL);
> > +     if (!dln2)
> > +             return -ENOMEM;
> > +
> > +     dln2->buf = devm_kmalloc(dev, DLN2_I2C_BUF_SIZE, GFP_KERNEL);
> > +     if (!dln2->buf)
> > +             return -ENOMEM;
> > +
> > +     dln2->pdev = pdev;
> > +     dln2->port = pdata->port;
> > +
> > +     /* setup i2c adapter description */
> > +     dln2->adapter.owner = THIS_MODULE;
> > +     dln2->adapter.class = I2C_CLASS_HWMON;
> > +     dln2->adapter.algo = &dln2_i2c_usb_algorithm;
> > +     dln2->adapter.dev.parent = dev;
> > +     i2c_set_adapdata(&dln2->adapter, dln2);
> > +     snprintf(dln2->adapter.name, sizeof(dln2->adapter.name), "%s-%s-%d",
> > +              "dln2-i2c", dev_name(pdev->dev.parent), dln2->port);
> > +
> > +     platform_set_drvdata(pdev, dln2);
> > +
> > +     /* initialize the i2c interface */
>
> No longer "initialisation" since you dropped the frequency setup?
>
> > +     ret = dln2_i2c_enable(dln2, true);
> > +     if (ret < 0) {
> > +             dev_err(dev, "failed to initialize adapter: %d\n", ret);
>
> Same here.

Hmm, I still consider this to be an initialization operation, albeit
less complex then it was before. If you don't mind too much, I would
prefer to keep it this way.
