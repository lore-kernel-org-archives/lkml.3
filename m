Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaIYMFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:05:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:60648 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIYMFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:05:13 -0400
Subject: [PATCH 0/5] fuse: handle release synchronously (v4)
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, avati@gluster.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2014 16:05:02 +0400
Message-ID: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a long-standing demand for synchronous behaviour of fuse_release:

http://sourceforge.net/mailarchive/message.php?msg_id=19343889
http://sourceforge.net/mailarchive/message.php?msg_id=29814693

A year ago Avati and me explained why such a feature would be useful:

http://sourceforge.net/mailarchive/message.php?msg_id=29889055
http://sourceforge.net/mailarchive/message.php?msg_id=29867423

In short, the problem is that fuse_release (that's usually called on last
user close(2)) sends FUSE_RELEASE to userspace and returns without waiting
for ACK from userspace. Consequently, there is a gap when user regards the
file released while userspace fuse is still working on it. An attempt to
access the file from another node leads to complicated synchronization
problems because the first node still "holds" the file.

The patch-set resolves the problem by making fuse_release synchronous:
wait for ACK from userspace for FUSE_RELEASE if the feature is ON.

It must be emphasized that even if the feature is enabled (i.e. fuse_release
is synchronous), nothing guarantees that fuse_release() will be called
in the context of close(2). In fact, it may happen later, on last fput().
However, there are still a lot of use cases when close(2) is synchronous,
so the feature must be regarded as an optimization maximizing chances of
synchronous behaviour of close(2).

To keep single-threaded userspace implementations happy the patch-set
ensures that by the time fuse_release_common calls fuse_file_put, no
more in-flight I/O exists. Asynchronous fuse callbacks (like
fuse_readpages_end) cannot trigger FUSE_RELEASE anymore. Hence, we'll
never block in contexts other than close().

Changed in v2:
 - improved comments, commented spin_unlock_wait out according to Brian'
suggestions.
 - rebased on v3.15-rc8 tag of Linus' tree.
Changed in v3:
 - changed patch-set title from "close file synchronously" to "handle
   release synchronously"
 - renamed CLOSE_WAIT to SYNC_RELEASE to convey the essence of the feature
   ("synchronous release" instead of "wait on close")
 - enabled feature on per file basis (instead of global fuse_conn parameter)
 - added "disable_sync_release" mount option
 - rebased on v3.17-rc1 tag of Linus' tree.
Changed in v4:
 - removed redundant locking around __fuse_file_put()
 - removed a patch making FUSE_RELEASE request uninterruptible. As Miklos
   pointed out, if the request is interrupted, then we should possibly allow
   that, effectively backgrounding the request. However, such a backgrounding
   is not easy to implement without breaking locking expectations of the
   userspace filesystem. Given the problem has existed for fuseblk mount for
   long time and there is no reasonable solution now, I put it aside for the
   future.

Thanks,
Maxim

---

Maxim Patlasov (5):
      fuse: add FOPEN_SYNC_RELEASE flag to ff->open_flags
      fuse: cosmetic rework of fuse_send_readpages
      fuse: wait for end of IO on release
      fuse: add mount option to disable synchronous release
      fuse: enable close_wait synchronous release


 fs/fuse/file.c            |   97 ++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h          |    3 +
 fs/fuse/inode.c           |    8 ++++
 include/uapi/linux/fuse.h |    3 +
 4 files changed, 95 insertions(+), 16 deletions(-)

-- 
Signature
