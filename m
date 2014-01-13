Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaAMKDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:03:10 -0500
Received: from vps1.hno.se ([31.192.227.87]:49773 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaAMKDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:03:07 -0500
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2014 05:03:07 EST
Message-ID: <1389606496.29053.16.camel@localhost>
Subject: Re: [linux-sunxi] Re: [RFC PATCH 0/9] mtd: nand: add sunxi NAND
 Flash Controller support
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: linux-sunxi@googlegroups.com
Cc: dev@linux-sunxi.org, Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jan 2014 10:48:16 +0100
In-Reply-To: <52D3ABB6.9030204@overkiz.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
		 <52D1494E.9090303@overkiz.com> <1389449230.19197.2.camel@localhost>
		 <52D1541F.4040400@overkiz.com> <1389456075.20989.11.camel@localhost>
	 <1389474709.22660.4.camel@localhost> <52D3ABB6.9030204@overkiz.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mån 2014-01-13 klockan 10:02 +0100 skrev boris brezillon:

> The most complicated part is the boot0 partition.

Not really. It's only a little different (sequential ECC, static
randomizer seed on every page).

> Tell me if I'm wrong, but here's what I understood from your work (and 
> yuq's work too):
> 
> boot 0 part properties:
> - uses sequential ECC

Yes

> - uses 1024 bytes ECC blocks

Seems to support a couple modes.

> - boot0 code is stored only on the first ECC block of each page (1024 
> bytes + ecc bytes)

No, it reads a whole page at a time in sequental mode
(data,ecc,data,ecc,data,ecc,data,ecc...).

> - boot0 code is stored on the first 64 pages of the first block

boot0 is restricted in size by available memory size (24KB max). 

iirc multiple blocks is tried until a valid one is found.

also I am pretty sure boot1 is stored using the same flash format, but
have not looked in detail at how boot0 reads boot1 as it's a detail of
boot0 software implementation and not needed when using u-boot.

> - boot0 uses HW randomizer with a specific rnd seed (0x4a80)

Yes.

> It's not that complicated to read/write from/to boot0, but it's a bit 
> more to mainline this
> implementation:

Ah, yes. It's different.

But isn't there other SoCs having similar issue with NAND boot blocks?
Maybe some guidance can be found there?

Qiang Yu (yuq) selected to implement the sunxi boot area driver using a
custom character device in his attempt in writing a sunxi mtd driver.
That approach works, but can't comment on if it's the right approach or
not.

   https://github.com/yuq/sunxi-nfc-mtd

>   - the nand chip must use the same ECC algorithm and ECC layout on the 
> whole flash
>     (no partition specific config available)

iirc there is an interface for dynamically selecting ECC mode and other
parameers. Or maybe that's only u-boot mtd?

> - you cannot mark some part of pages as unused => the nand driver will 
> write the
>    whole page, not just the first ECC block (1024 bytes)

Not sure what you mean. Why would something be marked as unused? The
boot area is not a filesystem, it is a single linear blob (or two if
boot1 is in the same format, but mostly irrelevant).

> I thought about manually creating an mtd device that fullfils these 
> needs (in case we
> encounter the "allwinner,nandn-boot" property on a nand@X node), but I'm 
> not sure
> this is the right approach.

Would work, if you also can make sure the two do not stomp on each
others. Should be divided by NAND block range.

Regards
Henrik

