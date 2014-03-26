Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaCZTz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:55:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbaCZTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:55:26 -0400
Date: Wed, 26 Mar 2014 12:55:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>
Subject: Re: mm: BUG: Bad page state in process ksmd
Message-Id: <20140326125525.4e8090096f647f654eb7329d@linux-foundation.org>
In-Reply-To: <5332EE97.4050604@oracle.com>
References: <5332EE97.4050604@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 11:13:27 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following.

(cc Hugh)

> Out of curiosity, is there a reason not to do bad flag checks when actually
> setting flag? Obviously it'll be slower but it'll be easier catching these
> issues.

Tricky.  Each code site must determine what are and are not valid page
states depending upon the current context.  The one place where we've
made that effort is at the point where a page is returned to the free
page pool.  Any other sites would require similar amounts of effort and
each one would be different from all the others.

We do this in a small way all over the place, against individual page
flags.  grep PageLocked */*.c.

> [ 3926.683948] BUG: Bad page state in process ksmd  pfn:5a6246
> [ 3926.689336] page:ffffea0016989180 count:0 mapcount:0 mapping:          (null) index:
> [ 3926.696507] page flags: 0x56fffff8028001c(referenced|uptodate|dirty|swapbacked|mlock
> [ 3926.709201] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> [ 3926.711216] bad because of flags:
> [ 3926.712136] page flags: 0x200000(mlocked)
> [ 3926.713574] Modules linked in:
> [ 3926.714466] CPU: 26 PID: 3864 Comm: ksmd Tainted: G        W     3.14.0-rc7-next-201
> [ 3926.720942]  ffffffff85688060 ffff8806ec7abc38 ffffffff844bd702 0000000000002fa0
> [ 3926.728107]  ffffea0016989180 ffff8806ec7abc68 ffffffff844b158f 000fffff80000000
> [ 3926.730563]  0000000000000000 000fffff80000000 ffffffff85688060 ffff8806ec7abcb8
> [ 3926.737653] Call Trace:
> [ 3926.738347]  dump_stack (lib/dump_stack.c:52)
> [ 3926.739841]  bad_page (arch/x86/include/asm/atomic.h:38 include/linux/mm.h:432 mm/page_alloc.c:339)
> [ 3926.741296]  free_pages_prepare (mm/page_alloc.c:644 mm/page_alloc.c:738)
> [ 3926.742818]  free_hot_cold_page (mm/page_alloc.c:1371)
> [ 3926.749425]  __put_single_page (mm/swap.c:71)
> [ 3926.751074]  put_page (mm/swap.c:237)
> [ 3926.752398]  ksm_do_scan (mm/ksm.c:1480 mm/ksm.c:1704)
> [ 3926.753957]  ksm_scan_thread (mm/ksm.c:1723)
> [ 3926.755940]  ? bit_waitqueue (kernel/sched/wait.c:291)
> [ 3926.758644]  ? ksm_do_scan (mm/ksm.c:1715)
> [ 3926.760420]  kthread (kernel/kthread.c:219)
> [ 3926.761605]  ? kthread_create_on_node (kernel/kthread.c:185)
> [ 3926.763149]  ret_from_fork (arch/x86/kernel/entry_64.S:555)
> [ 3926.764323]  ? kthread_create_on_node (kernel/kthread.c:185)

