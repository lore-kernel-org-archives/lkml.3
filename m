Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3AXW2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:28:34 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57848 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3AXW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:28:28 -0500
X-Originating-IP: 217.70.178.136
X-Originating-IP: 173.246.103.110
Date: Thu, 24 Jan 2013 14:28:20 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: mingo@kernel.org, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, JBeulich@suse.com, tglx@linutronix.de
Subject: Re: [tip:x86/debug] x86/EFI: Properly init-annotate BGRT code
Message-ID: <20130124222820.GA11888@jtriplet-mobl1>
References: <50AFB29F02000078000AAE8E@nat28.tlf.novell.com>
 <tip-13f0e4d2b9e2209f13d5a4122478eb79e6136870@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-13f0e4d2b9e2209f13d5a4122478eb79e6136870@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 12:34:21PM -0800, tip-bot for Jan Beulich wrote:
> Commit-ID:  13f0e4d2b9e2209f13d5a4122478eb79e6136870
> Gitweb:     http://git.kernel.org/tip/13f0e4d2b9e2209f13d5a4122478eb79e6136870
> Author:     Jan Beulich <JBeulich@suse.com>
> AuthorDate: Fri, 23 Nov 2012 16:30:07 +0000
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 24 Jan 2013 17:12:18 +0100
> 
> x86/EFI: Properly init-annotate BGRT code
> 
> These items are only ever referenced from initialization code.

Not true, and this patch will break the BGRT code.  bgrt_init, which
does indeed have an __init annotation, stores bgrt_image and
bgrt_image_size into the .private and .size fields of a sysfs
bin_attribute, which does *not* have an __initdata annotation, and which
will get read whenever the user reads the corresponding sysfs attribute.

> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: <mjg@redhat.com>
> Link: http://lkml.kernel.org/r/50AFB29F02000078000AAE8E@nat28.tlf.novell.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/platform/efi/efi-bgrt.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index d9c1b95..7145ec6 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -11,20 +11,21 @@
>   * published by the Free Software Foundation.
>   */
>  #include <linux/kernel.h>
> +#include <linux/init.h>
>  #include <linux/acpi.h>
>  #include <linux/efi.h>
>  #include <linux/efi-bgrt.h>
>  
>  struct acpi_table_bgrt *bgrt_tab;
> -void *bgrt_image;
> -size_t bgrt_image_size;
> +void *__initdata bgrt_image;
> +size_t __initdata bgrt_image_size;
>  
>  struct bmp_header {
>  	u16 id;
>  	u32 size;
>  } __packed;
>  
> -void efi_bgrt_init(void)
> +void __init efi_bgrt_init(void)
>  {
>  	acpi_status status;
>  	void __iomem *image;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
