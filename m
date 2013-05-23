Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab3EWXSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 19:18:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759895Ab3EWXSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 19:18:07 -0400
Date: Thu, 23 May 2013 16:18:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [Suggestion] fs/namespace.c: the direct cause of the warning
 for: "ida_remove called for id=0 which is not allocated" with
 mnt_release_group_id()
Message-Id: <20130523161805.1faa0f8c59bfc8ee728d8c7f@linux-foundation.org>
In-Reply-To: <5191FE96.6050607@asianux.com>
References: <5191FE96.6050607@asianux.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 May 2013 17:06:30 +0800 Chen Gang <gang.chen@asianux.com> wrote:

> After call collect_mounts(), then call drop_collected_mounts(), it will
> report an warning: "ida_remove called for id=0 which is not allocated"
> (one sample is audit_add_tree_rule() in kernel/audit_tree.c).
> 
> The direct cause (maybe also be the root cause):
>   collect_mounts() passs 'CL_PRIVATE' to copy_tree() -> clone_mnt().
>   it will set "mnt->mnt_group_id = 0" in clone_mnt().
>   when drop_collected_mounts() -> mnt_release_group_id(), 'mnt->mnt_group_id == 0'.

I expect this patch also addresses the bug.  Can you please review and test it?


From: Takashi Iwai <tiwai@suse.de>
Subject: vfs: fix invalid ida_remove() call

When the group id of a shared mount is not allocated, the umount still
tries to call mnt_release_group_id(), which eventually hits a kernel
warning at ida_remove() spewing a message like:

  ida_remove called for id=0 which is not allocated.

This patch fixes the bug simply checking the group id in the caller.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Cristian Rodríguez <crrodriguez@opensuse.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pnode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/pnode.c~vfs-fix-invalid-ida_remove-call fs/pnode.c
--- a/fs/pnode.c~vfs-fix-invalid-ida_remove-call
+++ a/fs/pnode.c
@@ -83,7 +83,8 @@ static int do_make_slave(struct mount *m
 		if (peer_mnt == mnt)
 			peer_mnt = NULL;
 	}
-	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share))
+	if (mnt->mnt_group_id && IS_MNT_SHARED(mnt) &&
+	    list_empty(&mnt->mnt_share))
 		mnt_release_group_id(mnt);
 
 	list_del_init(&mnt->mnt_share);
_

