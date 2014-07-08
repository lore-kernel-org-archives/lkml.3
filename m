Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaGHJHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:07:45 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:51914
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753443AbaGHJHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:07:41 -0400
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Topic: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Index: AQHPkX4w9bmiR/mw30qA8kPuB/vMKpuV8/9w
Date: Tue, 8 Jul 2014 09:06:47 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9875854@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1403818501-15547-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1403818501-15547-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.83]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(377454003)(189002)(51704005)(199002)(13464003)(31966008)(76176999)(26826002)(106466001)(15202345003)(80022001)(20776003)(64706001)(47776003)(74662001)(46406003)(50466002)(54356999)(16796002)(50986999)(86362001)(2201001)(81342001)(74502001)(85806002)(87936001)(99396002)(86612001)(85852003)(92726001)(55846006)(81156004)(95666004)(107046002)(83322001)(46102001)(83072002)(97756001)(85306003)(23726002)(2656002)(77096002)(19580405001)(69596002)(76482001)(4396001)(79102001)(84676001)(97736001)(81542001)(33656002)(92566001)(6806004)(15975445006)(21056001)(44976005)(19580395003)(68736004)(77982001)(106116001);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB1178;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0266491E90
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: driverdev-devel-bounces@linuxdriverproject.org [mailto:driverdev-
> devel-bounces@linuxdriverproject.org] On Behalf Of Dexuan Cui
> Sent: Friday, June 27, 2014 5:35 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; plagnioj@jcrosoft.com;
> tomi.valkeinen@ti.com; linux-fbdev@vger.kernel.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Cc: Haiyang Zhang
> Subject: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by force
> on VM panic
> 
> Currently the VSC has no chance to notify the VSP of the dirty rectangle on
> VM
> panic because the notification work is done in a workqueue, and in panic()
> the
> kernel typically ends up in an infinite loop, and a typical kernel config has
> CONFIG_PREEMPT_VOLUNTARY=y and CONFIG_PREEMPT is not set, so a
> context switch
> can't happen in panic() and the workqueue won't have a chance to run. As a
> result, the VM Connection window can't refresh until it's closed and we
> re-connect to the VM.
> 
> We can register a handler on panic_notifier_list: the handler can notify
> the VSC and switch the framebuffer driver to a "synchronous mode",
> meaning
> the VSC flushes any future framebuffer change to the VSP immediately.
> 
> v2: removed the MS-TFS line in the commit message
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Hi Greg, Tomi, Jean and all,
Any new comment for the patch?

Thanks,
-- Dexuan

> ---
>  drivers/video/fbdev/hyperv_fb.c | 58
> ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/fbdev/hyperv_fb.c
> b/drivers/video/fbdev/hyperv_fb.c
> index e23392e..291d171 100644
> --- a/drivers/video/fbdev/hyperv_fb.c
> +++ b/drivers/video/fbdev/hyperv_fb.c
> @@ -226,11 +226,16 @@ struct hvfb_par {
>  	u8 recv_buf[MAX_VMBUS_PKT_SIZE];
>  };
> 
> +static struct fb_info *hvfb_info;
> +
>  static uint screen_width = HVFB_WIDTH;
>  static uint screen_height = HVFB_HEIGHT;
>  static uint screen_depth;
>  static uint screen_fb_size;
> 
> +/* If true, the VSC notifies the VSP on every framebuffer change */
> +static bool synchronous_fb;
> +
>  /* Send message to Hyper-V host */
>  static inline int synthvid_send(struct hv_device *hdev,
>  				struct synthvid_msg *msg)
> @@ -532,6 +537,20 @@ static void hvfb_update_work(struct work_struct *w)
>  		schedule_delayed_work(&par->dwork,
> HVFB_UPDATE_DELAY);
>  }
> 
> +static int hvfb_on_panic(struct notifier_block *nb,
> +			unsigned long e, void *p)
> +{
> +	if (hvfb_info)
> +		synthvid_update(hvfb_info);
> +
> +	synchronous_fb = true;
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block hvfb_panic_nb = {
> +	.notifier_call = hvfb_on_panic,
> +};
> 
>  /* Framebuffer operation handlers */
> 
> @@ -582,14 +601,41 @@ static int hvfb_blank(int blank, struct fb_info *info)
>  	return 1;	/* get fb_blank to set the colormap to all black */
>  }
> 
> +static void hvfb_cfb_fillrect(struct fb_info *p,
> +				const struct fb_fillrect *rect)
> +{
> +	cfb_fillrect(p, rect);
> +
> +	if (unlikely(synchronous_fb))
> +		synthvid_update(p);
> +}
> +
> +static void hvfb_cfb_copyarea(struct fb_info *p,
> +				const struct fb_copyarea *area)
> +{
> +	cfb_copyarea(p, area);
> +
> +	if (unlikely(synchronous_fb))
> +		synthvid_update(p);
> +}
> +
> +static void hvfb_cfb_imageblit(struct fb_info *p,
> +				const struct fb_image *image)
> +{
> +	cfb_imageblit(p, image);
> +
> +	if (unlikely(synchronous_fb))
> +		synthvid_update(p);
> +}
> +
>  static struct fb_ops hvfb_ops = {
>  	.owner = THIS_MODULE,
>  	.fb_check_var = hvfb_check_var,
>  	.fb_set_par = hvfb_set_par,
>  	.fb_setcolreg = hvfb_setcolreg,
> -	.fb_fillrect = cfb_fillrect,
> -	.fb_copyarea = cfb_copyarea,
> -	.fb_imageblit = cfb_imageblit,
> +	.fb_fillrect = hvfb_cfb_fillrect,
> +	.fb_copyarea = hvfb_cfb_copyarea,
> +	.fb_imageblit = hvfb_cfb_imageblit,
>  	.fb_blank = hvfb_blank,
>  };
> 
> @@ -801,6 +847,9 @@ static int hvfb_probe(struct hv_device *hdev,
> 
>  	par->fb_ready = true;
> 
> +	hvfb_info = info;
> +	atomic_notifier_chain_register(&panic_notifier_list,
> &hvfb_panic_nb);
> +
>  	return 0;
> 
>  error:
> @@ -820,6 +869,9 @@ static int hvfb_remove(struct hv_device *hdev)
>  	struct fb_info *info = hv_get_drvdata(hdev);
>  	struct hvfb_par *par = info->par;
> 
> +	atomic_notifier_chain_unregister(&panic_notifier_list,
> &hvfb_panic_nb);
> +	hvfb_info = NULL;
> +
>  	par->update = false;
>  	par->fb_ready = false;
> 
> --
> 1.9.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
