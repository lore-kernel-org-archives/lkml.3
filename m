Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaI3Clw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:41:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbaI3Clu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:41:50 -0400
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Date: Tue, 30 Sep 2014 12:33:34 +1000
Subject: [PATCH 0/2] Allow access to sysfs attributes without mem
 allocations.
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20140930022205.13407.99210.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
 is this closer to what you would like?

 I do really need this functionality, but I honestly don't like this
 patch.
 The need to identify just which attributes need special care seems
 backwards to me.
  1/ it is the process (which has called mlock etc) which needs
     special care, more than the attribute.  Everything that process
     does needs to avoid allocating memory, whether that this is
     particularly related to enabling write-out or not.
  2/ It is also backwards because the vast majority of sysfs
     attributes only support bool/enum/int which means at most
     23 chars including sign and newline (maybe more for reads if the
     read provides a list of options).  So almost everything
     doesn't need an allocation at all - just some on-stack space.
     I would be quite happy to identify those attributes that
     may need care when accessing and could possibly supports
     read or write > 128 characters, because there wouldn't be any.

  I also don't like this approach because we end up allocating 2 pages
  for the buffer, as we have to ask for "PAGE_SIZE+1" bytes, for the
  hypothetical case that an important attribute actually requires a
  full PAGE_SIZE write...

  Would you be happy to have all specially identified attributes be
  limited to 127 characters IO max?  Then I would just use an on-stack
  buffer for those which would remove the allocation and simplify some
  of the code.

Thanks,
NeilBrown

---

NeilBrown (2):
      sysfs - allow attributes to request write buffer be pre-allocated.
      sysfs/kernfs: make read requests on pre-alloc files use the buffer.


 fs/kernfs/file.c       |   52 +++++++++++++++++++++++++++++++----------------
 fs/sysfs/file.c        |   53 +++++++++++++++++++++++++++++++++++++++++-------
 include/linux/kernfs.h |    2 ++
 include/linux/sysfs.h  |    9 ++++++++
 4 files changed, 90 insertions(+), 26 deletions(-)

-- 
Signature

