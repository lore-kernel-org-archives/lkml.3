Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbaFBQTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:19:24 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:48582 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaFBQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:19:22 -0400
Date: Mon, 2 Jun 2014 17:19:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de, linus.walleij@linaro.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: Provide 'device type' to 'OF device node'
 look-up
Message-ID: <20140602161915.GA30879@lee--X1>
References: <1401716463-23457-1-git-send-email-lee.jones@linaro.org>
 <1401716463-23457-2-git-send-email-lee.jones@linaro.org>
 <20140602160631.F2F6DC40476@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140602160631.F2F6DC40476@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We have a problem.  There are lots of I2C device ID tables scattered
> > around the kernel which are redundant in all Device Tree and/or ACPI
> > only supported device drivers.  After recent discussions it has become
> > apparent that the only thing blocking the complete removal of these
> > tables is the continued support of 'register an I2C device via sysfs'
> > functionality.  As the sysfs method doesn't know anything about Device
> > Tree or ACPI, we can not pass any nodes in.  This patch searches all
> > known Device Tree nodes and attempts to acquire a match from the
> > device name provided via sysfs.  It can not fail, but if found assigns
> > the matching of_node to i2c_board_info prior to registering.
> 
> Ummm... blech!  :-)
> 
> It shouldn't actually be necessary to have a node when instantiating an
> i2c_device... in fact, there /shouldn't/ be a node if the device is
> getting instantiated by had via sysfs. If there was a node, then I would
> expect a device to have been created at the same time.

You're right.  I realised that about 10 mins after I sent the patch!

> I think panto's overlays solve the problem where a node actually is
> required to instantiate the device by actually adding a node and letting
> the i2c subsystem create the associated device automatically.

This looks like it's exactly what I need.  Pulling the code now.

> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/i2c/i2c-core.c | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> > 
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index 7c7f4b8..2e47641 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -64,6 +64,7 @@ static DEFINE_IDR(i2c_adapter_idr);
> >  
> >  static struct device_type i2c_client_type;
> >  static int i2c_detect(struct i2c_adapter *adapter, struct i2c_driver *driver);
> > +static struct device_node *of_i2c_type_to_node(char *type);
> >  
> >  static struct static_key i2c_trace_msg = STATIC_KEY_INIT_FALSE;
> >  
> > @@ -863,6 +864,8 @@ i2c_sysfs_new_device(struct device *dev, struct device_attribute *attr,
> >  		return -EINVAL;
> >  	}
> >  
> > +	info.of_node = of_i2c_type_to_node(info.type);
> > +
> >  	client = i2c_new_device(adap, &info);
> >  	if (!client)
> >  		return -EINVAL;
> > @@ -1088,8 +1091,36 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
> >  	return i2c_verify_adapter(dev);
> >  }
> >  EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
> > +
> > +static struct device_node *of_i2c_type_to_node(char *type)
> > +{
> > +	struct device_node *np;
> > +	const char *compatible, *name;
> > +	int len;
> > +
> > +	if (!type)
> > +		return NULL;
> > +
> > +	for_each_of_allnodes(np) {
> > +		compatible = of_get_property(np, "compatible", &len);
> > +		if (!compatible)
> > +			continue;
> > +
> > +		name = strchr(compatible, ',');
> > +		if (!name)
> > +			name = compatible;
> > +		else
> > +			name++;
> > +
> > +		if (!strncmp(name, type, len - (name - compatible)))
> > +			return np;
> > +	}
> > +
> > +	return NULL;
> > +}
> >  #else
> >  static void of_i2c_register_devices(struct i2c_adapter *adap) { }
> > +static struct device_node *of_i2c_type_to_node(char *type) { return NULL; }
> >  #endif /* CONFIG_OF */
> >  
> >  /* ACPI support code */
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
