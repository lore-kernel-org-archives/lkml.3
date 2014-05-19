Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaESKGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:06:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7274 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaESKG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:06:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 May 2014 03:00:41 -0700
Message-ID: <5379D7A0.3050509@nvidia.com>
Date: Mon, 19 May 2014 19:06:24 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lucas Stach <l.stach@pengutronix.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC] drm/nouveau: disable caching for VRAM BOs on ARM
References: <1400492771-9746-1-git-send-email-acourbot@nvidia.com> <1400493433.8467.24.camel@weser.hi.pengutronix.de>
In-Reply-To: <1400493433.8467.24.camel@weser.hi.pengutronix.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 06:57 PM, Lucas Stach wrote:
> Am Montag, den 19.05.2014, 18:46 +0900 schrieb Alexandre Courbot:
>> This patch is not meant to be merged, but rather to try and understand
>> why this is needed and what a more suitable solution could be.
>>
>> Allowing BOs to be write-cached results in the following happening when
>> trying to run any program on Tegra/GK20A:
>>
>> Unhandled fault: external abort on non-linefetch (0x1008) at 0xf0036010
>> ...
>> (nouveau_bo_rd32) from [<c0357d00>] (nouveau_fence_update+0x5c/0x80)
>> (nouveau_fence_update) from [<c0357d40>] (nouveau_fence_done+0x1c/0x38)
>> (nouveau_fence_done) from [<c02c3d00>] (ttm_bo_wait+0xec/0x168)
>> (ttm_bo_wait) from [<c035e334>] (nouveau_gem_ioctl_cpu_prep+0x44/0x100)
>> (nouveau_gem_ioctl_cpu_prep) from [<c02aaa84>] (drm_ioctl+0x1d8/0x4f4)
>> (drm_ioctl) from [<c0355394>] (nouveau_drm_ioctl+0x54/0x80)
>> (nouveau_drm_ioctl) from [<c00ee7b0>] (do_vfs_ioctl+0x3dc/0x5a0)
>> (do_vfs_ioctl) from [<c00ee9a8>] (SyS_ioctl+0x34/0x5c)
>> (SyS_ioctl) from [<c000e6e0>] (ret_fast_syscall+0x0/0x30
>>
>> The offending nouveau_bo_rd32 is done over an IO-mapped BO, e.g. a BO
>> mapped through the BAR.
>>
> Um wait, this memory is behind an already mapped bar? I think ioremap on
> ARM defaults to uncached mappings, so if you want to access the memory
> behind this bar as WC you need to map the BAR as a whole as WC by using
> ioremap_wc.

Tried mapping the BAR using ioremap_wc(), but to no avail. On the other 
hand, could it be that VRAM BOs end up creating a mapping over an 
already-mapped region? I seem to remember that ARM might not like it...
