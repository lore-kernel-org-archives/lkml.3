Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3CPOAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 10:00:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39294 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab3CPOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 10:00:52 -0400
Date: Sat, 16 Mar 2013 17:00:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 07/50] staging: omap-thermal: introduce RMW_BITS macro
Message-ID: <20130316140042.GK9189@mwanda>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
 <1363352438-15935-8-git-send-email-eduardo.valentin@ti.com>
 <20130315210946.GK9138@mwanda>
 <51446763.5010606@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51446763.5010606@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 08:36:51AM -0400, Eduardo Valentin wrote:
> >But that said, I don't care for the RMW_BITS() very much as a long
> >term thing.  If we just used pointers instead of passing the offset
> >into the bg_ptr->conf->sensors[] array then everything would be a
> >lot cleaner.
> >
> >In other words, instead of this:
> >
> >static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
> >
> >We would have:
> >
> >static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr,
> >				  struct temp_sensor_registers *tsr)
> 
> I see. That will require a change in the whole driver though. If you
> see, the driver as of today uses the former approach, not only for
> read_temp or rmw_bits.

Yep.

> 
> >
> >If you have the pointer then it's easy write RMW_BITS() as a
> >function.
> >
> >static void rmw_bits(struct omap_bandgap *bg_ptr, u32 reg, u32 mask, u32 val)
> >{
> >	u32 r;
> >
> >	r = omap_bandgap_readl(bg_ptr, reg);
> >	r &= ~mask;
> >	r |= val << __ffs(mask);
> >	omap_bandgap_writel(bg_ptr, r, reg);
> >}
> >
> >It's called like:
> >
> >	rmw_bits(bg_ptr, tsr->bgap_mask_ctrl, tsr->mask_freeze_mask, 1);
> 
> This is nice, but it will require fetching tsr from .conf before
> every call o rmw_bits. And for that you need the sensor index.
> 

No.  I'm suggesting that you re-write the driver to pass the tsr
pointer directly instead of the index.

regards,
dan carpenter

