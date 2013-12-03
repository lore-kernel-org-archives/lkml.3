Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3LCVVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:21:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab3LCVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:21:22 -0500
Date: Tue, 3 Dec 2013 13:21:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
Message-Id: <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
In-Reply-To: <1385997579-22240-2-git-send-email-prarit@redhat.com>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
	<1385997579-22240-2-git-send-email-prarit@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Dec 2013 10:19:37 -0500 Prarit Bhargava <prarit@redhat.com> wrote:

> Logging and tracking firmware bugs in the kernel has long been an issue
> for system administrators.  The current kernel does not have a good
> uniform method of reporting firmware bugs and the code in the kernel is a
> mix of printk's and WARN_ONs.  This causes problems for both system
> administrators and QA engineers who attempt to diagnose problems within
> the kernel.
> 
> Using printk's is somewhat effective but lacks information useful for
> reporting a bug such as the system vendor or model, BIOS revision, etc.
> Using WARN_ONs is also questionable because the data like the backtrace
> and the list of modules is usually unnecessary for firmware issues as the
> warning stems from one call path during system or driver initialization.
> We have heard many complaints from users about the excess verbosity and
> confusing stacktraces for these messages.
> 
> I'm proposing with this patch to do something similar to the WARN()
> mechanism that is currently implemented in the kernel.  This
> patchset introduces FW_INFO() and FW_INFO_DEV() which logs output like:
> 
> [  230.661137] [Firmware Info]: pci_bus 0000:00: at
> /home/prarit_modules/prarit.c:21 Your BIOS is broken because it is
> -ENOWORKY.
> [  230.671076] [Firmware Info]: Intel Corporation SandyBridge Platform/To
> be filled by O.E.M., BIOS RMLCRB.86I.R3.27.D685.1305151733 05/15/2013
> 
> instead of the verbose back traces we are currently seeing.  These messages
> can be easily gleaned from /var/log/messages, etc., by automatic bug
> reporting tools and system administrators to properly report bugs to
> hardware vendors.
> 
> I found an improperly classified FW_INFO in arch/x86/kernel/cpu/amd.c
> which that should be a FW_BUG.

A slight simplification:

> +static inline char *dump_hadware_arch_desc(void)
> +{
> +	return NULL;
> +}

	return "unavailable";

> +void warn_slowpath_fmt_dev(const char *file, int line,
> +			   struct device *dev, int level, const char *fmt, ...)
> +{
> +	struct slowpath_args args;
> +	static char fw_str[16] = "\0";
> +
> +	switch (level) {
> +	case 1:
> +		strcpy(fw_str, "[Firmware Info]");
> +		break;
> +	case 2:
> +		strcpy(fw_str, "[Firmware Warn]");
> +		break;
> +	case 3:
> +		strcpy(fw_str, "[Firmware Bug]");

What's With The Crazy Capitalization In This Code?  It's Illiterate!

> +		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
> +		break;
> +	default:
> +		strcpy(fw_str, "[Firmware Bug]");
> +		break;
> +	}
> +
> +	if (dev)
> +		pr_info("%s: %s %s ", fw_str,
> +			dev_driver_string(dev), dev_name(dev));
> +	pr_info("%s: at %s:%d\n", fw_str, file, line);
> +
> +	args.fmt = fmt;
> +	va_start(args.args, fmt);
> +	printk(KERN_WARNING "%s: %pV", fw_str, &args);
> +	va_end(args.args);
> +
> +	if (dump_hardware_arch_desc())
> +		pr_info("%s: System Info: %s\n", fw_str,
> +			dump_hardware_arch_desc());
> +	else
> +		pr_info("%s: System Info: Hardware Unidentified\n", fw_str);

	pr_info(""%s: system info: %s\n", fw_str, dump_hardware_arch_desc());

> +}
> +EXPORT_SYMBOL(warn_slowpath_fmt_dev);
> +
> +

> +char *dump_hardware_arch_desc(void)
> +{
> +	if (dump_stack_arch_desc_str[0] != '\0')
> +		return dump_stack_arch_desc_str;
> +	return NULL;

	return "unavaliable";

> +}


The general thrust of the patchset seems useful and important.  I do
agree with Joe's suggestion regarding the presentation, although it
isn't a show-stopper.

I do wonder if it all should be generalised a bit - it creates a bunch
of infrastructure which is specific to system firmware issues, but
what's so special about firmware?  Why can't I use this infrastructure
to log netdev errors or acpi errors or PM errors or...?  But I didn't
think about it much ;)


