Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaGABwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:52:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:52033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaGABws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:52:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,578,1400050800"; 
   d="scan'208";a="566350905"
Message-ID: <53B21466.104@intel.com>
Date: Tue, 01 Jul 2014 09:52:38 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com> <20140630111820.GA29509@redhat.com>
In-Reply-To: <20140630111820.GA29509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/30 19:18, Michael S. Tsirkin wrote:
> On Thu, Jun 19, 2014 at 05:53:51PM +0800, Tiejun Chen wrote:
>> Originally the reason to probe ISA bridge instead of Dev31:Fun0
>> is to make graphics device passthrough work easy for VMM, that
>> only need to expose ISA bridge to let driver know the real
>> hardware underneath. This is a requirement from virtualization
>> team. Especially in that virtualized environments, XEN, there
>> is irrelevant ISA bridge in the system with that legacy qemu
>> version specific to xen, qemu-xen-traditional. So to work
>> reliably, we should scan through all the ISA bridge devices
>> and check for the first match, instead of only checking the
>> first one.
>>
>> But actually, qemu-xen-traditional, is always enumerated with
>> Dev31:Fun0, 00:1f.0 as follows:
>>
>> hw/pt-graphics.c:
>>
>> intel_pch_init()
>>      |
>>      + pci_isa_bridge_init(bus, PCI_DEVFN(0x1f, 0), ...);
>>
>> so this mean that isa bridge is still represented with Dev31:Func0
>> like the native OS. Furthermore, currently we're pushing VGA
>> passthrough support into qemu upstream, and with some discussion,
>> we wouldn't set the bridge class type and just expose this devfn.
>>
>> So we just go back to check devfn to make life normal.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
>> ---
>>   drivers/gpu/drm/i915/i915_drv.c | 19 +++----------------
>>   1 file changed, 3 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
>> index 651e65e..cb2526e 100644
>> --- a/drivers/gpu/drm/i915/i915_drv.c
>> +++ b/drivers/gpu/drm/i915/i915_drv.c
>> @@ -417,18 +417,8 @@ void intel_detect_pch(struct drm_device *dev)
>>   		return;
>>   	}
>>
>> -	/*
>> -	 * The reason to probe ISA bridge instead of Dev31:Fun0 is to
>> -	 * make graphics device passthrough work easy for VMM, that only
>> -	 * need to expose ISA bridge to let driver know the real hardware
>> -	 * underneath. This is a requirement from virtualization team.
>> -	 *
>> -	 * In some virtualized environments (e.g. XEN), there is irrelevant
>> -	 * ISA bridge in the system. To work reliably, we should scan trhough
>> -	 * all the ISA bridge devices and check for the first match, instead
>> -	 * of only checking the first one.
>> -	 */
>> -	while ((pch = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, pch))) {
>> +	pch = pci_get_bus_and_slot(0, PCI_DEVFN(0x1f, 0));
>> +	if (pch) {
>
> Then if you want to use this slot for something else, what happens?

I think this slot is always occupied to be dedicated to this ISA bridge 
in the platform.

So don't worry, the drivers in Linux and Windows can live with this.

Thanks
Tiejun

> If you want to relax the PCI_CLASS_BRIDGE_ISA requirement when
> running on top of a hypervisor, just scan all devices.
>
>>   		if (pch->vendor == PCI_VENDOR_ID_INTEL) {
>>   			unsigned short id = pch->device & INTEL_PCH_DEVICE_ID_MASK;
>>   			dev_priv->pch_id = id;
>> @@ -462,10 +452,7 @@ void intel_detect_pch(struct drm_device *dev)
>>   				DRM_DEBUG_KMS("Found LynxPoint LP PCH\n");
>>   				WARN_ON(!IS_HASWELL(dev));
>>   				WARN_ON(!IS_ULT(dev));
>> -			} else
>> -				continue;
>> -
>> -			break;
>> +			}
>>   		}
>>   	}
>>   	if (!pch)
>> --
>> 1.9.1
>>
>
