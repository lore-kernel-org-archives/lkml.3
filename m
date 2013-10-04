Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3JDNSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:18:31 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63299 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3JDNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:18:29 -0400
Message-ID: <524EC022.2050203@gmail.com>
Date: Fri, 04 Oct 2013 15:18:26 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2 1/2] Input: rotary-encoder: Add 'stepped' irq handler
References: <1380891203-17617-1-git-send-email-ezequiel@vanguardiasur.com.ar> <1380891203-17617-2-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1380891203-17617-2-git-send-email-ezequiel@vanguardiasur.com.ar>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.2013 14:53, Ezequiel Garcia wrote:
> Some rotary-encoder devices (such as those with detents) are capable
> of producing a stable event on each step. This commit adds support
> for this case, by implementing a new interruption handler.
> 
> The handler needs only detect the direction of the turn and generate
> an event according to this detection.

I think you can squash patch 2/2 into this one. It doesn't make much
sense to have a one-liner patch to just update the documenation separately.

Other than that, the code looks fine to me.

  Acked-by: Daniel Mack <zonque@gmail.com>


Thanks,
Daniel


> 
> Cc: Daniel Mack <zonque@gmail.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> ---
> v1->v2:
>   * Add DT property handling
>   * Replace binary representation by hexa-decimal in the sum encoding
> 
>  drivers/input/misc/rotary_encoder.c | 41 +++++++++++++++++++++++++++++++++++++
>  include/linux/rotary_encoder.h      |  1 +
>  2 files changed, 42 insertions(+)
> 
> diff --git a/drivers/input/misc/rotary_encoder.c b/drivers/input/misc/rotary_encoder.c
> index 5b1aff8..6c7a554 100644
> --- a/drivers/input/misc/rotary_encoder.c
> +++ b/drivers/input/misc/rotary_encoder.c
> @@ -117,6 +117,42 @@ static irqreturn_t rotary_encoder_irq(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +static irqreturn_t rotary_encoder_stepped_irq(int irq, void *dev_id)
> +{
> +	struct rotary_encoder *encoder = dev_id;
> +	int state;
> +	unsigned char sum;
> +
> +	state = rotary_encoder_get_state(encoder->pdata);
> +
> +	/*
> +	 * We encode the previous and the current state using a byte.
> +	 * The previous state in the MSB nibble, the current state in the LSB
> +	 * nibble. Then use a table to decide the direction of the turn.
> +	 */
> +	sum = (encoder->last_stable << 4) + state;
> +	switch (sum) {
> +	case 0x31:
> +	case 0x10:
> +	case 0x02:
> +	case 0x23:
> +		encoder->dir = 0; /* clockwise */
> +		break;
> +	/*
> +	 * TODO: Add the other case, and the illegal values should
> +	 * say a WARN (it's a BUG, but we won't stop the kernel for it :)
> +	 */
> +	default:
> +		encoder->dir = 1;
> +	}
> +
> +	rotary_encoder_report_event(encoder);
> +
> +	encoder->last_stable = state;
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static irqreturn_t rotary_encoder_half_period_irq(int irq, void *dev_id)
>  {
>  	struct rotary_encoder *encoder = dev_id;
> @@ -180,6 +216,8 @@ static struct rotary_encoder_platform_data *rotary_encoder_parse_dt(struct devic
>  					"rotary-encoder,rollover", NULL);
>  	pdata->half_period = !!of_get_property(np,
>  					"rotary-encoder,half-period", NULL);
> +	pdata->on_each_step = !!of_get_property(np,
> +					"rotary-encoder,on-each-step", NULL);
>  
>  	return pdata;
>  }
> @@ -254,6 +292,9 @@ static int rotary_encoder_probe(struct platform_device *pdev)
>  	if (pdata->half_period) {
>  		handler = &rotary_encoder_half_period_irq;
>  		encoder->last_stable = rotary_encoder_get_state(pdata);
> +	} else if (pdata->on_each_step) {
> +		handler = &rotary_encoder_stepped_irq;
> +		encoder->last_stable = rotary_encoder_get_state(pdata);
>  	} else {
>  		handler = &rotary_encoder_irq;
>  	}
> diff --git a/include/linux/rotary_encoder.h b/include/linux/rotary_encoder.h
> index 3f594dc..499f6f7 100644
> --- a/include/linux/rotary_encoder.h
> +++ b/include/linux/rotary_encoder.h
> @@ -11,6 +11,7 @@ struct rotary_encoder_platform_data {
>  	bool relative_axis;
>  	bool rollover;
>  	bool half_period;
> +	bool on_each_step;
>  };
>  
>  #endif /* __ROTARY_ENCODER_H__ */
> 

