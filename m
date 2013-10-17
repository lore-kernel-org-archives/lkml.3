Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab3JQObS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:31:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43145 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3JQObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:31:16 -0400
Date: Thu, 17 Oct 2013 16:31:21 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        grant.likely@secretlab.ca, roy.franz@linaro.org, msalter@redhat.com
Subject: Re: [PATCH v2 2/3] arm: Add [U]EFI runtime services support
Message-ID: <20131017143121.GJ1557@rocoto.smurfnet.nu>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
 <1380799481-5470-3-git-send-email-leif.lindholm@linaro.org>
 <20131017140739.GI10834@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017140739.GI10834@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 03:07:39PM +0100, Matt Fleming wrote:
> > +/*
> > + * If you need to (temporarily) support buggy firmware.
> > + */
> > +#define KEEP_BOOT_SERVICES_REGIONS
> 
> Have you seen firmware that requires this? I'm just curious more than
> anything else.

Not really.
I _think_ I saw it on a debug build of a development platform once.
That coincided with me seeing a post on linux-efi about some laptop
that broke unless boot services regions were preserved, so I decided
to put it in there for any future debugging.
 
> > +/*
> > + * Returns 1 if 'facility' is enabled, 0 otherwise.
> > + */
> > +int efi_enabled(int facility)
> > +{
> > +	return test_bit(facility, &arm_efi_facility) != 0;
> > +}
> > +EXPORT_SYMBOL(efi_enabled);
> 
> This should move to drivers/firmware/efi/efi.c. Let me write a patch
> that moves the x86 stuff out of arch/x86 and means you can get rid of
> this hunk.
 
Excellent, thanks!

> > +/*
> > + * Called explicitly from init/mm.c
> > + */
> 
> That's init/main.c.
 
*cough*, right.

> > +void __init efi_enter_virtual_mode(void)
> > +{
> > +	efi_status_t status;
> > +
> > +	if (!efi_enabled(EFI_BOOT)) {
> > +		pr_info("EFI services will not be available.\n");
> > +		return;
> 
> This is dead code as PATCH 3 does,
> 
> diff --git a/init/main.c b/init/main.c
> index af310af..ec6d76e 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -875,6 +875,10 @@ static noinline void __init
> kernel_init_freeable(void)
> 	smp_prepare_cpus(setup_max_cpus);
> 
> 	do_pre_smp_initcalls();
> +
> +	if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_BOOT))
> +		efi_enter_virtual_mode();
> +

True.

However, this call site is likely to change in the future (preferably
to an early_initcall), if we redesign the memory mapping to be reusable
after kexec(). At which point the test in efi_enter_virtual_mode() will
make sense again.

Could I change the test in init/main.c to do
     if (IS_ENABLED(CONFIG_ARM) && IS_ENABLED(CONFIG_EFI))
instead?

/
    Leif
