Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaFGHb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 03:31:27 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:35219 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaFGHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 03:30:17 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 3/7] i2c: Add the ability to match device to compatible
 string without an of_node
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
In-Reply-To: <20140606081026.GO24240@lee--X1>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
	<1401883796-17841-4-git-send-email-lee.jones@linaro.org>
	<20140605173620.5BDFBC41CBF@trevor.secretlab.ca>
	<20140606081026.GO24240@lee--X1>
Date: Sat, 07 Jun 2014 00:39:36 +0100
Message-Id: <20140606233936.D05B8C427DC@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 09:10:26 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 05 Jun 2014, Grant Likely wrote:
> 
> > On Wed,  4 Jun 2014 13:09:52 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> > > A great deal of I2C devices are currently matched via DT node name, and
> > > as such the compatible naming convention of '<vendor>,<device>' has gone
> > > somewhat awry - some nodes don't supply one, some supply an arbitrary
> > > string and others the correct device name with an arbitrary vendor prefix.
> > > 
> > > In an effort to correct this problem we have to supply a mechanism to
> > > match a device by compatible string AND by simple device name.  This
> > > function strips off the '<vendor>,' part of a supplied compatible string
> > > and attempts to match without it.
> > > 
> > > The plan is to remove this function once all of the compatible strings
> > > for each device have been brought into line.
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/i2c/i2c-core.c | 25 +++++++++++++++++++++++++
> > >  include/linux/i2c.h    | 10 ++++++++++
> > >  2 files changed, 35 insertions(+)
> > > 
> > > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > > index d3802dc..7dcd5c3 100644
> > > --- a/drivers/i2c/i2c-core.c
> > > +++ b/drivers/i2c/i2c-core.c
> > > @@ -1090,6 +1090,31 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
> > >  	return i2c_verify_adapter(dev);
> > >  }
> > >  EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
> > > +
> > > +const struct of_device_id
> > > +*i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
> > > +				  struct device *dev)
> > > +{
> > > +	const struct i2c_client *client = i2c_verify_client(dev);
> > > +	const char *name;
> > > +
> > > +	if (!(client && matches))
> > > +		return NULL;
> > > +
> > > +	for (; matches->compatible[0]; matches++) {
> > > +		name = strchr(matches->compatible, ',');
> > > +		if (!name)
> > > +			name = matches->compatible;
> > > +		else
> > > +			name++;
> > > +
> > > +		if (!strncmp(client->name, name, strlen(client->name)))
> > > +			return matches;
> > > +	}
> > 
> > Is it actually necessary to strip off the vendor name? It would be fine
> > to make users include the vendor prefix when creating the device in
> > sysfs. In fact that would be preferrable for new drivers so that vendor
> > prefixes start getting used correctly.
> 
> I see a few issues with this strategy.  Firstly, there are already
> users registering their devices via sysfs, some are taking their
> device names from an EEPROM which would require reprogramming in order
> to prefix the vendor ID.  I'm keen not to break existing systems -
> which not stripping off the vendor name would inevitably do.
> Secondly, I'm not sure how Wolfram would feel about the client->name
> containing a DT compatible string. And finally, other than looking
> at the kernel source, there is no real way for a user to know if the
> device supports ACPI or OF, or neither and if an i2c_device_table is
> supplied or not.

I just went and looked at the code. I2C_NAME_SIZE is fixed to 20
characters. Compatible strings can be larger than that, so you're right.
Stuffing it into the name field isn't a good solution.

g.
