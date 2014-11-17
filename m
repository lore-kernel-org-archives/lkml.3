Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaKQLxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:53:20 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:55116 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaKQLxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:53:19 -0500
Date: Mon, 17 Nov 2014 12:53:16 +0100
From: Johan Hovold <johan@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Johan Havold <johan@kernel.org>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141117115316.GA19375@localhost>
References: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
 <1415799490-27989-2-git-send-email-laurentiu.palcu@intel.com>
 <20141113122728.GA18285@localhost>
 <20141113151721.GQ5826@lpalcu-linux>
 <20141114105645.GB18285@localhost>
 <20141117103300.GA2583@lpalcu-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117103300.GA2583@lpalcu-linux>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:33:01PM +0200, Laurentiu Palcu wrote:
> Hi Johan,
> 
> On Fri, Nov 14, 2014 at 11:56:45AM +0100, Johan Havold wrote:
> > On Thu, Nov 13, 2014 at 05:17:21PM +0200, Laurentiu Palcu wrote:
> > > Hi Johan,
> > > 
> > > On Thu, Nov 13, 2014 at 01:27:28PM +0100, Johan Havold wrote:
> > > > On Wed, Nov 12, 2014 at 03:38:09PM +0200, Laurentiu Palcu wrote:

> > I noticed that checkpatch didn't complain, but 81 chars is still >80,
> > right? The newline counts as well (at least in vim).
>
> Isn't it all about visible characters? vim, which I use, does not count
> the newline. I even have a special plugin for linux kernel development
> that highlights the extra characters in red. Also, after looking at
> other files in the kernel, it seems this file is compliant.

You're right. For some reason I had my vim textwidth set to 78. Sorry.

> > > > > +static int dln2_spi_get_cs_num(struct dln2_spi *dln2, u16 *cs_num)
> > > > > +{
> > > > > +	int ret;
> > > > > +	struct {
> > > > > +		u8 port;
> > > > > +	} tx;
> > > > > +	struct {
> > > > > +		__le16 cs_count;
> > > > > +	} *rx = dln2->buf;
> > > > 
> > > > I don't think you want to use dln2->buf for all these small transfers.
> > > > And what would be protecting it from concurrent use?
> > > > 
> > > > Check this throughout.
> > >
> > > I answered this above.
> > 
> > So did I. Even though the transfer functions are serialised by spi-core
> > it's not obvious that all your helpers will be.
>
> I really looked this through and I couldn't find an example when one or
> more helpers can be called in parallel. Most of the helpers are called
> from the probe function and the rest are called from
> dln2_spi_transfer_setup(), via dln2_spi_transfer_one_message(). The
> dln2_spi_prepare_message() is called from SPI core's
> spi_pump_messages(), just before calling transfer_one_message()... So,
> it's still serial.
> 
> If there is a flaw in my logic, feel free to correct me.

I'm not doubting that you got it right. My point is just that it's hard
for someone else to see whether you did (and someone adding a new helper
later on might not be as careful as you).

> > And since there's no gain from using the global buffer why not simply
> > use stack allocated ones here as well (e.g. for both tx and rx above)?
>
> However, I will give this a shot though... Sounds reasonable and I could
> probably lose the struct constructs too if the struct contains just
> one field.

You might want to keep the structs for single-field messages for
consistency reasons (also used in the other dln2 subdrivers).

Johan
