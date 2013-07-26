Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab3GZILW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:11:22 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:54853 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3GZILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:11:04 -0400
Date: Fri, 26 Jul 2013 10:10:44 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, torvalds@linux-foundation.org, tglx@linutronix.de,
        hpa@zytor.com
Subject: Re: [Intel-gfx] [PATCH 2/2] x86: add early quirk for reserving Intel
 graphics stolen memory v3
Message-ID: <20130726081044.GA6084@phenom.ffwll.local>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	mingo@elte.hu, torvalds@linux-foundation.org, tglx@linutronix.de,
	hpa@zytor.com
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
 <1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 09:37:49AM -0700, Jesse Barnes wrote:
> Systems with Intel graphics controllers set aside memory exclusively for
> gfx driver use.  This memory is not marked in the E820 as reserved or as
> RAM, and so is subject to overlap from E820 manipulation later in the
> boot process.  On some systems, MMIO space is allocated on top, despite
> the efforts of the "RAM buffer" approach, which simply rounds memory
> boundaries up to 64M to try to catch space that may decode as RAM and so
> is not suitable for MMIO.
> 
> v2: use read_pci_config for 32 bit reads instead of adding a new one
>     (Chris)
>     add gen6 stolen size function (Chris)
>     use a function pointer (Chris)
>     drop gen2 bits (Daniel)
> 
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Our QA seems to be happy with this.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=66844
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=66726
Tested-by: lu hua <huax.lu@intel.com>

Cheers, Daniel
> ---
>  arch/x86/kernel/early-quirks.c  |  158 +++++++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/i915_reg.h |   15 ----
>  include/drm/i915_drm.h          |   32 ++++++++
>  3 files changed, 190 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 94ab6b9..bff8a6f 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -12,6 +12,7 @@
>  #include <linux/pci.h>
>  #include <linux/acpi.h>
>  #include <linux/pci_ids.h>
> +#include <drm/i915_drm.h>
>  #include <asm/pci-direct.h>
>  #include <asm/dma.h>
>  #include <asm/io_apic.h>
> @@ -208,6 +209,161 @@ static void __init intel_remapping_check(int num, int slot, int func)
>  
>  }
>  
> +/*
> + * Systems with Intel graphics controllers set aside memory exclusively
> + * for gfx driver use.  This memory is not marked in the E820 as reserved
> + * or as RAM, and so is subject to overlap from E820 manipulation later
> + * in the boot process.  On some systems, MMIO space is allocated on top,
> + * despite the efforts of the "RAM buffer" approach, which simply rounds
> + * memory boundaries up to 64M to try to catch space that may decode
> + * as RAM and so is not suitable for MMIO.
> + *
> + * And yes, so far on current devices the base addr is always under 4G.
> + */
> +static u32 __init intel_stolen_base(int num, int slot, int func)
> +{
> +	u32 base;
> +
> +	/*
> +	 * Almost universally we can find the Graphics Base of Stolen Memory
> +	 * at offset 0x5c in the igfx configuration space. On a few (desktop)
> +	 * machines this is also mirrored in the bridge device at different
> +	 * locations, or in the MCHBAR.
> +	 */
> +	base = read_pci_config(num, slot, func, 0x5c);
> +	base &= ~((1<<20) - 1);
> +
> +	return base;
> +}
> +
> +#define KB(x)	((x) * 1024)
> +#define MB(x)	(KB (KB (x)))
> +#define GB(x)	(MB (KB (x)))
> +
> +static size_t __init gen3_stolen_size(int num, int slot, int func)
> +{
> +	size_t stolen_size;
> +	u16 gmch_ctrl;
> +
> +	gmch_ctrl = read_pci_config_16(0, 0, 0, I830_GMCH_CTRL);
> +
> +	switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
> +	case I855_GMCH_GMS_STOLEN_1M:
> +		stolen_size = MB(1);
> +		break;
> +	case I855_GMCH_GMS_STOLEN_4M:
> +		stolen_size = MB(4);
> +		break;
> +	case I855_GMCH_GMS_STOLEN_8M:
> +		stolen_size = MB(8);
> +		break;
> +	case I855_GMCH_GMS_STOLEN_16M:
> +		stolen_size = MB(16);
> +		break;
> +	case I855_GMCH_GMS_STOLEN_32M:
> +		stolen_size = MB(32);
> +		break;
> +	case I915_GMCH_GMS_STOLEN_48M:
> +		stolen_size = MB(48);
> +		break;
> +	case I915_GMCH_GMS_STOLEN_64M:
> +		stolen_size = MB(64);
> +		break;
> +	case G33_GMCH_GMS_STOLEN_128M:
> +		stolen_size = MB(128);
> +		break;
> +	case G33_GMCH_GMS_STOLEN_256M:
> +		stolen_size = MB(256);
> +		break;
> +	case INTEL_GMCH_GMS_STOLEN_96M:
> +		stolen_size = MB(96);
> +		break;
> +	case INTEL_GMCH_GMS_STOLEN_160M:
> +		stolen_size = MB(160);
> +		break;
> +	case INTEL_GMCH_GMS_STOLEN_224M:
> +		stolen_size = MB(224);
> +		break;
> +	case INTEL_GMCH_GMS_STOLEN_352M:
> +		stolen_size = MB(352);
> +		break;
> +	default:
> +		stolen_size = 0;
> +		break;
> +	}
> +
> +	return stolen_size;
> +}
> +
> +static size_t __init gen6_stolen_size(int num, int slot, int func)
> +{
> +	u16 gmch_ctrl;
> +
> +	gmch_ctrl = read_pci_config_16(num, slot, func, SNB_GMCH_CTRL);
> +	gmch_ctrl >>= SNB_GMCH_GMS_SHIFT;
> +	gmch_ctrl &= SNB_GMCH_GMS_MASK;
> +
> +	return gmch_ctrl << 25; /* 32 MB units */
> +}
> +
> +typedef size_t (*stolen_size_fn)(int num, int slot, int func);
> +
> +static struct pci_device_id intel_stolen_ids[] __initdata = {
> +	INTEL_I915G_IDS(gen3_stolen_size),
> +	INTEL_I915GM_IDS(gen3_stolen_size),
> +	INTEL_I945G_IDS(gen3_stolen_size),
> +	INTEL_I945GM_IDS(gen3_stolen_size),
> +	INTEL_VLV_M_IDS(gen3_stolen_size),
> +	INTEL_VLV_D_IDS(gen3_stolen_size),
> +	INTEL_PINEVIEW_IDS(gen3_stolen_size),
> +	INTEL_I965G_IDS(gen3_stolen_size),
> +	INTEL_G33_IDS(gen3_stolen_size),
> +	INTEL_I965GM_IDS(gen3_stolen_size),
> +	INTEL_GM45_IDS(gen3_stolen_size),
> +	INTEL_G45_IDS(gen3_stolen_size),
> +	INTEL_IRONLAKE_D_IDS(gen3_stolen_size),
> +	INTEL_IRONLAKE_M_IDS(gen3_stolen_size),
> +	INTEL_SNB_D_IDS(gen6_stolen_size),
> +	INTEL_SNB_M_IDS(gen6_stolen_size),
> +	INTEL_IVB_M_IDS(gen6_stolen_size),
> +	INTEL_IVB_D_IDS(gen6_stolen_size),
> +	INTEL_HSW_D_IDS(gen6_stolen_size),
> +	INTEL_HSW_M_IDS(gen6_stolen_size),
> +};
> +
> +static void __init intel_graphics_stolen(int num, int slot, int func)
> +{
> +	size_t size;
> +	int i;
> +	u32 start;
> +	u16 device, subvendor, subdevice;
> +
> +	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
> +	subvendor = read_pci_config_16(num, slot, func,
> +				       PCI_SUBSYSTEM_VENDOR_ID);
> +	subdevice = read_pci_config_16(num, slot, func, PCI_SUBSYSTEM_ID);
> +
> +	for (i = 0; i < ARRAY_SIZE(intel_stolen_ids); i++) {
> +		if (intel_stolen_ids[i].device == device) {
> +			stolen_size_fn stolen_size =
> +				(stolen_size_fn)intel_stolen_ids[i].driver_data;
> +			size = stolen_size(num, slot, func);
> +			start = intel_stolen_base(num, slot, func);
> +			if (size && start)
> +				goto found;
> +			else
> +				break;
> +		}
> +	}
> +
> +	/* No match or invalid data, don't bother reserving */
> +	return;
> +found:
> +	/* Mark this space as reserved */
> +	e820_add_region(start, size, E820_RESERVED);
> +	return;
> +}
> +
>  #define QFLAG_APPLY_ONCE 	0x1
>  #define QFLAG_APPLIED		0x2
>  #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
> @@ -241,6 +397,8 @@ static struct chipset early_qrk[] __initdata = {
>  	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
>  	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
>  	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
> +	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA, PCI_ANY_ID,
> +	  QFLAG_APPLY_ONCE, intel_graphics_stolen },
>  	{}
>  };
>  
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index 5e58a44..d707ce6 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -33,21 +33,6 @@
>  #define _MASKED_BIT_ENABLE(a) (((a) << 16) | (a))
>  #define _MASKED_BIT_DISABLE(a) ((a) << 16)
>  
> -/*
> - * The Bridge device's PCI config space has information about the
> - * fb aperture size and the amount of pre-reserved memory.
> - * This is all handled in the intel-gtt.ko module. i915.ko only
> - * cares about the vga bit for the vga rbiter.
> - */
> -#define INTEL_GMCH_CTRL		0x52
> -#define INTEL_GMCH_VGA_DISABLE  (1 << 1)
> -#define SNB_GMCH_CTRL		0x50
> -#define    SNB_GMCH_GGMS_SHIFT	8 /* GTT Graphics Memory Size */
> -#define    SNB_GMCH_GGMS_MASK	0x3
> -#define    SNB_GMCH_GMS_SHIFT   3 /* Graphics Mode Select */
> -#define    SNB_GMCH_GMS_MASK    0x1f
> -
> -
>  /* PCI config space */
>  
>  #define HPLLCC	0xc0 /* 855 only */
> diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
> index 7276a72..3abfa6e 100644
> --- a/include/drm/i915_drm.h
> +++ b/include/drm/i915_drm.h
> @@ -36,4 +36,36 @@ extern bool i915_gpu_lower(void);
>  extern bool i915_gpu_busy(void);
>  extern bool i915_gpu_turbo_disable(void);
>  
> +/*
> + * The Bridge device's PCI config space has information about the
> + * fb aperture size and the amount of pre-reserved memory.
> + * This is all handled in the intel-gtt.ko module. i915.ko only
> + * cares about the vga bit for the vga rbiter.
> + */
> +#define INTEL_GMCH_CTRL		0x52
> +#define INTEL_GMCH_VGA_DISABLE  (1 << 1)
> +#define SNB_GMCH_CTRL		0x50
> +#define    SNB_GMCH_GGMS_SHIFT	8 /* GTT Graphics Memory Size */
> +#define    SNB_GMCH_GGMS_MASK	0x3
> +#define    SNB_GMCH_GMS_SHIFT   3 /* Graphics Mode Select */
> +#define    SNB_GMCH_GMS_MASK    0x1f
> +
> +#define I830_GMCH_CTRL			0x52
> +
> +#define I855_GMCH_GMS_MASK		0xF0
> +#define I855_GMCH_GMS_STOLEN_0M		0x0
> +#define I855_GMCH_GMS_STOLEN_1M		(0x1 << 4)
> +#define I855_GMCH_GMS_STOLEN_4M		(0x2 << 4)
> +#define I855_GMCH_GMS_STOLEN_8M		(0x3 << 4)
> +#define I855_GMCH_GMS_STOLEN_16M	(0x4 << 4)
> +#define I855_GMCH_GMS_STOLEN_32M	(0x5 << 4)
> +#define I915_GMCH_GMS_STOLEN_48M	(0x6 << 4)
> +#define I915_GMCH_GMS_STOLEN_64M	(0x7 << 4)
> +#define G33_GMCH_GMS_STOLEN_128M	(0x8 << 4)
> +#define G33_GMCH_GMS_STOLEN_256M	(0x9 << 4)
> +#define INTEL_GMCH_GMS_STOLEN_96M	(0xa << 4)
> +#define INTEL_GMCH_GMS_STOLEN_160M	(0xb << 4)
> +#define INTEL_GMCH_GMS_STOLEN_224M	(0xc << 4)
> +#define INTEL_GMCH_GMS_STOLEN_352M	(0xd << 4)
> +
>  #endif				/* _I915_DRM_H_ */
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
