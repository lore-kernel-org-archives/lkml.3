Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3CHFXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:23:02 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:45348 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3CHFW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:22:58 -0500
MIME-Version: 1.0
In-Reply-To: <20130308051059.GC14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-2-git-send-email-yinghai@kernel.org>
	<20130308051059.GC14556@mtj.dyndns.org>
Date: Thu, 7 Mar 2013 21:22:57 -0800
X-Google-Sender-Auth: V4J1gn89FQ6iG6TQGEna8UHI-qc
Message-ID: <CAE9FiQVMjm7P28XLYGQ675we2+dU+H6rJK2eiO+FFeynYefJHA@mail.gmail.com>
Subject: Re: [PATCH 01/14] x86, ACPI, mm: Kill max_low_pfn_mapped
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jacob Shin <jacob.shin@amd.com>,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 9:10 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 07, 2013 at 08:58:27PM -0800, Yinghai Lu wrote:
>> diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
>> index 69d97cb..7f9380b 100644
>> --- a/drivers/gpu/drm/i915/i915_gem_stolen.c
>> +++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
>> @@ -81,7 +81,7 @@ static unsigned long i915_stolen_to_physical(struct drm_device *dev)
>>               base -= dev_priv->mm.gtt->stolen_size;
>>       } else {
>>               /* Stolen is immediately above Top of Memory */
>> -             base = max_low_pfn_mapped << PAGE_SHIFT;
>> +             base = __REMOVED_CRAZY__ << PAGE_SHIFT;
>
> Huh?

Whole function:

static unsigned long i915_stolen_to_physical(struct drm_device *dev)
{
	struct drm_i915_private *dev_priv = dev->dev_private;
	struct pci_dev *pdev = dev_priv->bridge_dev;
	u32 base;

	/* On the machines I have tested the Graphics Base of Stolen Memory
	 * is unreliable, so on those compute the base by subtracting the
	 * stolen memory from the Top of Low Usable DRAM which is where the
	 * BIOS places the graphics stolen memory.
	 *
	 * On gen2, the layout is slightly different with the Graphics Segment
	 * immediately following Top of Memory (or Top of Usable DRAM). Note
	 * it appears that TOUD is only reported by 865g, so we just use the
	 * top of memory as determined by the e820 probe.
	 *
	 * XXX gen2 requires an unavailable symbol and 945gm fails with
	 * its value of TOLUD.
	 */
	base = 0;
	if (INTEL_INFO(dev)->gen >= 6) {
		/* Read Base Data of Stolen Memory Register (BDSM) directly.
		 * Note that there is also a MCHBAR miror at 0x1080c0 or
		 * we could use device 2:0x5c instead.
		*/
		pci_read_config_dword(pdev, 0xB0, &base);
		base &= ~4095; /* lower bits used for locking register */
	} else if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
		/* Read Graphics Base of Stolen Memory directly */
		pci_read_config_dword(pdev, 0xA4, &base);
#if 0
	} else if (IS_GEN3(dev)) {
		u8 val;
		/* Stolen is immediately below Top of Low Usable DRAM */
		pci_read_config_byte(pdev, 0x9c, &val);
		base = val >> 3 << 27;
		base -= dev_priv->mm.gtt->stolen_size;
	} else {
		/* Stolen is immediately above Top of Memory */
		base = __REMOVED_CRAZY__ << PAGE_SHIFT;
#endif
	}

	return base;
}
