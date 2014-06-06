Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaFFN1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:27:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:43604 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaFFN1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:27:11 -0400
Subject: [PATCH 0/5] fuse: close file synchronously (v2)
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 06 Jun 2014 17:27:09 +0400
Message-ID: <20140606132541.30321.68679.stgit@localhost.localdomain>
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

In short, the problem is that fuse_release (that's called on last user
close(2)) sends FUSE_RELEASE to userspace and returns without waiting for
ACK from userspace. Consequently, there is a gap when user regards the
file released while userspace fuse is still working on it. An attempt to
access the file from another node leads to complicated synchronization
problems because the first node still "holds" the file.

The patch-set resolves the problem by making fuse_release synchronous:
wait for ACK from userspace for FUSE_RELEASE if the feature is ON.

To keep single-threaded userspace implementations happy the patch-set
ensures that by the time fuse_release_common calls fuse_file_put, no
more in-flight I/O exists. Asynchronous fuse callbacks (like
fuse_readpages_end) cannot trigger FUSE_RELEASE anymore. Hence, we'll
never block in contexts other than close().

Changed in v2:
 - improved comments, commented spin_unlock_wait out according to Brian'
suggestions.
 - rebased on v3.15-rc8 tag of Linus' tree.

Thanks,
Maxim

---

Maxim Patlasov (5):
      fuse: add close_wait flag to fuse_conn
      fuse: cosmetic rework of fuse_send_readpages
      fuse: wait for end of IO on release
      fuse: enable close_wait feature
      fuse: fix synchronous case of fuse_file_put()


 fs/fuse/file.c            |  100 ++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h          |    3 +
 fs/fuse/inode.c           |    4 +-
 include/uapi/linux/fuse.h |    3 +
 4 files changed, 93 insertions(+), 17 deletions(-)

-- 
Signature
