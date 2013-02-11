Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab3BKXKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:10:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab3BKXKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:10:40 -0500
Date: Mon, 11 Feb 2013 15:10:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, rusty@rustcorp.com.au,
        hpa@linux.intel.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, grant.likely@secretlab.ca, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, patches@linaro.org
Subject: Re: [PATCH] driver core: add wait event for deferred probe
Message-Id: <20130211151038.8421aa54.akpm@linux-foundation.org>
In-Reply-To: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2013 00:57:57 +0800
Haojian Zhuang <haojian.zhuang@linaro.org> wrote:

> do_initcalls() could call all driver initialization code in kernel_init
> thread. It means that probe() function will be also called from that
> time. After this, kernel could access console & release __init section
> in the same thread.
> 
> But if device probe fails and moves into deferred probe list, a new
> thread is created to reinvoke probe. If the device is serial console,
> kernel has to open console failure & release __init section before
> reinvoking failure. Because there's no synchronization mechanism.
> Now add wait event to synchronize after do_initcalls().

It sounds like this:

static int __ref kernel_init(void *unused)
{
	kernel_init_freeable();
	/* need to finish all async __init code before freeing the memory */
	async_synchronize_full();

is designed to prevent the problem you describe?

> --- a/init/main.c
> +++ b/init/main.c
> @@ -786,6 +786,7 @@ static void __init do_basic_setup(void)
>  	do_ctors();
>  	usermodehelper_enable();
>  	do_initcalls();
> +	wait_for_device_probe();
>  }

Needs a nice comment here explaining what's going on.
