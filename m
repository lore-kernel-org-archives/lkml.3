Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaJJS3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:29:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52494 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaJJS27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:28:59 -0400
Date: Fri, 10 Oct 2014 20:28:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: Re: [PATCH 2/2] efi: Capsule update support
Message-ID: <20141010182846.GA10588@pd.tnic>
References: <1412692951-25478-1-git-send-email-matt@console-pimps.org>
 <1412692951-25478-2-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412692951-25478-2-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 03:42:31PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> The EFI capsule mechanism allows data blobs to be passed to the EFI
> firmware. This patch just introduces the main infrastruture for
> interacting with the firmware.
> 
> Once a capsule has been passed to the firmware, the next reboot will
> always be performed using the ResetSystem() EFI runtime service, which
> may involve overriding the reboot type specified by reboot=. This
> ensures the reset value returned by QueryCapsuleCapabilities() is used
> to reset the system, which is required for the capsule to be processed.
> 
> Cc: Leif Lindholm <leif.lindholm@linaro.org>
> Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Just a couple of quick thoughts which might or might not make sense...

> ---
>  arch/x86/kernel/reboot.c       |   7 ++
>  drivers/firmware/efi/Makefile  |   2 +-
>  drivers/firmware/efi/capsule.c | 239 +++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/reboot.c  |  12 ++-
>  include/linux/efi.h            |  20 ++++
>  5 files changed, 278 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/firmware/efi/capsule.c
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 17962e667a91..59fe1c03c71a 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -516,6 +516,13 @@ static void native_machine_emergency_restart(void)
>  	mode = reboot_mode == REBOOT_WARM ? 0x1234 : 0;
>  	*((unsigned short *)__va(0x472)) = mode;
>  
> +	/*
> +	 * If an EFI capsule has been registered with the firmware then
> +	 * override the reboot= parameter.
> +	 */
> +	if (efi_capsule_pending(NULL))
> +		reboot_type = BOOT_EFI;
> +
>  	for (;;) {
>  		/* Could also try the reset bit in the Hammer NB */
>  		switch (reboot_type) {
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index d8be608a9f3b..698846e67b09 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -1,7 +1,7 @@
>  #
>  # Makefile for linux kernel
>  #
> -obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
> +obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o capsule.o
>  obj-$(CONFIG_EFI_VARS)			+= efivars.o
>  obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
>  obj-$(CONFIG_UEFI_CPER)			+= cper.o
> diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> new file mode 100644
> index 000000000000..475643d66258
> --- /dev/null
> +++ b/drivers/firmware/efi/capsule.c
> @@ -0,0 +1,239 @@
> +/*
> + * EFI capsule support.
> + *
> + * Copyright 2013 Intel Corporation <matt.fleming@intel.com>
> + *
> + * This file is part of the Linux kernel, and is made available under
> + * the terms of the GNU General Public License version 2.
> + */
> +
> +#define pr_fmt(fmt) "efi-capsule: " fmt
> +
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/highmem.h>
> +#include <linux/efi.h>
> +#include <linux/vmalloc.h>
> +#include <asm/io.h>
> +
> +typedef struct {
> +	u64 length;
> +	u64 data;
> +} efi_capsule_block_desc_t;
> +
> +static bool capsule_pending;
> +static int efi_reset_type = -1;
> +
> +/*
> + * capsule_mutex serialises access to both 'capsule_pending' and
> + * 'efi_reset_type'.
> + *
> + * This mutex must be held across calls to efi_capsule_supported() and
> + * efi_update_capsule() so that the operation is atomic. This ensures
> + * that efi_update_capsule() isn't called with a capsule that requires a
> + * different reset type to the registered 'efi_reset_type'.
> + */
> +static DEFINE_MUTEX(capsule_mutex);
> +
> +static int efi_update_capsule(efi_capsule_header_t *capsule,
> +			      struct page **pages, size_t size, int reset);
> +
> +/**
> + * efi_capsule_pending - has a capsule been passed to the firmware?
> + * @reset_type: store the type of EFI reset if capsule is pending
> + *
> + * To ensure that the registered capsule is processed correctly by the
> + * firmware we need to perform a specific type of reset. If a capsule is
> + * pending return the reset type in @reset_type.
> + */
> +bool efi_capsule_pending(int *reset_type)
> +{
> +	bool rv = false;
> +
> +	mutex_lock(&capsule_mutex);
> +	if (!capsule_pending)
> +		goto out;
> +
> +	if (reset_type)
> +		*reset_type = efi_reset_type;
> +	rv = true;
> +
> +out:
> +	mutex_unlock(&capsule_mutex);
> +	return rv;
> +}
> +
> +/**
> + * efi_capsule_supported - does the firmware support the capsule?
> + * @guid: vendor guid of capsule
> + * @flags: capsule flags
> + * @size: size of capsule data
> + * @reset: the reset type required for this capsule
> + *
> + * Check whether a capsule with @flags is supported and that @size
> + * doesn't exceed the maximum size for a capsule.
> + */
> +int efi_capsule_supported(efi_guid_t guid, u32 flags, size_t size, int *reset)
> +{
> +	efi_capsule_header_t *capsule;
> +	efi_status_t status;
> +	u64 max_size;
> +	int rv = 0;
> +
> +	lockdep_assert_held(&capsule_mutex);
> +
> +	capsule = kmalloc(sizeof(*capsule), GFP_KERNEL);
> +	if (!capsule)
> +		return -ENOMEM;
> +
> +	capsule->headersize = capsule->imagesize = sizeof(*capsule);
> +	memcpy(&capsule->guid, &guid, sizeof(efi_guid_t));
> +	capsule->flags = flags;
> +
> +	status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
> +	if (status != EFI_SUCCESS) {
> +		rv = efi_status_to_err(status);
> +		goto out;
> +	}
> +
> +	if (size > max_size)
> +		rv = -ENOSPC;
> +out:
> +	kfree(capsule);
> +	return rv;
> +}
> +
> +/**
> + * efi_capsule_update - send a capsule to the firmware
> + * @capsule: capsule to send to firmware
> + * @pages: an array of capsule data
> + *
> + * Check that @capsule is supported by the firmware and that it doesn't
> + * conflict with any previously registered capsule.
> + */
> +int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)

You have efi_capsule_update() vs efi_update_capsule(). Maybe change the
names a bit more for differentiation. Or prepend the workhorse doing all
the work with "__" or so...

> +{
> +	efi_guid_t guid = capsule->guid;
> +	size_t size = capsule->imagesize;
> +	u32 flags = capsule->flags;
> +	int rv, reset_type;
> +
> +	mutex_lock(&capsule_mutex);
> +	rv = efi_capsule_supported(guid, flags, size, &reset_type);
> +	if (rv)
> +		goto out;
> +
> +	if (efi_reset_type >= 0 && efi_reset_type != reset_type) {
> +		pr_err("Incompatible capsule reset type %d\n", reset_type);
> +		rv = -EINVAL;
> +		goto out;
> +	}
> +
> +	rv = efi_update_capsule(capsule, pages, size, reset_type);
> +out:
> +	mutex_unlock(&capsule_mutex);
> +	return rv;
> +}
> +EXPORT_SYMBOL_GPL(efi_capsule_update);
> +
> +#define BLOCKS_PER_PAGE	(PAGE_SIZE / sizeof(efi_capsule_block_desc_t))
> +
> +/*
> + * How many pages of block descriptors do we need to map 'nr_pages'?
> + *
> + * Every list of block descriptors in a page must end with a
> + * continuation pointer. The last continuation pointer of the lage page
> + * must be zero to mark the end of the chain.
> + */
> +static inline unsigned int num_block_pages(unsigned int nr_pages)
> +{
> +	return DIV_ROUND_UP(nr_pages, BLOCKS_PER_PAGE - 1);
> +}
> +
> +/**
> + * efi_update_capsule - pass a single capsule to the firmware.
> + * @capsule: capsule to send to the firmware.
> + * @pages: an array of capsule data.
> + * @size: total size of capsule data + headers in @capsule.
> + * @reset: the reset type required for @capsule
> + *
> + * Map @capsule with EFI capsule block descriptors in PAGE_SIZE chunks.
> + * @size needn't necessarily be a multiple of PAGE_SIZE - we can handle
> + * a trailing chunk that is smaller than PAGE_SIZE.
> + *
> + * @capsule MUST be virtually contiguous.
> + *
> + * Return 0 on success.
> + */
> +static int efi_update_capsule(efi_capsule_header_t *capsule,
> +			      struct page **pages, size_t size, int reset)
> +{
> +	efi_capsule_block_desc_t *block = NULL;
> +	struct page **block_pgs;
> +	efi_status_t status;
> +	unsigned int nr_data_pgs, nr_block_pgs;
> +	int i, j, err = -ENOMEM;
> +
> +	lockdep_assert_held(&capsule_mutex);
> +
> +	nr_data_pgs = DIV_ROUND_UP(size, PAGE_SIZE);
> +	nr_block_pgs = num_block_pages(nr_data_pgs);
> +
> +	block_pgs = kzalloc(nr_block_pgs * sizeof(*block_pgs), GFP_KERNEL);
> +	if (!block_pgs)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nr_block_pgs; i++) {
> +		block_pgs[i] = alloc_page(GFP_KERNEL);

Maybe alloc_pages() once we verify that it actually gives phys. contig.
memory and maybe also try to do it outside of the locked region. I don't
know if it would matter to drop the locks though as capsule updating is
not something you do pretty often. I'd hope!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
