Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbbAYXDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 18:03:23 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51066 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbAYXDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 18:03:20 -0500
Message-ID: <54C57636.10500@kernel.org>
Date: Sun, 25 Jan 2015 23:03:18 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2 05/10] iio: core: Introduce CHANGE event type
References: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com> <1421003416-27557-6-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1421003416-27557-6-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/15 19:10, Irina Tirdea wrote:
> A step detector will generate an interrupt each time N step are detected.
> A device that has such pedometer functionality is Freescale's MMA9553L:
> http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf.
> 
> Introduce IIO_EV_TYPE_CHANGE event type for events that are generated
> when the channel passes a threshold on the absolute change in value.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Applied.
> ---
>  Documentation/ABI/testing/sysfs-bus-iio              | 20 ++++++++++++++++----
>  drivers/iio/industrialio-event.c                     |  1 +
>  .../staging/iio/Documentation/iio_event_monitor.c    |  2 ++
>  include/linux/iio/types.h                            |  1 +
>  4 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 71dc8db..c03a140 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -891,12 +891,24 @@ Description:
>  		number or direction is not specified, applies to all channels of
>  		this type.
>  
> -What:		/sys/.../events/in_steps_instance_en
> -KernelVersion:	3.19
> +What:		/sys/.../events/in_steps_change_en
> +KernelVersion:	3.20
>  Contact:	linux-iio@vger.kernel.org
>  Description:
> -		Enables or disables step detection. Each time the user takes a step an
> -		event of this type will be generated.
> +		Event generated when channel passes a threshold on the absolute
> +		change in value. E.g. for steps: a step change event is
> +		generated each time the user takes N steps, where N is set using
> +		in_steps_change_value.
> +
> +What:		/sys/.../events/in_steps_change_value
> +KernelVersion:	3.20
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Specifies the value of change threshold that the
> +		device is comparing against for the events enabled by
> +		<type>[Y][_name]_roc[_rising|falling|]_en. E.g. for steps:
> +		if set to 3, a step change event will be generated every 3
> +		steps.
>  
>  What:		/sys/bus/iio/devices/iio:deviceX/trigger/current_trigger
>  KernelVersion:	2.6.35
> diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
> index 3f5cee0..08c4a4c 100644
> --- a/drivers/iio/industrialio-event.c
> +++ b/drivers/iio/industrialio-event.c
> @@ -198,6 +198,7 @@ static const char * const iio_ev_type_text[] = {
>  	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
>  	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
>  	[IIO_EV_TYPE_INSTANCE] = "instance",
> +	[IIO_EV_TYPE_CHANGE] = "change",
>  };
>  
>  static const char * const iio_ev_dir_text[] = {
> diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
> index def236a..2e78d58 100644
> --- a/drivers/staging/iio/Documentation/iio_event_monitor.c
> +++ b/drivers/staging/iio/Documentation/iio_event_monitor.c
> @@ -60,6 +60,7 @@ static const char * const iio_ev_type_text[] = {
>  	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
>  	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
>  	[IIO_EV_TYPE_INSTANCE] = "instance",
> +	[IIO_EV_TYPE_CHANGE] = "change",
>  };
>  
>  static const char * const iio_ev_dir_text[] = {
> @@ -179,6 +180,7 @@ static bool event_is_known(struct iio_event_data *event)
>  	case IIO_EV_TYPE_THRESH_ADAPTIVE:
>  	case IIO_EV_TYPE_MAG_ADAPTIVE:
>  	case IIO_EV_TYPE_INSTANCE:
> +	case IIO_EV_TYPE_CHANGE:
>  		break;
>  	default:
>  		return false;
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index c3601c2..3ba3d66 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -79,6 +79,7 @@ enum iio_event_type {
>  	IIO_EV_TYPE_THRESH_ADAPTIVE,
>  	IIO_EV_TYPE_MAG_ADAPTIVE,
>  	IIO_EV_TYPE_INSTANCE,
> +	IIO_EV_TYPE_CHANGE,
>  };
>  
>  enum iio_event_info {
> 

