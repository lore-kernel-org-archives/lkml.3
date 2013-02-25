Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3BYX77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:59:59 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:49641 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3BYX76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:59:58 -0500
Date: Tue, 26 Feb 2013 08:59:53 +0900
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kexec: Use min_t to simplify logic
Message-ID: <20130225235951.GA16202@verge.net.au>
References: <512A25A1.4040002@gmail.com>
 <20130225003651.GD17964@verge.net.au>
 <20130225153554.19cde4b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225153554.19cde4b4.akpm@linux-foundation.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 03:35:54PM -0800, Andrew Morton wrote:
> On Mon, 25 Feb 2013 09:36:51 +0900
> Simon Horman <horms@verge.net.au> wrote:
> 
> > On Sun, Feb 24, 2013 at 10:37:21PM +0800, Zhang Yanfei wrote:
> > > From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> > > 
> > > This is just a tweak: using min_t to simplify logic of variable
> > > assignments.
> > > 
> > > v2:
> > > - Rewrite patch description as Simon suggested.
> > > - Fix an inappropriate if test introduced by v1. Thanks Simon.
> > 
> > Hi Zhang,
> > 
> > thanks for the update.
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Signed-off-by: implies that you were involved in the development or
> patch delivery.  Were you?  If not, an Acked-by or Reviewed-by is more
> appropriate.

My bad, I meant:

Reviewed-by: Simon Horman <horms@verge.net.au>

> Also, the need to use min_t rather than min is a sign that the types
> are screwed up.  Let's take a look.
> 
> > > 
> > > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > > index 2436ffc..effd655 100644
> > > --- a/kernel/kexec.c
> > > +++ b/kernel/kexec.c
> > > @@ -822,13 +822,8 @@ static int kimage_load_normal_segment(struct kimage *image,
> > >  		/* Start with a clear page */
> > >  		clear_page(ptr);
> > >  		ptr += maddr & ~PAGE_MASK;
> > > -		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
> > > -		if (mchunk > mbytes)
> > > -			mchunk = mbytes;
> > > -
> > > -		uchunk = mchunk;
> > > -		if (uchunk > ubytes)
> > > -			uchunk = ubytes;
> > > +		mchunk = min_t(size_t, mbytes, PAGE_SIZE - (maddr & ~PAGE_MASK));
> > > +		uchunk = min_t(size_t, ubytes, mchunk);
> 
> The types of ubytes and mbytes are clearly wrong.  They are initialised
> from a size_t and they are manipulated alongside size_t's.
> 
> The types of PAGE_SIZE and PAGE_MASK are vague - iirc they once had
> different types on different architectures, so some form of casting is
> unavoidable here.
> 
> > >  		result = copy_from_user(ptr, buf, uchunk);
> > >  		kunmap(page);
> > > @@ -874,13 +869,9 @@ static int kimage_load_crash_segment(struct kimage *image,
> > >  		}
> > >  		ptr = kmap(page);
> > >  		ptr += maddr & ~PAGE_MASK;
> > > -		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
> > > -		if (mchunk > mbytes)
> > > -			mchunk = mbytes;
> > > -
> > > -		uchunk = mchunk;
> > > -		if (uchunk > ubytes) {
> > > -			uchunk = ubytes;
> > > +		mchunk = min_t(size_t, mbytes, PAGE_SIZE - (maddr & ~PAGE_MASK));
> > > +		uchunk = min_t(size_t, ubytes, mchunk);
> > > +		if (mchunk > uchunk) {
> > >  			/* Zero the trailing part of the page */
> > >  			memset(ptr + uchunk, 0, mchunk - uchunk);
> > >  		}
> 
> Again, mybtes and ubytes have the wrong type.
> 
> > > @@ -1461,8 +1452,7 @@ void vmcoreinfo_append_str(const char *fmt, ...)
> > >  	r = vsnprintf(buf, sizeof(buf), fmt, args);
> > >  	va_end(args);
> > >  
> > > -	if (r + vmcoreinfo_size > vmcoreinfo_max_size)
> > > -		r = vmcoreinfo_max_size - vmcoreinfo_size;
> > > +	r = min_t(size_t, r, vmcoreinfo_max_size - vmcoreinfo_size);
> > >  
> > >  	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
> 
> vmcoreinfo_max_size is a size_t and vmcoreinfo_size is a size_t and
> memcpy's `size' argument is a size_t.  Therefore the type of `r' should
> be...  what?  int!  bzzzzt.
> 
