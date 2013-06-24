Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3FXMa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:30:26 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:37144 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3FXMaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:30:24 -0400
MIME-Version: 1.0
In-Reply-To: <51C5847C.7030100@kernel.org>
References: <CAP9ODKof+yv27-zHSO9MTLC9Wv6F6Ya-Ot-vW7OK7kwadYK8Xg@mail.gmail.com>
	<CAP9ODKq92LW-xQyiHkVe6AkwaaYV11nt92DxCEzUioEVARTZXw@mail.gmail.com>
	<51C5847C.7030100@kernel.org>
Date: Mon, 24 Jun 2013 09:30:23 -0300
X-Google-Sender-Auth: esEDssrZbrF62KLAszfTu5gh4Sg
Message-ID: <CAP9ODKohhQVTwj40K-h1LDAqjk6+nO1r=Fq404Xy1DUZWfwRxg@mail.gmail.com>
Subject: Re: Fwd: mxs-lradc oops when unloading module
From: Otavio Salvador <otavio@ossystems.com.br>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 8:03 AM, Jonathan Cameron <jic23@kernel.org> wrote:
>> From what I could grasp, it might be related to the IIO subsystem but
>> I couldn't find the culprit.
>>
>> It seems "iio_device_unregister_trigger_consumer", as:
>>
>> void iio_device_unregister_trigger_consumer(struct iio_dev *indio_dev)
>> {
>> /* Clean up an associated but not attached trigger reference */
>> if (indio_dev->trig)
>> iio_trigger_put(indio_dev->trig);
>> }
>>
>> and , as:
>>
>> static inline void iio_trigger_put(struct iio_trigger *trig)
>> {
>> module_put(trig->ops->owner);
>> put_device(&trig->dev);
>> }
>>
>> so, somehow the trig->ops is NULL here.
>>
>> Do someone has a clue?
>>
> I think the issue is more core to iio trigger handling than that, you
> have just been unlucky enough to hit a bug that has been there a while.
>
> In iio_trigger_unregister we call
> iio_device_unregister which in turn calls device_del (as intended) and
> device_put (as not!).  Then we get an additional device_put from
> iio_trigger_free giving us one more than we should have an resulting
> in a double attempt to free the device.
>
> Could you try the following change and see if it solves the problem?
> (the comment abov is 'interesting' and stupid given I've long ago
> forgotten what it refers to, but it could be related to this issue...)
>
> From 238faf76acaa9214b0eb607742dd14b134469328 Mon Sep 17 00:00:00 2001
> From: Jonathan Cameron <jic23@kernel.org>
> Date: Sat, 22 Jun 2013 12:00:04 +0100
> Subject: [PATCH] iio:trigger: device_unregister->device_del to avoid double
>  free
>
> iio_trigger unregistration and freeing has been separated in this
> code for some time, but it looks like the calls to the device
> handling were not appropriately updated.
>
> Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  drivers/iio/industrialio-trigger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
> index 4d6c7d8..ea8a414 100644
> --- a/drivers/iio/industrialio-trigger.c
> +++ b/drivers/iio/industrialio-trigger.c
> @@ -104,7 +104,7 @@ void iio_trigger_unregister(struct iio_trigger *trig_info)
>
>         ida_simple_remove(&iio_trigger_ida, trig_info->id);
>         /* Possible issue in here */
> -       device_unregister(&trig_info->dev);
> +       device_del(&trig_info->dev);
>  }
>  EXPORT_SYMBOL(iio_trigger_unregister);

Tested-by: Otavio Salvador <otavio@ossystems.com.br>

It does fix the Oops for me.

--
Otavio Salvador                             O.S. Systems
http://www.ossystems.com.br        http://projetos.ossystems.com.br
Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750
