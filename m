Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3ENFOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:14:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39309 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3ENFOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:14:20 -0400
Date: Tue, 14 May 2013 07:13:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v3] media: i2c: mt9p031: add OF support
Message-ID: <20130514051356.GW32299@pengutronix.de>
References: <1367563919-2880-1-git-send-email-prabhakar.csengg@gmail.com>
 <5750435.WVYuIYMX2V@avalon>
 <20130513104604.GU20989@pengutronix.de>
 <2897565.OjqREpRvoz@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2897565.OjqREpRvoz@avalon>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:12:32 up 324 days, 20:24, 66 users,  load average: 0.17, 0.33,
 0.43
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 12:59:27AM +0200, Laurent Pinchart wrote:
> Hi Sascha,
> 
> On Monday 13 May 2013 12:46:04 Sascha Hauer wrote:
> > On Wed, May 08, 2013 at 12:37:29PM +0200, Laurent Pinchart wrote:
> > > Hi Prabhakar,
> > > 
> > > On Wednesday 08 May 2013 10:19:57 Prabhakar Lad wrote:
> > > > On Wed, May 8, 2013 at 7:32 AM, Laurent Pinchart wrote:
> > > > > On Tuesday 07 May 2013 15:10:36 Prabhakar Lad wrote:
> > > > >> On Mon, May 6, 2013 at 8:29 PM, Prabhakar Lad wrote:
> > > > >> > On Fri, May 3, 2013 at 8:04 PM, Arnd Bergmann wrote:
> > > > >> >> On Friday 03 May 2013, Prabhakar Lad wrote:
> > > > >> > [snip]
> > > > >> > 
> > > > >> >>> +}
> > > > >> >> 
> > > > >> >> Ok, good.
> > > > >> >> 
> > > > >> >>> @@ -955,7 +998,17 @@ static int mt9p031_probe(struct i2c_client
> > > > >> >>> *client,
> > > > >> >>> 
> > > > >> >>>         mt9p031->pdata = pdata;
> > > > >> >>>         mt9p031->output_control = MT9P031_OUTPUT_CONTROL_DEF;
> > > > >> >>>         mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
> > > > >> >>> 
> > > > >> >>> -       mt9p031->model = did->driver_data;
> > > > >> >>> +
> > > > >> >>> +       if (!client->dev.of_node) {
> > > > >> >>> +               mt9p031->model = (enum
> > > > >> >>> mt9p031_model)did->driver_data;
> > > > >> >>> +       } else {
> > > > >> >>> +               const struct of_device_id *of_id;
> > > > >> >>> +
> > > > >> >>> +               of_id =
> > > > >> >>> of_match_device(of_match_ptr(mt9p031_of_match),
> > > > >> >>> +                                       &client->dev);
> > > > >> >>> +               if (of_id)
> > > > >> >>> +                       mt9p031->model = (enum
> > > > >> >>> mt9p031_model)of_id->data;
> > > > >> >>> +       }
> > > > >> >>> 
> > > > >> >>>         mt9p031->reset = -1;
> > > > >> >> 
> > > > >> >> Is this actually required? I thought the i2c core just compared
> > > > >> >> the
> > > > >> >> part of the "compatible" value after the first comma to the
> > > > >> >> string, so
> > > > >> >> "mt9p031->model = (enum mt9p031_model)did->driver_data" should
> > > > >> >> work
> > > > >> >> in both cases.
> > 
> > At least on v3.8 I just checked that 'did' is indeed NULL for the
> > devicetree case. Also I see no indication that i2c starts comparing
> > after the first comma in the string.
> > 
> > > > >> > I am OK with "mt9p031->model = (enum
> > > > >> > mt9p031_model)did->driver_data"
> > > > >> > but I see still few drivers doing this, I am not sure for what
> > > > >> > reason.
> > > > >> > If everyone is OK with it I can drop the above change.
> > > > >> 
> > > > >> My bad, while booting with DT the i2c_device_id ie did in this case
> > > > >> will
> > > > >> be NULL, so the above changes are required :-)
> > > > > 
> > > > > I've just tested your patch, and did isn't NULL when booting my
> > > > > Beagleboard with DT (on v3.9-rc5).
> > > > 
> > > > I am pretty much sure you tested it compatible property as
> > > > "aptina,mt9p031"
> > > > if the compatible property is set to "aptina,mt9p031m" the did will be
> > > > NULL.> 
> > > I've tested both :-)
> > 
> > Sorry to nag, but did you use "aptina,mt9p031[m]" as a compatible string or
> > did you use "mt9p031[m]". With "aptina,..." 'did' should really be NULL.
> 
> I've used "aptina,mt9p031[m]".
> 
> Please see the of_modalias_node() call in of_i2c_register_devices() 
> (drivers/of/of-i2c.c), that's where the I2C device type name should be 
> initialized.

Ok, got it. I still had the older aptina,mt9p031m-sensor binding in my
patch.

Sorry for the noise.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
