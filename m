Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaJHX6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:58:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaJHX6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:58:09 -0400
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 09 Oct 2014 10:57:06 +1100
Subject: [PATCH 0/2 V2] Allow access to sysfs attributes without mem
 allocations.
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20141008234119.19126.4182.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
 thanks for the review.  This version incorporates your suggestions.

 You are certainly right about there being issues deeper than just the
 sysfs/kernfs level - I've been cleaning up the locking in md to avoid
 the "reconfig_mutex" as much as possible.  It is something that has
 been at the back of my mind for a while, but this need has pushed it
 to the fore-front.  All the attributes that mdmon needs to touch will
 soon only take a spinlock or nothing.

 On the topic of inadvertently locking in semantics, I noticed that
 prior to kernfs, sysfs would allocate a buffer on first read or
 write, and continue to use that buffer.  I could try to argue that I
 was using those semantics, which have now changed ... though I wasn't
 doing it consciously...  Certainly this is a thorny issue.

 As well as checking that ->seq_show isn't used with ->prealloc,
 I've also made sure that sysfs_kf_read() doesn't call the attribute
 ->show() function unless it is certain it has a preallocated (and
 hence >= PAGE_SIZE) buffer.

Thanks,
NeilBrown

---

NeilBrown (2):
      sysfs/kernfs: allow attributes to request write buffer be pre-allocated.
      sysfs/kernfs: make read requests on pre-alloc files use the buffer.


 fs/kernfs/file.c       |   70 ++++++++++++++++++++++++++++++++----------------
 fs/sysfs/file.c        |   53 +++++++++++++++++++++++++++++++-----
 include/linux/kernfs.h |    2 +
 include/linux/sysfs.h  |    9 ++++++
 4 files changed, 103 insertions(+), 31 deletions(-)

-- 
Signature

