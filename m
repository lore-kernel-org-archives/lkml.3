Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3DKHcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:32:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab3DKHcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:32:11 -0400
Date: Thu, 11 Apr 2013 03:32:04 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Message-ID: <1365665524-nj0fhwkj-mutt-n-horiguchi@ah.jp.nec.com>
Subject: Re: [RFC Patch 2/2] mm: Add parameters to limit a rate of outputting
 memory error messages
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 12:59:38AM -0400, Naoya Horiguchi wrote:
> Hi Tanino-san,
> 
> On Thu, Apr 11, 2013 at 12:27:15PM +0900, Mitsuhiro Tanino wrote:
> > This patch introduces new sysctl interfaces in order to limit
> > a rate of outputting memory error messages.
> > 
> > - vm.memory_failure_print_ratelimit:
> >   Specify the minimum length of time between messages.
> >   By default the rate limiting is disabled.
> > 
> > - vm.memory_failure_print_ratelimit_burst:
> >   Specify the number of messages we can send before rate limiting.
> > 
> > Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
...
> > @@ -78,6 +79,16 @@ EXPORT_SYMBOL_GPL(hwpoison_filter_dev_minor);
> >  EXPORT_SYMBOL_GPL(hwpoison_filter_flags_mask);
> >  EXPORT_SYMBOL_GPL(hwpoison_filter_flags_value);
> >  
> > +/*
> > + * This enforces a rate limit for outputting error message.
> > + * The default interval is set to "0" HZ. This means that
> > + * outputting error message is not limited by default.
> > + * The default burst is set to "10". This parameter can control
> > + * to output number of messages per interval.
> > + * If interval is set to "0", the burst is ineffective.
> > + */
> > +DEFINE_RATELIMIT_STATE(sysctl_memory_failure_print_ratelimit, 0 * HZ, 10);
> > +
> >  static int hwpoison_filter_dev(struct page *p)
> >  {
> >  	struct address_space *mapping;
> > @@ -622,13 +633,16 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
> >  	SetPageError(p);
> >  	if (mapping) {
> >  		/* Print more information about the file. */
> > -		if (mapping->host != NULL && S_ISREG(mapping->host->i_mode))
> > -			pr_info("MCE %#lx: File was corrupted: Dev:%s Inode:%lu Offset:%lu\n",
> > -				page_to_pfn(p), mapping->host->i_sb->s_id,
> > -				mapping->host->i_ino, page_index(p));
> > -		else
> > -			pr_info("MCE %#lx: A dirty page cache was corrupted.\n",
> > -				page_to_pfn(p));
> > +		if (__ratelimit(&sysctl_memory_failure_print_ratelimit)) {
> > +			if (mapping->host != NULL &&
> > +			    S_ISREG(mapping->host->i_mode))
> > +				pr_info("MCE %#lx: File was corrupted: Dev:%s Inode:%lu Offset:%lu\n",
> > +				   page_to_pfn(p), mapping->host->i_sb->s_id,
> > +				   mapping->host->i_ino, page_index(p));
> > +			else
> > +				pr_info("MCE %#lx: A dirty page cache was corrupted.\n",
> > +					page_to_pfn(p));
> > +		}
> >  
> >  		/*
> >  		 * IO error will be reported by write(), fsync(), etc.

I don't think it's enough to do ratelimit only for me_pagecache_dirty().
When tons of memory errors flood, all of printk()s in memory error handler
can print out tons of messages.

Thanks,
Naoya
