Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaAMJDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:03:07 -0500
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:36300 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751358AbaAMJCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:02:54 -0500
Message-ID: <52D3ABB6.9030204@overkiz.com>
Date: Mon, 13 Jan 2014 10:02:46 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVucmlrIE5vcmRzdHLDtm0=?= <henrik@henriknordstrom.net>
CC: dev@linux-sunxi.org, Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-sunxi] Re: [RFC PATCH 0/9] mtd: nand: add sunxi NAND Flash
 Controller support
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>	 <52D1494E.9090303@overkiz.com> <1389449230.19197.2.camel@localhost>	 <52D1541F.4040400@overkiz.com> <1389456075.20989.11.camel@localhost> <1389474709.22660.4.camel@localhost>
In-Reply-To: <1389474709.22660.4.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12384054552448628832
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On 11/01/2014 22:11, Henrik Nordström wrote:
> <bbrezillon> thanks for pointing out your documents
> <bbrezillon> I'm trying to get the NAND driver with HW ECC (and HW RND)
> without using DMA at all
>
> I tried many things but did not quite get the ECC reading command to
> return meaningful resuts. But should work somehow.
>
> <bbrezillon> do you have any other information I could use to do this ?
>
> Not really. There is no known code to look at using the nand controller
> without DMA. All allwinner code uses DMA even the boot ROM (BROM).
>
> <bbrezillon> For example, I wonder why there are 2 RAM sectors (the
> driver I found only make use of RAM0)
>
> I think it's used during DMA to fetch next sector while the previous one
> is transferred by DMA. But not sure.

Some feedback on my tests:

- I managed to get HW ECC working without any DMA transfer (using CMD = 01):
   * I only tested the sequential ECC => ECC are stored between 2 data 
blocks (1024 byte)
   * Non sequential ECC should work if I store ECC bytes in the OOB area 
too (I'll just have
      to send RANDOM_OUT commands to move to the OOB area before sending 
the ECC
      cmd and another RANDOM_OUT to go back to the DATA area)

- The HW RND (randomizer) works too, I'll just have to figure out how 
this could be
   mainlined:
    * using a simple dt property to tell the controller it should enable 
the randomizer
    * provide an interface (like the nand_ecc_ctrl struct ) for other to 
add their own
       randomizer implementation (this was requested: 
https://lkml.org/lkml/2013/12/13/154)


The most complicated part is the boot0 partition.

Tell me if I'm wrong, but here's what I understood from your work (and 
yuq's work too):

boot 0 part properties:
- uses sequential ECC
- uses 1024 bytes ECC blocks
- boot0 code is stored only on the first ECC block of each page (1024 
bytes + ecc bytes)
- boot0 code is stored on the first 64 pages of the first block
- boot0 uses HW randomizer with a specific rnd seed (0x4a80)

It's not that complicated to read/write from/to boot0, but it's a bit 
more to mainline this
implementation:
  - the nand chip must use the same ECC algorithm and ECC layout on the 
whole flash
    (no partition specific config available)
- you cannot mark some part of pages as unused => the nand driver will 
write the
   whole page, not just the first ECC block (1024 bytes)

I thought about manually creating an mtd device that fullfils these 
needs (in case we
encounter the "allwinner,nandn-boot" property on a nand@X node), but I'm 
not sure
this is the right approach.

Any ideas ?


Best Regards,

Boris
>
> Regards
> Henrik
>

