Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3JJMpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:45:11 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.161]:22076 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922Ab3JJMpJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:45:09 -0400
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-3.tower-39.messagelabs.com!1381409104!11834836!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH V1] new API regmap_multi_write()
Thread-Topic: [PATCH V1] new API regmap_multi_write()
Thread-Index: AQHOxacDmCx2gczDSEmb5YmvpyXe3ZntyjsAgAARpTA=
Date: Thu, 10 Oct 2013 12:45:03 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB516FC70765@NB-EX-MBX02.diasemi.com>
References: <201310101053.r9AArpal039552@swsrvapps-02.lan>
 <20131010122048.GI21581@sirena.org.uk>
In-Reply-To: <20131010122048.GI21581@sirena.org.uk>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.104]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: 10 October 2013 13:21
> To: Opensource [Anthony Olech]
> Cc: Greg Kroah-Hartman; LKML; David Dajun Chen
> Subject: Re: [PATCH V1] new API regmap_multi_write()
> 
> On Thu, Oct 10, 2013 at 11:50:23AM +0100, Anthony Olech wrote:
> 
> > +/*
> > + * regmap_multi_write(): Write multiple non sequential registers to
> > +the device
> > + *
> > + * @map: Register map to write to
> > + * @reg: Array of registers to be written, all on the same page
> 
> Why all on the same page?  That doesn't seem helpful for things trying to
> build on top of this.  We currently manage to split even block writes up over
> page boundaries.

As far as I could see, the splitting of a block write that spans a page boundary
requires a read-modify-write of a "page" register. That therefore breaks the
primary raison d'etre for the new API, namely that it is atomic on the I2C bus
with respect to multiple I2C bus masters.

Cutting the transfer at a page boundary and inserting a write to a "page"
register would work very well for most of our PM MFDs because there is
no requirement to do a read modify write. Indeed I had thought that it should
be the responsibility of the device driver to insert any necessary "page" register
writes into a transfer that spans page boundaries. The driver knows where the
boundaries are so it should be easy.

> 
> > + * @val: Block of data to be written, in native register size for
> > + device
> > + * @reg_count: Number of registers to write
> 
> I'm not seeing anything here which says how the registers and values are
> related to each other.  I assume that the idea is that the same number of
> registers are provided as values...

Yes - 2 arrays with the same dimension.

> This really doesn't feel like an idiomatic abstraction - it's a bit cumbersome to
> have the pair of arrays and try to line them up especially in native register
> format, normally we do this with an array reg_default.  This would also mean
> that generic code like patches and cache syncing could pick up on the same
> functionality.

You seem to be suggesting that the API could be used by drivers of devices that
do not support in hardware the MULTIWRITE capability. If that is the case then
driver need an config "multi_write_supported" field for initialization.
 
> > +	/*
> > +	 * Some devices do not support multi write, for
> > +	 * them we have a series of single write operations.
> > +	 */
> > +	if (map->use_single_rw) {
> 
> single_rw is somewhat relevant but this needs a separate flag since...
> 
> > +	} else {
> > +		ret = _regmap_raw_multi_write(map,
> > +					      reg_count,
> > +					      reg,
> > +					      wval);
> > +	}
> 
> ...this will try to use the new functionality even if the device doesn't support
> it.  Indeed what this looks like is support for devices that can only do single
> register writes but in the I2C case allow it to be done without releasing the
> bus (it looks a lot like someone optimised things to look like a bunch of SPI
> register writes, with SPI bouncing /CS is much quicker than starting a new I2C
> transfer is).
> 
> I can see it being nice to have something like this but it needs more thought
> on the API and implementation.  I'd suggest splitting the API addition from
> the underlying implementation to make things easier to review (the API
> should work for any user even if it just ends up as a series of separate
> register writes).  Something like DAPM in ASoC could use it for example, as
> well as the patch and cache sync code.

Thanks Mark for your thoughtful comments.

What should the next step in progressing this be?

Tony Olech - Dialog Semiconductor
