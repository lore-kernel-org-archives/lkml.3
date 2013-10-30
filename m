Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3J3DY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:24:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22852 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab3J3DYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:24:55 -0400
X-IronPort-AV: E=Sophos;i="4.93,597,1378828800"; 
   d="scan'208";a="8895654"
Message-ID: <52707A97.5080203@cn.fujitsu.com>
Date: Wed, 30 Oct 2013 11:18:47 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, guz.fnst@cn.fujitsu.com
Subject: Re: [RFC PATCH RESEND] fb: reorder the lock sequence to fix a potential
 lockdep
References: <526DFDA8.7010806@cn.fujitsu.com>
In-Reply-To: <526DFDA8.7010806@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/30 11:23:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/30 11:23:08,
	Serialize complete at 2013/10/30 11:23:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi, Jean,
How about this patch?

Thanks,
Gu


On 10/28/2013 02:01 PM, Gu Zheng wrote:

> Following commits:
> 50e244cc79 fb: rework locking to fix lock ordering on takeover
> e93a9a8687 fb: Yet another band-aid for fixing lockdep mess
> 054430e773 fbcon: fix locking harder
> 
> reworked locking to fix related lock ordering on takeover, and introduced console_lock
> into fbmem, but it seems that the new lock sequence(fb_info->lock ---> console_lock)
> is against with the one in console_callback(console_lock ---> fb_info->lock), and leads to
> a potential deadlock as following:
> [  601.079000] ======================================================
> [  601.079000] [ INFO: possible circular locking dependency detected ]
> [  601.079000] 3.11.0 #189 Not tainted
> [  601.079000] -------------------------------------------------------
> [  601.079000] kworker/0:3/619 is trying to acquire lock:
> [  601.079000]  (&fb_info->lock){+.+.+.}, at: [<ffffffff81397566>] lock_fb_info+0x26/0x60
> [  601.079000]
> but task is already holding lock:
> [  601.079000]  (console_lock){+.+.+.}, at: [<ffffffff8141aae3>] console_callback+0x13/0x160
> [  601.079000]
> which lock already depends on the new lock.
> 
> [  601.079000]
> the existing dependency chain (in reverse order) is:
> [  601.079000]
> -> #1 (console_lock){+.+.+.}:
> [  601.079000]        [<ffffffff810dc971>] lock_acquire+0xa1/0x140
> [  601.079000]        [<ffffffff810c6267>] console_lock+0x77/0x80
> [  601.079000]        [<ffffffff81399448>] register_framebuffer+0x1d8/0x320
> [  601.079000]        [<ffffffff81cfb4c8>] efifb_probe+0x408/0x48f
> [  601.079000]        [<ffffffff8144a963>] platform_drv_probe+0x43/0x80
> [  601.079000]        [<ffffffff8144853b>] driver_probe_device+0x8b/0x390
> [  601.079000]        [<ffffffff814488eb>] __driver_attach+0xab/0xb0
> [  601.079000]        [<ffffffff814463bd>] bus_for_each_dev+0x5d/0xa0
> [  601.079000]        [<ffffffff81447e6e>] driver_attach+0x1e/0x20
> [  601.079000]        [<ffffffff81447a07>] bus_add_driver+0x117/0x290
> [  601.079000]        [<ffffffff81448fea>] driver_register+0x7a/0x170
> [  601.079000]        [<ffffffff8144a10a>] __platform_driver_register+0x4a/0x50
> [  601.079000]        [<ffffffff8144a12d>] platform_driver_probe+0x1d/0xb0
> [  601.079000]        [<ffffffff81cfb0a1>] efifb_init+0x273/0x292
> [  601.079000]        [<ffffffff81002132>] do_one_initcall+0x102/0x1c0
> [  601.079000]        [<ffffffff81cb80a6>] kernel_init_freeable+0x15d/0x1ef
> [  601.079000]        [<ffffffff8166d2de>] kernel_init+0xe/0xf0
> [  601.079000]        [<ffffffff816914ec>] ret_from_fork+0x7c/0xb0
> [  601.079000]
> -> #0 (&fb_info->lock){+.+.+.}:
> [  601.079000]        [<ffffffff810dc1d8>] __lock_acquire+0x1e18/0x1f10
> [  601.079000]        [<ffffffff810dc971>] lock_acquire+0xa1/0x140
> [  601.079000]        [<ffffffff816835ca>] mutex_lock_nested+0x7a/0x3b0
> [  601.079000]        [<ffffffff81397566>] lock_fb_info+0x26/0x60
> [  601.079000]        [<ffffffff813a4aeb>] fbcon_blank+0x29b/0x2e0
> [  601.079000]        [<ffffffff81418658>] do_blank_screen+0x1d8/0x280
> [  601.079000]        [<ffffffff8141ab34>] console_callback+0x64/0x160
> [  601.079000]        [<ffffffff8108d855>] process_one_work+0x1f5/0x540
> [  601.079000]        [<ffffffff8108e04c>] worker_thread+0x11c/0x370
> [  601.079000]        [<ffffffff81095fbd>] kthread+0xed/0x100
> [  601.079000]        [<ffffffff816914ec>] ret_from_fork+0x7c/0xb0
> [  601.079000]
> other info that might help us debug this:
> 
> [  601.079000]  Possible unsafe locking scenario:
> 
> [  601.079000]        CPU0                    CPU1
> [  601.079000]        ----                    ----
> [  601.079000]   lock(console_lock);
> [  601.079000]                                lock(&fb_info->lock);
> [  601.079000]                                lock(console_lock);
> [  601.079000]   lock(&fb_info->lock);
> [  601.079000]
>  *** DEADLOCK ***
> 
> so we reorder the lock sequence the same as it in console_callback() to
> avoid this issue.
> Not very sure this change is suitable, any comments is welcome.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  drivers/video/fbmem.c |   50 +++++++++++++++++++++++++++++++-----------------
>  1 files changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index dacaf74..010d191 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1108,14 +1108,16 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>  	case FBIOPUT_VSCREENINFO:
>  		if (copy_from_user(&var, argp, sizeof(var)))
>  			return -EFAULT;
> -		if (!lock_fb_info(info))
> -			return -ENODEV;
>  		console_lock();
> +		if (!lock_fb_info(info)) {
> +			console_unlock();
> +			return -ENODEV;
> +		}
>  		info->flags |= FBINFO_MISC_USEREVENT;
>  		ret = fb_set_var(info, &var);
>  		info->flags &= ~FBINFO_MISC_USEREVENT;
> -		console_unlock();
>  		unlock_fb_info(info);
> +		console_unlock();
>  		if (!ret && copy_to_user(argp, &var, sizeof(var)))
>  			ret = -EFAULT;
>  		break;
> @@ -1144,12 +1146,14 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>  	case FBIOPAN_DISPLAY:
>  		if (copy_from_user(&var, argp, sizeof(var)))
>  			return -EFAULT;
> -		if (!lock_fb_info(info))
> -			return -ENODEV;
>  		console_lock();
> +		if (!lock_fb_info(info)) {
> +			console_unlock();
> +			return -ENODEV;
> +		}
>  		ret = fb_pan_display(info, &var);
> -		console_unlock();
>  		unlock_fb_info(info);
> +		console_unlock();
>  		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
>  			return -EFAULT;
>  		break;
> @@ -1184,23 +1188,27 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>  			break;
>  		}
>  		event.data = &con2fb;
> -		if (!lock_fb_info(info))
> -			return -ENODEV;
>  		console_lock();
> +		if (!lock_fb_info(info)) {
> +			console_unlock();
> +			return -ENODEV;
> +		}
>  		event.info = info;
>  		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
> -		console_unlock();
>  		unlock_fb_info(info);
> +		console_unlock();
>  		break;
>  	case FBIOBLANK:
> -		if (!lock_fb_info(info))
> -			return -ENODEV;
>  		console_lock();
> +		if (!lock_fb_info(info)) {
> +			console_unlock();
> +			return -ENODEV;
> +		}
>  		info->flags |= FBINFO_MISC_USEREVENT;
>  		ret = fb_blank(info, arg);
>  		info->flags &= ~FBINFO_MISC_USEREVENT;
> -		console_unlock();
>  		unlock_fb_info(info);
> +		console_unlock();
>  		break;
>  	default:
>  		if (!lock_fb_info(info))
> @@ -1660,12 +1668,15 @@ static int do_register_framebuffer(struct fb_info *fb_info)
>  	registered_fb[i] = fb_info;
>  
>  	event.info = fb_info;
> -	if (!lock_fb_info(fb_info))
> -		return -ENODEV;
>  	console_lock();
> +	if (!lock_fb_info(fb_info)) {
> +		console_unlock();
> +		return -ENODEV;
> +	}
> +
>  	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
> -	console_unlock();
>  	unlock_fb_info(fb_info);
> +	console_unlock();
>  	return 0;
>  }
>  
> @@ -1678,13 +1689,16 @@ static int do_unregister_framebuffer(struct fb_info *fb_info)
>  	if (i < 0 || i >= FB_MAX || registered_fb[i] != fb_info)
>  		return -EINVAL;
>  
> -	if (!lock_fb_info(fb_info))
> -		return -ENODEV;
>  	console_lock();
> +	if (!lock_fb_info(fb_info)) {
> +		console_unlock();
> +		return -ENODEV;
> +	}
> +
>  	event.info = fb_info;
>  	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
> -	console_unlock();
>  	unlock_fb_info(fb_info);
> +	console_unlock();
>  
>  	if (ret)
>  		return -EINVAL;


