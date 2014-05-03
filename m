Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaECKKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 06:10:19 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51134 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaECKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 06:10:17 -0400
Message-ID: <5364C0E6.4020401@kernel.org>
Date: Sat, 03 May 2014 11:11:50 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iio: fix possible buffer overflow
References: <1399070450-23391-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1399070450-23391-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/14 23:40, Alexandre Belloni wrote:
> Found using smatch:
> drivers/iio/industrialio-core.c:719 iio_device_add_info_mask_type() error:
> buffer overflow 'iio_chan_info_postfix' 17 <= 63
>
> It was probably never hit because the info_mask_* members are filled by using
> the BIT() macro with values from the iio_chan_info_enum enum that also serve as
> the index of the iio_chan_info_postfix array.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
See
ef4b4856593fc3d9d169bededdaf7acf62f83a52
iio:core: Fix bug in length of event info_mask and catch unhandled bits set in masks.

Which fixes the same issue in a slightly different way.

Pretty recent patch though and this was there for ages before that.
Better to have two fixes than none.

Thanks,

J
> ---
>   drivers/iio/industrialio-core.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index ede16aec20fb..5e7a67e53879 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -715,7 +715,8 @@ static int iio_device_add_info_mask_type(struct iio_dev *indio_dev,
>   {
>   	int i, ret, attrcount = 0;
>
> -	for_each_set_bit(i, infomask, sizeof(infomask)*8) {
> +	for_each_set_bit(i, infomask, min(sizeof(infomask)*8,
> +					  ARRAY_SIZE(iio_chan_info_postfix))) {
>   		ret = __iio_add_chan_devattr(iio_chan_info_postfix[i],
>   					     chan,
>   					     &iio_read_channel_info,
>

