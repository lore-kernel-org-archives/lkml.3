Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaDNTu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:50:28 -0400
Received: from www84.your-server.de ([213.133.104.84]:51676 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaDNTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:50:26 -0400
Message-ID: <1397504974.1059.5.camel@vger.seibold.net>
Subject: Re: X86: kexec issues with i915 in 3.14
From: Stefani Seibold <stefani@seibold.net>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "Zanoni, Paulo R" <paulo.r.zanoni@intel.com>,
        "greg@kroah.com" <greg@kroah.com>
Date: Mon, 14 Apr 2014 21:49:34 +0200
In-Reply-To: <1397435291.19944.176.camel@shinybook.infradead.org>
References: <1397419299.1407.18.camel@vger.seibold.net>
	 <1397435291.19944.176.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 14.04.2014, 00:28 +0000 schrieb Woodhouse, David:
> On Sun, 2014-04-13 at 22:01 +0200, Stefani Seibold wrote:
> > Rebooting my kernel vanilla kernel 3.14 will fail with tons of kernel
> > log messages:
> > 
> > [    0.262754] IOMMU: Setting identity map for device 0000:00:1a.0 [0x7c45f000 - 0x7c46bfff]
> > [    0.262780] IOMMU: Setting identity map for device 0000:00:14.0 [0x7c45f000 - 0x7c46bfff]
> > [    0.262798] IOMMU: Prepare 0-16MiB unity mapping for LPC
> > [    0.262807] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
> > [    0.262948] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> > [    0.262948] dmar: DRHD: handling fault status reg 3
> > [    0.262951] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr ffffe000 
> > DMAR:[fault reason 05] PTE Write access is not set
> 
> I'm inferring from the subject line that you mean kexec, not
> "rebooting"?
> 

Rebooting via BIOS works, but booting via kexec will result the message
storm or hang kernel with a corrupted display.

> It looks like a peripheral device is being left active and doing DMA by
> the previous kernel, rather than being shut down. So as soon as the new
> kernel resets the IOMMU mappings, that peripheral device is causing
> faults.
> 
> We really ought to rate-limit the faults and isolate the offending
> device before there are 21,000 of them. As discussed elsewhere recently,
> we could do with a way to tell the PCI layer that it offended us but I
> suppose we could at *least* stop the IOMMU from reporting faults for it.
> 
> Is this new behaviour? I'm not sure why this should have changed...
> 

I can reproduce the behaviour also with a 3.13.7 kernel.

One thing i found after the end of the 21.000 messages was a GPU crash:

[    5.002484] r8169 0000:03:00.0 eth0: link up
[    5.002489] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    6.745051] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... blitter ring idle
[   11.743768] [drm] stuck on render ring
[   11.743773] [drm] GPU crash dump saved to /sys/class/drm/card0/error
[   11.743774] [drm] GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.
[   11.743775] [drm] Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel
[   11.743777] [drm] drm/i915 developers can then reassign to the right component if it's not a kernel issue.
[   11.743778] [drm] The gpu crash dump is required to analyze gpu hangs, so please always attach it.
[   14.240743] systemd-journald[158]: File /var/log/journal/bb613621feef82d686edde0046e9bcea/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.

- Stefani


