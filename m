Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbaLQQNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:13:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48736 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaLQQN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:13:28 -0500
Date: Wed, 17 Dec 2014 11:13:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH] xen/blkfront: increase the default value of
 xen_blkif_max_segments
Message-ID: <20141217161323.GA6414@laptop.dumpdata.com>
References: <1418724696-23922-1-git-send-email-bob.liu@oracle.com>
 <54900A3F.7070300@citrix.com>
 <54913C72.7090704@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <54913C72.7090704@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 04:18:58PM +0800, Bob Liu wrote:
> 
> On 12/16/2014 06:32 PM, Roger Pau Monné wrote:
> > El 16/12/14 a les 11.11, Bob Liu ha escrit:
> >> The default maximum value of segments in indirect requests was 32, IO
> >> operations with bigger block size(>32*4k) would be split and performance start
> >> to drop.
> >>
> >> Nowadays backend device usually support 512k max_sectors_kb on desktop, and
> >> may larger on server machines with high-end storage system.
> >> The default size 128k was not very appropriate, this patch increases the default
> >> maximum value to 128(128*4k=512k).
> > 
> > This looks fine, do you have any data/graphs to backup your reasoning?
> > 
> 
> I only have some results for 1M block size FIO test but I think that's
> enough.
> 
> xen_blkfront.max 	Rate (MB/s) 	Percent of Dom-0
> 32 	11.1 	31.0%
> 48 	15.3 	42.7%
> 64 	19.8 	55.3%
> 80 	19.9 	55.6%
> 96 	23.0 	64.2%
> 112 	23.7 	66.2%
> 128 	31.6 	88.3%
> 
> The rates above are compared against the dom-0 rate of 35.8 MB/s.
> 
> > I would also add to the commit message that this change implies we can
> > now have 32*128+32 = 4128 in-flight grants, which greatly surpasses the
> 
> The number could be larger if using more pages as the
> xen-blkfront/backend ring based on Wei Liu's patch "xenbus_client:
> extend interface to suppurt multi-page ring", it helped improve the IO
> performance a lot on our system connected with high-end storage.
> I'm preparing resend related patches.

Or potentially making the request and response be seperate rings - and the
response ring entries not tied in to the request. As in right now if we
have an request at say slot 1,5, and 7, we expect the response to be at
slot 1,5, and 7 as well. If we made the response ring producer index
not be tied to the request we could put the responses on the first available
slot - so say at 1, 2, and 3 (if all three responses came at the same time).

> 
> > default amount of persistent grants blkback can handle, so the LRU in
> > blkback will kick in.
> > 
> 
> Sounds good.
> 
> -- 
> Regards,
> -Bob
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
