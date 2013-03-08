Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab3CHWrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:47:10 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62904 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab3CHWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:47:08 -0500
Message-ID: <513A6A65.9050706@suse.cz>
Date: Fri, 08 Mar 2013 23:47:01 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
References: <20130307185642.GF13719@hansolo.jdub.homelinux.org> <5138E56B.6090308@suse.cz> <20130307191005.GH13719@hansolo.jdub.homelinux.org> <20130307211426.GI13719@hansolo.jdub.homelinux.org> <20130307231242.GC4280@kroah.com> <20130308010140.GJ13719@hansolo.jdub.homelinux.org> <20130308013923.GA12474@kroah.com> <20130308212722.GL13719@hansolo.jdub.homelinux.org>
In-Reply-To: <20130308212722.GL13719@hansolo.jdub.homelinux.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 10:27 PM, Josh Boyer wrote:
> On Fri, Mar 08, 2013 at 09:39:23AM +0800, Greg Kroah-Hartman wrote:
>>>>> Yes, reverting just 835d844d1 on top of 3.7.0 fixes it.  I also see why
>>>>> now.  That commit changed the module name from 8250 to 8250_core in the
>>>>> makefile, so clearly 8250.nr_uarts = 16 isn't going to get parsed.
>>>>> Adding 8250_core.nr_uarts = 16 seems to work fine.  This wasn't
>>>>> immediately obvious because the whole thing is built-in and not a
>>>>> module.  Thankfully, looking in /sys/modules/ still works and that
>>>>> showed up pretty clearly.
>>>>>
>>>>> So I guess this isn't really a break in functionality as much as it's a
>>>>> driver rename.  Not sure if it's worth fixing in some form or not.
>>>>
>>>> Yes it needs to be fixed, we shouldn't break userspace stuff like that.
>>>> Patches gladly accepted.
>>>
>>> OK... well I don't think renaming it back to 8250 is going to actually
>>> work.  It's already been renamed for 2 releases now, and a renaming
>>> isn't appropriate for 3.8.y.
>>>
>>> I don't remember exactly, but I don't think simply adding a modalias to
>>> 8250 will work either.
>>>
>>> So basically, the only way to fix this that I can see is to create a
>>> new, additional module parameter or something similar that parses
>>> "8250.nr_uarts".  Is that what you had in mind?
>>
>> I think that's the only way we can properly solve this, so yes, that
>> would be good.
> 
> "Be good" is subjective.  The following is functional, but it's pretty
> damn ugly.  Hopefully I'm missing some cleaner way to do this, but in my
> few attempts I didn't find anything.  I really hope I'm just blind or
> wrong or something.
> 
> I think the lesson here is "don't rename modules".
> 
> josh
> 
> From: Josh Boyer <jwboyer@redhat.com>
> Date: Fri, 8 Mar 2013 16:18:24 -0500
> Subject: [PATCH] serial: 8250: Keep 8250.nr_uarts option functional
> 
> With commit 835d844d1 (8250_pnp: do pnp probe before legacy probe), the
> 8250 driver was renamed to 8250_core.  This means any existing usage of
> 8250.nr_uarts= as module parameter or as a kernel command line switch is
> now broken, as the 8250_core driver doesn't parse options belonging to
> something called "8250".
> 
> We need the option to still be called "nr_uarts" and the existing module
> parameter macros do excellent checking to make sure you don't wind up with
> duplicate parameter names, so we can't just call __module_param_call with
> a different prefix.  Thus, we open code the kernel_param struct to add a
> "8250.nr_uarts" parameter to the module.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  drivers/tty/serial/8250/8250.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index 0efc815..e378e7e 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -3388,6 +3388,16 @@ MODULE_PARM_DESC(share_irqs, "Share IRQs with other non-8250/16x50 devices"
>  module_param(nr_uarts, uint, 0644);
>  MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
>  
> +/* This module was renamed to 8250_core in 3.7.  Keep the old "8250" name
> + * working as well for nr_uarts so we don't break people.  We open code the
> + * addition of the parameter because we need to actually keep the name
> + * identical and the convenient macros will happily refuse to let us do that
> + * by failing the build with redefinition errors.  I'm really sorry.
> + */
> +static struct kernel_param __moduleparam_const __param_8250_nr_uarts
> +__used __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *))))
> += { "8250.nr_uarts", &param_ops_uint, 0644, -1, { &nr_uarts } };
> +

Yeah, I agree this is ugly. Just re-definining MODULE_PARAM_PREFIX at
the end of the file should do the trick (followed by
"module_param(nr_uarts, uint, 0644)").

>  module_param(skip_txen_test, uint, 0644);
>  MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");

Well, we should do that for all the parameters, right? Sigh.

thanks,
-- 
js
suse labs
