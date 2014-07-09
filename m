Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaGIGhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:37:13 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41944 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaGIGhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:37:10 -0400
Date: Tue, 8 Jul 2014 23:35:32 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: akpm@linux-foundation.org, hughd@google.com, davej@redhat.com,
        koct9i@gmail.com, lczerner@redhat.com, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
 added to -mm tree
In-Reply-To: <53BCBF1F.1000506@oracle.com>
Message-ID: <alpine.LSU.2.11.1407082309040.7374@eggly.anvils>
References: <53b45c9b.2rlA0uGYBLzlXEeS%akpm@linux-foundation.org> <53BCBF1F.1000506@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014, Sasha Levin wrote:
> On 07/02/2014 03:25 PM, akpm@linux-foundation.org wrote:
> > From: Hugh Dickins <hughd@google.com>
> > Subject: shmem: fix faulting into a hole while it's punched, take 2
> 
> I suspect there's something off with this patch, as the shmem_fallocate
> hangs are back... Pretty much same as before:

Thank you for reporting, but that is depressing news.

I don't see what's wrong with this (take 2) patch,
and I don't see that it's been garbled in any way in next-20140708.

> 
> [  363.600969] INFO: task trinity-c327:9203 blocked for more than 120 seconds.
> [  363.605359]       Not tainted 3.16.0-rc4-next-20140708-sasha-00022-g94c7290-dirty #772
> [  363.609730] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  363.615861] trinity-c327    D 000000000000000b 13496  9203   8559 0x10000004
> [  363.620284]  ffff8800b857bce8 0000000000000002 ffffffff9dc11b10 0000000000000001
> [  363.624468]  ffff880104860000 ffff8800b857bfd8 00000000001d7740 00000000001d7740
> [  363.629118]  ffff880104863000 ffff880104860000 ffff8800b857bcd8 ffff8801eaed8868
> [  363.633879] Call Trace:
> [  363.635442]  [<ffffffff9a4dc535>] schedule+0x65/0x70
> [  363.638638]  [<ffffffff9a4dc948>] schedule_preempt_disabled+0x18/0x30
> [  363.642833]  [<ffffffff9a4df0a5>] mutex_lock_nested+0x2e5/0x550
> [  363.646599]  [<ffffffff972a4d7c>] ? shmem_fallocate+0x6c/0x350
> [  363.651319]  [<ffffffff9719b721>] ? get_parent_ip+0x11/0x50
> [  363.654683]  [<ffffffff972a4d7c>] ? shmem_fallocate+0x6c/0x350
> [  363.658264]  [<ffffffff972a4d7c>] shmem_fallocate+0x6c/0x350

So it's trying to acquire i_mutex at shmem_fallocate+0x6c...

> [  363.662010]  [<ffffffff971bd96e>] ? put_lock_stats.isra.12+0xe/0x30
> [  363.665866]  [<ffffffff9730c043>] do_fallocate+0x153/0x1d0
> [  363.669381]  [<ffffffff972b472f>] SyS_madvise+0x33f/0x970
> [  363.672906]  [<ffffffff9a4e3f13>] tracesys+0xe1/0xe6
> [  363.682900] 2 locks held by trinity-c327/9203:
> [  363.684928]  #0:  (sb_writers#12){.+.+.+}, at: [<ffffffff9730c02d>] do_fallocate+0x13d/0x1d0
> [  363.715102]  #1:  (&sb->s_type->i_mutex_key#16){+.+.+.}, at: [<ffffffff972a4d7c>] shmem_fallocate+0x6c/0x350

...but it already holds i_mutex, acquired at shmem_fallocate+0x6c.
Am I reading that correctly?

In my source for next-20140708, the only return from shmem_fallocate()
which omits to mutex_unlock(&inode->i_mutex) is the "return -EOPNOTSUPP"
at the top, just before the mutex_lock(&inode->i_mutex).  And inode
doesn't get reassigned in the middle.

Does 3.16.0-rc4-next-20140708-sasha-00022-g94c7290-dirty look different?

Hugh
