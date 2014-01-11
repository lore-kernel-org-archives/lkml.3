Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaAKSOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:14:42 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34503 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751539AbaAKSOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:14:39 -0500
Date: Sat, 11 Jan 2014 18:14:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 13/28] drm/i2c: tda998x: use irq for connection
	status and EDID read
Message-ID: <20140111181432.GB15937@n2100.arm.linux.org.uk>
References: <20140109120412.7697d23c@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120412.7697d23c@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:04:12PM +0100, Jean-Francois Moine wrote:
> +	if (priv->int_irq != NO_IRQ) {
> +		priv->wq_edid_wait = 1;
> +		i = wait_event_timeout(priv->wq_edid,
> +					!priv->wq_edid_wait,
> +					msecs_to_jiffies(100));

This looks wrong on two counts.

First, this is racy.  What you're expecting is that this function is
called before the EDID is read, in order for wq_edid_wait to be set.
You're then hoping that the interrupt is received afterwards.

What if this function wasn't called before the EDID read interrupt
occurred?  We time out.

Secondly, what happens if this function is called more than once?
The second time, we won't see an interrupt, because no state has
changed.

This approach is just too buggy.  Please re-work it to be race free
and safe.  You need to maintain a flag which indicates when there is
valid EDID data present - set this when the device indicates that's
the case, and clear it on disconnect.  Then the above becomes a
wait_event_timeout() based on that.

The last thing which needs to be considered here is whether it's possible
to use wait_event_interruptible_timeout() in this path, but that requires
a bit of research into whether DRM is able to restart a call to this
function after handling a signal.

> @@ -1250,6 +1311,39 @@ tda998x_encoder_init(struct i2c_client *client,
>  		priv->vip_cntrl_2 = video;
>  	}
>  
> +	/* install the optional HDMI connect IRQ */
> +	priv->int_irq = irq_of_parse_and_map(np, 0);
> +	if (priv->int_irq < 0)
> +		priv->int_irq = NO_IRQ;
> +	if (priv->int_irq != NO_IRQ) {

NAK.  Do not use NO_IRQ.  Use <= 0 instead, or just test against zero for
no IRQ.  It would also be nice to offer this facility to non-DT platforms
via client->irq.  Not every arch in the Linux kernel uses DT.

> +
> +		/* init read EDID waitqueue */
> +		init_waitqueue_head(&priv->wq_edid);
> +/*		priv->wq_edid_wait = 0;	*/
> +
> +		/* clear pending interrupts */
> +		reg_read(priv, REG_INT_FLAGS_0);
> +		reg_read(priv, REG_INT_FLAGS_1);
> +		reg_read(priv, REG_INT_FLAGS_2);
> +
> +		ret = request_threaded_irq(priv->int_irq, NULL,
> +					   tda998x_irq_thread,
> +					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +					   "tda998x-int", priv);
> +		if (ret) {
> +			dev_err(&client->dev, "failed to request IRQ#%u: %d\n",
> +				priv->int_irq, ret);
> +			goto fail;
> +		}
> +
> +		/* enable HPD irq */
> +		cec_write(priv, REG_CEC_RXSHPDINTENA,
> +				CEC_RXSHPDLEV_HPD | CEC_RXSHPDLEV_RXSENS);
> +
> +		/* treat the first irq if any */
> +		msleep(10);

This comment makes no sense, and doesn't describe what this delay is
actually here for, and why 10ms is the right amount of time to wait.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
