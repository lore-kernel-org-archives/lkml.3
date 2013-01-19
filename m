Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3ASQZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 11:25:44 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:51360 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3ASQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 11:25:43 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <50FAC61A.9060503@ionic.de>
References: <50F9DF53.4090601@ionic.de>
	<CAKMK7uExHc=PEBpn2vPrX+sQcv=U7VuvsJHRxc-SSOh=_G_1Dg@mail.gmail.com>
	<50FAC61A.9060503@ionic.de>
Date: Sat, 19 Jan 2013 17:25:41 +0100
Message-ID: <CAKMK7uFqW4Farb8Ki-6PCkFfYM-foNWZxfPKzEJeh4-stpNofA@mail.gmail.com>
Subject: Re: i915-related and general system freezes with specific kernel
 config // IOMMU
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 5:13 PM, Mihai Moldovan <ionic@ionic.de> wrote:
>> [...] and we've never added the proper
>> quirks. See https://bugzilla.kernel.org/show_bug.cgi?id=51921 for a
>> proposed patch to fix this (i.e. automatically set
>> intel_iommu=igfx_off for affected platfroms). Testing highly welcome.
>
> From a quick glance, I don't think this patch will work as-is, my PCI ID 2e12 is
> missing.
> I'll add it to the relevant section.

The quirk matches your pci host bridge, which should have id 2e10, not
the gfx, which has id 2e12.

> But even if it worked, I'd still have the "box freezes randomly" issue (mostly
> within 5 to 60 minutes of uptime). :(
> The only way to get rid of this is disabling Intel IOMMU as a whole via kernel
> parameters intel_iommu=off iommu=off.

Hm, can you try enabling the related iommu quirk:

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b9d0911..e834395 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4251,6 +4251,7 @@ static void quirk_iommu_rwbf(struct pci_dev *dev)
 }

 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e10, quirk_iommu_rwbf);

 #define GGC 0x52
 #define GGC_MEMORY_SIZE_MASK   (0xf << 8)

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
