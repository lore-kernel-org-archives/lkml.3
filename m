Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966804Ab3DRORm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:17:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965049Ab3DRORl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:17:41 -0400
Date: Thu, 18 Apr 2013 07:17:36 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130418141736.GA7989@dhcp22.suse.cz>
References: <20130416110009.GA2664@localhost.localdomain>
 <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
 <20130417094750.GB2672@localhost.localdomain>
 <20130417141909.GA24912@dhcp22.suse.cz>
 <20130418101541.GC2672@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418101541.GC2672@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18-04-13 18:15:41, Han Pingtian wrote:
> On Wed, Apr 17, 2013 at 07:19:09AM -0700, Michal Hocko wrote:
> > On Wed 17-04-13 17:47:50, Han Pingtian wrote:
> > > [ 5233.949714] Node 1 DMA free:3968kB min:7808kB low:9728kB high:11712kB active_anon:0kB inactive_anon:3584kB active_file:2240kB inactive_file:576kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4194304kB managed:3854464kB mlocked:0kB dirty:64kB writeback:448kB mapped:0kB shmem:64kB slab_reclaimable:106496kB slab_unreclaimable:3654976kB kernel_stack:14912kB pagetables:18496kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:531 all_unreclaimable? yes
> > 
> > This smells either like a slab backed memory leak or something went
> > crazy and allocate huge amount of slab. You have 3.6G (or of 4G
> > available) of slab_unreclaimable. I would check /proc/slabinfo for which
> > cache consumes that huge amount of memory.
> 
> Thanks your reply. But I cannot find any clues in the slabinfo:

awk '{val=$3*$4; printf "%s %d\n", $1, val}' /proc/slabinfo | sort -k2 -n
says:
[...]
kmalloc-65536 41943040
kmemleak_object 112746000
pgtable-2^12 113246208
kmalloc-8192 122159104
kmalloc-32768 137887744
task_struct 241293920
kmalloc-2048 306446336
kmalloc-96 307652928
kmalloc-16384 516620288

Hmm, how many processes you have running? Having 240M in task_structs
sounds quite excessive. Also there seem to be quite a lot of memory used
in the generic 16K, 96B and 2K caches. Core kernel usually do not use
those on its own so I would be inclined to suspect some driver.
-- 
Michal Hocko
SUSE Labs
