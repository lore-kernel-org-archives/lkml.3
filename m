Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3IMVOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:14:48 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58265 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3IMVOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:14:46 -0400
Date: Fri, 13 Sep 2013 14:14:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH] clk: si570: Add a driver for SI570 oscillators
Message-ID: <20130913211443.GA9511@roeck-us.net>
References: <1379033737-30015-1-git-send-email-soren.brinkmann@xilinx.com>
 <1379033737-30015-2-git-send-email-soren.brinkmann@xilinx.com>
 <20130913170005.GB5681@roeck-us.net>
 <c6755ff6-104d-40fe-a753-0e165cff1e10@AM1EHSMHS004.ehs.local>
 <20130913194822.GA12117@roeck-us.net>
 <4b7029c7-8617-4c3d-9544-4245293b77f1@CO9EHSMHS014.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b7029c7-8617-4c3d-9544-4245293b77f1@CO9EHSMHS014.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 02:05:49PM -0700, Sören Brinkmann wrote:
> On Fri, Sep 13, 2013 at 12:48:22PM -0700, Guenter Roeck wrote:
> > On Fri, Sep 13, 2013 at 10:26:04AM -0700, Sören Brinkmann wrote:
> > > On Fri, Sep 13, 2013 at 10:00:05AM -0700, Guenter Roeck wrote:
> > > > On Thu, Sep 12, 2013 at 05:55:37PM -0700, Soren Brinkmann wrote:
> > > > > Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> > > > > The devices generate low-jitter clock signals and are reprogrammable via
> > > > > an I2C interface.
> > > > > 
> > > > > Cc: Guenter Roeck <linux@roeck-us.net>
> > > > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > > > ---
> > [ ... ]
> > 
> > > > > +	/* Applying a new frequency can take up to 10ms */
> > > > > +	usleep_range(10000, 10001);
> > > > 
> > > > One microsecond range doesn't really buy anything besides forcing the compiler
> > > > to generate extra code. Why not just use 10000 ?
> > > That's due to checkpatch. I originally had 'msleep(10)' and checkpatch
> > > suggested to use 'usleep_range()'. Then I put
> > > 'usleep_range(10000, 10000)' and checkpatch suggested to not use the
> > > same values for MIN and MAX, so I added the 1 to the MAX value.
> > > If it is considered to be safe and okay to put in MIN=MAX=10000, I'll
> > > change it accordingly.
> > > 
> > Guess what checkpatch means is to put in something resonable,
> > such as maybe (10000, 12000). (10000, 10001) just defeats checkpatch
> > which doesn't really provide any value. So either provide a reasonable
> > and acceptable range or use a single value.
> All right. I'll make it 10000 then, for MIN and MAX.
> 
> > 
> > [ ... ]
> > 
> > > > > +	match = of_match_node(clk_si570_of_match, client->dev.of_node);
> > > > > +	if (!match)
> > > > > +		return -EINVAL;
> > > > 
> > > > Seems unusual. Is this really needed ? It precludes the driver from being used
> > > > in a non-devicetree environment, for example. I would guess that there is a match
> > > > if client->dev.of_node is set. Otherwise, this code would be needed in every
> > > > driver supporting devicetree, and I don't recall seeing that.
> > > > 
> > > > > +	ddata = match->data;
> > > > > +
> > > > You should be able to get this information (ie the pointer to si570_device_data)
> > > > from id->driver_data. That would be more consistent with other i2c devices.
> > > I think I copied this approach from the other clk-si... driver. I'll
> > > do some research on your suggestion and change it. Could you point me to
> > > an example for your proposal?
> > > 
> > drivers/hwmon/lm90.c or drivers/hwmon/max6697.c.
> Thanks.
> 
> > 
> > > > > +
> > > > > +	if (of_property_read_u32(client->dev.of_node, "factory-fout",
> > > > > +				&factory_fout)) {
> > > > > +		dev_warn(&client->dev,
> > > > > +			"DTS does not contain factory-fout, using default\n");
> > > > 
> > > > Is that really worth a warning ?
> > > My understanding is, that the default output frequency is part-specific
> > > and required to calculate the frequency of the internal crystal. Hence,
> > > if you do not provide the correct default output frequency for your part, all
> > > frequencies generated by this driver will be off, unless the here used
> > > default matches your part. Please correct me if I'm wrong, otherwise, I
> > > think it's worth a warning.
> > > 
> > Maybe the property should be mandatory ?
> It's actually listed as required property in the documentation. I'll
> make it mandatory in the code as well and let probe() fail if it's not
> provided.
> 
Ok.

Thanks,
Guenter
