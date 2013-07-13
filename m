Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab3GMFgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 01:36:50 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:44459 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3GMFgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 01:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=PWUHka
	fYKvlLP2228JtYx1e+74MyhO6hK9dDnNY0uv2oetN2ulOGCu++OA2rcdd85Nlj2W
	OhGruZBtRuvv8RM7TfATWY4MxXryFzJ2gUfdC0/zMvYB3k2crDzV9mGleHg7JgyG
	VoK15KhshqfPS+XmDtnuU2KWiiXY4/VO5GJm4=
Message-ID: <51E0E76B.1040304@pobox.com>
Date: Sat, 13 Jul 2013 14:36:43 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: mika.westerberg@linux.intel.com
CC: christian.ruppert@abilis.com, linux-i2c@vger.kernel.org, wsa@the-dreams.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
References: <1373283927-21677-1-git-send-email-mika.westerberg@linux.intel.com> <20130708134216.GB6402@ab42.lan> <20130709084402.GF4898@intel.com> <20130709161927.GC30236@ab42.lan> <20130710105215.GY4898@intel.com> <20130710165634.GA30693@ab42.lan> <20130711073600.GG4898@intel.com> <20130711101330.GP4898@intel.com> <51DFB6C1.4040001@pobox.com> <20130712085140.GY4898@intel.com>
In-Reply-To: <20130712085140.GY4898@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 35750E62-EB7E-11E2-8841-E84251E3A03C-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now I've had a look at the whole discussion.

Basically, DW I2C core provides a good enough (and quite direct) way
to control tHIGH and tLOW timing specs, *HCNT and *LCNT registers.

But from my experience (with a slightly old version of DW I2C core
around 2005, version 1.06a or so), DW I2C core was apparently lacking
in an appropriate hardware mechanism to meet tHD;STA timing spec.  We
then found that we could meet tHD;STA by increasing *HCNT values, so
that's what currently we have in i2c-designware.c  I know with that
workaround applied, tHIGH is to be configured with a larger value
than necessary, but we have no choice.  For I2C bus systems, we must
meet every timing constraint strictly as required.  If DW I2C core
cannot meet tHD;STA without the sacrifice of tHIGH, and I would call
it a hardware bug.

On Wed, Jul 10, 2013 at 06:56:35PM +0200, Christian Ruppert wrote:
>> If I understand the above, it leaves Tf and Tr to be PCB specific and then
>> these values are passed to the core driver from platform data, right?
>
> That would be the idea: Calculate Th' and Tl' in function of the desired
> clock frequency and duty cycle and then adapt these values using
> measured transition times.

I think this would be a good solution.

On 7/8/13 10:42 PM, Christian Ruppert wrote:
> Anyway, the HCNT, LCNT and SDA hold time values we get from ACPI SSCN/FMCN
> methods are measured by our HW guys on a certain board and they have
> verified that using those we meet all the I2C timing specs.
>
> In order to take advantage of those we need some way to pass those values
> to the i2c designware core. I have two suggestions:
>
>    - Use the method outlined in this patch and let the interface driver
>      override *CNT values.

With *HCNT and *LCNT registers, we can control tHIGH, tLOW, tHD;STA
quite accurately.  On the other hand, what we can't control with DW
I2C core is tr and tf.  I assumed that it could never be longer than
300nsec (it's defined as a max. in the I2C specification), so I used
it for calculation.

I agree that tr and tf are PCB specific, and it would a good first
step toward timing optimization to make them configurable through
platform data.

Second step is that if current i2c_dw_scl_hcnt and i2c_dw_scl_lcnt
calculations don't suit with later DW I2C cores, then it would be
nice for someone who can access to the data book to update formulas,
or provide alternative formulas and make them selectable depending
on DW core versions.

It always helps us to have a way to calculate *HCNT and *LCNT values
automatically.  As said above, DW I2C core can control tHIGH, tLOW,
tHD;STA, etc. quite _accurate_, if HCNT/LCNT values were calculated
with proper formulas.  It also helps hardware people as well to
provide reference HCNT/LCNT values.

And as a third step, if we want to use optimized HCNT/LCNT values
which can not be obtained from proper formulas + user-requested
tf/tr, or if we want to use HCNT/LCNT settings verified by vendors
or provided from hardware team, then I'm fine with having a way to
_override_ HCNT/LCNT values.  Such direct way might be useful.

>    - Allow interface drivers to override the function that does calculations
>      for these values like:
>
> 	if (dev->std_scl_cnt)
> 		dev->std_scl_cnt(dev, &hcnt, &lcnt);
> 	else
> 		/* Fallback to the calculation based solely on iclk */

To make the code having less indentations and be more clear that *CNT
values are being overridden, something like this would be nice (leave
more good comments if necessary I'll leave it to you):

  	/* set standard and fast speed deviders for high/low periods */
  
  	/* Standard-mode */
  	hcnt = i2c_dw_scl_hcnt(input_clock_khz,
  				40,	/* tHD;STA = tHIGH = 4.0 us */
  				3,	/* tf = 0.3 us */
  				0,	/* 0: DW default, 1: Ideal */
  				0);	/* No offset */
  	lcnt = i2c_dw_scl_lcnt(input_clock_khz,
  				47,	/* tLOW = 4.7 us */
  				3,	/* tf = 0.3 us */
  				0);	/* No offset */
+	if (dev->ss_hcnt && dev->ss_lcnt) {
+		/* give preference to immediate values over optimal ones */
+		hcnt = dev->ss_hcnt;
+		lcnt = dev->ss_lcnt;
+	}
  	dw_writel(dev, hcnt, DW_IC_SS_SCL_HCNT);
  	dw_writel(dev, lcnt, DW_IC_SS_SCL_LCNT);
  	dev_dbg(dev->dev, "Standard-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);

   Shinya
