Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3EOHw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:52:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:62086 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab3EOHw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:52:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,675,1363158000"; 
   d="scan'208";a="334297167"
Message-ID: <1368604536.13665.25.camel@sauron.fi.intel.com>
Subject: Re: MTD : cannot reserve enough PEBs for bad PEB handling
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@newflow.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Wed, 15 May 2013 10:55:36 +0300
In-Reply-To: <51750526.70508@newflow.co.uk>
References: <51750526.70508@newflow.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 10:38 +0100, Mark Jackson wrote:
> I'm trying to work out how to generate a "valid" UBI image, but I keep
> getting a "cannot get enough PEBs" warning.
> 
> I generate my image (destined for a 64MB NAND partition) using:-
> 
> $ mkfs.ubifs -d output/target -e 0x1f000 -c 483 -m 0x800 -x none -F -o
> output/images/rootfs.ubifs
> $ ubinize -o output/images/rootfs.ubi -m 0x800 -p 0x20000 -s 512 -O 2048
> ubinize.cfg
> 
> My .cfg file is:-
> 
> [ubifs]
> mode=ubi
> vol_id=0
> vol_type=dynamic
> vol_name=rootfs
> vol_alignment=1
> vol_flags=autoresize
> vol_size=61MiB
> image=output/images/rootfs.ubifs
> 
> And the resulting image is:-
> 
> -rw-rw-r-- 1 mpfj mpfj 9437184 Apr 16 10:19 rootfs.ubi
> 
> This is then written to a freshly erased 64MB NAND partition, and
> appears to mount correctly, apart from the warning about not enough
> reserved PEBs, as follows:-
> 
> ...
> [    0.792456] UBI: attaching mtd7 to ubi0
> [    1.540858] UBI: scanning is finished
> [    1.557578] UBI warning: print_rsvd_warning: cannot reserve enough
> PEBs for bad PEB handling, reserved 4, need 40
> [    1.561346] UBI: attached mtd7 (name "rootfs", size 64 MiB) to ubi0
> [    1.561404] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
> [    1.561434] UBI: min./max. I/O unit sizes: 2048/2048, sub-page size 512
> [    1.561464] UBI: VID header offset: 2048 (aligned 2048), data offset:
> 4096
> [    1.561493] UBI: good PEBs: 512, bad PEBs: 0, corrupted PEBs: 0
> [    1.561520] UBI: user volume: 1, internal volumes: 1, max. volumes
> count: 128
> [    1.561554] UBI: max/mean erase counter: 2/1, WL threshold: 4096,
> image sequence number: 1434266085
> [    1.561591] UBI: available PEBs: 0, total reserved PEBs: 512, PEBs
> reserved for bad PEB handling: 4
> [    1.562374] UBI: background thread "ubi_bgt0d" started, PID 598
> ...
> 
> I think I've calculated the various option values correctly for
> mkfs.ubifs and ubinize.
> 
> But since I'm getting the warning, can anyone explain where I've gone
> wrong ?

This is because UBI is trying to reserve 40 PEBs for bad block handling.
Why so much? See the explanations here:

http://www.linux-mtd.infradead.org/doc/ubi.html#L_max_beb

You may adjust this value, but the default for UBI is the most
pessimistic scenario.

-- 
Best Regards,
Artem Bityutskiy

