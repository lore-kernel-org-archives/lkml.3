Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaFVIAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:00:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:18721 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaFVIAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:00:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,523,1400050800"; 
   d="scan'208";a="561394190"
Message-ID: <53A68D1F.5050101@intel.com>
Date: Sun, 22 Jun 2014 16:00:31 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: "Nikula, Jani" <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com, qemu-devel@nongnu.org
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>	<53A40198.6020007@intel.com> <CAKMK7uGr=Mn13eRO-AZBM7aEBrNEp7Zn+5mQyEbuoq9XeqT-pQ@mail.gmail.com>
In-Reply-To: <CAKMK7uGr=Mn13eRO-AZBM7aEBrNEp7Zn+5mQyEbuoq9XeqT-pQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/20 20:32, Daniel Vetter wrote:
> Well I have no clue about forwarding the intel gpu to virtualized
> hosts and also no idea who could review this really. There's been a
> bit a discussion around the iommu mapping forwarding and similar

No, this doesn't affect IOMMU mapping.

> topics though. So I really wonder how well our driver works in this
> use case ...

In native case the truth is intel_detect_pch() needs to probe the 
00:15.0 to determine what type current pch is, then the i915 driver can 
be initialized correctly. Actually the 00:15.0 is just a ISA bridge.

In virtualized case we thought this ISA bridge mayn't be represented 
with 00:15.0 originally by qemu-xen-traditional. So instead of checking 
devfn, the i915 driver check the class type to get this ISA bridge.

But with my investigation,qemu-xen-traditional always set 00:15.0 
explicitly to represent this ISA bridge. And especially, we wouldn't 
provide that ISA bridge with an explicit class type in qemu-upstream, so 
we need to the i915 driver to probe pch by checking devfn.

This should work both on the native case and the virtualized case.

Thanks
Tiejun

> -Daniel
>
> On Fri, Jun 20, 2014 at 11:40 AM, Chen, Tiejun <tiejun.chen@intel.com> wrote:
>> Just ping, any comments?
>>
>> Thanks
>> Tiejun
>>
>>
>> On 2014/6/19 17:53, Tiejun Chen wrote:
>>>
>>> Originally the reason to probe ISA bridge instead of Dev31:Fun0
>>> is to make graphics device passthrough work easy for VMM, that
>>> only need to expose ISA bridge to let driver know the real
>>> hardware underneath. This is a requirement from virtualization
>>> team. Especially in that virtualized environments, XEN, there
>>> is irrelevant ISA bridge in the system with that legacy qemu
>>> version specific to xen, qemu-xen-traditional. So to work
>>> reliably, we should scan through all the ISA bridge devices
>>> and check for the first match, instead of only checking the
>>> first one.
>>>
>>> But actually, qemu-xen-traditional, is always enumerated with
>>> Dev31:Fun0, 00:1f.0 as follows:
>>>
>>> hw/pt-graphics.c:
>>>
>>> intel_pch_init()
>>>       |
>>>       + pci_isa_bridge_init(bus, PCI_DEVFN(0x1f, 0), ...);
>>>
>>> so this mean that isa bridge is still represented with Dev31:Func0
>>> like the native OS. Furthermore, currently we're pushing VGA
>>> passthrough support into qemu upstream, and with some discussion,
>>> we wouldn't set the bridge class type and just expose this devfn.
>>>
>>> So we just go back to check devfn to make life normal.
>>>
>>> Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
>>> ---
>>>    drivers/gpu/drm/i915/i915_drv.c | 19 +++----------------
>>>    1 file changed, 3 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/i915/i915_drv.c
>>> b/drivers/gpu/drm/i915/i915_drv.c
>>> index 651e65e..cb2526e 100644
>>> --- a/drivers/gpu/drm/i915/i915_drv.c
>>> +++ b/drivers/gpu/drm/i915/i915_drv.c
>>> @@ -417,18 +417,8 @@ void intel_detect_pch(struct drm_device *dev)
>>>                  return;
>>>          }
>>>
>>> -       /*
>>> -        * The reason to probe ISA bridge instead of Dev31:Fun0 is to
>>> -        * make graphics device passthrough work easy for VMM, that only
>>> -        * need to expose ISA bridge to let driver know the real hardware
>>> -        * underneath. This is a requirement from virtualization team.
>>> -        *
>>> -        * In some virtualized environments (e.g. XEN), there is
>>> irrelevant
>>> -        * ISA bridge in the system. To work reliably, we should scan
>>> trhough
>>> -        * all the ISA bridge devices and check for the first match,
>>> instead
>>> -        * of only checking the first one.
>>> -        */
>>> -       while ((pch = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, pch))) {
>>> +       pch = pci_get_bus_and_slot(0, PCI_DEVFN(0x1f, 0));
>>> +       if (pch) {
>>>                  if (pch->vendor == PCI_VENDOR_ID_INTEL) {
>>>                          unsigned short id = pch->device &
>>> INTEL_PCH_DEVICE_ID_MASK;
>>>                          dev_priv->pch_id = id;
>>> @@ -462,10 +452,7 @@ void intel_detect_pch(struct drm_device *dev)
>>>                                  DRM_DEBUG_KMS("Found LynxPoint LP PCH\n");
>>>                                  WARN_ON(!IS_HASWELL(dev));
>>>                                  WARN_ON(!IS_ULT(dev));
>>> -                       } else
>>> -                               continue;
>>> -
>>> -                       break;
>>> +                       }
>>>                  }
>>>          }
>>>          if (!pch)
>>>
>>
>
>
>
