Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbaEPTvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbaEPTvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:51:39 -0400
Date: Fri, 16 May 2014 21:29:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: uprobes && shmem (Was: uprobes: Shift ->readpage check from
	__copy_insn() to uprobe_register())
Message-ID: <20140516192949.GA16446@redhat.com>
References: <20140516152919.GA30659@redhat.com> <20140516153058.GA30667@redhat.com> <alpine.LSU.2.11.1405161120410.3604@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405161120410.3604@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Hugh Dickins wrote:
>
> On Fri, 16 May 2014, Oleg Nesterov wrote:
> > On 05/16, Oleg Nesterov wrote:
> > >
> > > copy_insn() fails with -EIO if ->readpage == NULL
> >
> > In particular, this means that we can not probe the binaries on tmpfs.
> > This is pity.
>
> Yes, that is a pity: thanks for noticing.

Thanks to Denys ;)

> > It seems that the potential fix is trivial, copy_insn() could use
> > shmem_getpage_gfp(). But, is there any way to figure out that this
>
> shmem_getpage_gfp() itself is static: please use
> shmem_read_mapping_page(mapping, pgoff): inline in linux/shmem_fs.h,
> calls shmem_read_mapping_page_gfp() in mm/shmem.c (a very few places
> need to override gfp_mask too: you do not), calls shmem_getpage_gfp().

Even better, thanks,

> > inode/mapping/aops/whatever is actually shmem?
> >
> > I am looking at shmem_get_inode() and I see nothing which could help,
> > and shmem_aops/etc are all static.
>
> On 3.15 and later, you're in luck: Hannes added bool shmem_mapping(mapping)
> in his 0cd6144aadd2 "mm + fs: prepare for non-page entries in page cache
> radix trees"; and I just checked, it builds for "tiny" !CONFIG_SHMEM too.

Heh. I need to do git pull more often, I guess. Great.

> If you're backporting to an earlier kernel, it would probably be best
> to add in a very small patch, extracting just shmem_mapping() and its
> linux/mm.h declarations from 0cd6144aadd2.
>
> I notice shmem_mapping() checks backing_dev_info,
> whereas shmem_get_mapping_page_gfp() checks a_ops: no problem in that.
> But it reminds me that you should test uprobe on SysV SHM when you're
> done: again I think no problem, but there's an incestuous relationship
> between shm and shmem that can catch us out when adding such checks.

Hugh, thanks a lot!

Oleg.

