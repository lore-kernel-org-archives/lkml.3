Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaA0F3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:29:41 -0500
Received: from mail1.windriver.com ([147.11.146.13]:36755 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaA0F3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:29:39 -0500
Date: Mon, 27 Jan 2014 00:29:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Hugh Dickins <hughd@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: bring back /sys/kernel/mm
Message-ID: <20140127052959.GA20111@windriver.com>
References: <alpine.LSU.2.11.1401261849120.1259@eggly.anvils>
 <20140127040330.GA17584@windriver.com>
 <alpine.LSU.2.11.1401262053510.1002@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401262053510.1002@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] mm: bring back /sys/kernel/mm] On 26/01/2014 (Sun 21:02) Hugh Dickins wrote:

> On Sun, 26 Jan 2014, Paul Gortmaker wrote:
> > [[PATCH] mm: bring back /sys/kernel/mm] On 26/01/2014 (Sun 18:52) Hugh Dickins wrote:
> > 
> > > Commit da29bd36224b ("mm/mm_init.c: make creation of the mm_kobj happen
> > > earlier than device_initcall") changed to pure_initcall(mm_sysfs_init).
> > > 
> > > That's too early: mm_sysfs_init() depends on core_initcall(ksysfs_init)
> > > to have made the kernel_kobj directory "kernel" in which to create "mm".
> > > 
> > > Make it postcore_initcall(mm_sysfs_init).  We could use core_initcall(),
> > > and depend upon Makefile link order kernel/ mm/ fs/ ipc/ security/ ...
> > > as core_initcall(debugfs_init) and core_initcall(securityfs_init) do;
> > > but better not.
> > 
> > Agreed, N+1 is better than link order.  I guess it silently fails then,
> > with /sys/kernel/mm missing as the symptom?  I'd booted i386 and ppc
> > and didn't spot this, unfortunately...  wondering now if there was a
> > hint in dmesg that I simply failed to notice.
> 
> No, nothing in dmesg at all: both mm_sysfs_init() and ksm_init()
> (it was /sys/kernel/mm/ksm/run that I was looking for) thought
> they had succeeded.
> 
> Ah, I get it: it's normal to pass NULL parent to kobject_create_and_add(),
> that just means create at the root.  And when I look at an unfixed box,
> yes, there's /sys/mm with all the right contents.

Aha - yeah, I would have never seen that; the subtle rename is too
easy to overlook unless one is used to going after some path by habit,
and wonders why tab completion isn't working anymore...

> 
> Given /sys/block and /sys/fs and /sys/kernel, I think /sys/mm is a better
> location; but we're a few years too late to be making that change now ;)

Agreed.

Thanks again for the root cause, I don't feel so bad for missing it now.
Paul.
--

> 
> Hugh
> 
> > 
> > > 
> > > Signed-off-by: Hugh Dickins <hughd@google.com>
> > 
> > Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > 
> > Thanks,
> > Paul.
> > 
> > > ---
> > > 
> > >  mm/mm_init.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > --- 3.13.0+/mm/mm_init.c	2014-01-23 21:51:26.004001378 -0800
> > > +++ linux/mm/mm_init.c	2014-01-26 18:06:40.488488209 -0800
> > > @@ -202,4 +202,4 @@ static int __init mm_sysfs_init(void)
> > >  
> > >  	return 0;
> > >  }
> > > -pure_initcall(mm_sysfs_init);
> > > +postcore_initcall(mm_sysfs_init);
