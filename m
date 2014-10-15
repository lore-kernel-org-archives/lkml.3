Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaJOBWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 21:22:24 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:48452 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaJOBWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 21:22:23 -0400
Message-ID: <543DCC4C.3090404@acm.org>
Date: Tue, 14 Oct 2014 20:22:20 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [patch 1/3] ipmi: Setup ipmi_devintf automatically if ipmi_msghandler
 gets loaded
References: <20141014144020.683892494@d46.suse.de> <20141014144315.178850163@d46.suse.de>
In-Reply-To: <20141014144315.178850163@d46.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 09:40 AM, trenn@suse.de wrote:
> This removes the ipmi_devintf to be a module, but it will automatically
> compiled in if ipmi_msghandler is set.
>
> ipmi_msghandler module is renamed to ipmi_handler because of the name
> clash with the ipmi_msghandler.o object file (see Makefile for details).
> Alternatively ipmi_msghandler.c could be renamed to ipmi_handler.c, but
> not polluting git history should be more of an advantage than module renaming.
>
> cleanup_ipmi_dev() and init_ipmi_devintf() implemented in ipmi_devintf.c
> are are simply declared ipmi_msghandler.c without creating a separate header
> file which looks more reasonable to me. Hope that is ok.

One minor style issue: the function definitions should really be in a .h
file.

Renaming the module is also probably a bad idea.  If this was to go in,
it would certainly need to keep the ipmi_msghandler.ko name to avoid
complete breakage all over the place.

In that vein, I am worried that this would just result in a lot of work
for all the
distros that have set up this already.  I'm trying to see the pros and
cons of
this, and I can't see that the pros outweigh the cons.  Do you have people
that have issues with this?

Does anyone else care about this?  Unless I hear from some people that
the way it is causes issues, I don't think I can let this in.

>
> In fact there already was a kind of autoloading mechanism (gets deleted
> with this patch). I interpret this line that ipmi_devintf should get
> autoloaded if ipmi_si gets loaded?:
> -MODULE_ALIAS("platform:ipmi_si");
> But:
>   - It's wrong: There are other low lever drivers which can be used by
>     ipmi_devintf
>   - It does not work (anymore?)
>   - There is no need to keep ipmi_devintf as a module (resource and load time
>     overhead)

This change is certainly a good idea.  Whatever it was trying to do is
wrong.

-corey

>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: minyard@acm.org
> CC: martin.wilck@ts.fujitsu.com
>
> Index: kernel_ipmi/drivers/char/ipmi/Kconfig
> ===================================================================
> --- kernel_ipmi.orig/drivers/char/ipmi/Kconfig
> +++ kernel_ipmi/drivers/char/ipmi/Kconfig
> @@ -8,6 +8,8 @@ menuconfig IPMI_HANDLER
>         help
>           This enables the central IPMI message handler, required for IPMI
>  	 to work.
> +	 It also provides userspace interface /dev/ipmiX, so that userspace
> +	 tools can query the BMC.
>  
>           IPMI is a standard for managing sensors (temperature,
>           voltage, etc.) in a system.
> @@ -37,12 +39,6 @@ config IPMI_PANIC_STRING
>  	  You can fetch these events and use the sequence numbers to piece the
>  	  string together.
>  
> -config IPMI_DEVICE_INTERFACE
> -       tristate 'Device interface for IPMI'
> -       help
> -         This provides an IOCTL interface to the IPMI message handler so
> -	 userland processes may use IPMI.  It supports poll() and select().
> -
>  config IPMI_SI
>         tristate 'IPMI System Interface handler'
>         help
> Index: kernel_ipmi/drivers/char/ipmi/Makefile
> ===================================================================
> --- kernel_ipmi.orig/drivers/char/ipmi/Makefile
> +++ kernel_ipmi/drivers/char/ipmi/Makefile
> @@ -4,8 +4,10 @@
>  
>  ipmi_si-y := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
>  
> -obj-$(CONFIG_IPMI_HANDLER) += ipmi_msghandler.o
> -obj-$(CONFIG_IPMI_DEVICE_INTERFACE) += ipmi_devintf.o
> +obj-$(CONFIG_IPMI_HANDLER) += ipmi_handler.o
> +
> +ipmi_handler-objs := ipmi_msghandler.o ipmi_devintf.o
> +
>  obj-$(CONFIG_IPMI_SI) += ipmi_si.o
>  obj-$(CONFIG_IPMI_WATCHDOG) += ipmi_watchdog.o
>  obj-$(CONFIG_IPMI_POWEROFF) += ipmi_poweroff.o
> Index: kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
> ===================================================================
> --- kernel_ipmi.orig/drivers/char/ipmi/ipmi_devintf.c
> +++ kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
> @@ -928,7 +928,7 @@ static struct ipmi_smi_watcher smi_watch
>  	.smi_gone = ipmi_smi_gone,
>  };
>  
> -static int __init init_ipmi_devintf(void)
> +int __init init_ipmi_devintf(void)
>  {
>  	int rv;
>  
> @@ -964,9 +964,8 @@ static int __init init_ipmi_devintf(void
>  
>  	return 0;
>  }
> -module_init(init_ipmi_devintf);
>  
> -static void __exit cleanup_ipmi(void)
> +void cleanup_ipmi_dev(void)
>  {
>  	struct ipmi_reg_list *entry, *entry2;
>  	mutex_lock(&reg_list_mutex);
> @@ -980,9 +979,3 @@ static void __exit cleanup_ipmi(void)
>  	ipmi_smi_watcher_unregister(&smi_watcher);
>  	unregister_chrdev(ipmi_major, DEVICE_NAME);
>  }
> -module_exit(cleanup_ipmi);
> -
> -MODULE_LICENSE("GPL");
> -MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
> -MODULE_DESCRIPTION("Linux device interface for the IPMI message handler.");
> -MODULE_ALIAS("platform:ipmi_si");
> Index: kernel_ipmi/drivers/char/ipmi/ipmi_msghandler.c
> ===================================================================
> --- kernel_ipmi.orig/drivers/char/ipmi/ipmi_msghandler.c
> +++ kernel_ipmi/drivers/char/ipmi/ipmi_msghandler.c
> @@ -4560,13 +4560,27 @@ static int ipmi_init_msghandler(void)
>  	return 0;
>  }
>  
> +void cleanup_ipmi_dev(void);
> +static void cleanup_ipmi(void);
> +int init_ipmi_devintf(void);
> +
> +
>  static int __init ipmi_init_msghandler_mod(void)
>  {
> -	ipmi_init_msghandler();
> +	int ret;
> +
> +	ret = ipmi_init_msghandler();
> +	if (ret)
> +		return ret;
> +	ret = init_ipmi_devintf();
> +	if (ret) {
> +		cleanup_ipmi();
> +		return ret;
> +	}
>  	return 0;
>  }
>  
> -static void __exit cleanup_ipmi(void)
> +static void cleanup_ipmi(void)
>  {
>  	int count;
>  
> @@ -4605,6 +4619,7 @@ static void __exit cleanup_ipmi(void)
>  	if (count != 0)
>  		printk(KERN_WARNING PFX "recv message count %d at exit\n",
>  		       count);
> +	cleanup_ipmi_dev();
>  }
>  module_exit(cleanup_ipmi);
>  
>

