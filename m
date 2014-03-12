Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaCLOF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:05:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49038 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754577AbaCLOF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:05:56 -0400
Date: Wed, 12 Mar 2014 14:05:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-mm@kvack.org,
        Daniel Walker <dwalker@fifo99.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        David Brown <davidb@codeaurora.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-arm-msm@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv4 2/2] arm: Get rid of meminfo
Message-ID: <20140312140522.GI21483@n2100.arm.linux.org.uk>
References: <1392761733-32628-1-git-send-email-lauraa@codeaurora.org> <1392761733-32628-3-git-send-email-lauraa@codeaurora.org> <20140312085401.GB21483@n2100.arm.linux.org.uk> <53205CA1.1090502@ti.com> <20140312133806.GH21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312133806.GH21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:38:06PM +0000, Russell King - ARM Linux wrote:
> Try booting a machine with 2G of RAM with page offset set to 3GB and
> highmem enabled - it will fail as per the above.

BTW, simple way to test this on any ARM platform:

Build with PAGE_OFFSET=3GB and highmem enabled.  Pass vmalloc=1G on the
kernel command line to force maximal vmalloc region (which should push
lowmem down to the minimum of 32MB.)  The remainder will be highmem.

Now, with Laura's patch applied, some platforms do boot but the result
is rather odd:

vmalloc area is too big, limiting to 976MB

So, the vmalloc=1G has done the right thing here, but:

Memory: 507404K/523264K available (3839K kernel code, 230K rwdata, 1388K rodata, 211K init, 5266K bss, 15860K reserved, 0K highmem)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xe0800000 - 0xff000000   ( 488 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
    pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
    modules : 0xbf000000 - 0xbfe00000   (  14 MB)
      .text : 0xc0008000 - 0xc0522f34   (5228 kB)
      .init : 0xc0523000 - 0xc0557fc0   ( 212 kB)
      .data : 0xc0558000 - 0xc0591980   ( 231 kB)
       .bss : 0xc0591988 - 0xc0ab6220   (5267 kB)

something has overriden it, and we end up with no highmem.  Without
Laura's patch, it all behaves correctly:

vmalloc area is too big, limiting to 976MB
...
Memory: 507932K/523264K available (3839K kernel code, 230K rwdata, 1388K rodata, 211K init, 5266K bss, 15332K reserved, 490496K highmem)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
    lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
    pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
    modules : 0xbf000000 - 0xbfe00000   (  14 MB)
      .text : 0xc0008000 - 0xc0522f34   (5228 kB)
      .init : 0xc0523000 - 0xc0557fc0   ( 212 kB)
      .data : 0xc0558000 - 0xc0591980   ( 231 kB)
       .bss : 0xc0591988 - 0xc0ab6260   (5267 kB)

So... the more I look at the boot results from last night's autobuild,
the more stuff appears to be broken with this meminfo removal.

Therefore, I have to wonder what kind of testing was done with these
patches - I suspect the test consisted of "does it boot" without looking
at any of the details about what memory was where.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
