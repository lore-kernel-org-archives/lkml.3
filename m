Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaJYT1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:27:18 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49960 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaJYT1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:27:16 -0400
Message-ID: <544BF991.1050306@kernel.org>
Date: Sat, 25 Oct 2014 20:27:13 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: irina.tirdea@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 6/7] iio: dummy: Demonstrate the usage of new channel
 types
References: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com> <1412858385-11954-7-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1412858385-11954-7-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 13:39, Daniel Baluta wrote:
> Adds support for the new channel types in the dummy driver:
>   * a new channel IIO_ACTIVITY
>   * two state transition events (running and walking)
>   * a new channel IIO_STEPS and support for reading and writing
>     pedometer step counter
>   * step detect event
>   * a new channel IIO_HEIGHT and support for reading and writing
>     height
>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
This looks fine, allowing for changes due to suggestions / discussions
about earlier patches.
> ---
>  drivers/staging/iio/iio_simple_dummy.c        | 199 +++++++++++++++++++++++---
>  drivers/staging/iio/iio_simple_dummy.h        |   5 +
>  drivers/staging/iio/iio_simple_dummy_events.c |  38 +++++
>  3 files changed, 223 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/staging/iio/iio_simple_dummy.c b/drivers/staging/iio/iio_simple_dummy.c
> index bf78e6f..5430aed 100644
> --- a/drivers/staging/iio/iio_simple_dummy.c
> +++ b/drivers/staging/iio/iio_simple_dummy.c
> @@ -69,6 +69,34 @@ static const struct iio_event_spec iio_dummy_event = {
>  	.mask_separate = BIT(IIO_EV_INFO_VALUE) | BIT(IIO_EV_INFO_ENABLE),
>  };
>
> +/*
> + * simple step detect event - triggered when a step is detected
> + */
> +static const struct iio_event_spec step_detect_event = {
> +	.type = IIO_EV_TYPE_INSTANCE,
> +	.dir = IIO_EV_DIR_NONE,
> +	.mask_separate = BIT(IIO_EV_INFO_ENABLE),
> +};
> +
> +/*
> + * simple transition event - triggered when the reported running confidence
> + * value rises above a threshold value
> + */
> +static const struct iio_event_spec iio_running_event = {
> +	.type = IIO_EV_TYPE_TRANSITION,
> +	.dir = IIO_EV_DIR_RISING,
> +	.mask_separate = BIT(IIO_EV_INFO_VALUE) | BIT(IIO_EV_INFO_ENABLE),
> +};
> +
> +/*
> + * simple transition event - triggered when the reported walking confidence
> + * value falls under a threshold value
> + */
> +static const struct iio_event_spec iio_walking_event = {
> +	.type = IIO_EV_TYPE_TRANSITION,
> +	.dir = IIO_EV_DIR_FALLING,
> +	.mask_separate = BIT(IIO_EV_INFO_VALUE) | BIT(IIO_EV_INFO_ENABLE),
> +};
>  #endif
>
>  /*
> @@ -215,6 +243,42 @@ static const struct iio_chan_spec iio_dummy_channels[] = {
>  		.indexed = 1,
>  		.channel = 0,
>  	},
> +	{
> +		.type = IIO_STEPS,
> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_ENABLE),
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> +		.scan_index = -1,
> +#ifdef CONFIG_IIO_SIMPLE_DUMMY_EVENTS
> +		.event_spec = &step_detect_event,
> +		.num_event_specs = 1,
> +#endif /* CONFIG_IIO_SIMPLE_DUMMY_EVENTS */
> +	},
> +	{
> +		.type = IIO_HEIGHT,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),
> +		.scan_index = -1,
> +	},
> +	{
> +		.type = IIO_ACTIVITY,
> +		.modified = 1,
> +		.channel2 = IIO_MOD_RUNNING,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> +#ifdef CONFIG_IIO_SIMPLE_DUMMY_EVENTS
> +		.event_spec = &iio_running_event,
> +		.num_event_specs = 1,
> +#endif /* CONFIG_IIO_SIMPLE_DUMMY_EVENTS */
> +	},
> +	{
> +		.type = IIO_ACTIVITY,
> +		.modified = 1,
> +		.channel2 = IIO_MOD_WALKING,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> +#ifdef CONFIG_IIO_SIMPLE_DUMMY_EVENTS
> +		.event_spec = &iio_walking_event,
> +		.num_event_specs = 1,
> +#endif /* CONFIG_IIO_SIMPLE_DUMMY_EVENTS */
> +	},
>  };
>
>  /**
> @@ -259,6 +323,34 @@ static int iio_dummy_read_raw(struct iio_dev *indio_dev,
>  			*val = st->accel_val;
>  			ret = IIO_VAL_INT;
>  			break;
> +		case IIO_HEIGHT:
> +			*val = st->height;
> +			ret = IIO_VAL_INT;
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
> +	case IIO_CHAN_INFO_PROCESSED:
> +		switch (chan->type) {
> +		case IIO_STEPS:
> +			*val = st->steps;
> +			ret = IIO_VAL_INT;
> +			break;
> +		case IIO_ACTIVITY:
> +			switch (chan->channel2) {
> +			case IIO_MOD_RUNNING:
> +				*val = st->activity_running;
> +				ret = IIO_VAL_INT;
> +				break;
> +			case IIO_MOD_WALKING:
> +				*val = st->activity_walking;
> +				ret = IIO_VAL_INT;
> +				break;
> +			default:
> +				break;
> +			}
> +			break;
>  		default:
>  			break;
>  		}
> @@ -269,18 +361,29 @@ static int iio_dummy_read_raw(struct iio_dev *indio_dev,
>  		ret = IIO_VAL_INT;
>  		break;
>  	case IIO_CHAN_INFO_SCALE:
> -		switch (chan->differential) {
> -		case 0:
> -			/* only single ended adc -> 0.001333 */
> -			*val = 0;
> -			*val2 = 1333;
> -			ret = IIO_VAL_INT_PLUS_MICRO;
> +		switch (chan->type) {
> +		case IIO_VOLTAGE:
> +			switch (chan->differential) {
> +			case 0:
> +				/* only single ended adc -> 0.001333 */
> +				*val = 0;
> +				*val2 = 1333;
> +				ret = IIO_VAL_INT_PLUS_MICRO;
> +				break;
> +			case 1:
> +				/* all differential adc channels ->
> +				 * 0.000001344 */
> +				*val = 0;
> +				*val2 = 1344;
> +				ret = IIO_VAL_INT_PLUS_NANO;
> +			}
> +			break;
> +		case IIO_HEIGHT:
> +			*val = 1;
> +			ret = IIO_VAL_INT;
> +			break;
> +		default:
>  			break;
> -		case 1:
> -			/* all differential adc channels -> 0.000001344 */
> -			*val = 0;
> -			*val2 = 1344;
> -			ret = IIO_VAL_INT_PLUS_NANO;
>  		}
>  		break;
>  	case IIO_CHAN_INFO_CALIBBIAS:
> @@ -298,6 +401,16 @@ static int iio_dummy_read_raw(struct iio_dev *indio_dev,
>  		*val2 = 33;
>  		ret = IIO_VAL_INT_PLUS_NANO;
>  		break;
> +	case IIO_CHAN_INFO_ENABLE:
> +		switch (chan->type) {
> +		case IIO_STEPS:
> +			*val = st->steps_enabled;
> +			ret = IIO_VAL_INT;
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
>  	default:
>  		break;
>  	}
> @@ -330,14 +443,50 @@ static int iio_dummy_write_raw(struct iio_dev *indio_dev,
>
>  	switch (mask) {
>  	case IIO_CHAN_INFO_RAW:
> -		if (chan->output == 0)
> +		switch (chan->type) {
> +		case IIO_VOLTAGE:
> +			if (chan->output == 0)
> +				return -EINVAL;
> +
> +			/* Locking not required as writing single value */
> +			mutex_lock(&st->lock);
> +			st->dac_val = val;
> +			mutex_unlock(&st->lock);
> +			return 0;
> +		case IIO_HEIGHT:
> +			mutex_lock(&st->lock);
> +			st->height = val;
> +			mutex_unlock(&st->lock);
> +			return 0;
> +		default:
>  			return -EINVAL;
> -
> -		/* Locking not required as writing single value */
> -		mutex_lock(&st->lock);
> -		st->dac_val = val;
> -		mutex_unlock(&st->lock);
> -		return 0;
> +		}
> +	case IIO_CHAN_INFO_PROCESSED:
> +		switch (chan->type) {
> +		case IIO_STEPS:
> +			mutex_lock(&st->lock);
> +			st->steps = val;
> +			mutex_unlock(&st->lock);
> +			return 0;
> +		case IIO_ACTIVITY:
> +			if (val < 0)
> +				val = 0;
> +			if (val > 100)
> +				val = 100;
> +			switch (chan->channel2) {
> +			case IIO_MOD_RUNNING:
> +				st->activity_running = val;
> +				return 0;
> +			case IIO_MOD_WALKING:
> +				st->activity_walking = val;
> +				return 0;
> +			default:
> +				return -EINVAL;
> +			}
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
>  	case IIO_CHAN_INFO_CALIBSCALE:
>  		mutex_lock(&st->lock);
>  		/* Compare against table - hard matching here */
> @@ -356,7 +505,16 @@ static int iio_dummy_write_raw(struct iio_dev *indio_dev,
>  		st->accel_calibbias = val;
>  		mutex_unlock(&st->lock);
>  		return 0;
> -
> +	case IIO_CHAN_INFO_ENABLE:
> +		switch (chan->type) {
> +		case IIO_STEPS:
> +			mutex_lock(&st->lock);
> +			st->steps_enabled = val;
> +			mutex_unlock(&st->lock);
> +			return 0;
> +		default:
> +			return -EINVAL;
> +		}
>  	default:
>  		return -EINVAL;
>  	}
> @@ -395,6 +553,9 @@ static int iio_dummy_init_device(struct iio_dev *indio_dev)
>  	st->accel_val = 34;
>  	st->accel_calibbias = -7;
>  	st->accel_calibscale = &dummy_scales[0];
> +	st->steps = 47;
> +	st->activity_running = 98;
> +	st->activity_walking = 4;
>
>  	return 0;
>  }
> diff --git a/drivers/staging/iio/iio_simple_dummy.h b/drivers/staging/iio/iio_simple_dummy.h
> index 1a74e26..d49aec3 100644
> --- a/drivers/staging/iio/iio_simple_dummy.h
> +++ b/drivers/staging/iio/iio_simple_dummy.h
> @@ -32,9 +32,14 @@ struct iio_dummy_state {
>  	int differential_adc_val[2];
>  	int accel_val;
>  	int accel_calibbias;
> +	int activity_running;
> +	int activity_walking;
>  	const struct iio_dummy_accel_calibscale *accel_calibscale;
>  	struct mutex lock;
>  	struct iio_dummy_regs *regs;
> +	int steps_enabled;
> +	int steps;
> +	int height;
>  #ifdef CONFIG_IIO_SIMPLE_DUMMY_EVENTS
>  	int event_irq;
>  	int event_val;
> diff --git a/drivers/staging/iio/iio_simple_dummy_events.c b/drivers/staging/iio/iio_simple_dummy_events.c
> index 719dfa5..ae37620 100644
> --- a/drivers/staging/iio/iio_simple_dummy_events.c
> +++ b/drivers/staging/iio/iio_simple_dummy_events.c
> @@ -66,12 +66,23 @@ int iio_simple_dummy_write_event_config(struct iio_dev *indio_dev,
>  	 */
>  	switch (chan->type) {
>  	case IIO_VOLTAGE:
> +	case IIO_ACTIVITY:
>  		switch (type) {
>  		case IIO_EV_TYPE_THRESH:
>  			if (dir == IIO_EV_DIR_RISING)
>  				st->event_en = state;
>  			else
>  				return -EINVAL;
> +		case IIO_EV_TYPE_TRANSITION:
> +			st->event_en = state;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	case IIO_STEPS:
> +		switch (type) {
> +		case IIO_EV_TYPE_INSTANCE:
> +			st->event_en = state;
>  			break;
>  		default:
>  			return -EINVAL;
> @@ -161,6 +172,33 @@ static irqreturn_t iio_simple_dummy_event_handler(int irq, void *private)
>  					      IIO_EV_TYPE_THRESH, 0, 0, 0),
>  			       iio_get_time_ns());
>  		break;
> +	case 1:
> +		if (st->activity_running > st->event_val)
> +			iio_push_event(indio_dev,
> +				       IIO_EVENT_CODE(IIO_ACTIVITY, 0,
> +						      IIO_MOD_RUNNING,
> +						      IIO_EV_DIR_RISING,
> +						      IIO_EV_TYPE_TRANSITION,
> +						      0, 0, 0),
> +				       iio_get_time_ns());
> +		break;
> +	case 2:
> +		if (st->activity_walking < st->event_val)
> +			iio_push_event(indio_dev,
> +				       IIO_EVENT_CODE(IIO_ACTIVITY, 0,
> +						      IIO_MOD_WALKING,
> +						      IIO_EV_DIR_FALLING,
> +						      IIO_EV_TYPE_TRANSITION,
> +						      0, 0, 0),
> +				       iio_get_time_ns());
> +		break;
> +	case 3:
> +		iio_push_event(indio_dev,
> +			       IIO_EVENT_CODE(IIO_STEPS, 0, IIO_NO_MOD,
> +					      IIO_EV_DIR_NONE,
> +					      IIO_EV_TYPE_INSTANCE, 0, 0, 0),
> +			       iio_get_time_ns());
> +		break;
>  	default:
>  		break;
>  	}
>
