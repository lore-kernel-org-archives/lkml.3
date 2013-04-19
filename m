Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967873Ab3DSCdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 22:33:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40419 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967815Ab3DSCdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 22:33:51 -0400
Date: Fri, 19 Apr 2013 10:33:45 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130419023345.GE2672@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20130416110009.GA2664@localhost.localdomain>
 <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
 <20130417094750.GB2672@localhost.localdomain>
 <20130417141909.GA24912@dhcp22.suse.cz>
 <20130418101541.GC2672@localhost.localdomain>
 <20130418175513.GA12581@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418175513.GA12581@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041902-7182-0000-0000-0000064EF653
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 10:55:14AM -0700, Michal Hocko wrote:
> On Fri 19-04-13 00:55:31, Han Pingtian wrote:
> > On Thu, Apr 18, 2013 at 07:17:36AM -0700, Michal Hocko wrote:
> > > On Thu 18-04-13 18:15:41, Han Pingtian wrote:
> > > > On Wed, Apr 17, 2013 at 07:19:09AM -0700, Michal Hocko wrote:
> > > > > On Wed 17-04-13 17:47:50, Han Pingtian wrote:
> > > > > > [ 5233.949714] Node 1 DMA free:3968kB min:7808kB low:9728kB high:11712kB active_anon:0kB inactive_anon:3584kB active_file:2240kB inactive_file:576kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4194304kB managed:3854464kB mlocked:0kB dirty:64kB writeback:448kB mapped:0kB shmem:64kB slab_reclaimable:106496kB slab_unreclaimable:3654976kB kernel_stack:14912kB pagetables:18496kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:531 all_unreclaimable? yes
> > > > > 
> > > > > This smells either like a slab backed memory leak or something went
> > > > > crazy and allocate huge amount of slab. You have 3.6G (or of 4G
> > > > > available) of slab_unreclaimable. I would check /proc/slabinfo for which
> > > > > cache consumes that huge amount of memory.
> > > > 
> > > > Thanks your reply. But I cannot find any clues in the slabinfo:
> > > 
> > > awk '{val=$3*$4; printf "%s %d\n", $1, val}' /proc/slabinfo | sort -k2 -n
> > > says:
> > > [...]
> > > kmalloc-65536 41943040
> > > kmemleak_object 112746000
> > > pgtable-2^12 113246208
> > > kmalloc-8192 122159104
> > > kmalloc-32768 137887744
> > > task_struct 241293920
> > > kmalloc-2048 306446336
> > > kmalloc-96 307652928
> > > kmalloc-16384 516620288
> > > 
> > Oh, I see. I only calculated "$2*$4" and got some small numbers. Thanks.
> 
> OK, this is interesting. Only 865M out of 3.5G slabs are on the partial
> or full lists. I do not have much time to look at this more closely but
> it would suggest that free slabs do not get returned to the system.
> 
> > > Hmm, how many processes you have running? Having 240M in task_structs
> > > sounds quite excessive. Also there seem to be quite a lot of memory used
> > > in the generic 16K, 96B and 2K caches. Core kernel usually do not use
> > > those on its own so I would be inclined to suspect some driver.
> > There are 671 processes is running and most of them are kernel thread I
> > think:
> 
> awk '{val=$2*$4; sum+=val; printf "%s %d\n", $1, val}' a | grep task_struct
> task_struct 27080016
> 
> looks only slightly more reasonable because it is still way too high and
> it doesn't seem to match the number of processes you see.
> 
> What is the kernel that you are using and what config?
> 
We are testing a alpha version of a enterprise linux which using a 3.7
series kernel. On this 3.7 kernel we encountered the oom killer problem. So
we decide to see if the problem can be reproduced on 3.9-rc7. We
configured 3.9-rc7 by copying the enterprise linux's config file to
.config and then run 'make localmodconfig' and pressed enter to all the
questions. Then the oom problem is reproduced on the 3.9-rc7.

But we also used the same method to config 3.9-rc7 on another company's
enterprise linux yesterday and found that the problem cannot be
reproduced there. So maybe the leak is caused by some userspace
applications?

> >     [root@riblp3 ~]# ps haux|wc -l
> >     671
> >     [root@riblp3 ~]# ps haux|awk '{print $11}'|grep '^\['|wc -l
> >     620
> >     [root@riblp3 ~]# 
> > 
> [...]
> -- 
> Michal Hocko
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

