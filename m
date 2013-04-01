Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab3DAKjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:39:42 -0400
Received: from relay.parallels.com ([195.214.232.42]:54373 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab3DAKjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:39:41 -0400
Subject: [PATCH v4 00/14] fuse: An attempt to implement a write-back cache
 policy
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:40:09 +0400
Message-ID: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the fourth iteration of Pavel Emelyanov's patch-set implementing
write-back policy for FUSE page cache. Initial patch-set description was
the following:

One of the problems with the existing FUSE implementation is that it uses the
write-through cache policy which results in performance problems on certain
workloads. E.g. when copying a big file into a FUSE file the cp pushes every
128k to the userspace synchronously. This becomes a problem when the userspace
back-end uses networking for storing the data.

A good solution of this is switching the FUSE page cache into a write-back policy.
With this file data are pushed to the userspace with big chunks (depending on the
dirty memory limits, but this is much more than 128k) which lets the FUSE daemons
handle the size updates in a more efficient manner.

The writeback feature is per-connection and is explicitly configurable at the
init stage (is it worth making it CAP_SOMETHING protected?) When the writeback is
turned ON:

* still copy writeback pages to temporary buffer when sending a writeback request
  and finish the page writeback immediately

* make kernel maintain the inode's i_size to avoid frequent i_size synchronization
  with the user space

* take NR_WRITEBACK_TEMP into account when makeing balance_dirty_pages decision.
  This protects us from having too many dirty pages on FUSE

The provided patchset survives the fsx test. Performance measurements are not yet
all finished, but the mentioned copying of a huge file becomes noticeably faster
even on machines with few RAM and doesn't make the system stuck (the dirty pages
balancer does its work OK). Applies on top of v3.5-rc4.

We are currently exploring this with our own distributed storage implementation
which is heavily oriented on storing big blobs of data with extremely rare meta-data
updates (virtual machines' and containers' disk images). With the existing cache
policy a typical usage scenario -- copying a big VM disk into a cloud -- takes way
too much time to proceed, much longer than if it was simply scp-ed over the same
network. The write-back policy (as I mentioned) noticeably improves this scenario.
Kirill (in Cc) can share more details about the performance and the storage concepts
details if required.

Changed in v2:
 - numerous bugfixes:
   - fuse_write_begin and fuse_writepages_fill and fuse_writepage_locked must wait
     on page writeback because page writeback can extend beyond the lifetime of
     the page-cache page
   - fuse_send_writepages can end_page_writeback on original page only after adding
     request to fi->writepages list; otherwise another writeback may happen inside
     the gap between end_page_writeback and adding to the list
   - fuse_direct_io must wait on page writeback; otherwise data corruption is possible
     due to reordering requests
   - fuse_flush must flush dirty memory and wait for all writeback on given inode
     before sending FUSE_FLUSH to userspace; otherwise FUSE_FLUSH is not reliable
   - fuse_file_fallocate must hold i_mutex around FUSE_FALLOCATE and i_size update;
     otherwise a race with a writer extending i_size is possible
   - fix handling errors in fuse_writepages and fuse_send_writepages
 - handle i_mtime intelligently if writeback cache is on (see patch #7 (update i_mtime
   on buffered writes) for details.
 - put enabling writeback cache under fusermount control; (see mount option
   'allow_wbcache' introduced by patch #13 (turn writeback cache on))
 - rebased on v3.7-rc5

Changed in v3:
 - rebased on for-next branch of the fuse tree (fb05f41f5f96f7423c53da4d87913fb44fd0565d)

Changed in v4:
 - rebased on for-next branch of the fuse tree (634734b63ac39e137a1c623ba74f3e062b6577db)
 - fixed fuse_fillattr() for non-writeback_chace case
 - added comments explaining why we cannot trust size from server
 - rewrote patch handling i_mtime; it's titled Trust-kernel-i_mtime-only now
 - simplified patch titled Flush-files-on-wb-close
 - eliminated code duplications from fuse_readpage() ans fuse_prepare_write()
 - added comment about "disk full" errors to fuse_write_begin()

Thanks,
Maxim

---

Maxim V. Patlasov (14):
      fuse: Linking file to inode helper
      fuse: Getting file for writeback helper
      fuse: Prepare to handle short reads
      fuse: Prepare to handle multiple pages in writeback
      fuse: Connection bit for enabling writeback
      fuse: Trust kernel i_size only - v3
      fuse: Trust kernel i_mtime only
      fuse: Flush files on wb close
      fuse: Implement writepages and write_begin/write_end callbacks - v3
      fuse: fuse_writepage_locked() should wait on writeback
      fuse: fuse_flush() should wait on writeback
      fuse: Fix O_DIRECT operations vs cached writeback misorder - v2
      fuse: Turn writeback cache on
      mm: Account for WRITEBACK_TEMP in balance_dirty_pages


 fs/fuse/cuse.c            |    5 
 fs/fuse/dir.c             |  127 +++++++++-
 fs/fuse/file.c            |  575 ++++++++++++++++++++++++++++++++++++++++-----
 fs/fuse/fuse_i.h          |   26 ++
 fs/fuse/inode.c           |   37 +++
 include/uapi/linux/fuse.h |    2 
 mm/page-writeback.c       |    3 
 7 files changed, 689 insertions(+), 86 deletions(-)

-- 
Signature
