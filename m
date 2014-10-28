Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaJ1DoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:44:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbaJ1DoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Dickson <SteveD@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 054/127] NFS: Fix an uninitialised pointer Oops in the writeback error path
Date: Tue, 28 Oct 2014 11:34:49 +0800
Message-Id: <20141028033423.247041847@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 3caa0c6ed754d91b15266abf222498edbef982bd upstream.

SteveD reports the following Oops:
 RIP: 0010:[<ffffffffa053461d>]  [<ffffffffa053461d>] __put_nfs_open_context+0x1d/0x100 [nfs]
 RSP: 0018:ffff880fed687b90  EFLAGS: 00010286
 RAX: 0000000000000024 RBX: 0000000000000000 RCX: 0000000000000006
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: ffff880fed687bc0 R08: 0000000000000092 R09: 000000000000047a
 R10: 0000000000000000 R11: ffff880fed6878d6 R12: ffff880fed687d20
 R13: ffff880fed687d20 R14: 0000000000000070 R15: ffffea000aa33ec0
 FS:  00007fce290f0740(0000) GS:ffff8807ffc60000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000070 CR3: 00000007f2e79000 CR4: 00000000000007e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  0000000000000000 ffff880036c5e510 ffff880fed687d20 ffff880fed687d20
  ffff880036c5e200 ffffea000aa33ec0 ffff880fed687bd0 ffffffffa0534710
  ffff880fed687be8 ffffffffa053d5f0 ffff880036c5e200 ffff880fed687c08
 Call Trace:
  [<ffffffffa0534710>] put_nfs_open_context+0x10/0x20 [nfs]
  [<ffffffffa053d5f0>] nfs_pgio_data_destroy+0x20/0x40 [nfs]
  [<ffffffffa053d672>] nfs_pgio_error+0x22/0x40 [nfs]
  [<ffffffffa053d8f4>] nfs_generic_pgio+0x74/0x2e0 [nfs]
  [<ffffffffa06b18c3>] pnfs_generic_pg_writepages+0x63/0x210 [nfsv4]
  [<ffffffffa053d579>] nfs_pageio_doio+0x19/0x50 [nfs]
  [<ffffffffa053eb84>] nfs_pageio_complete+0x24/0x30 [nfs]
  [<ffffffffa053cb25>] nfs_direct_write_schedule_iovec+0x115/0x1f0 [nfs]
  [<ffffffffa053675f>] ? nfs_get_lock_context+0x4f/0x120 [nfs]
  [<ffffffffa053d252>] nfs_file_direct_write+0x262/0x420 [nfs]
  [<ffffffffa0532d91>] nfs_file_write+0x131/0x1d0 [nfs]
  [<ffffffffa0532c60>] ? nfs_need_sync_write.isra.17+0x40/0x40 [nfs]
  [<ffffffff812127b8>] do_io_submit+0x3b8/0x840
  [<ffffffff81212c50>] SyS_io_submit+0x10/0x20
  [<ffffffff81610f29>] system_call_fastpath+0x16/0x1b

This is due to the calls to nfs_pgio_error() in nfs_generic_pgio(), which
happen before the nfs_pgio_header's open context is referenced in
nfs_pgio_rpcsetup().

Reported-by: Steve Dickson <SteveD@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pagelist.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -527,7 +527,8 @@ EXPORT_SYMBOL_GPL(nfs_pgio_header_free);
  */
 void nfs_pgio_data_destroy(struct nfs_pgio_header *hdr)
 {
-	put_nfs_open_context(hdr->args.context);
+	if (hdr->args.context)
+		put_nfs_open_context(hdr->args.context);
 	if (hdr->page_array.pagevec != hdr->page_array.page_array)
 		kfree(hdr->page_array.pagevec);
 }


