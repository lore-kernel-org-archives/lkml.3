Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaHDKM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:12:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43412 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbaHDKMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:12:21 -0400
Date: Mon, 4 Aug 2014 12:12:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] iommu/amd: Implement syscore_ops.shutdown()
Message-ID: <20140804101217.GA4808@pd.tnic>
References: <20140801225049.GC4553@pd.tnic>
 <1406946339-4297-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406946339-4297-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 10:25:39AM +0800, Jiang Liu wrote:
> During hibernation or shutdown, AMD iommu generates warnings on some
> platforms as below:
> [   89.089832] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000080 flags=0x0020]
> [   89.102239] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000000 flags=0x0000]
> [   89.114684] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.127162] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.139576] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.152017] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.164481] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> 
> It may be caused by that the firmware takes back the device after the OS
> released it and now the legacy emulation tries to do DMA with it. But
> since there is an IOMMU the physical addresses it tries to DMA to is
> not mapped and it generated IO page faults. So explicitly shutdown
> IOMMU units during hibernation or poweroff.

Unfortunately, this doesn't help. The current observation is that I
don't get the IOPFs during *every* suspend-to-disk cycle but I do get
them from time to time. Here are all IOPFs from 10ish suspend/resume
cycles with this patch. The newlines between them show how the IOPFs
happen: sometimes it is the GPU (device 01:00.0) with a single IOPF...

[   78.482122] AMD-Vi: Event logged [IO_PAGE_FAULT device=01:00.0 domain=0x0014 address=0x0000000020001000 flags=0x0000]

[  171.593660] AMD-Vi: Event logged [IO_PAGE_FAULT device=01:00.0 domain=0x0014 address=0x0000000020001000 flags=0x0000]

and sometimes it is the GPU and OHCI0 with multiple ones.

[  280.680624] IO_PAGE_FAULT device=01:00.0 domain=0x0014 address=0x0000000020001000 flags=0x0000]
[  280.694539] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000080 flags=0x0020]
[  280.707917] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000000 flags=0x0000]
[  280.721234] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[  280.734565] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[  280.747877] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[  280.761227] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[  280.774444] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[  290.686170] AMD-Vi: Event logged [IO_PAGE_FAULT device=01:00.0 domain=0x0014 address=0x0000000020001000 flags=0x0000]

[   49.393307] IO_PAGE_FAULT device=01:00.0 domain=0x0014 address=0x0000000020001000 flags=0x0000]

Other than that, the box is fine AFAICT.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
