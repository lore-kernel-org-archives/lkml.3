Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaJQPqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:46:06 -0400
Received: from mail.efficios.com ([78.47.125.74]:48320 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbaJQPqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:46:04 -0400
Date: Fri, 17 Oct 2014 15:45:42 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <1063411139.10919.1413560742957.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141016212234.GF11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com> <1411677218-29146-9-git-send-email-matthew.r.wilcox@intel.com> <20141016100525.GF19075@thinkos.etherlink> <20141016212234.GF11522@wil.cx>
Subject: Re: [PATCH v11 08/21] dax,ext2: Replace ext2_clear_xip_target with
 dax_clear_blocks
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.156.150.204]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: dax,ext2: Replace ext2_clear_xip_target with dax_clear_blocks
Thread-Index: p9fYHFhmHizJ6xqKVDuO0aeJC/SLyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Matthew Wilcox" <willy@linux.intel.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Matthew Wilcox" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
> linux-kernel@vger.kernel.org
> Sent: Thursday, October 16, 2014 11:22:34 PM
> Subject: Re: [PATCH v11 08/21] dax,ext2: Replace ext2_clear_xip_target with dax_clear_blocks
> 
> On Thu, Oct 16, 2014 at 12:05:25PM +0200, Mathieu Desnoyers wrote:
> > > +int dax_clear_blocks(struct inode *inode, sector_t block, long size)
> > > +{
> > > +	struct block_device *bdev = inode->i_sb->s_bdev;
> > > +	sector_t sector = block << (inode->i_blkbits - 9);
> > 
> > Is there a define e.g. SECTOR_SHIFT rather than using this hardcoded "9"
> > value ?
> 
> Yeah ... in half a dozen drivers, so introducing them globally spews
> warnings about redefining macros.  The '9' and '512' are sprinkled all
> over the storage parts of the kernel, it's a complete flustercluck that
> I wasn't about to try to unscrew.

Fair enough.

> 
> > > +		while (count > 0) {
> > > +			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
> > 
> > unsigned -> unsigned int
> 
> Any particular reason?  Omitting it in some places helps stay within
> the 80-column limit without sacrificing readability.

It looks like FS code often uses "unsigned", so I'm not too concerned.

It's just that I'm used to the Linux core kernel style, which tend to
use "unsigned int".

> 
> > > +		}
> > > +	} while (size);
> > 
> > Just to stay on the safe side, can we do while (size > 0) ? Just in case
> > an unforeseen issue makes size negative, and gets us in a very long loop.
> 
> If size < 0, we should BUG, because that means we've zeroed more than
> we were asked to do, which is data corruption.
> 
> There's probably some other hardening we should do for this loop.
> For example, if 'count' is < 512, it can go into an infinite loop.
> 
>         do {
>                 void *addr;
>                 unsigned long pfn;
>                 long count;
> 
>                 count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
>                 if (count < 0)
>                         return count;
>                 while (count > 0) {
>                         unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
>                         if (pgsz > count)
>                                 pgsz = count;
>                         if (pgsz < PAGE_SIZE)
>                                 memset(addr, 0, pgsz);
>                         else
>                                 clear_page(addr);
>                         addr += pgsz;
>                         size -= pgsz;
>                         count -= pgsz;
> 			BUG_ON(pgsz & 511);
>                         sector += pgsz / 512;
>                         cond_resched();
>                 }
> 		BUG_ON(size < 0);
>         } while (size);
> 
> I think that should do the job ... ?
> 

Yep. I love defensive programming, especially for filesystems. :)

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
