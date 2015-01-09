Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbbAIX1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:27:20 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59253 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbbAIX1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:27:17 -0500
Date: Fri, 9 Jan 2015 23:27:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150109232707.GA6325@e104818-lin.cambridge.arm.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
 <54AE7D53.2020305@redhat.com>
 <20150108134520.GC14200@e104818-lin.cambridge.arm.com>
 <54AEBE84.6090307@redhat.com>
 <20150108173408.GF17290@e104818-lin.cambridge.arm.com>
 <54AED10C.7090305@redhat.com>
 <CA+55aFwpwkjRnTzBe2K0y+2DOH1F=5SpJkYe=P5z8ps5_1PQHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwpwkjRnTzBe2K0y+2DOH1F=5SpJkYe=P5z8ps5_1PQHQ@mail.gmail.com>
Thread-Topic: Linux 3.19-rc3
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 07:21:02PM +0000, Linus Torvalds wrote:
> The only excuse for 64kB pages is "my hardware TLB is complete crap,
> and I have very specialized server-only loads".

I would make a slight correction: s/and/or/.

I agree that for a general purpose system (and even systems like web
hosting servers), 64KB is overkill; 16KB may be a better compromise.

There are however some specialised loads that benefit from this. The
main example here is virtualisation where if both guest and host use 4
levels of page tables each (that's what you may get with 4KB pages on
arm64), a full TLB miss in both stages of translation (the ARM
terminology for nested page tables) needs up to _24_ memory accesses
(though cached). Of course, once the TLB warms up, there will be much
less but for new mmaps you always get some misses.

With 64KB pages (in the host usually), you can reduce the page table
levels to three or two (the latter for 42-bit VA) or you could even
couple this with some insanely huge pages (512MB, the next up from 64KB)
to decrease the number of levels further.

I see three main advantages: the usual reduced TLB pressure (which
arguably can be solved with bigger TLBs), less TLB misses and, pretty
important with virtualisation, the cost of the TLB miss due to a reduced
number of levels. But that's for the user to balance the advantages and
disadvantages you already mentioned based on the planned workload (e.g.
host configured with 64KB pages while guests use 4KB).

Another aspect on ARM is the TLB flushing on (large) MP systems. With a
larger page size, we reduce the number of TLB operation (in-hardware)
broadcasting between CPUs (we could use non-broadcasting ops and IPIs,
not sure they are any faster though).

-- 
Catalin
