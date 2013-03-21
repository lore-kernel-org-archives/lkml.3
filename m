Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3CUU4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:56:08 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:41074 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab3CUU4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:56:06 -0400
Date: Thu, 21 Mar 2013 14:55:45 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Lior Amsalem <alior@marvell.com>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
Message-ID: <20130321205545.GA8358@obsidianresearch.com>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
 <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
 <20130321201533.GN21478@lunn.ch>
 <20130321212236.1015295d@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321212236.1015295d@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:22:36PM +0100, Thomas Petazzoni wrote:

> And I'm not sure the SDRAM address decoding windows allows to split the
> first 4 GB of RAM into two areas, one that would be mapped starting at
> physical address 0x0, and another area that would be mapped at a
> different address (above 4 GB).

On prior Marvell chips the SDRAM is mapped on a rank by rank basis, so
each rank can be placed in DRAM properly.
 
> However, I'm unsure why 0xC0000000 was chosen. Why not 0xD0000000,
> where the internal registers currently start?

Probably because the 8GB is composed of 4 2GB ranks and what was done
is to map like this:

  Rank 0 ->           0 ->  0x80000000 (2G)
  Rank 1 -> 0x080000000 -> 0x0C0000000 (2G rank, 1G mapped)
  Rank 2 -> 0x100000000 -> 0x180000000
  Rank 3 -> 0x180000000 -> 0x300000000

The ranks must be power of two sizes, and aligned to their size,
so it isn't possible to get closer to 0xD0000000.

To recover the lost RAM the entire rank would need to be located
above 4G.

Or, better, locate all the internal registers above 8G and use
contiguous DRAM mapping from 0 -> 8GB

Linux is sensitive to the ratio of high/low memory, if that gets too
big it struggles, maximizing low memory is desirable - I assume ARM is
basically the same as x86 in this regard?

> So why not map the whole SDRAM above 4GB physical address?

I think the no-MMU boot mode would break if this was done?

Jason
