Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3KPWh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 17:37:59 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53142 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202Ab3KPWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 17:37:52 -0500
Message-ID: <1384641466.3614.19.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: John David Anglin <dave.anglin@bell.net>
Cc: Simon Baatz <gmbnomis@gmail.com>, Helge Deller <deller@gmx.de>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Date: Sat, 16 Nov 2013 14:37:46 -0800
In-Reply-To: <BLU0-SMTP77F560605C9D02E4CA7C6997FA0@phx.gbl>
References: <20131115220529.GA3160@ls3530.box>
	 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
	 <20131116200717.GA18939@schnuecks.de>
	 <1384639590.3614.16.camel@dabdike.int.hansenpartnership.com>
	 <BLU0-SMTP77F560605C9D02E4CA7C6997FA0@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-16 at 17:32 -0500, John David Anglin wrote:
> On 16-Nov-13, at 5:06 PM, James Bottomley wrote:
> 
> > On Sat, 2013-11-16 at 21:07 +0100, Simon Baatz wrote:
> >> On Fri, Nov 15, 2013 at 02:42:05PM -0800, James Bottomley wrote:
> >>> On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
> >>>> When a user page mapping is released via kunmap*() functions, the  
> >>>> D-cache needs
> >>>> to be flushed via flush_dcache_page() to avoid D-cache aliasing  
> >>>> issues.
> >>>>
> >>>> This patch fixes aio on the parisc platform (and probably others).
> >>>
> >>> This should be flush_kernel_dcache_page().  flush_dcache_page() is  
> >>> for
> >>> full coherency but for unmap, we know the page was coherent going  
> >>> in and
> >>> may have been modified by the kernel, so only the kernel view  
> >>> needs to
> >>> be sync'd.  Technically, by the kernel API, the flush should be done
> >>> *before* unmapping.  This would have mattered on parisc until we did
> >>> flush via tmpalias which means we no-longer care if the mapping  
> >>> for the
> >>> flush exists or not because we always recreate it via the tmpalias
> >>> pages.
> >>
> >> On ARM, flush_kernel_dcache_page() actually assumes that the page is
> >> mapped.  It avoids double flushing of highmem pages by not flushing
> >> in those cases where kunmap_atomic() already takes care of flushing.
> >
> > On Parisc, kmap/kunmap is currently a nop.  However, if we ever
> > implemented highmem, we would also need to flush before we unmap,  
> > which
> > is why the flush needs to go before the kunmap.
> 
> Not quite.  On PA8800/PA8900, we currently do a flush in kunmap.
> 
> I'm fairly certain from discussion with Helge that he saw this bug on  
> a C8000
> with PA8800 processor.  In that case, adding a call to  
> flush_kernel_dcache_page()
> just duplicates the call in kunmap().

Yes, if that's true it won't be the solution.

>   Could be wrong though.
> 
> The problem is the coherence with userspace.  That's why  
> flush_dcache_page()
> is called in several places in this file.  I agree with you that this  
> should be done
> before.

If we need coherence with userspace, we can't do it as we unmap because
by then we've used the data in the kernel.  We have to do it as we kmap,
because that's when we're preparing to use the data.  So the solution,
if this is the problem, would be flush_dcache_page() just after kmap.

James


