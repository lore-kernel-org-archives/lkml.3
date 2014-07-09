Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbaGIXlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:41:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbaGIXlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:41:51 -0400
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Date: Thu, 10 Jul 2014 09:41:14 +1000
Subject: [PATCH 0/6] autofs4: support RCU-walk
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140709233541.4525.25151.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

autofs4 currently doesn't support RCU-walk - it immediately
aborts any attempt at RCU-walk to force REF-walk for path name
lookup.

This can cause a significant performance impact on multi-core
systems.
I have a client with a test case which spends >80% of its time
waiting for spinlocks with a "make -j 40" on a 40 core system.

This patchset aims to remove most of these spinlocks.  To be fully
effective in the particular case it needs a second patch set which
makes NFS RCU-walk friendly, but one thing at a time.

This has only been lightly tested so far so I'm really after feed-back
rather than to have the patch set accepted, though the first two
patches are trivial and could be taken immediately.

The last two patches are the most interesting so review comments on
those are particularly welcome.

Thanks,
NeilBrown


---

NeilBrown (6):
      autofs4: remove unused autofs4_ispending()
      autofs4: remove a redundant assignment
      autofs4: allow RCU-walk to walk through autofs4.
      autofs4: factor should_expire() out of autofs4_expire_indirect.
      autofs4: avoid taking fs_lock during rcu-walk
      autofs4: don't take spinlock when not needed in autofs4_lookup_expiring


 fs/autofs4/autofs_i.h  |   20 +----
 fs/autofs4/dev-ioctl.c |    2 -
 fs/autofs4/expire.c    |  192 +++++++++++++++++++++++++++++-------------------
 fs/autofs4/root.c      |   46 ++++++++----
 4 files changed, 151 insertions(+), 109 deletions(-)

-- 
Signature

