Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaFBTLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:11:40 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51499 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaFBTLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:11:38 -0400
Date: Mon, 2 Jun 2014 12:09:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Christoph Hellwig <hch@infradead.org>
cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>, Hugh Dickins <hughd@google.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: tmpfs support
In-Reply-To: <20140602183028.GA9372@infradead.org>
Message-ID: <alpine.LSU.2.11.1406021141160.1531@eggly.anvils>
References: <20140602141406.GA17863@redhat.com> <20140602183028.GA9372@infradead.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014, Christoph Hellwig wrote:
> On Mon, Jun 02, 2014 at 04:14:06PM +0200, Oleg Nesterov wrote:
> > Ingo, please pull from
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> > 
> > Based on tip:perf/uprobes
> 
> Eww, adding tmpfs-specific code to uprobes screams layering violation.
> 
> Hugh, what is the problem with implementing ->readpage for tmpfs again?

The problem is that ->readpage invites the caller to allocate a page
of their choice for pagecache, and then pass it down to the filesystem
to fill and use thereafter.

There are several ways in which that does not suit tmpfs, 3 spring to mind:
1. the page may already be in memory, but currently in swapcache not in
filecache: tmpfs knows how to manage that, the ->readpage caller does not
2. there may be a NUMA mempolicy applied to that file, which would choose
to allocate the page differently: tmpfs knows about that, caller does not
3. (handy side-effect) it happens to disable use of tmpfs file as swapfile

It was a great relief when tmpfs could finally jettison its ->readpage
back in v3.1 (though if you press me, I could admit to some remaining
embarrassments).  I certainly do not want it back.

Just think of tmpfs as a layering violation itself (memory as backing!
no wonder it has peculiar demands on the allocation of its backing)
and we're all good - there's a variety of ways in which the generic
code already happens to accommodate it (many PageSwapBacked tests,
or the mapping_cap_account_dirty/writeback tests, for example).

IIRC, you were in on the discussion of shmem_read_mapping_page() when we
introduced it: Oleg is simply adding a call to it to fix a uprobes bug.  
That the name explicitly mentions shmem instead of concealing it,
is not necessarily a bad thing.

Hugh
