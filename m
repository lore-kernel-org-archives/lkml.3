Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3HEJdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:33:00 -0400
Received: from mail.abilis.ch ([195.70.19.74]:20093 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3HEJc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:32:58 -0400
Date: Mon, 5 Aug 2013 11:31:27 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Shinya Kuribayashi <skuribay@pobox.com>
Cc: mika.westerberg@linux.intel.com, linux-i2c@vger.kernel.org,
        wsa@the-dreams.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130805093126.GE20936@ab42.lan>
References: <20130710165634.GA30693@ab42.lan>
 <20130711073600.GG4898@intel.com>
 <20130711101330.GP4898@intel.com>
 <51DFB6C1.4040001@pobox.com>
 <20130712085140.GY4898@intel.com>
 <51E0E76B.1040304@pobox.com>
 <20130716111616.GA25835@ab42.lan>
 <51E6ACBE.7000509@pobox.com>
 <20130722131706.GA24081@ab42.lan>
 <51EFE550.1000507@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51EFE550.1000507@pobox.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:31:44PM +0900, Shinya Kuribayashi wrote:
> On 7/22/13 10:17 PM, Christian Ruppert wrote:> On Wed, Jul 17, 2013 at 11:39:58PM +0900, Shinya Kuribayashi wrote:
> >>On 7/16/13 8:16 PM, Christian Ruppert wrote:> On Sat, Jul 13, 2013 at 02:36:43PM +0900, Shinya Kuribayashi wrote:
> >>>>Basically, DW I2C core provides a good enough (and quite direct) way
> >>>>to control tHIGH and tLOW timing specs, *HCNT and *LCNT registers.
> >>>>
> >>>>But from my experience (with a slightly old version of DW I2C core
> >>>>around 2005, version 1.06a or so), DW I2C core was apparently lacking
> >>>>in an appropriate hardware mechanism to meet tHD;STA timing spec.  We
> >>>>then found that we could meet tHD;STA by increasing *HCNT values, so
> >>>>that's what currently we have in i2c-designware.c  I know with that
> >>>>workaround applied, tHIGH is to be configured with a larger value
> >>>>than necessary, but we have no choice.  For I2C bus systems, we must
> >>>>meet every timing constraint strictly as required.  If DW I2C core
> >>>>cannot meet tHD;STA without the sacrifice of tHIGH, and I would call
> >>>>it a hardware bug.
> >>>
> >>>I agree. However, tHD;STA [min] is defined to the same value as tHIGH
> >>>[min] for all modes in the I2C specification. Do I understand you
> >>>correctly that the SCL_HCNT parameters control at the same time tHIGH
> >>>and tHD;STA?
> >>
> >>*HCNT value does affect both tHIGH and tHD;STA at the same time.
> >>But we have to make sure that composition of tHIGH is different
> >>from the one of tHD;STA.
> >>
> >>For tHIGH
> >>----------
> >>
> >>DW I2C core is aware of the SCL rising transition (tr) and can
> >>ignore it.  It starts counting the HIGH period of the SCL signal
> >>(tHIGH) after the SCL input voltage increases at VIH.
> >>
> >>This is described in the data book as an ideal configuration,
> >>and the resulting formula would be:
> >>
> >>	HCNT + (1+4+3) >= IC_CLK * tHIGH ... (a)
> >>
> >>please refer to the data book for details about (1+4+3) part.
> >>
> >>For tLOW
> >>--------
> >>
> >>DW I2C core starts counting the SCL CNTs for the LOW period of
> >>the SCL signal (tLOW) as soon as it pulls the SCL line _without_
> >>_confirming_ the SCL input voltage decreases at VIL.
> >>
> >>In order to meet the tLOW timing spec, we need to take into
> >>account the fall time of SCL signal (tf), so the resulting
> >>formula should be:
> >>
> >>	LCNT + 1 >= IC_CLK * (tLOW + tf)
> >>
> >>please refer to the data book for details about '+1' part.
> >>
> >>For tHD;STA
> >>-----------
> >>
> >>There is no explanation about tHD;STA in the data book.  We
> >>only have (my) experimental result; tHD;STA turned out to be
> >>proportional to 'HCNT + 3'.  The formula is:
> >>
> >>	HCNT + 3 >= IC_CLK * (tHD;STA + tf) ... (b)
> >>
> >>DW I2C core seems to start counting the SCL CNTs for the HIGH
> >>period of the SCL signel (tHD;STA) as soon as it pulls the _SDA_
> >>line without confirming the SDA input voltage decreases at VIL,
> >>so we have to take into account the SDA falling transition (tf)
> >>here.
> >>
> >>As can be expected from (a) and (b), if tHD;STA [min] is defined
> >>to the same value as tHIGH [min], we need to have larger HCNT
> >>value than necessary for tHIGH, to meet tHD;STA constraint.
> >>
> >>[...]
> >
> >Hrmmm... This makes my head spin. Do you think the following code
> >snippet represents an accurate method to calculate the register values?
> >If you agree I'll prepare a patch based on that for the DW I2C. The
> >question will be, however, how to obtain the transition times.
> 
> Please find my comments below.
> 
> >/*
> > *        t_f;SDA
> > *          |-|
> > *     _____              _____ . . .
> > *          \            /
> > * SDA       \          /
> > *            \________/       t_r;SCL    t_f;SCL
> > *                               |-|        |-|
> > *     ______________               ________
> > *                   \             /        \
> > * SCL                \           /          \
> > *                     \_________/            \_______ . . .
> > *            |------| |---------| |--------|
> > *            t_HD;STA    t_LOW      t_HIGH
> > *
> > *          |--------|-----------| |--------|
> > *         (   HCNT       LCNT        HCNT   ) * 1/f_SYS
> 
> Composition is:  HCNT+3     LCNT+1      HCNT+(1+4+3)

OK

> The offsets for the HCNT are different in the cases of tHD;STA and
> t_HIGH.  It's based on my experimental result and we can't know how
> DW I2C core actually counts those period, but it can be easily
> imagined that for DW I2C core, the way to count t_HD;STA is similar
> to the way to count t_LOW; it starts counting CNTs as soon as it
> pulls the SCL/SDA line, then waits for given CNTs.
> 
> I think your equations and snippet code are based on the assumption
> that DW I2C core must be counting the number of CNTs for the HIGH
> period of the SCL signal (that's t_HD;STA and t_HIGH) in the same
> way, but I don't think so.  From my observation and experimental
> results, it must be different.  We couldn't know what actually is,
> though.
> 
> > *
> > * HCNT = f_SYS * max(t_HD;STA + t_f;SDA , t_HIGH)
> > *      = f_SYS * (t_HIGH + t_f;SDA)      because T_HD;STA == T_HIGH
> > * LCNT = f_SYS * (t_f;SCL + t_LOW)
> > * HCNT + LCNT + t_r;SCL = 1/f_SCL = t_SCL

So the corrected HCNT would be:
HCNT = max(f_SYS * (t_HD;STA + t_f;SDA) - 3, f_SYS * t_HIGH - 7)
     = f_SYS * (t_HD;STA + t_f;SDA) - 3

> As said before, all t_SCL things should go away.  Please forget
> about 100kbps, 400kbps, and so on.  Bus/clock speed is totally
> pointless concept for the I2C bus systems.  For example, as long
> as tr/tf, tHIGH/tLOW, tHD;STA, etc. are met by _all_ devices in a
> certain I2C bus, it doesn't matter that the resulting clock speed
> is, say 120 kbps with Standard-mode, or even 800 kbps for Fast-mode.
> Nobody in the I2C bus doesn't care about actual bus/clock speed.
> 
> We don't have to care about the resulting bus speed, or rather
> we should/must not check to see if it's within the proper range.

Actually, the I2C specification clearly defines f_SCL;max (and thus
implies t_SCL;min), both in the tables and the timing diagrams. Why can
we ignore this constraint while having to meet all the others?

> >#define I2C_STD_MODE       (0)
> >#define I2C_FAST_MODE      (1)
> >#define I2C_FAST_MODE_PLUS (2)
> >
> >static const struct i2c_timing_params {
> >	unsigned int t_SCL;   /* t_SCL in (ms * 65536) */
> >	unsigned int t_LOW;   /* t_LOW in (ms * 65536) */
> >	unsigned int t_HIGH;  /* t_HIGH = t_HD;STA in (ms * 65536) */
> >} i2c_timing_params[] = {
> >	{ /* I2C_STD_MODE */
> >		.t_SCL   = 10.0e-3 * 65536 + 0.5,
> >		.t_LOW   =  4.7e-3 * 65536 + 0.5,
> >		.t_HIGH  =  4.0e-3 * 65536 + 0.5,
> >	},
> >	{ /* I2C_FAST_MODE */
> >		.t_SCL   =  2.5e-3 * 65536 + 0.5,
> >		.t_LOW   =  1.3e-3 * 65536 + 0.5,
> >		.t_HIGH  =  0.6e-3 * 65536 + 0.5,
> >	},
> >	{ /* I2C_FAST_MODE_PLUS */
> >		.t_SCL   =  1.0e-3 * 65536 + 0.5,
> >		.t_LOW   =  0.5e-3 * 65536 + 0.5,
> >		.t_HIGH  =  0.26e-3 * 65536 + 0.5,
> >	},
> >};
> 
> I just can't take to these 65536s, 0.5s, and {(x + 32768) >> 16},
> as it's not intuitive.  Would be nice to come up with another way!

OK, I'll make this more readable in the next version.

> >#define DW_CNT_OFFS    (1)
> >#define DW_FILT_OFFS   (2)
> >#define DW_SCL_LATENCY (3)
> >
> >/*
> >  * all timings in ns f_SYS in kHz
> >  * For worst case scenario assume tf_SCL = tf_SDA = 300ns, tr_SCL = 0ns
> >  */
> >void calc_timing_params(u16 *HCNT, u16 *LCNT, unsigned int f_SYS
> >			unsigned int tf_SCL, unsigned int tr_SCL,
> >			unsigned int tf_SDA, unsigned int mode,
> >			unsigned int IC_SPKLEN)
> >{
> >	unsigned int H, L;
> >	int D;
> >	/*
> >	 * The worst case High count timing includes the SDA falling
> >	 * transition of start condition
> >	 */
> >	H = f_SYS * (tf_SDA + i2c_timing_params[mode].t_HIGH);
> >
> >	/* The Low count timing always includes the preceding falling edge. */
> >	L = f_SYS * (tf_SCL + i2c_timing_params[mode].t_LOW);
> >
> >	/*
> >	 * The clock timings must not exceed the maximum frequencies
> >	 * from the I2C specification, slow down if required.
> >	 */
> >	D = (f_SYS * i2c_timing_params[mode].t_scl - H - L - tr_SCL) / 2;
> >	if (D > 0) {
> >		H += D;
> >		L += D;
> >	}
> 
> These H/L adjustments based on clock timings are not necessary.
> 
> >	/*
> >	 * Round the HIGH count and subtract
> >	 * (DW_CNT_OFFS + DW_FILT_OFFS + DW_SCL_LATENCY + IC_SPKLEN)
> >	 * which are added to the register value inside the DW IP.
> >	 */
> >	H = ((H + 32768) >> 16) - DW_CNT_OFFS - DW_FILT_OFFS
> >				- DW_SCL_LATENCY - IC_SPKLEN;
> 
> And this adjustment for HCNT has to be altered to suit t_HIGH or
> t_HD;STA.  It can not be processed in a single form like this.

I agree.

> >	/*
> >	 * Round the LOW count and subtract DW_CNT_OFFS which is added to
> >	 * the register value inside the DW IP.
> >	 */
> >	L = ((L + 32768) >> 16) - DW_CNT_OFFS;
> 
> This is Ok.
> 
> >	/* Respect the DW IP minimum timings */
> >	if (H < (IC_SPKLEN + 5))
> >		H = IC_SPKLEN + 5;
> >	if (L < (IC_SPKLEN + 7))
> >		L = IC_SPKLEN + 7;
> >	*HCNT = H;
> >	*LCNT = L;
> >}
> 
> I'm not familiar with this SPKLEN (spike length?) as it didn't
> appear in the data book around 2005, but it's fine to try to make
> sure H/L values are within the range supported.

Yes, SPKLEN is a register defining the number of cycles to filter out in
spike filtering. If this has appeared sometime between 2005 and today we
must also check the version for this. This is really starting to become
complicated.

> >Would it make sense to add generic I2C device tree properties for those
> >parameters? These parameters are independent of the actual bus driver,
> >rather a PCB property... And as such the correct place would be device
> >tree or ACPI or similar.
> 
> If there are other bus drivers that make use of tr/tf transition
> times, I think it makes sense.

Wolfram, what's your opinion on this?

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
