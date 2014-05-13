Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaEMU4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:56:02 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36960 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaEMUz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:55:56 -0400
Date: Tue, 13 May 2014 14:55:48 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
Message-ID: <20140513205548.GC22907@obsidianresearch.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-4-git-send-email-arnd@arndb.de>
 <20140509184505.GA30330@arch.cereza>
 <20140509212810.GF18257@obsidianresearch.com>
 <20140509220915.GA391@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509220915.GA391@arch.cereza>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 07:09:15PM -0300, Ezequiel Garcia wrote:
> On 09 May 03:28 PM, Jason Gunthorpe wrote:
> > 
> > > I gave this a try in order to answer Arnd's performance
> > > question. First of all, the patch seems wrong. I guess it's because
> > > readsl reads 4-bytes pieces, instead of 8-bytes.
> > > 
> > > This patch below is tested (but not completely, see below) and works:
> > 
> > Compilers are better now, I think you can just ditch the weirdness:
> > 
> [..]
> > 
> > The below gives:
> > 
> >   c8:   ea000002        b       d8 <orion_nand_read_buf+0x84>
> >   cc:   e5dc0000        ldrb    r0, [ip]
> >   d0:   e7c30001        strb    r0, [r3, r1]
> >   d4:   e2811001        add     r1, r1, #1
> >   d8:   e1510002        cmp     r1, r2
> > 
> > Which looks the same as the asm version to me.
> > 
> 
> Nice! It wasn't really needed but since I have the board here:
> 
> # time nanddump /dev/mtd5 -f /dev/null -q
> real	0m 5.82s
> user	0m 0.20s
> sys	0m 5.60s
> 
> Jason: Care to submit a proper patch?

Sure, but did anyone (Arnd?) have thoughts on a better way to do this:

+#ifdef CONFIG_64BIT
+               buf64[i++] = readq_relaxed(io_base);
+#else
+               buf64[i++] = *(const volatile u64 __force *)io_base;
+#endif

IMHO, readq should exist on any platform that can issue a 64 bit bus
transaction, and I expect many ARM's qualify.

> On 08 May 04:56 PM, Arnd Bergmann wrote:

> Ok, so it takes 5.6 seconds in kernel mode to access 31MB, which
> comes down to 5.60MB/s. That isn't very fast compared to the time
> the CPU should take for those instructions, so I'm surprised it
> actually makes any difference at all.

Likely, what is happening is that the bus interface is holding off
returning the read data until it complets the bus cycles, then the
response travels to the CPU which turns around another.

This creates a dead time where the bus isn't do anything.

The larger bus transfer the CPU can do the less percentage of time the
turnaround takes as overhead.

If the cpu could pipeline two reads then it could be highest-possible,
but I guess the memory ordering for the mapping prevents that??

Regarding DMA, who knows if the interface can handle a burst
transfer..

Jason
