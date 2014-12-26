Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaLZLfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 06:35:37 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44804 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaLZLfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 06:35:33 -0500
Message-ID: <549D4800.1040904@kernel.org>
Date: Fri, 26 Dec 2014 11:35:28 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v2 1/3] iio: kfifo: Remove unused argument in iio_kfifo_allocate
References: <1419010766-13557-1-git-send-email-k.wrona@samsung.com> <1419010766-13557-2-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1419010766-13557-2-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 17:39, Karol Wrona wrote:
> indio_dev was unused in function body plus some small style fix - add new
> lines after "if(sth) return sth" and before the last return statement.
> 
> The argument was removed also in its client.
> 
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Good cleanup - some fuzz applying and required a bit of hand editting
in kfifo_buf.c for reasons I couldn't immediately spot.  Please sanity
check I haven't messed anything up.

Thanks,

Jonathan
> ---
>  drivers/iio/adc/ti_am335x_adc.c                 |    2 +-
>  drivers/iio/industrialio-triggered-buffer.c     |    2 +-
>  drivers/iio/kfifo_buf.c                         |    6 ++++--
>  drivers/staging/iio/accel/lis3l02dq_ring.c      |    2 +-
>  drivers/staging/iio/iio_simple_dummy_buffer.c   |    2 +-
>  drivers/staging/iio/impedance-analyzer/ad5933.c |    2 +-
>  drivers/staging/iio/meter/ade7758_ring.c        |    2 +-
>  include/linux/iio/kfifo_buf.h                   |    2 +-
>  8 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index b730864..bf87993 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -250,7 +250,7 @@ static int tiadc_iio_buffered_hardware_setup(struct iio_dev *indio_dev,
>  	struct iio_buffer *buffer;
>  	int ret;
>  
> -	buffer = iio_kfifo_allocate(indio_dev);
> +	buffer = iio_kfifo_allocate();
>  	if (!buffer)
>  		return -ENOMEM;
>  
> diff --git a/drivers/iio/industrialio-triggered-buffer.c b/drivers/iio/industrialio-triggered-buffer.c
> index d6f54930..6c6307a 100644
> --- a/drivers/iio/industrialio-triggered-buffer.c
> +++ b/drivers/iio/industrialio-triggered-buffer.c
> @@ -49,7 +49,7 @@ int iio_triggered_buffer_setup(struct iio_dev *indio_dev,
>  	struct iio_buffer *buffer;
>  	int ret;
>  
> -	buffer = iio_kfifo_allocate(indio_dev);
> +	buffer = iio_kfifo_allocate();
>  	if (!buffer) {
>  		ret = -ENOMEM;
>  		goto error_ret;
> diff --git a/drivers/iio/kfifo_buf.c b/drivers/iio/kfifo_buf.c
> index 7134e8a..a383291 100644
> --- a/drivers/iio/kfifo_buf.c
> +++ b/drivers/iio/kfifo_buf.c
> @@ -166,19 +166,21 @@ static const struct iio_buffer_access_funcs kfifo_access_funcs = {
>  	.release = &iio_kfifo_buffer_release,
>  };
>  
> -struct iio_buffer *iio_kfifo_allocate(struct iio_dev *indio_dev)
> +struct iio_buffer *iio_kfifo_allocate(void)
>  {
>  	struct iio_kfifo *kf;
>  
> -	kf = kzalloc(sizeof *kf, GFP_KERNEL);
> +	kf = kzalloc(sizeof(*kf), GFP_KERNEL);
>  	if (!kf)
>  		return NULL;
> +
>  	kf->update_needed = true;
>  	iio_buffer_init(&kf->buffer);
>  	kf->buffer.attrs = &iio_kfifo_attribute_group;
>  	kf->buffer.access = &kfifo_access_funcs;
>  	kf->buffer.length = 2;
>  	mutex_init(&kf->user_lock);
> +
>  	return &kf->buffer;
>  }
>  EXPORT_SYMBOL(iio_kfifo_allocate);
> diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
> index 9efc77b..1fd9009 100644
> --- a/drivers/staging/iio/accel/lis3l02dq_ring.c
> +++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
> @@ -393,7 +393,7 @@ int lis3l02dq_configure_buffer(struct iio_dev *indio_dev)
>  	int ret;
>  	struct iio_buffer *buffer;
>  
> -	buffer = iio_kfifo_allocate(indio_dev);
> +	buffer = iio_kfifo_allocate();
>  	if (!buffer)
>  		return -ENOMEM;
>  
> diff --git a/drivers/staging/iio/iio_simple_dummy_buffer.c b/drivers/staging/iio/iio_simple_dummy_buffer.c
> index fd74f91..df765c9 100644
> --- a/drivers/staging/iio/iio_simple_dummy_buffer.c
> +++ b/drivers/staging/iio/iio_simple_dummy_buffer.c
> @@ -122,7 +122,7 @@ int iio_simple_dummy_configure_buffer(struct iio_dev *indio_dev,
>  	struct iio_buffer *buffer;
>  
>  	/* Allocate a buffer to use - here a kfifo */
> -	buffer = iio_kfifo_allocate(indio_dev);
> +	buffer = iio_kfifo_allocate();
>  	if (buffer == NULL) {
>  		ret = -ENOMEM;
>  		goto error_ret;
> diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
> index b6bd609..ace9ef8 100644
> --- a/drivers/staging/iio/impedance-analyzer/ad5933.c
> +++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
> @@ -626,7 +626,7 @@ static int ad5933_register_ring_funcs_and_init(struct iio_dev *indio_dev)
>  {
>  	struct iio_buffer *buffer;
>  
> -	buffer = iio_kfifo_allocate(indio_dev);
> +	buffer = iio_kfifo_allocate();
>  	if (!buffer)
>  		return -ENOMEM;
>  
> diff --git a/drivers/staging/iio/meter/ade7758_ring.c b/drivers/staging/iio/meter/ade7758_ring.c
> index 6e90064..31d2cf3 100644
> --- a/drivers/staging/iio/meter/ade7758_ring.c
> +++ b/drivers/staging/iio/meter/ade7758_ring.c
> @@ -118,7 +118,7 @@ int ade7758_configure_ring(struct iio_dev *indio_dev)
>  	struct iio_buffer *buffer;
>  	int ret = 0;
>  
> -	buffer = iio_kfifo_allocate(indio_dev);
> +	buffer = iio_kfifo_allocate();
>  	if (!buffer) {
>  		ret = -ENOMEM;
>  		return ret;
> diff --git a/include/linux/iio/kfifo_buf.h b/include/linux/iio/kfifo_buf.h
> index 25eeac7..1a8d57a 100644
> --- a/include/linux/iio/kfifo_buf.h
> +++ b/include/linux/iio/kfifo_buf.h
> @@ -5,7 +5,7 @@
>  #include <linux/iio/iio.h>
>  #include <linux/iio/buffer.h>
>  
> -struct iio_buffer *iio_kfifo_allocate(struct iio_dev *indio_dev);
> +struct iio_buffer *iio_kfifo_allocate(void);
>  void iio_kfifo_free(struct iio_buffer *r);
>  
>  #endif
> 

