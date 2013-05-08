Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3EHT4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:56:54 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53442 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754309Ab3EHT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:56:53 -0400
Message-ID: <518AAE01.2010005@hurleysoftware.com>
Date: Wed, 08 May 2013 15:56:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, airlied@redhat.com,
        linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com
Subject: Re: [PATCH 3/9] vt: delete unneeded functions register_con_driver|take_over_console
References: <20130508181359.GD12344@udknight>
In-Reply-To: <20130508181359.GD12344@udknight>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 02:13 PM, Wang YanQing wrote:
> Now there is no place use register_con_driver|take_over_console,
> and we can achieve their function with do_register_con_driver|
> do_take_over_console easily, so just delete them to reduce code duplication.
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>   drivers/tty/vt/vt.c     | 45 ---------------------------------------------
>   include/linux/console.h |  2 --
>   2 files changed, 47 deletions(-)
>
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index fbd447b..852d470 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3576,26 +3576,6 @@ err:
>   	return retval;
>   }
>
> -/**
> - * register_con_driver - register console driver to console layer
> - * @csw: console driver
> - * @first: the first console to take over, minimum value is 0
> - * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
> - *
> - * DESCRIPTION: This function registers a console driver which can later
> - * bind to a range of consoles specified by @first and @last. It will
> - * also initialize the console driver by calling con_startup().
> - */
> -int register_con_driver(const struct consw *csw, int first, int last)
> -{
> -	int retval;
> -
> -	console_lock();
> -	retval = do_register_con_driver(csw, first, last);
> -	console_unlock();
> -	return retval;
> -}
> -EXPORT_SYMBOL(register_con_driver);

Maybe register_con_driver() should print a deprecated warning
for a release or two before we remove it.

>   /**
>    * unregister_con_driver - unregister console driver from console layer
> @@ -3677,30 +3657,6 @@ int do_take_over_console(const struct consw *csw, int first, int last, int deflt
>   }
>   EXPORT_SYMBOL_GPL(do_take_over_console);
>
> -/*
> - *	If we support more console drivers, this function is used
> - *	when a driver wants to take over some existing consoles
> - *	and become default driver for newly opened ones.
> - *
> - *	take_over_console is basically a register followed by unbind
> - */
> -int take_over_console(const struct consw *csw, int first, int last, int deflt)
> -{
> -	int err;
> -
> -	err = register_con_driver(csw, first, last);
> -	/*
> -	 * If we get an busy error we still want to bind the console driver
> -	 * and return success, as we may have unbound the console driver
> -	 * but not unregistered it.
> -	 */
> -	if (err == -EBUSY)
> -		err = 0;
> -	if (!err)
> -		bind_con_driver(csw, first, last, deflt);
> -
> -	return err;
> -}
>
>   /*
>    * give_up_console is a wrapper to unregister_con_driver. It will only
> @@ -4264,6 +4220,5 @@ EXPORT_SYMBOL(console_blanked);
>   EXPORT_SYMBOL(vc_cons);
>   EXPORT_SYMBOL(global_cursor_default);
>   #ifndef VT_SINGLE_DRIVER
> -EXPORT_SYMBOL(take_over_console);

This effectively converts take_over_console() to require GPL now.


