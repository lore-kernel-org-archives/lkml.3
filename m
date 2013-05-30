Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967403Ab3E3DPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:15:08 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45664 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3E3DPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:15:02 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.32 with qID r4U3EdhK003049, This message is accepted by code: ctloc85258
From: Bard Liao <bardliao@realtek.com>
To: Mark Brown <broonie@sirena.org.uk>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 30 May 2013 11:14:38 +0800
Subject: RE: a question about range_map_cfg
Thread-Topic: a question about range_map_cfg
Thread-Index: Ac5cfLAF8IO3nvngR2WOdGdkZF2SsQAZVugA
Message-ID: <1121E117AD4ECE49880A389A396215BB8A8969905C@rtitmbs7.realtek.com.tw>
References: <1121E117AD4ECE49880A389A396215BB8A89698D14@rtitmbs7.realtek.com.tw>
 <74CDBE0F657A3D45AFBB94109FB122FF2A774AA716@HQMAIL01.nvidia.com>
 <1121E117AD4ECE49880A389A396215BB8A89698FC5@rtitmbs7.realtek.com.tw>
 <20130529145603.GU3660@sirena.org.uk>
In-Reply-To: <20130529145603.GU3660@sirena.org.uk>
Accept-Language: zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@sirena.org.uk]
> Sent: Wednesday, May 29, 2013 10:56 PM
> To: Bard Liao
> Cc: Stephen Warren
> Subject: Re: a question about range_map_cfg
> 
> On Wed, May 29, 2013 at 08:46:40PM +0800, Bard Liao wrote:
> 
> > > However, I /think/ that the window_start/len fields in
> > > regmap_range_cfg are meant to represent the "virtual" registers
> > > numbers of the registers behind the addr/data keyhole, and hence
> > > should be 0x100 and something much larger than 1, respectively. Does that
> solve the problem?
> 
> > In my opinion, window_start represents the address of indirectly accessed
> registers' data.
> > Ie. If we want to access the private register of ALC5640, we should
> > write the private register's address to 0x6a which is defined in .selector_reg.
> > Then read/write it's data from reg 0x6c which is defined in .window_start.
> > And the .window_len represents the data length of indirectly accessed
> register.
> > So if I set .window_len = 2 for example, it will write the private
> > register's address to 0x6a, and read/write 0x6c and 0x6d to access the
> private register's data.
> > But I don't know if my thought is right or not.
> 
> That sounds about right, though obviously that's a *very* small window.
> The window is the physical registers through which the range can be seen, the
> range is the virtual registers where the windowed region is linearised for
> upper layers.
> 
> > I look at regmap-debugfs.c and guess the issue is from
> regmap_debugfs_get_dump_start function.
> > It add debugfs_off_cache list in if (list_empty(&map->debugfs_off_cache))
> condition.
> > So if I cat "PR" first, it will add indirectly accessed registers' range in
> debugfs_off_cache.
> > But after that if I cat "range" or "registers" debugfs_off_cache is not empty.
> > So it will not enter if (list_empty(&map->debugfs_off_cache)) condition.
> > That's why I will only see indirectly accessed registers' data from "range"
> and "registers".
> > In the other case, if I cat "registers" or "range" first,
> > regmap_debugfs_get_dump_start will add all registers'(including directly
> and indirectly accessed registers) range in debugfs_off_cache.
> 
> Yes, the cache should be suppressed in the case where we're not looking at the
> full map.  Try the patch below:
> 
> From c53da2153185cf3f522ce4952e4148aa7287cb89 Mon Sep 17 00:00:00
> 2001
> From: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Date: Wed, 29 May 2013 15:54:54 +0100
> Subject: [PATCH] regmap: debugfs: Suppress cache for partial register files
> 
> The cache is based on the full register map so confuses things if used for a
> partial map.

Unfortunately, it does not work.
Actually, I see from is always 0, so it never enter the "if (from)" condition.


> 
> Reported-by: Bard Liao <bardliao@realtek.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/regmap-debugfs.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/base/regmap/regmap-debugfs.c
> b/drivers/base/regmap/regmap-debugfs.c
> index 98cb94e..5349575 100644
> --- a/drivers/base/regmap/regmap-debugfs.c
> +++ b/drivers/base/regmap/regmap-debugfs.c
> @@ -84,6 +84,10 @@ static unsigned int
> regmap_debugfs_get_dump_start(struct regmap *map,
>  	unsigned int fpos_offset;
>  	unsigned int reg_offset;
> 
> +	/* Suppress the cache if we're using a subrange */
> +	if (from)
> +		return from;
> +
>  	/*
>  	 * If we don't have a cache build one so we don't have to do a
>  	 * linear scan each time.
> --
> 1.7.10.4
> 
> 
> ------Please consider the environment before printing this e-mail.
