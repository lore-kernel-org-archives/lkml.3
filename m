Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967321AbaFTMcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:32:14 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:54316 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965113AbaFTMcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:32:12 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53A40198.6020007@intel.com>
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
	<53A40198.6020007@intel.com>
Date: Fri, 20 Jun 2014 14:32:11 +0200
Message-ID: <CAKMK7uGr=Mn13eRO-AZBM7aEBrNEp7Zn+5mQyEbuoq9XeqT-pQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: "Chen, Tiejun" <tiejun.chen@intel.com>
Cc: "Nikula, Jani" <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com, qemu-devel@nongnu.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well I have no clue about forwarding the intel gpu to virtualized
hosts and also no idea who could review this really. There's been a
bit a discussion around the iommu mapping forwarding and similar
topics though. So I really wonder how well our driver works in this
use case ...
-Daniel

On Fri, Jun 20, 2014 at 11:40 AM, Chen, Tiejun <tiejun.chen@intel.com> wrote:
> Just ping, any comments?
>
> Thanks
> Tiejun
>
>
> On 2014/6/19 17:53, Tiejun Chen wrote:
>>
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
>> diff --git a/drivers/gpu/drm/i915/i915_drv.c
>> b/drivers/gpu/drm/i915/i915_drv.c
>> index 651e65e..cb2526e 100644
>> --- a/drivers/gpu/drm/i915/i915_drv.c
>> +++ b/drivers/gpu/drm/i915/i915_drv.c
>> @@ -417,18 +417,8 @@ void intel_detect_pch(struct drm_device *dev)
>>                 return;
>>         }
>>
>> -       /*
>> -        * The reason to probe ISA bridge instead of Dev31:Fun0 is to
>> -        * make graphics device passthrough work easy for VMM, that only
>> -        * need to expose ISA bridge to let driver know the real hardware
>> -        * underneath. This is a requirement from virtualization team.
>> -        *
>> -        * In some virtualized environments (e.g. XEN), there is
>> irrelevant
>> -        * ISA bridge in the system. To work reliably, we should scan
>> trhough
>> -        * all the ISA bridge devices and check for the first match,
>> instead
>> -        * of only checking the first one.
>> -        */
>> -       while ((pch = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, pch))) {
>> +       pch = pci_get_bus_and_slot(0, PCI_DEVFN(0x1f, 0));
>> +       if (pch) {
>>                 if (pch->vendor == PCI_VENDOR_ID_INTEL) {
>>                         unsigned short id = pch->device &
>> INTEL_PCH_DEVICE_ID_MASK;
>>                         dev_priv->pch_id = id;
>> @@ -462,10 +452,7 @@ void intel_detect_pch(struct drm_device *dev)
>>                                 DRM_DEBUG_KMS("Found LynxPoint LP PCH\n");
>>                                 WARN_ON(!IS_HASWELL(dev));
>>                                 WARN_ON(!IS_ULT(dev));
>> -                       } else
>> -                               continue;
>> -
>> -                       break;
>> +                       }
>>                 }
>>         }
>>         if (!pch)
>>
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
