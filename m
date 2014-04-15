Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaDOIyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:54:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:21488 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaDOIyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:54:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="513185057"
Message-ID: <534CF3B1.7020508@linux.intel.com>
Date: Tue, 15 Apr 2014 16:54:09 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>,
        "Woodhouse, David" <david.woodhouse@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "Zanoni, Paulo R" <paulo.r.zanoni@intel.com>,
        "greg@kroah.com" <greg@kroah.com>
Subject: Re: X86: kexec issues with i915 in 3.14
References: <1397419299.1407.18.camel@vger.seibold.net>	 <1397435291.19944.176.camel@shinybook.infradead.org> <1397504974.1059.5.camel@vger.seibold.net>
In-Reply-To: <1397504974.1059.5.camel@vger.seibold.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefanin,
	As David has mentioned, the warning messages indicates the VGA
controller hasn't been shut down correctly during reboot and keeps doing
DMA write operations after loading the new kernel. Do you have found
any older kernel without this issue?
	There is a patch set to solve similar issue for crashdump,
please refer to https://lkml.org/lkml/2014/1/10/518.

Thanks!
Gerry

On 2014/4/15 3:49, Stefani Seibold wrote:
> Am Montag, den 14.04.2014, 00:28 +0000 schrieb Woodhouse, David:
>> On Sun, 2014-04-13 at 22:01 +0200, Stefani Seibold wrote:
>>> Rebooting my kernel vanilla kernel 3.14 will fail with tons of kernel
>>> log messages:
>>>
>>> [    0.262754] IOMMU: Setting identity map for device 0000:00:1a.0 [0x7c45f000 - 0x7c46bfff]
>>> [    0.262780] IOMMU: Setting identity map for device 0000:00:14.0 [0x7c45f000 - 0x7c46bfff]
>>> [    0.262798] IOMMU: Prepare 0-16MiB unity mapping for LPC
>>> [    0.262807] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
>>> [    0.262948] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
>>> [    0.262948] dmar: DRHD: handling fault status reg 3
>>> [    0.262951] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr ffffe000 
>>> DMAR:[fault reason 05] PTE Write access is not set
>>
>> I'm inferring from the subject line that you mean kexec, not
>> "rebooting"?
>>
> 
> Rebooting via BIOS works, but booting via kexec will result the message
> storm or hang kernel with a corrupted display.
> 
>> It looks like a peripheral device is being left active and doing DMA by
>> the previous kernel, rather than being shut down. So as soon as the new
>> kernel resets the IOMMU mappings, that peripheral device is causing
>> faults.
>>
>> We really ought to rate-limit the faults and isolate the offending
>> device before there are 21,000 of them. As discussed elsewhere recently,
>> we could do with a way to tell the PCI layer that it offended us but I
>> suppose we could at *least* stop the IOMMU from reporting faults for it.
>>
>> Is this new behaviour? I'm not sure why this should have changed...
>>
> 
> I can reproduce the behaviour also with a 3.13.7 kernel.
> 
> One thing i found after the end of the 21.000 messages was a GPU crash:
> 
> [    5.002484] r8169 0000:03:00.0 eth0: link up
> [    5.002489] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [    6.745051] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... blitter ring idle
> [   11.743768] [drm] stuck on render ring
> [   11.743773] [drm] GPU crash dump saved to /sys/class/drm/card0/error
> [   11.743774] [drm] GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.
> [   11.743775] [drm] Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel
> [   11.743777] [drm] drm/i915 developers can then reassign to the right component if it's not a kernel issue.
> [   11.743778] [drm] The gpu crash dump is required to analyze gpu hangs, so please always attach it.
> [   14.240743] systemd-journald[158]: File /var/log/journal/bb613621feef82d686edde0046e9bcea/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.
> 
> - Stefani
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
