Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaFBIbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:31:07 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62632 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaFBIbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:31:04 -0400
Message-ID: <538C360F.7020901@ontolinux.com>
Date: Mon, 02 Jun 2014 10:30:07 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows NT 5.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Daniel Phillips <daniel@phunq.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
References: <538B9DEE.20800@phunq.net>
In-Reply-To: <538B9DEE.20800@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:RUlXdflbZRRnEPCi/P/S3JZzdS4QPIEhtktetUwhi/6
 21vURwjVvEwDEvnBKDU7k7Qelj+rDQB1EX49+vihBJiwXoxyYv
 AycgJIEju46eSvbIUP7rycVUC9uleDce/GgDy5G2K7BxOwUdb1
 F8aIx3d6Ua6M/Yk5AcBX5LhpFaa6Eb2fQC1hEoQGUTlgeggaoH
 LYSJj8OKMlu/gcuXUtO+NV0nvHK9hIcYnYS+PCKoRyi6QltP1W
 mzPr7ft0KFnW/oPRgLXukfUVfTsA/on4dKMu8SOm4u+qCViM5Q
 Re/g9f6kibEbr+hA6yoj2zKdCEtPtiA2kv8nmHGEsymg4kGx35
 t03uTpzutqA3LnBgH3KA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the 1st of June 2014 23:41, Daniel Phillips wrote:
> Hi,
>
> This is the first of four core changes we would like for Tux3. We
> start with a hard one and suggest a simple solution.
>
> The first patch in this series adds a new super operation to write
> back multiple inodes in a single call. The second patch applies to
> our linux-tux3 repository at git.kernel.org to demonstrate how this
> interface is used, and removes about 450 lines of workaround code.
>
> Traditionally, core kernel tells each mounted filesystems which
> dirty pages of which inodes should be flushed to disk, but
> unfortunately, is blissfully ignorant of filesystem-specific
> ordering constraints. This scheme was really invented for Ext2 and
> has not evolved much recently. Tux3, with its strong ordering and
> optimized delta commit, cannot tolerate random flushing and
> therefore takes responsibility for flush ordering itself. On the
> other hand, Tux3 has no good way to know when is the right time to
> flush, but core is good at that. This proposed API harmonizes those
> two competencies so that Tux3 and core each take care of what they
> are good at, and not more.
>
> The API extension consists of a new writeback hook and two helpers
> to be uses within the hook. The hook sits about halfway down the
> fs-writeback stack, just after core has determined that some dirty
> inodes should be flushed to disk and just before it starts thinking
> about which inodes those should be. At that point, core calls Tux3
> instead of continuing on down the usual do_writepages path. Tux3
> responds by staging a new delta commit, using the new helpers to
> tell core which inodes were flushed versus being left dirty in
> cache. This is pretty much the same behavior as the traditional
> writeout path, but less convoluted, probably more efficient, and
> certainly easier to analyze.
>
> The new writeback hook looks like:
>
>      progress = sb->s_op->writeback(sb,&writeback_control,&nr_pages);
>
> This should be self-explanatory: nr_pages and progress have the
> semantics of existing usage in fs-writeback; writeback_control is
> ignored by Tux3, but that is only because Tux3 always flushes
> everything and does not require hints for now. We can safely assume
> that&wbc or equivalent is wanted here. An obvious wart is the
> overlap between "progress" and "nr_pages", but fs-writeback thinks
> that way, so it would not make much sense to improve one without
> improving the other.
>
> Tux3 necessarily keeps its own dirty inode list, which is an area
> of overlap with fs-writeback. In a perfect world, there would be
> just one dirty inode list per superblock, on which both fs-writeback
> and Tux3 would operate. That would be a deeper core change than
> seems appropriate right now.
>
> Potential races are a big issue with this API, which is no surprise.
> The fs-writeback scheme requires keeping several kinds of object in
> sync: tux3 dirty inode lists, fs-writeback dirty inode lists and
> inode dirty state. The new helpers inode_writeback_done(inode) and
> inode_writeback_touch(inode) take care of that while hiding
> internal details of the fs-writeback implementation.
>
> Tux3 calls inode_writeback_done when it has flushed an inode and
> marked it clean, or calls inode_writeback_touch if it intends to
> retain a dirty inode in cache. These have simple implementations.
> The former just removes a clean inode from any fs-writeback list.
> The latter updates the inode's dirty timestamp so that fs-writeback
> does not keep trying flush it. Both these things could be done more
> efficiently by re-engineering fs-writeback, but we prefer to work
> with the existing scheme for now.
>
> Hirofumi's masterful hack nicely avoided racy removal of inodes from
> the writeback list by taking an internal fs-writeback lock inside
> filesystem code. The new helper requires dropping i_lock inside
> filesystem code and retaking it in the helper, so inode redirty can
> race with writeback list removal. This does not seem to present a
> problem because filesystem code is able to enforce strict
> alternation of cleaning and calling the helper. As an offsetting
> advantage, writeback lock contention is reduced.
>
> Compared to Hirofumi's hack, the cost of this interface is one
> additional spinlock per inode_writeback_done,  which is
> insignificant compared to the convoluted code path that is avoided.
> Regards,
>
> Daniel
When I followed the advice of Dave Chinner:
"We're not going to merge that page forking stuff (like you were told at 
LSF 2013 more than a year ago: http://lwn.net/Articles/548091/) without 
rigorous design review and a demonstration of the solutions to all the 
hard corner cases it has"
given in his e-mail related with the presentation of the latest version 
of the Tux3 file system (see [1]) and read the linked article, I found 
in the second comments:
"Parts of this almost sound like it either a.) overlaps with or b.) 
would benefit greatly from something similar to Featherstitch [[2]]."

Could it be that we have with Featherstitch a general solution already 
that is said to be even "file system agnostic"?
Honestly, I thought that something like this would make its way into the 
Linux code base.



Have fun
Christian

[1] Dave Chinner Re: [RFC] Tux3 for review 
https://lkml.org/lkml/2014/5/18/158
[2] Featherstitch http://featherstitch.cs.ucla.edu/
