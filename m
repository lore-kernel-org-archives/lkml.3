Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaKVLUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 06:20:47 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40107 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaKVLUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 06:20:45 -0500
Message-ID: <5470718B.90608@kernel.org>
Date: Sat, 22 Nov 2014 11:20:43 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, knaack.h@gmx.de
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com, daniel.baluta@inte.com
Subject: Re: [PATCH v4 7/7] iio: event_monitor: Add support for new channel
 types
References: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com> <1415623535-24337-8-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1415623535-24337-8-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/14 12:45, Daniel Baluta wrote:
> We have the following testing scenario:
> 
> $ insmod iio_dummy_evgen.ko
> $ insmod iio_dummy.ko
> 
> ./iio_event_monitor /dev/iio:device0
> Event: time: 1412786467971335337, type: activity(running), channel: 0,
> evtype: thresh, direction: rising
> Event: time: 1412786530792974091, type: activity(walking), channel: 0,
> evtype: thresh, direction: falling
> Event: time: 1412764319184761765, type: steps, channel: 0, evtype: instance
> 
> $ echo 1 > /sys/bus/iio/devices/iio_evgen/poke_ev0
> $ echo 2 > /sys/bus/iio/devices/iio_evgen/poke_ev0
> $ echo 3 > /sys/bus/iio/devices/iio_evgen/poke_ev0
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Good description and a good patch.  Nice series all in all - I like
the approach of adding ABI with dummy driver and tool support before
the hardware driver comes along.  Not quite the same from working out
how things will be used in anger, but still a clean way to work.

All applied to the togreg branch of iio.git - pushed out as testing - in
this case for the autobuilders to completely ignore the patch...

Thanks,

Jonathan
> ---
>  .../staging/iio/Documentation/iio_event_monitor.c  | 23 +++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
> index 940ed23..def236a 100644
> --- a/drivers/staging/iio/Documentation/iio_event_monitor.c
> +++ b/drivers/staging/iio/Documentation/iio_event_monitor.c
> @@ -49,6 +49,8 @@ static const char * const iio_chan_type_name_spec[] = {
>  	[IIO_CCT] = "cct",
>  	[IIO_PRESSURE] = "pressure",
>  	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
> +	[IIO_ACTIVITY] = "activity",
> +	[IIO_STEPS] = "steps",
>  };
>  
>  static const char * const iio_ev_type_text[] = {
> @@ -57,6 +59,7 @@ static const char * const iio_ev_type_text[] = {
>  	[IIO_EV_TYPE_ROC] = "roc",
>  	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
>  	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
> +	[IIO_EV_TYPE_INSTANCE] = "instance",
>  };
>  
>  static const char * const iio_ev_dir_text[] = {
> @@ -92,6 +95,10 @@ static const char * const iio_modifier_names[] = {
>  	[IIO_MOD_NORTH_TRUE] = "from_north_true",
>  	[IIO_MOD_NORTH_MAGN_TILT_COMP] = "from_north_magnetic_tilt_comp",
>  	[IIO_MOD_NORTH_TRUE_TILT_COMP] = "from_north_true_tilt_comp",
> +	[IIO_MOD_RUNNING] = "running",
> +	[IIO_MOD_JOGGING] = "jogging",
> +	[IIO_MOD_WALKING] = "walking",
> +	[IIO_MOD_STILL] = "still",
>  };
>  
>  static bool event_is_known(struct iio_event_data *event)
> @@ -121,6 +128,8 @@ static bool event_is_known(struct iio_event_data *event)
>  	case IIO_CCT:
>  	case IIO_PRESSURE:
>  	case IIO_HUMIDITYRELATIVE:
> +	case IIO_ACTIVITY:
> +	case IIO_STEPS:
>  		break;
>  	default:
>  		return false;
> @@ -154,6 +163,10 @@ static bool event_is_known(struct iio_event_data *event)
>  	case IIO_MOD_NORTH_TRUE:
>  	case IIO_MOD_NORTH_MAGN_TILT_COMP:
>  	case IIO_MOD_NORTH_TRUE_TILT_COMP:
> +	case IIO_MOD_RUNNING:
> +	case IIO_MOD_JOGGING:
> +	case IIO_MOD_WALKING:
> +	case IIO_MOD_STILL:
>  		break;
>  	default:
>  		return false;
> @@ -165,6 +178,7 @@ static bool event_is_known(struct iio_event_data *event)
>  	case IIO_EV_TYPE_ROC:
>  	case IIO_EV_TYPE_THRESH_ADAPTIVE:
>  	case IIO_EV_TYPE_MAG_ADAPTIVE:
> +	case IIO_EV_TYPE_INSTANCE:
>  		break;
>  	default:
>  		return false;
> @@ -174,6 +188,7 @@ static bool event_is_known(struct iio_event_data *event)
>  	case IIO_EV_DIR_EITHER:
>  	case IIO_EV_DIR_RISING:
>  	case IIO_EV_DIR_FALLING:
> +	case IIO_EV_DIR_NONE:
>  		break;
>  	default:
>  		return false;
> @@ -214,9 +229,11 @@ static void print_event(struct iio_event_data *event)
>  	else if (chan >= 0)
>  		printf("channel: %d, ", chan);
>  
> -	printf("evtype: %s, direction: %s\n",
> -		iio_ev_type_text[ev_type],
> -		iio_ev_dir_text[dir]);
> +	printf("evtype: %s", iio_ev_type_text[ev_type]);
> +
> +	if (dir != IIO_EV_DIR_NONE)
> +		printf(", direction: %s", iio_ev_dir_text[dir]);
> +	printf("\n");
>  }
>  
>  int main(int argc, char **argv)
> 

