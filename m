Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3JQI1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 04:27:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3JQI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:27:52 -0400
Date: Thu, 17 Oct 2013 10:27:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
In-Reply-To: <20131017020745.GA14013@intel.com>
Message-ID: <Pine.LNX.4.64.1310170851230.27369@axis700.grange>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:IQvdk3Pvq2EDm+Tp3lxFNo+PYa7bQ2sdUZAKJkeIXsB
 HHp2aUnhwH+59MjqmP9rwji3p83n4SVz/rAIEFOULFu7hpxC8b
 J18rILBHm3aPRJUTuUqwYLAbj9ku0uK6fDQ0T9cXdC6csG0V8l
 PLafJzRixaYMwF6R7pjhDD2+On3mqQlg04bCg78K8BpUmEFQ1r
 8YdB94LqTiFMDU6Ry4km0d8I2fQxTR+/KvL7IghljR2Ugej1eD
 G1aczlZnsB3THjNBeENQefkfqZikdtI9UVUCyZYXX3Y3HZwwRX
 HitfNpi0/bxh+MjR+T00Lona0NIRxi3kH2P2fX4P5W7u0LPkBL
 QYuKaMqn4qR18rvz3Awm8E+DVbEnfh/Y07iMPxsaulDv3kpVMR
 Bhww2SqtLi5fg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Vinod Koul wrote:

> On Wed, Oct 16, 2013 at 11:45:48AM -0700, Dan Williams wrote:
> > On Wed, Oct 16, 2013 at 11:29 AM, Guennadi Liakhovetski
> > >
> > > Doesn't this break kernel compilation for a total of 27 commits? Or am I
> > > missing anything?
> > 
> > Yes, I think at the start DMA_COMPLETE should just be a alias for
> > DMA_SUCCESS, then after all the driver renames are in delete
> > DMA_SUCCESS.
> Oops, taht was bad of me. ffixes in v2 and sending patch 29 for removal case

Ok, yes, this should work now. I'm wondering though - is DMA_COMPLTE 
really a better name? AFAICS, we can only differentiate between 2 
possibilities with the current API: a transfer is "in progress" - between 
last used and last completed, and "unknown" - either completed, or 
aborted, or not yet submitted - if the cookie is larger, than last 
completed and we assume, that it has wrapped.

Actually for a driver, that I'm currently working on, I implemented a 
cache of N last cookies (e.g. 128), which is a bitfield, where I just 
record a 1, if that descriptor has failed, and a 0, if completed 
successfully. That way I can report one of 4 states: cookie on queue, 
completed successfully, failed, unknown. I'm not sure, whether I'll keep 
this in the final version, this doesn't really fit the present dmaengine 
API concept. We could make this generic, if desired. Otherwise your 
proposed error callback should help too. But in either case I think with 
the current implementation we cannot find out whether a specific cookie 
completed successfully or failed.

One more observation: I looked at a couple of drivers, using the DMA_ERROR 
state. E.g. mmp_tdma.c, mxs-dma.c. They store errors in a .status field in 
their private data. Then they return that status in their 
.device_tx_status() methods - independent on the cookie! This doesn't look 
right to me... at_hdmac.c does something similarly strange.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
