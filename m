Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaHLLhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:37:06 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8773 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaHLLg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:36:59 -0400
X-AuditID: cbfec373-b7f9d6d00000479f-e9-53e9fc596c0a
Date: Tue, 12 Aug 2014 08:36:51 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: ttmesterr@gmail.com, dheitmueller@kernellabs.com, cb.xiong@samsung.com,
        yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix au0828 dvb suspend/resume to call
 dvb_frontend_suspend/resume
Message-id: <20140812083651.3cfb079d.m.chehab@samsung.com>
In-reply-to: <1407813235-30435-1-git-send-email-shuah.kh@samsung.com>
References: <1407813235-30435-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/hEN3IPy+DDc5fV7Y4fvcAk8Wt3atZ
	LC7vmsNm0bNhK6vFl89cFm+fP2G12Lmuk92B3WPnrLvsHnOP9TJ69G1Zxeix9N5RRo/Pm+QC
	WKO4bFJSczLLUov07RK4Mv6eu8lScEG64sGB9AbGFWJdjJwcEgImEvOfdDFB2GISF+6tZ+ti
	5OIQEljCKDGhezYzhNPMJPHq3VvGLkYODhYBVYnN6+pAGtgEjCReNbawgtgiQOGWq4/BmpkF
	VjBKXN36EiwhLBAvsWJPCxuIzStgJfF76kwWEJtTwFViweJ/YJuFBFwkZh7fxQpxhbPEz5mT
	GCHqBSV+TL4HVs8soCWxeVsTK4QtL7F5zVvmCYwCs5CUzUJSNgtJ2QJG5lWMoqXFyQXFSem5
	RnrFibnFpXnpesn5uZsYISFevIPxxQarQ4wCHIxKPLwz/r4IFmJNLCuuzD3EKMHBrCTCK3j7
	ZbAQb0piZVVqUX58UWlOavEhRiYOTqkGxrV8dnFZs2/33VEJuhd1+szTWxUrBN994nqQnJBo
	9k54rult398LtCtPCfY2njjTefBH8yJ2t6nruu5+EZ30bc+NcIdF9z/aRP+KX/pRa5Zv6r0Z
	Lx552ps8+cRvsFWgqUVgf9mlqpd2WY47d5bz//vrvZQjIMqX4Xj9v48mWbEf1fjZTjbEqCqx
	FGckGmoxFxUnAgDJo/r0TwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

Em Mon, 11 Aug 2014 21:13:55 -0600
Shuah Khan <shuah.kh@samsung.com> escreveu:

> au0828 doesn't resume correctly and TV tuning fails with
> xc_set_signal_source(0) failed message. Change au0828 dvb
> suspend and resume interfaces to suspend and resume frontend
> during suspend and resume respectively. au0828_dvb_suspend()
> calls dvb_frontend_suspend() which in turn invokes tuner ops
> sleep followed by fe ops sleep. au0828_dvb_resume() calls
> dvb_frontend_resume() which in turn calls fe ops ini follwed
> by tuner ops ini before waking up the frontend. With this change
> HVR950Q suspend and resume work when system gets suspended when
> digital function is tuned to a channel and with active TV stream,
> and after resume it went right back to active TV stream.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-dvb.c |   37 ++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> index 821f86e..50e7c82 100644
> --- a/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/drivers/media/usb/au0828/au0828-dvb.c
> @@ -619,35 +619,30 @@ int au0828_dvb_register(struct au0828_dev *dev)
>  
>  void au0828_dvb_suspend(struct au0828_dev *dev)
>  {
> -	struct au0828_dvb *dvb = &dev->dvb;
> -
> -	if (dvb->frontend && dev->urb_streaming) {
> -		pr_info("stopping DVB\n");
> +	struct au0828_dvb *dvb;
> +	int rc;
>  
> -		cancel_work_sync(&dev->restart_streaming);

The restart streaming delayed work still needs to be canceled if
active. This work can be active while DVB is streaming, to workaround
on a chipset bug.

The best is to first call cancel the pending URBs and stop_urb_transfer(),
in order to avoid race conditions.

> +	if (dev == NULL)
> +		return;

In this specific device driver, I think that this condition will never
happen:

	$ git grep "dev = NULL" drivers/media/usb/au0828/au0828*
	drivers/media/usb/au0828/au0828-core.c: dev->usbdev = NULL;

>  
> -		/* Stop transport */
> -		mutex_lock(&dvb->lock);
> -		stop_urb_transfer(dev);

My understanding is that we still need to cancel the pending URBs before
suspending, in order to stop the DMA engine.

> -		au0828_stop_transport(dev, 1);
> -		mutex_unlock(&dvb->lock);
> -		dev->need_urb_start = 1;
> +	dvb = &dev->dvb;
> +	if (dvb->frontend) {
> +		rc = dvb_frontend_suspend(dvb->frontend);
> +		pr_info("au0828_dvb_suspend(): Suspending DVB fe %d\n", rc);
>  	}
>  }
>  
>  void au0828_dvb_resume(struct au0828_dev *dev)
>  {
> -	struct au0828_dvb *dvb = &dev->dvb;
> -
> -	if (dvb->frontend && dev->need_urb_start) {
> -		pr_info("resuming DVB\n");
> +	struct au0828_dvb *dvb;
> +	int rc;
>  
> -		au0828_set_frontend(dvb->frontend);
> +	if (dev == NULL)
> +		return;
>  
> -		/* Start transport */
> -		mutex_lock(&dvb->lock);
> -		au0828_start_transport(dev);
> -		start_urb_transfer(dev);
> -		mutex_unlock(&dvb->lock);

As we need to stop pending URB transfers and stop the DMA engine,
we still need the above code. We don't need to restart a pending
work, because what the pending work would be doing is to stop and
restart the transfer, and the suspend/resume code should do it already.

> +	dvb = &dev->dvb;
> +	if (dvb->frontend) {
> +		rc = dvb_frontend_resume(dvb->frontend);
> +		pr_info("au0828_dvb_resume(): Resuming DVB fe %d\n", rc);
>  	}
>  }

Regards,
Mauro
