Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaLCOUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:20:14 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:1271 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbaLCOUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:20:12 -0500
Message-ID: <547F1C11.5090408@free.fr>
Date: Wed, 03 Dec 2014 15:20:01 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Creating 16 MB super-sections for MMIO
References: <547D97A5.4090302@free.fr> <547EDD61.5080907@free.fr> <20141203103211.GB7373@e104818-lin.cambridge.arm.com>
In-Reply-To: <20141203103211.GB7373@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Catalin,

On 03/12/2014 11:32, Catalin Marinas wrote:

> The reasons behind this proposal aren't clear. Are you trying
> to optimise mmio register accesses by avoiding TLB misses?

I am trying to minimize TLB "pollution" by using a "huge" page.

The ARM manual states: "Support for Supersections, Sections and
Large pages enables a large region of memory to be mapped using
only a single entry in the TLB."

Is it correct that, if I create a virtual-to-physical mapping of
an 8 MB memory region, then, in the best-case scenario, the kernel
will create 8 Sections? Thus my mapping would use up to 8 entries
in the TLB at any given time.

Instead, if I create a V2P mapping of a 16 MB region, and if the
kernel supports so-called Super-sections, then the mapping would
use only a single entry in the TLB. Right?

Thus creating a Super-section leaves more TLB entries available
for user-space processes and kernel threads, which can only
improve system performance, AFAIU.

On my SoC, physical addresses 0 to 2^24 are reserved for device
memory-mapped registers. There are holes in the region (meaning
addresses that don't map to any register) but the bus is defined
in such a way that
- writing to a hole is a NOP,
-reading from a hole returns 0.

So I'd like to map
physical addresses 0-2^24
to
virtual addresses 0xf000_0000 - 0xf100_0000
using a Super-section.

And I was hoping that calling iotable_init with a struct map_desc
entry where length = SZ_16M would create such a super-section.

Did that make sense?

As far as I could tell, Linux does not create a super-section in the
case outlined above. Perhaps I misread the source code?

Regards.

