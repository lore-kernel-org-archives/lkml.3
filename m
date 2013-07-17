Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3GQOkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:40:06 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:46660 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab3GQOkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=aa7snU
	jK1qxGVuI58g8ITo5aeMCfnLTbAakjHto+Z+BNlC0d0+fYwpUECVcbhbRYu6d64a
	MP4DI0uiNaYPX9isDPNj7FDFLDuqRXuSVQDvoiHSJB/EdMHSvmtup37CPLXdzhqt
	gbgoNACIqPsCqdBUiVe7PWTfT76TVsJ/S5OI4=
Message-ID: <51E6ACBE.7000509@pobox.com>
Date: Wed, 17 Jul 2013 23:39:58 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: christian.ruppert@abilis.com
CC: mika.westerberg@linux.intel.com, linux-i2c@vger.kernel.org,
        wsa@the-dreams.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
References: <20130708134216.GB6402@ab42.lan> <20130709084402.GF4898@intel.com> <20130709161927.GC30236@ab42.lan> <20130710105215.GY4898@intel.com> <20130710165634.GA30693@ab42.lan> <20130711073600.GG4898@intel.com> <20130711101330.GP4898@intel.com> <51DFB6C1.4040001@pobox.com> <20130712085140.GY4898@intel.com> <51E0E76B.1040304@pobox.com> <20130716111616.GA25835@ab42.lan>
In-Reply-To: <20130716111616.GA25835@ab42.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: C35BDD46-EEEE-11E2-9A1D-E84251E3A03C-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/13 8:16 PM, Christian Ruppert wrote:> On Sat, Jul 13, 2013 at 02:36:43PM +0900, Shinya Kuribayashi wrote:
>> Basically, DW I2C core provides a good enough (and quite direct) way
>> to control tHIGH and tLOW timing specs, *HCNT and *LCNT registers.
>>
>> But from my experience (with a slightly old version of DW I2C core
>> around 2005, version 1.06a or so), DW I2C core was apparently lacking
>> in an appropriate hardware mechanism to meet tHD;STA timing spec.  We
>> then found that we could meet tHD;STA by increasing *HCNT values, so
>> that's what currently we have in i2c-designware.c  I know with that
>> workaround applied, tHIGH is to be configured with a larger value
>> than necessary, but we have no choice.  For I2C bus systems, we must
>> meet every timing constraint strictly as required.  If DW I2C core
>> cannot meet tHD;STA without the sacrifice of tHIGH, and I would call
>> it a hardware bug.
>
> I agree. However, tHD;STA [min] is defined to the same value as tHIGH
> [min] for all modes in the I2C specification. Do I understand you
> correctly that the SCL_HCNT parameters control at the same time tHIGH
> and tHD;STA?

*HCNT value does affect both tHIGH and tHD;STA at the same time.
But we have to make sure that composition of tHIGH is different
from the one of tHD;STA.

For tHIGH
----------

DW I2C core is aware of the SCL rising transition (tr) and can
ignore it.  It starts counting the HIGH period of the SCL signal
(tHIGH) after the SCL input voltage increases at VIH.

This is described in the data book as an ideal configuration,
and the resulting formula would be:

	HCNT + (1+4+3) >= IC_CLK * tHIGH ... (a)

please refer to the data book for details about (1+4+3) part.

For tLOW
--------

DW I2C core starts counting the SCL CNTs for the LOW period of
the SCL signal (tLOW) as soon as it pulls the SCL line _without_
_confirming_ the SCL input voltage decreases at VIL.

In order to meet the tLOW timing spec, we need to take into
account the fall time of SCL signal (tf), so the resulting
formula should be:

	LCNT + 1 >= IC_CLK * (tLOW + tf)

please refer to the data book for details about '+1' part.

For tHD;STA
-----------

There is no explanation about tHD;STA in the data book.  We
only have (my) experimental result; tHD;STA turned out to be
proportional to 'HCNT + 3'.  The formula is:

	HCNT + 3 >= IC_CLK * (tHD;STA + tf) ... (b)

DW I2C core seems to start counting the SCL CNTs for the HIGH
period of the SCL signel (tHD;STA) as soon as it pulls the _SDA_
line without confirming the SDA input voltage decreases at VIL,
so we have to take into account the SDA falling transition (tf)
here.

As can be expected from (a) and (b), if tHD;STA [min] is defined
to the same value as tHIGH [min], we need to have larger HCNT
value than necessary for tHIGH, to meet tHD;STA constraint.

> Concerning SDA_HOLD_TIME, we have done a few measurements in our lab and
> it looks like the delay between the falling edge clock of the start
> condition and the rising edge of the first data bit of the start byte is
> controlled by this parameter. I conclude that in the drawing below (1)
> is controlled by SCL_HCNT whereas (2) is controlled by SDA_HOLD_TIME.
>
>       _________
> scl           \__________ ...
>       ___           ______
> sda     \_________/       ...
>
>          |-----|---|
>            (1)  (2)

Thanks for the clarification, understood.

   Shinya

>>> In order to take advantage of those we need some way to pass those values
>>> to the i2c designware core. I have two suggestions:
>>>
>>>    - Use the method outlined in this patch and let the interface driver
>>>      override *CNT values.
>>
>> With *HCNT and *LCNT registers, we can control tHIGH, tLOW, tHD;STA
>> quite accurately.  On the other hand, what we can't control with DW
>> I2C core is tr and tf.  I assumed that it could never be longer than
>> 300nsec (it's defined as a max. in the I2C specification), so I used
>> it for calculation.
>>
>> I agree that tr and tf are PCB specific, and it would a good first
>> step toward timing optimization to make them configurable through
>> platform data.
>>
>> Second step is that if current i2c_dw_scl_hcnt and i2c_dw_scl_lcnt
>> calculations don't suit with later DW I2C cores, then it would be
>> nice for someone who can access to the data book to update formulas,
>> or provide alternative formulas and make them selectable depending
>> on DW core versions.
>
> I'm not having the impression there is a huge difference between the
> different generations of DW blocks. Probably we can find one formula
> that suits all blocks. We just have to be careful (in doubt rather
> conservative) with the transition times. This seems to be currently
> the case and if I understand Mika correctly, his objective is to remove
> some of this conservatism.
>
>> It always helps us to have a way to calculate *HCNT and *LCNT values
>> automatically.  As said above, DW I2C core can control tHIGH, tLOW,
>> tHD;STA, etc. quite _accurate_, if HCNT/LCNT values were calculated
>> with proper formulas.  It also helps hardware people as well to
>> provide reference HCNT/LCNT values.
>>
>> And as a third step, if we want to use optimized HCNT/LCNT values
>> which can not be obtained from proper formulas + user-requested
>> tf/tr, or if we want to use HCNT/LCNT settings verified by vendors
>> or provided from hardware team, then I'm fine with having a way to
>> _override_ HCNT/LCNT values.  Such direct way might be useful.
>
> I agree. Probably it is best to have both, a default method based on
> formulas and timing parameters (the formulas are quite simple anyway)
> which works with device tree and such and a second method based on
> register values which works with mechanisms like ACPI.

