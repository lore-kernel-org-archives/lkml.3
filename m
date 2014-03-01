Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaCANsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 08:48:43 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:11930 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaCANsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 08:48:42 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-fc-5311e5388476
Date: Sat, 01 Mar 2014 10:48:35 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [RFC] [PATCH 4/6] media: em28xx-input - implement em28xx_ops:
 suspend/resume hooks
Message-id: <20140301104835.631c65bb@samsung.com>
In-reply-to: <5dc00d657718dfefedb35b055abd13997afd6979.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
 <5dc00d657718dfefedb35b055abd13997afd6979.1393027856.git.shuah.kh@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/hEF2Lp4LBBgfXGVpc3jWHzaJnw1ZW
	iy+fuSy+/nRwYPHYOesuu0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlvH7ymbXghHDFo97V
	bA2MswS6GDk5JARMJJ7eX8cCYYtJXLi3nq2LkYtDSGAJo8SMQ9egnB4miektk9hAqlgEVCXm
	tRxmBbHZBIwkXjW2gNkiQPGWq4/BapgFQiRWrznGCGILCyRKbHp+HWwDr4ChxILj/5lAbE6B
	WIlHkx+wQCzoYJT42D4H6gwniVevJzNBNAhK/Jh8jwViqLrEpHmLmCFsbYkn7y6wTmAUmIWk
	bBaSsllIyhYwMq9iFC0tTi4oTkrPNdQrTswtLs1L10vOz93ECAnZoh2MzzZYHWIU4GBU4uGV
	WCQQLMSaWFZcmXuIUYKDWUmEN/OMYLAQb0piZVVqUX58UWlOavEhRiYOTqkGxj1PfLI5+i8y
	tTywZtx79Zji433i296arozX82i65yR8rTbhSN2Rq2Lyd6qP9clPNSqQ2pf8ZJZ0u8m9mvdq
	zr/b5TqfL/gV9vH6R7NFig0T1d0f8Hwp9GGoEfz7pyo4fOsqrTl/tj+z9n743C9O71HifzF/
	B9XZ6rPVDmwR/czU3PzgCq/JSyWW4oxEQy3mouJEAI4Lfj43AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 21 Feb 2014 17:50:16 -0700
Shuah Khan <shuah.kh@samsung.com> escreveu:

> Implement em28xx_ops: suspend/resume hooks. em28xx usb driver will
> invoke em28xx_ops: suspend and resume hooks for all its extensions
> from its suspend() and resume() interfaces.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-input.c | 35 +++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 18f65d8..1227309 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -827,11 +827,46 @@ static int em28xx_ir_fini(struct em28xx *dev)
>  	return 0;
>  }
>  
> +static int em28xx_ir_suspend(struct em28xx *dev)
> +{
> +	struct em28xx_IR *ir = dev->ir;
> +
> +	if (dev->is_audio_only)
> +		return 0;
> +
> +	em28xx_info("Suspending input extension");
> +	cancel_delayed_work_sync(&ir->work);
> +	cancel_delayed_work_sync(&dev->buttons_query_work);
> +	/* is canceling delayed work sufficient or does the rc event
> +	   kthread needs stopping? kthread is stopped in
> +	   ir_raw_event_unregister() */
> +	return 0;
> +}
> +
> +static int em28xx_ir_resume(struct em28xx *dev)
> +{
> +	struct em28xx_IR *ir = dev->ir;
> +
> +	if (dev->is_audio_only)
> +		return 0;
> +
> +	em28xx_info("Resuming input extension");
> +	/* if suspend calls ir_raw_event_unregister(), the should call
> +	   ir_raw_event_register() */
> +	schedule_delayed_work_sync(&ir->work);

This causes a compilation breakage:

drivers/media/usb/em28xx/em28xx-input.c: In function ‘em28xx_ir_resume’:
drivers/media/usb/em28xx/em28xx-input.c:856:2: error: implicit declaration of function ‘schedule_delayed_work_sync’ [-Werror=implicit-function-declaration]
  schedule_delayed_work_sync(&ir->work);


> +	if (dev->num_button_polling_addresses)
> +		schedule_delayed_work(&dev->buttons_query_work,
> +			       msecs_to_jiffies(dev->button_polling_interval));
> +	return 0;
> +}
> +
>  static struct em28xx_ops rc_ops = {
>  	.id   = EM28XX_RC,
>  	.name = "Em28xx Input Extension",
>  	.init = em28xx_ir_init,
>  	.fini = em28xx_ir_fini,
> +	.suspend = em28xx_ir_suspend,
> +	.resume = em28xx_ir_resume,
>  };
>  
>  static int __init em28xx_rc_register(void)


-- 

Cheers,
Mauro
