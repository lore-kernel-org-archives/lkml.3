Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbaEPSvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:51:12 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39275 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaEPSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:51:11 -0400
Date: Fri, 16 May 2014 11:49:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: uprobes && shmem (Was: uprobes: Shift ->readpage check from
 __copy_insn() to uprobe_register())
In-Reply-To: <20140516153058.GA30667@redhat.com>
Message-ID: <alpine.LSU.2.11.1405161120410.3604@eggly.anvils>
References: <20140516152919.GA30659@redhat.com> <20140516153058.GA30667@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Oleg Nesterov wrote:
> On 05/16, Oleg Nesterov wrote:
> >
> > copy_insn() fails with -EIO if ->readpage == NULL
> 
> In particular, this means that we can not probe the binaries on tmpfs.
> This is pity.

Yes, that is a pity: thanks for noticing.

> 
> It seems that the potential fix is trivial, copy_insn() could use
> shmem_getpage_gfp(). But, is there any way to figure out that this

shmem_getpage_gfp() itself is static: please use
shmem_read_mapping_page(mapping, pgoff): inline in linux/shmem_fs.h,
calls shmem_read_mapping_page_gfp() in mm/shmem.c (a very few places
need to override gfp_mask too: you do not), calls shmem_getpage_gfp().

> inode/mapping/aops/whatever is actually shmem?
> 
> I am looking at shmem_get_inode() and I see nothing which could help,
> and shmem_aops/etc are all static.

On 3.15 and later, you're in luck: Hannes added bool shmem_mapping(mapping)
in his 0cd6144aadd2 "mm + fs: prepare for non-page entries in page cache
radix trees"; and I just checked, it builds for "tiny" !CONFIG_SHMEM too.

If you're backporting to an earlier kernel, it would probably be best
to add in a very small patch, extracting just shmem_mapping() and its
linux/mm.h declarations from 0cd6144aadd2.

I notice shmem_mapping() checks backing_dev_info,
whereas shmem_get_mapping_page_gfp() checks a_ops: no problem in that.
But it reminds me that you should test uprobe on SysV SHM when you're
done: again I think no problem, but there's an incestuous relationship
between shm and shmem that can catch us out when adding such checks.

Hugh
