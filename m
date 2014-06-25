Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaFYGsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:48:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57890 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaFYGsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:48:39 -0400
Message-ID: <53AA70C0.2000806@redhat.com>
Date: Wed, 25 Jun 2014 08:48:32 +0200
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
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com> <53A42DAA.80406@redhat.com> <53A692F9.3060200@intel.com>
In-Reply-To: <53A692F9.3060200@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/06/2014 10:25, Chen, Tiejun ha scritto:
> In qemu-upstream, as you commented we can't create this as a ISA class
> type explicitly.

Note I didn't say that QEMU doesn't like having two ISA bridges.

I commented that the firmware will see two ISA bridges and will try to 
initialize both of them.  It currently doesn't just because it only 
knows of two southbridge PCI IDs, and both of them are old or relatively 
old (PIIX3/4 and ICH9).

But what would happen if you did graphics passthrough on a machine with 
an ICH9 southbridge?  Your code will create the PIIX4 ISA bridge, and 
will create an ICH9 southbridge just to please the i915 driver.  The 
BIOS will recognize the ICH9's vendor/device ids and try to initialize 
it.  It will write to the configuration space to set up PCI PIRQ[A-H] 
routing, for example, which makes no sense since your ICH9 is just a 
dummy device.

Second problem.  Your IGD passthrough code currently works with QEMU's 
PIIX4-based machine.  But what happens if you try to extend it, so that 
it works with QEMU's ICH9-based machine?  That's a more modern machine 
that has a PCIe chipset and hence has its ISA bridge at 00:1f.0.  Now 
you have a conflict.

In other words, if you want IGD passthrough in QEMU, you need a solution 
that is future-proof.

> So we compromise by faking this ISA bridge without ISA
> class type setting (as I recall you already said this way is slightly
> better).

It is only slightly better, but the right solution is to fix the driver. 
  There is absolutely zero reason why a graphics driver should know 
about the vendor/device ids of the PCH.

The right way could be to make QEMU add a vendor-specific capability to 
the video device. The driver can probe for that capability before 
looking at the PCI bus.  QEMU can add the capability to the list, it is 
easy because all accesses to the video device's configuration space trap 
to QEMU.  Then you do not need to add fake devices to the machine.

In fact, it would be nice if Intel added such a capability on the next 
generation of integrated graphics, too.  On real hardware, ACPI or some 
other kind of firmware can probe the PCH at 00:1f.0 and initialize that 
vendor-specific capability.  QEMU would just forward the value from the 
host, so that virtualized guests never depend on the PCH at 00:1f.0.

Paolo

> Maybe we will figure better way in the future. But anyway, this
> is always registered as 00:15.0, right? So I think the i915 driver can
> go back to probe the devfn like the native environment.

