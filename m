Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaEGWuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:50:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15772 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaEGWuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:50:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 May 2014 15:45:57 -0700
Date: Wed, 7 May 2014 15:50:16 -0700
From: Christopher Freeman <cfreeman@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] dma: tegra: avoid int overflow for transferred
 count
Message-ID: <20140507225016.GC20137@nvidia.com>
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
 <1399411343-12222-4-git-send-email-cfreeman@nvidia.com>
 <536A61A3.3050601@wwwdotorg.org>
 <536A865B.1060007@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <536A865B.1060007@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 12:15:39PM -0700, Lars-Peter Clausen wrote:
> On 05/07/2014 06:38 PM, Stephen Warren wrote:
> > On 05/06/2014 03:22 PM, Christopher Freeman wrote:
> >> bytes_transferred will overflow during long audio playbacks.  Since
> >> the driver only ever consults this value modulo bytes_requested, store the
> >> value modulo bytes_requested.
> >
> > The audio driver may only interpret the value modulo bytes_requested,
> > but what about other drivers such as the high-speed UART (and SPI?) drivers?
> >
> > What is the dmaengine API's design requirement here, and what do other
> > dmaengine drivers do. If it's to store the modulo, then I'm fine with
> > this change.
>
> Yep, this part of the API. The residue should be between transfer length and 
> 0. While 0 is special and should only be returned if the transfer has 
> finished. For cyclic transfers this means it should never be zero. So if 
> transferred_bytes is incremented modulo length and residue is length - 
> transferred_bytes you get the correct result.
>
What each driver receives remains unchanged here.  bytes_transferred is only ever read modulo bytes_requested in all cases (audio, spi, uart)  This shifts that part of the calculation to the assignment.  I guess this is a roundabout way of saying it's not any more wrong than it could have possibly been before.  We can rename "bytes_transferred" to something like "residue" or "segment_residue" though.
 
