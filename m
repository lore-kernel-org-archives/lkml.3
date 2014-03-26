Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaCZSwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:52:19 -0400
Received: from xes-mad.com ([216.165.139.218]:33314 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaCZSwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:52:18 -0400
Date: Wed, 26 Mar 2014 13:51:53 -0500 (CDT)
From: Aaron Sierra <asierra@xes-inc.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: martyn welch <martyn.welch@ge.com>,
        manohar vanga <manohar.vanga@gmail.com>, gregkh@linuxfoundation.org,
        lisa@xenapiadmin.com, yongjun wei <yongjun_wei@trendmicro.com.cn>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Message-ID: <1455668003.49319.1395859913516.JavaMail.zimbra@xes-inc.com>
In-Reply-To: <3217679.sqG7Yrhs8H@daeseok-laptop.cloud.net>
References: <3217679.sqG7Yrhs8H@daeseok-laptop.cloud.net>
Subject: Re: [PATCH] staging: vme: fix memory leak in vme_user_probe()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.16.65]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC33 (Linux)/8.0.6_GA_5922)
Thread-Topic: staging: vme: fix memory leak in vme_user_probe()
Thread-Index: QnzfrNYSnTVLCXn7aQgr1aM9hsBwKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Daeseok Youn" <daeseok.youn@gmail.com>
> Sent: Tuesday, March 25, 2014 10:01:48 PM
> Subject: [PATCH] staging: vme: fix memory leak in vme_user_probe()
> 
> 
> If vme_master_request() returns NULL when it failed,
> it need to free buffers for master.
> 
> And also removes unreachable code in vme_user_probe().
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/vme/devices/vme_user.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)

Nice catches Daeseok. I don't maintain this driver, but I have some
suggestions below.

> 
> diff --git a/drivers/staging/vme/devices/vme_user.c
> b/drivers/staging/vme/devices/vme_user.c
> index 7927927..ffb4eee 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -776,7 +776,8 @@ static int vme_user_probe(struct vme_dev *vdev)
>  		image[i].kern_buf = kmalloc(image[i].size_buf, GFP_KERNEL);
>  		if (image[i].kern_buf == NULL) {
>  			err = -ENOMEM;
> -			goto err_master_buf;
> +			vme_master_free(image[i].resource);
> +			goto err_master;
>  		}
>  	}

I think it would be nice to keep all of the cleanup under the err_master
label.

That could be done by changing the kern_buf allocation in this part to
a devm_kmalloc. Then devm handles the kern_buf freeing entirely.

>  
> @@ -819,8 +820,6 @@ static int vme_user_probe(struct vme_dev *vdev)
>  
>  	return 0;
>  
> -	/* Ensure counter set correcty to destroy all sysfs devices */
> -	i = VME_DEVS;
>  err_sysfs:
>  	while (i > 0) {
>  		i--;
> @@ -830,12 +829,10 @@ err_sysfs:
>  
>  	/* Ensure counter set correcty to unalloc all master windows */
>  	i = MASTER_MAX + 1;
> -err_master_buf:
> -	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++)
> -		kfree(image[i].kern_buf);
>  err_master:
>  	while (i > MASTER_MINOR) {
>  		i--;
> +		kfree(image[i].kern_buf);
>  		vme_master_free(image[i].resource);
>  	}

Using devm_kmalloc as mentioned above, the while loop could be
simplified to this:

err_master:
	while (i >= MASTER_MINOR) {
 		vme_master_free(image[i].resource);
		i--;
	}

If not moving to devm, this should be safe even though the first
kern_buf may be NULL:

err_master:
	while (i >= MASTER_MINOR) {
		kfree(image[i].kern_buf);
 		vme_master_free(image[i].resource);
		i--;
	}

-Aaron

>  
> --
> 1.7.4.4
> 
> 
> 
