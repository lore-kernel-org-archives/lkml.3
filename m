Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaLDQS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:18:27 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:59509 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaLDQSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:18:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH 1/2] arm64: amd-seattle: Fix dma-ranges property
Date: Thu, 04 Dec 2014 17:17:47 +0100
Message-ID: <2491716.6gErSSjiAc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <D0A3B11F.AAC8%suravee.suthikulpanit@amd.com>
References: <D0A3B11F.AAC8%suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:VSfo7egLNy8Qyx3lE3y96VIov0i5+F9pYUojhWPNPPtTV92k2P9
 1YGLasRu/AAh42fdm+ZozlH3cF7HsewqtjdY+DZicpy0lmc1X2lg/YUpoFqfH/uYuok1pu6
 hIo9Nt1wspETD47q8FZaWIRUMQ7TUKRSHVQxR4pezUoYDxeU/QPBtwCkvAMa05xQODNqCXw
 2QiEz4LgzptNHBuXXYbyw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2014 14:12:48 Suthikulpanit, Suravee wrote:
> 
> Would you minding adding the following detail in the commit message?

I was going to, but then decided not to. It's usually better if you
just send a new patch when requested to update the changelog, so
please do that.
 
> - BEGIN -
> AMD Seattle supports 40-bit DMA, which includes two ranges:
>     1. GICv2m MSI register frame at 0xe0080000
>     2. DRAM range [0x8000000000 to 0xffffffffff]
> 
> Since the current parsing logic handles only single range, this patch
> specifies the range from zero to 0x10000000000 to cover the whole
> 40-bit range.
> 
> However, it expects DMA allocation/mapping logic to check the specified
> DMA range against the reported DRAM range, which starts from
> 0x8000000000 in this case.

Unfortunately the description is (for the most part) wrong:

- It doesn't matter whatsoever what the target of the DMA is or
  how large the DRAM can be. The only thing that matters is the
  transformation that the bus physically performs. If the AXI bus
  is (as you said earlier, though I'm no longer sure about it
  after your text above) limited to 40 bit address, you should
  use the 40-bit mask you gave above. If the 40-bit address is not
  a result of a limitation of the AXI bus but of the memory
  controller, you should just list a full 64-bit mask here.
  In that case, you actually have to use '0xffffffff 0xffffffff'
  as the length, which is one byte short as before, but we can't
  express that otherwise.

- Furthermore it does not matter at all what the Linux implementation
  does. If your hardware does a transformation that the current
  code can't handle, we need to fix the code rather than work around
  the implementation bug by putting incorrect data into the DT.

	Arnd
