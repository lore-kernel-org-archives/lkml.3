Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaLJJw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:52:28 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39307 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaLJJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:52:25 -0500
Date: Wed, 10 Dec 2014 17:42:53 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, Yinghai Lu <yinghai@kernel.org>,
        Marek =?iso-8859-1?Q?Kord=EDk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
Message-ID: <20141210094253.GA10445@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
 <1418079372.13358.9.camel@kernel.crashing.org>
 <CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>
 <20141209001119.GA24661@shangw>
 <20141209022601.GA16207@richard>
 <CAE9FiQWz=vdR=QSkoEs5XjUxg_y4vJgnChQAc1-U_9xzfQpknQ@mail.gmail.com>
 <20141209075619.GA23327@richard>
 <CAErSpo5Wj1GScsj6=_=Vv73NSh3D-SCfhEdeK6VOY1AicVUN3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5Wj1GScsj6=_=Vv73NSh3D-SCfhEdeK6VOY1AicVUN3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121009-0029-0000-0000-000000C952B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 11:21:11AM -0700, Bjorn Helgaas wrote:
>On Tue, Dec 9, 2014 at 12:56 AM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:
>
>> As you mentioned in another thread, "5b28541552ef is taking the wrong
>> approach". (http://www.spinics.net/lists/linux-pci/msg37374.html) Maybe I
>> don't catch it clearly. Put a 32bit prefetchable resource in a 32bit
>> non-prefetchable bridge window is a bad idea?
>
>A 32-bit prefetchable resource *can* be put in a 32-bit
>non-prefetchable window, but the device won't perform as well as it
>would if the resource were in a prefetchable window.
>
>What I object to is the fact that we put a 32-bit prefetchable
>resource in the non-prefetchable window and leave the 64-bit
>prefetchable window unused.  This gives up performance for no benefit.
>

OK, I get your point. This is really a waste to put a 32-bit prefetchable
resource in non-prefetchable window and no one use the 64-bit prefetchable
window. (That's very interesting even no performance lost by doing so as
mentioned in reply from Marek. Maybe the reason is the most important IO is
performed in DMA.)

Below is what's in my mind, if not correct please let me know.

1. Yinghai's patch needs a little modification

Now back to Yinghai's patch. If this patch wants to apply this logic it should
check all prefetchable resource, including M64 and non-M64 

  if *none* of them has M64 prefetchable resource, then clear the M64 flag in
  bridge.

But the logic in patch is

  if *any* of them has non-M64 prefetchable resource, then clear the M64 flag 
  in bridge.


2. Yes, the strategy will improve the performance in some case, but with
limited case.

Then suppose we use the strategy, clear the M64 flag in bridge when none of
the child resource need it. 

I imagined this scenario:

                       +--------------+
                       |B1            |
                       +------+-------+
                              |  Bus#1
            ---+--------------+-------------------+----
               |  Bus#2                           |  Bus#3
        +------+------+                    +------+-------+
        |B2           |                    |B3            |
        +-------------+                    +--------------+
	res[1] 32-bit non-pref             res[1] 32-bit non-pref
	res[2] 64-bit pref                 res[2] 32-bit pref

Suppose we have a PCI sub-tree like this. And suppose all the bus->resource[2]
is with M64 flag before sizing. (The initial value is retrieved in enumeration
stage by pci_read_bridge_bases(). This happens before sizing.)

We will first size Bus#2, then Bus#3, at last Bus#1. As shown in the chart,
    For Bus#2, there is a 64-bit pref, so Bus#2->resource[2] with M64 flag set.
    For Bus#3, there is no 64-bit pref, so Bus#3->resource[2] with M64 flag
    cleared.
    Then up to Bus#1, since there is a 64-bit prefetchable resource, the
    Bus#1->resource[2] is with M64 flag set.

The final B1's window will look like this:

         +--------------------------------------+
         | B1                                   |
         |                                      |
	 | res[1] 32-bit non-pref               |
         | +---------+----------+----------+    |
	 | |B2.res[1]| B3.res[1]| B3.res[2]|    |
         | +---------+----------+----------+    |
	 |                                      |
         | res[2] 64-bit pref                   |
         | +----------------+                   |
         | |B2.res[2]       |                   |
         | +----------------+                   |
         +--------------------------------------+

>From the performance perspective: 

  B3.res[2] will bring some performance improvement to those devices under it.
  But from its grand parent's point of view, B3.res[2] still sits under a
  non-prefetchable window. So the performance improvement will be limited. Hope
  my understanding is correct.
  
  So the best case for the performance improvement is all this PCI tree has no
  64-bit prefetchable resource.

>From the resource sizing/allocation perspective:
  
  B3.res[2] still contribute to the root's non-prefetchable window, once
  there is a 64-bit prefetchable in the PCI tree. If we don't have enough
  non-prefetchable window in root, we would fail.

Bjorn, I agree to apply the logic you mentioned to clear the M64 flag when no
child need it. But the benefits is limited. 

I did a grep on the lspci -vvv output and see there is no 64-bit prefetchable
BAR in the system.

$ grep Region lspci | grep Me
	Region 0: Memory at febff400 (32-bit, non-prefetchable) [size=1K]
	Region 0: Memory at febf8000 (64-bit, non-prefetchable) [size=16K]
	Region 0: Memory at febff000 (32-bit, non-prefetchable) [size=1K]
	Region 5: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
	Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 2: Memory at fdff0000 (32-bit, non-prefetchable) [size=64K]
	Region 0: Memory at fe0c0000 (64-bit, non-prefetchable) [size=256K]
	Region 0: Memory at fe1fe000 (64-bit, non-prefetchable) [size=8K]
	Region 0: Memory at feaffc00 (32-bit, non-prefetchable) [size=1K]

I think this is the reason why this patch could help on this case.

3. Not sure why the non-prefetchable window becomes bigger on 3.16

I past the fragment of /proc/iomem from Marek.

3.15 good version

c0000000-ffffffff : PCI Bus 0000:00
  c0000000-cfffffff : PCI Bus 0000:01
    c0000000-cfffffff : 0000:01:00.0
  d0000000-d01fffff : PCI Bus 0000:08
  ddf00000-dfefffff : PCI Bus 0000:06
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : pnp 00:0b
  fdf00000-fdffffff : PCI Bus 0000:01
    fdfc0000-fdfdffff : 0000:01:00.0
    fdff0000-fdffffff : 0000:01:00.0

3.16 bad version

c0000000-ffffffff : PCI Bus 0000:00
  c0000000-c01fffff : PCI Bus 0000:01
  c0200000-c03fffff : PCI Bus 0000:08
  ddf00000-dfefffff : PCI Bus 0000:06
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : pnp 00:07
  fdf00000-fdffffff : PCI Bus 0000:01
    fdfc0000-fdfdffff : 0000:01:00.0
    fdff0000-fdffffff : 0000:01:00.0

On 3.15, one BAR in device 01:00.0 is allocated from c0000000-cffffffff. While
on 3.16, we need to allocate the same BAR from fdf0000000 range. But we see
this range keeps the same size as in 3.15. I don't catch the reason for this.

My thoughts is if we could have a bigger range in fdf00000, the non-prefetch
window in Bus#01, the Graphic card could work too.

>> But in my mind, if the bridge           
>> prefetchable window is 64bit, we can't put a 32bit prefetchable resource in
>> it.
>
>If the window is programmed to be above 4GB, of course we can't put a
>32-bit resource in it.  My point is that if the bridge *supports* a
>64-bit prefetchable window, we can decide where to place it.  If we
>put the window below 4GB, we can put a 32-bit prefetchable resource in
>it.

Yes, agree.

If the 64-bit prefetchable window contains some space under 4G, we could put
some 32-bit prefetchable resource in it. But this would bring more complexity
to the sizing algorithm. We need a separate value to track the size below 4G
in 64-bit prefetchable window, then to see who would have the luck to fit in.
And those can't the ticket would be sit in non-prefetchable window.

>
>I think maybe you're thinking of "64-bit window" as "a window
>programmed to be above 4GB."  I'm using "64-bit window" to mean "a
>window that supports 64-bit addressing," i.e., one where
>PCI_PREF_BASE_UPPER32 and PCI_PREF_LIMIT_UPPER32 are implemented.
>That's analogous to the way we talk about 64-bit BARs.  A 64-bit BAR
>is still a 64-bit BAR even if it is currently programmed to be below
>4GB.

Thanks for reminding. It makes me more clear.

Let me make my statement more clear.

If the 64-bit window is enabled, like the
PCI_PREF_BASE_UPPER32/PCI_PREF_BASE_UPPER32 is set. And this address is set
the M64 flag, which means the range contains space above 4G. In this case, we
can't put a 32-bit resource in this window.

If my understanding is not correct, please let me know.

>
>Bjorn

-- 
Richard Yang
Help you, Help me

