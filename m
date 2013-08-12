Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3HLQjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:39:07 -0400
Received: from relay.parallels.com ([195.214.232.42]:38149 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3HLQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:39:04 -0400
Subject: [PATCH 0/2] fuse: fix races related to fuse writeback
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, xemul@parallels.com
Date: Mon, 12 Aug 2013 20:39:00 +0400
Message-ID: <20130812163739.10366.64896.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patchset fixes a few subtle races stemmed from incorrect expectation
of what fuse_set_nowrite() guarantees. The fact that it makes fi->writectr
negative and waits for fi->writectr == FUSE_NOWRITE ensures only two things:

1) If there are any in-flight writeback requests right now, let's wait for
them being completed.
2) Suspend processing new writeback requests until fuse_release_nowrite().

Both are related to communication between in-kernel fuse and userspace
fuse daemon. But fuse_set_nowrite() does not prevent generic kernel code
from sending dirty pages to writeback resulting in fuse_writepage being
called. I.e. fi->queued_writes may grow independently on fuse_set_nowrite()
machinery.

As soon as fuse_writepage_locked() called end_page_writeback() generic
kernel code may do with the page virtually anything w/o notifying fuse. See
per-patch descriptions for details of some races.

Thanks,
Maxim

---

Maxim Patlasov (2):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()
      fuse: wait for writeback in fuse_file_fallocate()


 fs/fuse/file.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 46 insertions(+), 10 deletions(-)

-- 
Signature
