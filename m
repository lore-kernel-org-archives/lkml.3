Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161109Ab3BOCwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:52:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25388 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab3BOCwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:52:23 -0500
Date: Thu, 14 Feb 2013 21:52:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH] xen-blkback: use balloon pages for persistent grants
Message-ID: <20130215025217.GC10506@phenom.dumpdata.com>
References: <1360836729-17874-1-git-send-email-roger.pau@citrix.com>
 <20130214132318.GC2506@phenom.dumpdata.com>
 <511CFC93.9070205@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <511CFC93.9070205@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 04:02:43PM +0100, Roger Pau Monné wrote:
> On 14/02/13 14:23, Konrad Rzeszutek Wilk wrote:
> > On Thu, Feb 14, 2013 at 11:12:09AM +0100, Roger Pau Monne wrote:
> >> With current persistent grants implementation we are not freeing the
> >> persistent grants after we disconnect the device. Since grant map
> > 
> > Can you explain this in more details please? Isn't gnttab_set_unmap_op
> > in free_persistent_gnts doing the right job of putting in the right
> > mfn in? And then we could free the page?
> 
> No, after gnttab_unmap_refs the page still points to the grant frame
> mfn. All the users of grant frames either have an internal buffer of
> pages that are reused (like blkback), or use balloon pages (like gntdev).
> 
> I could probably modify gnttab_map to store the mfn and set it back at
> gnttab_unmap, but that will surely require more work than this simple fix.

Simple fix is what we want right now.
> 
> > 
> > 
> >> operations change the mfn of the allocated page, and we can no longer
> >> pass it to __free_page without setting the mfn to a sane value, use
> >> balloon grant pages instead, as the gntdev device does.
> > 
> > 
> > Wow. I did not realize that we leaving such a huge memory leak behind!
> > But I guess that was never an issue as we would recycle those persistent
> > grants to other domains.
> 
> No, we didn't recycle them AFAIK, we allocated them using alloc_page,
> passed them to gnttab_map, used them, and when closing the backend we
> only unmapped them, but they where never freed.

Ghastly!
