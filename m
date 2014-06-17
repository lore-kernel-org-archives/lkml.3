Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaFQHPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:15:30 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:55028 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaFQHP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:15:29 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1402988692.7595.106.camel@i7.infradead.org>
References: <20140613162901.4550.94476.stgit@bling.home>
	<1402983303.3707.94.camel@ul30vt.home>
	<1402988692.7595.106.camel@i7.infradead.org>
Date: Tue, 17 Jun 2014 09:15:28 +0200
X-Google-Sender-Auth: C1Xa1rsDfmaZmL2bUI5V3VXUw80
Message-ID: <CAKMK7uHvHgWY9RX26Shk3LcBNHdzeLjAAsO+LifFNhTKCgTmHg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] iommu/intel: Exclude devices using RMRRs
 from IOMMU API domains
From: Daniel Vetter <daniel@ffwll.ch>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 9:04 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2014-06-16 at 23:35 -0600, Alex Williamson wrote:
>>
>> Any idea what an off-the-shelf Asus motherboard would be doing with an
>> RMRR on the Intel HD graphics?
>>
>> dmar: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
>> IOMMU: Setting identity map for device 0000:00:02.0 [0xbb800000 - 0xbf9fffff]
>
> Hm, we should have thought of that sooner. That's quite normal — it's
> for the 'stolen' memory used for the framebuffer. And maybe also the
> GTT, and shadow GTT and other things; I forget precisely what, and it
> varies from one setup to another.
>
> I'd expect fairly much all systems to have an RMRR for the integrated
> graphics device if they have one, and your patch¹ is going to prevent
> assignment of those to guests... as you've presumably noticed.
>
> I'm not sure if the i915 driver is capable of fully reprogramming the
> hardware to completely stop using that region, to allow assignment to a
> guest with a 'pure' memory map and no stolen region. I suppose it must,
> if assignment to guests was working correctly before?
>
> Perhaps the better answer here is not to have the special cases in
> 'device_is_rmrr_locked()', and instead allow a device driver to call a
> 'iommu_release_rmrrs()' function once it's reset the hardware to *stop*
> doing whatever DMA the BIOS set it up with.

We've always been struggling with stolen handling, and we've' always
been struggling with vt-d stuff. Also pass-through seems to be a major
pain (I've never tried myself). Given all that I'm voting for keeping
the RMRR and everything else as much like for the normal case since I
have no idea what exactly must be remapped and what's optional. The
gpu is definitely keeping a lot of it's own private stuff in various
chunks of stolen memory.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
