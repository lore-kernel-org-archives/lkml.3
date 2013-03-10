Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3CJWda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:33:30 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:39158 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:33:28 -0400
Message-ID: <513D0A33.5050204@suse.cz>
Date: Sun, 10 Mar 2013 23:33:23 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] serial: 8250: Keep 8250.<xxxx> module options functional
 after driver rename
References: <20130308224950.GM13719@hansolo.jdub.homelinux.org> <513A6D1F.5000202@suse.cz> <513A6FD4.7000506@suse.cz> <513A70CF.9010800@suse.cz> <20130308232809.GO13719@hansolo.jdub.homelinux.org> <20130308234404.GP13719@hansolo.jdub.homelinux.org> <513AFD66.3030404@suse.cz> <20130309133014.GQ13719@hansolo.jdub.homelinux.org> <513B43BA.3000906@suse.cz> <20130309170241.GR13719@hansolo.jdub.homelinux.org> <20130310143340.GA7718@hansolo.jdub.homelinux.org>
In-Reply-To: <20130310143340.GA7718@hansolo.jdub.homelinux.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 03:33 PM, Josh Boyer wrote:
> With commit 835d844d1 (8250_pnp: do pnp probe before legacy probe), the
> 8250 driver was renamed to 8250_core.  This means any existing usage of
> the 8259.<xxxx> module parameters or as a kernel command line switch is
> now broken, as the 8250_core driver doesn't parse options belonging to
> something called "8250".
> 
> To solve this, we redefine the module options in a dummy function using
> a redefined MODULE_PARAM_PREFX when built into the kernel.  In the case
> where we're building as a module, we provide an alias to the old 8250
> name.  The dummy function prevents compiler errors due to global variable
> redefinitions that happen as part of the module_param_ macro expansions.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Despite the inevitable ugly nature of the approach:

Acked-by: Jiri Slaby <jslaby@suse.cz>

> ---
>  v2: Use __module_param_call for probe_rsa instead of undefining the
>      __param_check macro as suggested by Jiri Slaby
> 
>  drivers/tty/serial/8250/8250.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index 0efc815..f982633 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -3396,3 +3396,32 @@ module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
>  MODULE_PARM_DESC(probe_rsa, "Probe I/O ports for RSA");
>  #endif
>  MODULE_ALIAS_CHARDEV_MAJOR(TTY_MAJOR);
> +
> +#ifndef MODULE
> +/* This module was renamed to 8250_core in 3.7.  Keep the old "8250" name
> + * working as well for the module options so we don't break people.  We
> + * need to keep the names identical and the convenient macros will happily
> + * refuse to let us do that by failing the build with redefinition errors
> + * of global variables.  So we stick them inside a dummy function to avoid
> + * those conflicts.  The options still get parsed, and the redefined
> + * MODULE_PARAM_PREFIX lets us keep the "8250." syntax alive.
> + *
> + * This is hacky.  I'm sorry.
> + */
> +static void __used s8250_options(void)
> +{
> +#undef MODULE_PARAM_PREFIX
> +#define MODULE_PARAM_PREFIX "8250."
> +
> +	module_param_cb(share_irqs, &param_ops_uint, &share_irqs, 0644);
> +	module_param_cb(nr_uarts, &param_ops_uint, &nr_uarts, 0644);
> +	module_param_cb(skip_txen_test, &param_ops_uint, &skip_txen_test, 0644);
> +#ifdef CONFIG_SERIAL_8250_RSA
> +	__module_param_call(MODULE_PARAM_PREFIX, probe_rsa,
> +		&param_array_ops, .arr = &__param_arr_probe_rsa,
> +		0444, -1);
> +#endif
> +}
> +#else
> +MODULE_ALIAS("8250");
> +#endif
> 


-- 
js
suse labs
