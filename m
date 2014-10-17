Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaJQPtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:49:50 -0400
Received: from mail.efficios.com ([78.47.125.74]:48356 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbaJQPtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:49:49 -0400
Date: Fri, 17 Oct 2014 15:49:39 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Message-ID: <1868658383.10922.1413560979310.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141016220126.GK11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com> <1411677218-29146-20-git-send-email-matthew.r.wilcox@intel.com> <20141016123824.GQ19075@thinkos.etherlink> <20141016220126.GK11522@wil.cx>
Subject: Re: [PATCH v11 19/21] dax: Add dax_zero_page_range
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.156.150.204]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: Add dax_zero_page_range
Thread-Index: 1cq0YffbflKQYPXM0Ra6/Yd5COe83A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Matthew Wilcox" <willy@linux.intel.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Matthew Wilcox" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
> linux-kernel@vger.kernel.org, "Ross Zwisler" <ross.zwisler@linux.intel.com>
> Sent: Friday, October 17, 2014 12:01:26 AM
> Subject: Re: [PATCH v11 19/21] dax: Add dax_zero_page_range
> 
> On Thu, Oct 16, 2014 at 02:38:24PM +0200, Mathieu Desnoyers wrote:
> > > +int dax_zero_page_range(struct inode *inode, loff_t from, unsigned
> > > length,
> > 
> > nit: unsigned -> unsigned int ?
> > 
> > Do we want a unsigned int or unsigned long here ?
> 
> It's supposed to be for a fragment of a page, so until we see a machine
> with PAGE_SIZE > 4GB, we're good to use an unsigned int.

OK

> 
> > >  	if (!length)
> > >  		return 0;
> > > +	BUG_ON((offset + length) > PAGE_CACHE_SIZE);
> > 
> > Isn't it a bit extreme to BUG_ON this condition ? We could return an
> > error to the caller, and perhaps WARN_ON_ONCE(), but BUG_ON() appears to
> > be slightly too strong here.
> 
> Dave Chinner asked for it :-)  The filesystem is supposed to be doing
> this clamping (until the last version, I had this function doing the
> clamping, and I was told off for "leaving landmines lying around".

Makes sense,

> 
> > > +static inline int dax_zero_page_range(struct inode *i, loff_t frm,
> > > +						unsigned len, get_block_t gb)
> > > +{
> > > +	return 0;
> > 
> > Should we return 0 or -ENOSYS here ?
> 
> I kind of wonder if we shouldn't just declare the function.  It's called
> like this:
> 
>         if (IS_DAX(inode))
>                 return dax_zero_page_range(inode, from, length,
>                 ext4_get_block);
>         return __ext4_block_zero_page_range(handle, mapping, from, length);
> 
> and if CONFIG_DAX is not set, IS_DAX evaluates to 0 at compile time, so
> the compiler will optimise out the call to dax_zero_page_range() anyway.

I strongly prefer to implement "unimplemented stub" as static inlines
rather than defining to 0, because the compiler can check that the types
passed to the function are valid, even in the #else configuration which
uses the stubs.

The only reason why I have not pointed this out for some of your other
patches was because it was clear that the local style of those files was
to define stubbed functions as 0. But I still dislike it.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
