Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaFDR4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:56:02 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:50346 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaFDRz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:55:59 -0400
Date: Wed, 4 Jun 2014 18:55:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/7] i2c: Add the ability to match device to compatible
 string without an of_node
Message-ID: <20140604175552.GB19550@lee--X1>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-4-git-send-email-lee.jones@linaro.org>
 <CAL_JsqJOEipHyjD2NCjQd1BvLumnM3PkVDqUjrMNfXCOmXcNAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJOEipHyjD2NCjQd1BvLumnM3PkVDqUjrMNfXCOmXcNAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2014, Rob Herring wrote:

> On Wed, Jun 4, 2014 at 7:09 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > A great deal of I2C devices are currently matched via DT node name, and
> > as such the compatible naming convention of '<vendor>,<device>' has gone
> > somewhat awry - some nodes don't supply one, some supply an arbitrary
> > string and others the correct device name with an arbitrary vendor prefix.
> >
> > In an effort to correct this problem we have to supply a mechanism to
> > match a device by compatible string AND by simple device name.  This
> > function strips off the '<vendor>,' part of a supplied compatible string
> > and attempts to match without it.
> >
> > The plan is to remove this function once all of the compatible strings
> > for each device have been brought into line.
> 
> Then should you add a warning for cases needing to be fixed?

I was just going to go and fix them all, but I could do that as well?

> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/i2c/i2c-core.c | 25 +++++++++++++++++++++++++
> >  include/linux/i2c.h    | 10 ++++++++++
> >  2 files changed, 35 insertions(+)
> >
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index d3802dc..7dcd5c3 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -1090,6 +1090,31 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
> >         return i2c_verify_adapter(dev);
> >  }
> >  EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
> > +
> > +const struct of_device_id
> > +*i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
> > +                                 struct device *dev)
> > +{
> > +       const struct i2c_client *client = i2c_verify_client(dev);
> > +       const char *name;
> > +
> > +       if (!(client && matches))
> > +               return NULL;
> > +
> > +       for (; matches->compatible[0]; matches++) {
> > +               name = strchr(matches->compatible, ',');
> > +               if (!name)
> > +                       name = matches->compatible;
> > +               else
> > +                       name++;
> > +
> > +               if (!strncmp(client->name, name, strlen(client->name)))
> > +                       return matches;
> > +       }
> > +
> > +       return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(i2c_of_match_device_strip_vendor);
> >  #else
> >  static void of_i2c_register_devices(struct i2c_adapter *adap) { }
> >  #endif /* CONFIG_OF */
> > diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> > index b556e0a..f7ec75b 100644
> > --- a/include/linux/i2c.h
> > +++ b/include/linux/i2c.h
> > @@ -564,6 +564,9 @@ extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
> >  /* must call put_device() when done with returned i2c_adapter device */
> >  extern struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node);
> >
> > +extern const struct of_device_id
> > +*i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
> > +                                 struct device *dev);
> >  #else
> >
> >  static inline struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
> > @@ -575,6 +578,13 @@ static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node
> >  {
> >         return NULL;
> >  }
> > +
> > +const struct of_device_id
> > +*i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
> > +                                 struct device *dev)
> > +{
> > +       return NULL;
> > +}
> >  #endif /* CONFIG_OF */
> >
> >  #endif /* _LINUX_I2C_H */
> >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
