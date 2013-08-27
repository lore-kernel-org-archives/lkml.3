Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3H0Mzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:55:36 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39973 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3H0Mze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:55:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: devicetree-discuss@lists.ozlabs.org, Archit Taneja <archit@ti.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, grant.likely@secretlab.ca
Subject: Re: [PATCH v5] gpio: pcf857x: Add OF support
Date: Tue, 27 Aug 2013 14:56:55 +0200
Message-ID: <2400176.9Vcd5TUYl9@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1830640.BeoA2uHWDI@amdc1227>
References: <1377590559-14279-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <521C63A0.10902@ti.com> <1830640.BeoA2uHWDI@amdc1227>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Tuesday 27 August 2013 13:55:00 Tomasz Figa wrote:
> On Tuesday 27 of August 2013 14:00:24 Archit Taneja wrote:
> > On Tuesday 27 August 2013 01:44 PM, Tomasz Figa wrote:
> > > On Tuesday 27 of August 2013 10:02:39 Laurent Pinchart wrote:
> > >> Add DT bindings for the pcf857x-compatible chips and parse the device
> > >> tree node in the driver.
> > >> 
> > >> Signed-off-by: Laurent Pinchart
> > >> <laurent.pinchart+renesas@ideasonboard.com> ---
> > >> 
> > >>   .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71 +++++++++++++
> > >>   drivers/gpio/gpio-pcf857x.c                        | 44 ++++++++++---
> > >>   2 files changed, 107 insertions(+), 8 deletions(-)
> > >>   create mode 100644
> > >> Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> > >> 
> > >> Changes since v4:
> > >> 
> > >> - Don't try to get ngpio from of_device_id data, we already get it
> > >>   from i2c_device_id
> > > 
> > > Hmm, I'm not sure how this is supposed to work.
> > > 
> > > How does the I2C core resolve OF compatible name to particular entry in
> > > id_table? I believe it simply passes NULL as the second argument of
> > > .probe() if the device is instantiated based on OF compatible string
> > > and not one in the legacy ID table.
> > 
> > It doesn't pass the second argument as NULL. If you look at
> > i2c_device_probe() in drivers/i2c/i2c-core.c, the second argument to
> > probe is passed as: i2c_match_id(driver->id_table, client)
> > 
> > This will extract the i2c_device_id pointer from the id_table.
> 
> Yes, there is a chance that it will not return NULL, but I think that
> relying on this is rather flawed.
> 
> If you look at the whole code path, you can see that it's only a
> coincidence that this works. See the execution flow:
>  - I2C adapter driver calls of_i2c_register_devices(),
>  - of_i2c_register_devices() calls of_modalias_node() for every device on
> this bus,
>  - of_modalias_node() stores the second substring of compatible string
> separated by a comma, if there is one or the whole compatible otherwise to
> the output buffer (type field of i2c_board_info struct, as passed by
> of_i2c_register_devices()),
>  - of_i2c_register_devices() then calls i2c_new_device() with the resulting
> info struct,
>  - i2c_new_device() takes info->type and copies its contents to client->name
>  - then a bit later, I2C core calls i2c_match_id(), which does matching of
> client->name against id_table of the driver and the resulting i2c_device_id
> entry (or NULL) is then passed to driver's .probe() callback.
> 
> So if it happens that compatible is not equal to "<vendor>,<ID from legacy
> I2C table>", then the matching will fail and NULL will be passed.

The driver should support the same chip models reardless of whether it's used 
with or without DT. If an entry in the OF table has no corresponding entry in 
the I2C table I would consider that as a driver bug. It would be caught early, 
as the driver would crash at probe time, so it will likely not make it to 
mainline (unless we merge untested code, but that's another issue :-)).

> [CCing Wolfram and Grant, as they should now more about this behavior and
> whether it's intentional or no]

-- 
Regards,

Laurent Pinchart

