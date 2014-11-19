Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaKSPLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:11:24 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:33221 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbaKSPLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:11:21 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat5gNPvy+mM
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2 1/5] video: omapdss: Add opa362 driver
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <5464DF26.2010707@ti.com>
Date: Wed, 19 Nov 2014 16:10:26 +0100
Cc: Marek Belisko <marek@goldelico.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-fbdev@vger.kernel.org, gta04-owner@goldelico.com
Content-Transfer-Encoding: 8BIT
Message-Id: <BF6765C1-8D5C-4ABA-8796-195058C82E17@goldelico.com>
References: <1415830247-31633-1-git-send-email-marek@goldelico.com> <1415830247-31633-2-git-send-email-marek@goldelico.com> <54649B43.1000801@ti.com> <9FD016B8-4EA2-4A0D-B790-6494AB449B31@goldelico.com> <5464DF26.2010707@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 13.11.2014 um 17:41 schrieb Tomi Valkeinen <tomi.valkeinen@ti.com>:

> On 13/11/14 18:25, Dr. H. Nikolaus Schaller wrote:
>> Hi,
>> 
>> Am 13.11.2014 um 12:51 schrieb Tomi Valkeinen <tomi.valkeinen@ti.com>:
>> 
>>> On 13/11/14 00:10, Marek Belisko wrote:
>>>> opa362 is amplifier for video and can be connected to the tvout pads
>>>> of the OMAP3. It has one gpio control for enable/disable of the output
>>>> (high impedance).
>>>> 
>>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>>> ---
>>>> drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
>>>> drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
>>>> .../fbdev/omap2/displays-new/amplifier-opa362.c    | 343 +++++++++++++++++++++
>>> 
>>> I think it would be better to rename this to encoder-opa362.c. It's not
>> 
>> When developing this driver we did simply rename the encoder-tfp410 file,
>> but thent hough that it does not fit into the „encoder“ category, because we
>> would expect something digital or digital to analog „encoding“ which it does not.
> 
> That is true, but we already have other "encoders" like
> encoder-tpd12s015.c, which also do not encode. "encoder" in this context
> means something that takes a video input, and has a video output. In
> contrast to a panel or a connector.
> 
>>>> +
>>>> +	in->ops.atv->set_timings(in, &ddata->timings);
>>>> +	/* fixme: should we receive the invert from our consumer, i.e. the connector? */
>>>> +	in->ops.atv->invert_vid_out_polarity(in, true);
>>> 
>>> Well this does seem to be broken. I don't know what the answer to the
>>> question above is, but the code doesn't work properly.
>>> 
>>> In the opa362_invert_vid_out_polarity function below, you get the invert
>>> boolean from the connector. This you pass to the OMAP venc. However,
>>> above you always override that value in venc with true.
>>> 
>>> So, either the invert_vid_out_polarity value has to be always true or
>>> false, because _OPA362_ requires it to be true or false, OR you need use
>>> the value from the connector.
>>> 
>>> Seeing the comment in opa362_invert_vid_out_polarity, my guess is the
>>> latter, and the call above should be removed.
>> 
>> Yes, you are right - this is not systematic.
>> 
>> But the problem is that we can’t ask the connector here what it wants
>> to see. It might (or might not) call our opa362_invert_vid_out_polarity() later
>> which we can then forward to overwrite the inital state of this opa362_enable().
> 
> You don't need to ask. The connector calls invert_vid_out_polarity
> before enabling the output.

Unfortunately it doesn’t. At least not always.

It does only for pdata systems but not for DT based systems:

	if (!ddata->dev->of_node) {
		in->ops.atv->set_type(in, ddata->connector_type);
		in->ops.atv->invert_vid_out_polarity(in,
			ddata->invert_polarity);
	}

Not calling is in our case different from calling with ddata->invert_polarity == 0.

> You can just pass it forward inverted, as
> you already do in this driver. If it doesn't, it's either a bug or you
> can just rely on the value that is already programmed to venc.

Therefore it is not called with “false” which would make our invert_vid_out_polarity
invert it and send “true” towards the VENC. So VENC remains non-inverted.

We will also add a patch for the connector-analog.c

>>> We are going to support only DT boot at some point. Thus I think the
>>> whole platform data code should be left out.
>> 
>> Is there already a decision? I think it should not be done before. And it
>> does not harm to still have it.
> 
> It's just a matter of time. I don't accept any new boards using platform
> data for display, or new display drivers using platform data, because I
> don't want to spend my time converting them later. And as this is a new
> driver, no existing board can be using the opa362 platform_data. So we
> can support DT only.

Ok, that looks reasonable - as long as we can rely on that all mainline DSS
drivers are already fully converted to DT :)

BR,
Nikolaus

