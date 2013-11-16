Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3KPWGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 17:06:46 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53085 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab3KPWGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 17:06:39 -0500
Message-ID: <1384639590.3614.16.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Simon Baatz <gmbnomis@gmail.com>
Cc: Helge Deller <deller@gmx.de>, Benjamin LaHaise <bcrl@kvack.org>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Date: Sat, 16 Nov 2013 14:06:30 -0800
In-Reply-To: <20131116200717.GA18939@schnuecks.de>
References: <20131115220529.GA3160@ls3530.box>
	 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
	 <20131116200717.GA18939@schnuecks.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-16 at 21:07 +0100, Simon Baatz wrote:
> On Fri, Nov 15, 2013 at 02:42:05PM -0800, James Bottomley wrote:
> > On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
> > > When a user page mapping is released via kunmap*() functions, the D-cache needs
> > > to be flushed via flush_dcache_page() to avoid D-cache aliasing issues.
> > > 
> > > This patch fixes aio on the parisc platform (and probably others).
> > 
> > This should be flush_kernel_dcache_page().  flush_dcache_page() is for
> > full coherency but for unmap, we know the page was coherent going in and
> > may have been modified by the kernel, so only the kernel view needs to
> > be sync'd.  Technically, by the kernel API, the flush should be done
> > *before* unmapping.  This would have mattered on parisc until we did
> > flush via tmpalias which means we no-longer care if the mapping for the
> > flush exists or not because we always recreate it via the tmpalias
> > pages.
> 
> On ARM, flush_kernel_dcache_page() actually assumes that the page is
> mapped.  It avoids double flushing of highmem pages by not flushing
> in those cases where kunmap_atomic() already takes care of flushing.

On Parisc, kmap/kunmap is currently a nop.  However, if we ever
implemented highmem, we would also need to flush before we unmap, which
is why the flush needs to go before the kunmap.

I've got to say on all of this, we've implemented the most inane set of
primitives.  It would be much easier if kmap/kunmap just took care of
all of this.  kmap should bring userspace into coherence (because why
else would we be kmapping) and kunmap should force coherence on the
kernel address ... and then no-one would need to worry when to and when
not to flush.

James


