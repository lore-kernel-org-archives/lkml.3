Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3IJFn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:43:27 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:45695 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab3IJFn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:43:26 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-ef-522eb17b2123
Date: Tue, 10 Sep 2013 14:43:42 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 3/4] slab: introduce byte sized index for the
 freelist of a slab
Message-ID: <20130910054342.GB24602@lge.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1378447067-19832-4-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140f3fed229-f49b95d4-7087-476f-b2c9-37846749aad6-000000@email.amazonses.com>
 <20130909043217.GB22390@lge.com>
 <00000141032dea11-c5aa9c77-b2f2-4cab-b7a0-d37665a6cec8-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141032dea11-c5aa9c77-b2f2-4cab-b7a0-d37665a6cec8-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 02:44:03PM +0000, Christoph Lameter wrote:
> On Mon, 9 Sep 2013, Joonsoo Kim wrote:
> 
> > 32 byte is not minimum object size, minimum *kmalloc* object size
> > in default configuration. There are some slabs that their object size is
> > less than 32 byte. If we have a 8 byte sized kmem_cache, it has 512 objects
> > in 4K page.
> 
> As far as I can recall only SLUB supports 8 byte objects. SLABs mininum
> has always been 32 bytes.

No.
There are many slabs that their object size are less than 32 byte.
And I can also create a 8 byte sized slab in my kernel with SLAB.

js1304@js1304-P5Q-DELUXE:~/Projects/remote_git/linux$ sudo cat /proc/slabinfo | awk '{if($4 < 32) print $0}'
slabinfo - version: 2.1
ecryptfs_file_cache      0      0     16  240    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_revoke_table_s      2    240     16  240    1 : tunables  120   60    8 : slabdata      1      1      0
journal_handle         0      0     24  163    1 : tunables  120   60    8 : slabdata      0      0      0
revoke_table           0      0     16  240    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_data_buffer       0      0     24  163    1 : tunables  120   60    8 : slabdata      0      0      0
fsnotify_event_holder      0      0     24  163    1 : tunables  120   60    8 : slabdata      0      0      0
numa_policy            3    163     24  163    1 : tunables  120   60    8 : slabdata      1      1      0

> 
> > Moreover, we can configure slab_max_order in boot time so that we can't know
> > how many object are in a certain slab in compile time. Therefore we can't
> > decide the size of the index in compile time.
> 
> You can ignore the slab_max_order if necessary.
> 
> > I think that byte and short int sized index support would be enough, but
> > it should be determined at runtime.
> 
> On x86 f.e. it would add useless branching. The branches are never taken.
> You only need these if you do bad things to the system like requiring
> large contiguous allocs.

As I said before, since there is a possibility that some runtime loaded modules
use a 8 byte sized slab, we can't determine index size in compile time. Otherwise
we should always use short int sized index and I think that it is worse than
adding a branch.

Thanks.
