Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab3EWTG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 15:06:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47277 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758960Ab3EWTGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 15:06:55 -0400
Message-ID: <1369336013.2075.47.camel@joe-AO722>
Subject: Re: [PATCH] Print the actual UEFI error name, not just the error
 code.
From: Joe Perches <joe@perches.com>
To: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 23 May 2013 12:06:53 -0700
In-Reply-To: <1369334231-11100-1-git-send-email-pjones@redhat.com>
References: <1369334231-11100-1-git-send-email-pjones@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-23 at 14:37 -0400, Peter Jones wrote:
> EFI error numbers are useful, but symbol names are way easier to
> understand when you're reading bug reports.  And since, for the most
> part, we know the names, we should show them.
[]
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
[]
> +#define efi_pr_warn(status, fmt, ...) ({				\
> +		typeof(status) __status = EFI_REVERSE_ERROR(status);	\
> +		if (__status >= 0 &&					\
> +				__status <= EFI_REVERSE_ERROR(EFI_MAX_ERROR))\
> +			pr_warn(fmt ": %s (0x%lx)\n", ## __VA_ARGS__,	\
> +				efi_error_strings[__status], __status);	\
> +		else							\
> +			pr_warn(fmt ": 0x%lx\n", ## __VA_ARGS__, __status);\
> +	})

This doubles the number of formats (and code size text) used.

Please don't remove trailing newlines from these sorts
of messages.  

I think a function to return "unknown efi error" would be
acceptable and these should become something like:

const char *efi_error_string(unsigned long status)
{
	if (status <= EFI_REVERSE_ERROR(EFI_MAX_ERROR))
		return efi_error_strings[status];
	return "unknown efi error";
}

and the uses something like:

> -		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
> -			status);
--
	pr_warn("set_variable() failed: %s (%lx)\n",
		efi_error_string(status), status);

(with #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt)


