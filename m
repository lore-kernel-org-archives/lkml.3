Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbaFYH4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:56:10 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:54916 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbaFYH4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:56:08 -0400
Message-ID: <53AA808C.5020402@redhat.com>
Date: Wed, 25 Jun 2014 09:55:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Chen, Tiejun" <tiejun.chen@intel.com>, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, airlied@linux.ie
CC: intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com> <53A42DAA.80406@redhat.com> <53A692F9.3060200@intel.com> <53AA70C0.2000806@redhat.com> <53AA7B73.90503@intel.com>
In-Reply-To: <53AA7B73.90503@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/06/2014 09:34, Chen, Tiejun ha scritto:
> On 2014/6/25 14:48, Paolo Bonzini wrote:
>> Second problem.  Your IGD passthrough code currently works with QEMU's
>> PIIX4-based machine.  But what happens if you try to extend it, so that
>
> Yes, current xen machine, xenpv, is based on pii4, and also I don't
> known if we will plan to migrate to q35 or others. So its hard to
> further say more now.
>
>> it works with QEMU's ICH9-based machine?  That's a more modern machine
>> that has a PCIe chipset and hence has its ISA bridge at 00:1f.0.  Now
>
> But even in this case, could we set the real vendor/device ids for that
> ISA bridge at 00:1f.0? If not, what's broken?

The config space layout changes for different vendor/device ids, so the 
guest firmware only works if you have the right vendor/device id.

>> It is only slightly better, but the right solution is to fix the driver.
>>   There is absolutely zero reason why a graphics driver should know
>> about the vendor/device ids of the PCH.
>
> This means we have to fix this both on Linux and Windows but I'm not
> sure if this is feasible to us.

You have to do it if you want this feature in QEMU in a future-proof way.

You _can_ provide the ugly PIIX4-specific hack as a compatibility 
fallback (and this patch is okay to make the compatibility fallback less 
hacky).  However, I don't think QEMU should accept the patch for IGD 
passthrough unless Intel is willing to make drivers 
virtualization-friendly.  Once you assign the IGD, it is not that 
integrated anymore and the drivers must take that into account.

It is worthwhile pointing out that neither AMD nor nVidia need any of this.

>> The right way could be to make QEMU add a vendor-specific capability to
>> the video device. The driver can probe for that capability before
>
> Do you mean we can pick two unused offsets in the configuration space of
> the video device as a vendor-specific capability to hold the
> vendor/device ids of the PCH?

Yes, either that or add a new capability (which lets you choose the 
offsets more freely).

If the IGD driver needs config space fields of the MCH, those fields 
could also be mirrored in the new capability.  QEMU would forward them 
automatically.

It could even be a new BAR, which gives even more freedom to allocate 
the fields.

>> looking at the PCI bus.  QEMU can add the capability to the list, it is
>> easy because all accesses to the video device's configuration space trap
>> to QEMU.  Then you do not need to add fake devices to the machine.
>>
>> In fact, it would be nice if Intel added such a capability on the next
>> generation of integrated graphics, too.  On real hardware, ACPI or some
>
> Maybe, but even this would be implemented, shouldn't we need to be
> compatible with those old generations?

Yes.

- old generation / old driver: use 00:1f.0 hack, only guaranteed to work 
on PIIX4-based virtual guest

- old generation / new driver: use 00:1f.0 hack on real hardware, use 
capability on 00:02.0 on virtual guest, can work on PCIe virtual guest

- new generation / old driver: doesn't exist

- new generation / new driver: always use capability on 00:02.0, can 
work on PCIe virtual guest.

Paolo
