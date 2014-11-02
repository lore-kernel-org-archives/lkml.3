Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaKBMLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 07:11:45 -0500
Received: from pepin.polanet.pl ([193.34.52.2]:42735 "EHLO pepin.polanet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKBMLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 07:11:42 -0500
Date: Sun, 2 Nov 2014 13:11:39 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141102121139.GA7000@polanet.pl>
References: <20141102102212.GA7034@polanet.pl>
 <20141102103300.GB5229@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <20141102103300.GB5229@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 11:33:00 +0100, Borislav Petkov wrote:

> Not enabling it on 32-bit was a conscious decision for the simple reason
> that with the current DIMM sizes, you can have 1 or 2 DIMMs tops which
> you can use on 32-bit and having a fat driver mapping memory errors to
> DIMMs in that case does seem like a waste of time, energy, resources...
> you name it.

In my case it's not about mapping but Detection.

=== begin story ===

Recently my PostgreSQL db failed with:

invalid page header in block 240 of relation base/49095/161613

which was fortunately 'fixed' by:

echo 1 > /proc/sys/vm/drop_caches

It turned out that there were on-disk differences between RAID1 (md)
components, not only shown by next run of mdadm-checkarray, but also
visible in actual filesystem after splitting RAID1 into separate
volumes. There were no problems registered in S.M.A.R.T. logs, but
_somehow_ my data got corrupted and I got not a single diagnostic tool
available. There were no power outages or any other abrupt events, it
just happened, without any reason. I've found some page cache corruption
reports on the net, but none of those matched my conditions.

Currently I'm using checksums at application level (available since
PostgreSQL 9.3) and FS level (BTRFS) and EDAC for 4x1 GB ECC UDIMM
(I did replace 2x2 GB non-ECC with these).

If I could I'd use block-level checksumming or setup RAID1 to
scrub-on-read mode, as this system has very low usage volume and I don't
care about performance at all. Unfortunately SATA T13 didn't made it to
the market, and SCSI drives with DIF/DIX are overkill for this system.

=== end story ===


There is absolutely no reason for you to forbid me using EDAC.

And your reasoning is flawn because:

1. I got 4 pieces of 1 GB ECC UDIMM, not 1 or 2 as you stated; isn't it
   supported config? or maybe you would like to replace my modules with
   4 GB one free of charge (shipping included)?
2. It is my time, energy and resources, it's not up to you to decide how
   I'm going to waste them. What next, removing support for power-hungry
   CPUs? Anyway Poland recently got free CO2 emmisions in EU commision;)
3. If _that_ was the reason, why didn't you made it straightforward
   by depending on HIGHMEM64G? Because such ridiculous condition would
   be soon removed?
4. You could apply the same logic to all the other EDAC modules - next
   to the system mentioned above I got some real server boards, some of
   them running 32-bit kernel with ECC FBDIMMs and first from the top:
	config EDAC_I5000
	depends on EDAC_MM_EDAC && X86 && PCI
   Actually there are only 2 X86_64 dependencies in drivers/edac/Kconfig:
   EDAC_SBRIDGE and EDAC_AMD64 - would you 'fix' every X86 as pointless?
5. If you want to prevent this module from loading when only 1 or 2
   DIMMs are installed, just wire this into the module; I got 4 modules.
   Anyway, even with just 1 module installed, I'd like to know error
   rates to be aware of memory module/controller quality and replace it
   when failing too often.

> I guess I'll add a note about this in the Kconfig text because I keep
> getting patches about this once every couple of months :-)

...so, didn't you think that maybe someone needs this?!

Once again: the circuits are working, there is no technical reason not
to use them. It's up to the owner to decide whether it makes sense.

regards,
-- 
Tomasz Pala <gotar@pld-linux.org>
