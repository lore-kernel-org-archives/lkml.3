Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaLKSyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:54:47 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:48995 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLKSyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:54:45 -0500
From: Sifan Naeem <Sifan.Naeem@imgtec.com>
To: James Hogan <James.Hogan@imgtec.com>,
        "mchehab@osg.samsung.com" <mchehab@osg.samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>
Subject: RE: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
Thread-Topic: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
Thread-Index: AQHQD9hz2MhHdqlgJU6fRi14UuxI+5yF9hoAgATRHsA=
Date: Thu, 11 Dec 2014 18:54:40 +0000
Message-ID: <A0E307549471DA4DBAF2DE2DE6CBFB7E49564260@hhmail02.hh.imgtec.org>
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com>
 <1417707523-7730-4-git-send-email-sifan.naeem@imgtec.com>
 <5485DD40.60500@imgtec.com>
In-Reply-To: <5485DD40.60500@imgtec.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.167.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Hogan
> Sent: 08 December 2014 17:18
> To: Sifan Naeem; mchehab@osg.samsung.com
> Cc: linux-kernel@vger.kernel.org; linux-media@vger.kernel.org; James
> Hartley; Ezequiel Garcia
> Subject: Re: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
> 
> On 04/12/14 15:38, Sifan Naeem wrote:
> > Biphase decoding in the current img-ir has got a quirk, where multiple
> > Interrupts are generated when an incomplete IR code is received by the
> > decoder.
> >
> > Patch adds a work around for the quirk and enables biphase decoding.
> >
> > Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
> > ---
> >  drivers/media/rc/img-ir/img-ir-hw.c |   56
> +++++++++++++++++++++++++++++++++--
> >  drivers/media/rc/img-ir/img-ir-hw.h |    2 ++
> >  2 files changed, 55 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/rc/img-ir/img-ir-hw.c
> > b/drivers/media/rc/img-ir/img-ir-hw.c
> > index 4a1407b..a977467 100644
> > --- a/drivers/media/rc/img-ir/img-ir-hw.c
> > +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> > @@ -52,6 +52,11 @@ static struct img_ir_decoder *img_ir_decoders[] = {
> >
> >  #define IMG_IR_QUIRK_CODE_BROKEN	0x1	/* Decode is broken
> */
> >  #define IMG_IR_QUIRK_CODE_LEN_INCR	0x2	/* Bit length needs
> increment */
> > +/*
> > + * The decoder generates rapid interrupts without actually having
> > + * received any new data after an incomplete IR code is decoded.
> > + */
> > +#define IMG_IR_QUIRK_CODE_IRQ		0x4
> >
> >  /* functions for preprocessing timings, ensuring max is set */
> >
> > @@ -547,6 +552,7 @@ static void img_ir_set_decoder(struct img_ir_priv
> > *priv,
> >
> >  	/* stop the end timer and switch back to normal mode */
> >  	del_timer_sync(&hw->end_timer);
> > +	del_timer_sync(&hw->suspend_timer);
> 
> FYI, this'll need rebasing due to conflicting with "img-ir/hw: Fix potential
> deadlock stopping timer". The new del_timer_sync will need to be when spin
> lock isn't held, i.e. still next to the other one, and don't forget to ensure that
> suspend_timer doesn't get started if
> hw->stopping.
> 
Yes, I'll rebase and resend the patch.

> >  	hw->mode = IMG_IR_M_NORMAL;
> >
> >  	/* clear the wakeup scancode filter */ @@ -843,6 +849,26 @@ static
> > void img_ir_end_timer(unsigned long arg)
> >  	spin_unlock_irq(&priv->lock);
> >  }
> >
> > +/*
> > + * Timer function to re-enable the current protocol after it had been
> > + * cleared when invalid interrupts were generated due to a quirk in
> > +the
> > + * img-ir decoder.
> > + */
> > +static void img_ir_suspend_timer(unsigned long arg) {
> > +	struct img_ir_priv *priv = (struct img_ir_priv *)arg;
> > +
> 
> You should take the spin lock for most of this function now that
> "img-ir/hw: Fix potential deadlock stopping timer" is applied and it is safe to
> do so.
> 
done
> > +	img_ir_write(priv, IMG_IR_IRQ_CLEAR,
> > +			IMG_IR_IRQ_ALL & ~IMG_IR_IRQ_EDGE);
> > +
> > +	/* Don't set IRQ if it has changed in a different context. */
> 
> Wouldn't hurt to clarify this while you're at it (it confused me for a moment
> thinking it was concerned about the enabled raw event IRQs
> (IMG_IR_IRQ_EDGE) changing).
> 
Ok
> Maybe "Don't overwrite enabled valid/match IRQs if they have already been
> changed by e.g. a filter change".
> 
> Should you even be clearing IRQs in that case? Maybe safer to just treat that
> case as a "return immediately without touching anything" sort of situation.
> 
don't have to clear it for this work around to work, so will remove.

> > +	if ((priv->hw.suspend_irqen & IMG_IR_IRQ_EDGE) ==
> > +				img_ir_read(priv, IMG_IR_IRQ_ENABLE))
> > +		img_ir_write(priv, IMG_IR_IRQ_ENABLE, priv-
> >hw.suspend_irqen);
> > +	/* enable */
> > +	img_ir_write(priv, IMG_IR_CONTROL, priv->hw.reg_timings.ctrl); }
> > +
> >  #ifdef CONFIG_COMMON_CLK
> >  static void img_ir_change_frequency(struct img_ir_priv *priv,
> >  				    struct clk_notifier_data *change) @@ -
> 908,15 +934,37 @@ void
> > img_ir_isr_hw(struct img_ir_priv *priv, u32 irq_status)
> >  	if (!hw->decoder)
> >  		return;
> >
> > +	ct = hw->decoder->control.code_type;
> > +
> >  	ir_status = img_ir_read(priv, IMG_IR_STATUS);
> > -	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)))
> > +	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2))) {
> > +		if (!(priv->hw.ct_quirks[ct] & IMG_IR_QUIRK_CODE_IRQ))
> 
> (I suggest adding "|| hw->stopping" to this case)
> 
> > +			return;
> > +		/*
> > +		 * The below functionality is added as a work around to stop
> > +		 * multiple Interrupts generated when an incomplete IR code
> is
> > +		 * received by the decoder.
> > +		 * The decoder generates rapid interrupts without actually
> > +		 * having received any new data. After a single interrupt it's
> > +		 * expected to clear up, but instead multiple interrupts are
> > +		 * rapidly generated. only way to get out of this loop is to
> > +		 * reset the control register after a short delay.
> > +		 */
> > +		img_ir_write(priv, IMG_IR_CONTROL, 0);
> > +		hw->suspend_irqen = img_ir_read(priv,
> IMG_IR_IRQ_ENABLE);
> 
> You're reusing hw->suspend_irqen. What if you get this workaround being
> activated between img_ir_enable_wake() and img_ir_disable_wake()? I
> suggest just using a new img_ir_priv_hw member.
> 
Sure.

Thanks,
Sifan

> The rest looks reasonable to me, even if unfortunate that it is necessary in
> the first place.
> 
> Thanks for the hard work!
> 
> Cheers
> James
> 
> > +		img_ir_write(priv, IMG_IR_IRQ_ENABLE,
> > +			     hw->suspend_irqen & IMG_IR_IRQ_EDGE);
> > +
> > +		/* Timer activated to re-enable the protocol. */
> > +		mod_timer(&hw->suspend_timer,
> > +			  jiffies + msecs_to_jiffies(5));
> >  		return;
> > +	}
> >  	ir_status &= ~(IMG_IR_RXDVAL | IMG_IR_RXDVALD2);
> >  	img_ir_write(priv, IMG_IR_STATUS, ir_status);
> >
> >  	len = (ir_status & IMG_IR_RXDLEN) >> IMG_IR_RXDLEN_SHIFT;
> >  	/* some versions report wrong length for certain code types */
> > -	ct = hw->decoder->control.code_type;
> >  	if (hw->ct_quirks[ct] & IMG_IR_QUIRK_CODE_LEN_INCR)
> >  		++len;
> >
> > @@ -958,7 +1006,7 @@ static void img_ir_probe_hw_caps(struct
> img_ir_priv *priv)
> >  	hw->ct_quirks[IMG_IR_CODETYPE_PULSELEN]
> >  		|= IMG_IR_QUIRK_CODE_LEN_INCR;
> >  	hw->ct_quirks[IMG_IR_CODETYPE_BIPHASE]
> > -		|= IMG_IR_QUIRK_CODE_BROKEN;
> > +		|= IMG_IR_QUIRK_CODE_IRQ;
> >  	hw->ct_quirks[IMG_IR_CODETYPE_2BITPULSEPOS]
> >  		|= IMG_IR_QUIRK_CODE_BROKEN;
> >  }
> > @@ -977,6 +1025,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
> >
> >  	/* Set up the end timer */
> >  	setup_timer(&hw->end_timer, img_ir_end_timer, (unsigned
> long)priv);
> > +	setup_timer(&hw->suspend_timer, img_ir_suspend_timer,
> > +				(unsigned long)priv);
> >
> >  	/* Register a clock notifier */
> >  	if (!IS_ERR(priv->clk)) {
> > diff --git a/drivers/media/rc/img-ir/img-ir-hw.h
> > b/drivers/media/rc/img-ir/img-ir-hw.h
> > index 5e59e8e..8578aa7 100644
> > --- a/drivers/media/rc/img-ir/img-ir-hw.h
> > +++ b/drivers/media/rc/img-ir/img-ir-hw.h
> > @@ -221,6 +221,7 @@ enum img_ir_mode {
> >   * @rdev:		Remote control device
> >   * @clk_nb:		Notifier block for clock notify events.
> >   * @end_timer:		Timer until repeat timeout.
> > + * @suspend_timer:	Timer to re-enable protocol.
> >   * @decoder:		Current decoder settings.
> >   * @enabled_protocols:	Currently enabled protocols.
> >   * @clk_hz:		Current core clock rate in Hz.
> > @@ -235,6 +236,7 @@ struct img_ir_priv_hw {
> >  	struct rc_dev			*rdev;
> >  	struct notifier_block		clk_nb;
> >  	struct timer_list		end_timer;
> > +	struct timer_list		suspend_timer;
> >  	const struct img_ir_decoder	*decoder;
> >  	u64				enabled_protocols;
> >  	unsigned long			clk_hz;
> >

