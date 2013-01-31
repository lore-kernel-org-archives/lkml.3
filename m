Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3AaWZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:25:31 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49889 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3AaWZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:25:27 -0500
Date: Thu, 31 Jan 2013 17:25:59 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] dmaengine: add per channel capabilities api
Message-ID: <20130131222559.GK2244@beef>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <abcd725c6216491da2b1054e5e11ad82@DFLE72.ent.ti.com>
 <20130120163735.GC21407@beef>
 <c4113bae604945b586e9613814be737a@DLEE74.ent.ti.com>
 <20130121181922.GD10020@beef>
 <f97c0fe89e4643069c177f549a2e5628@DLEE74.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f97c0fe89e4643069c177f549a2e5628@DLEE74.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 10:06:03AM +0000, Vinod Koul wrote:
> On Mon, Jan 21, 2013 at 01:19:23PM -0500, Matt Porter wrote:
> > > b) Sg segment length and numbers: Well these are capabilities, so it tells
> > > you what is the maximum I can do. IMO it doesn't make sense to tie it down to
> > > burst, width etc. For that configuration you are checking maximum. What this
> > > needs to return is what is the maximum length it supports and maximum number of
> > > sg list the h/w can use. Also if you return your burst and width capablity, then
> > > any client can easily find out what is the length byte value it can hold.
> >  
> > Ok, so I could report the max burst size to the client, but on EDMA it's
> > going to be SZ_64K-1, as that's the hw limit. Max addr width would also
> > be the same or capped at the maximum enum the current API support of 8
> > bytes.
> Yes IMO you should report the h/w limit and let client deduce what can be done
> with that h/w limit given the other parameters (burst, length etc...)

Hrm, in a driver that runs on two different DMACs, we don't know which
one we are running on in order to determine if the information returned
is relevant to do a calculation. If omap_hsmmc.c is running on SDMA the
absolute max_seg_len may be fixed. On EDMA, that max values can be
returned but is invalid for purposes of computing the actual length of
sg segments that can be absorbed by the driver.

The client driver does know the burst and length, and could compute this
in an EDMA specific way, but we're talking now about in the client
driver is:

if (i_am_edma)
	max_seg_len = (SZ_64K-1) * max_burst * addr_width;
else /* sdma */
	max_seg_len = MY_FIXED_VALUE_FROM_CHANNEL_CAPS;

There's no way to deduce what to do in the client driver without having
the knowledge of being on an EDMA DMAC or not. The only thing to do with
fixed h/w caps is to report back a safe value. That would be SZ_64K-1
but would be very inefficient when the slave config is set for a large
FIFO and 32-bit address width and the actual size that can be
transferred if much larger.

> > 
> > This information is not useful to the client in my case. Only the client
> > knows its FIFO size, and thus the actual burst size it needs to request
> > as that is a value specific to the IP the client driver controls. So it
> > knows actual burst size and the width of that fifo transfer, because we
> > already support telling the dmaengine driver this info in the current
> > API.
> Your current API way is not very generic. We need to make sure it useful on
> other systems too. That is why it would make sense to query the DMA H/W
> capablities and then use it with above properties to get various parameters used
> for initiating a transfer, that way you dont need to set slave parameters
 
Ok, you want something then that takes max_burst and addr_width as
arguments and returns max_seg_len. Easy enough. That's the minimum
information the driver needs to report the value and will avoid having
to set the slave config first.

-Matt
