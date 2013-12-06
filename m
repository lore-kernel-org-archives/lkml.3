Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161348Ab3LFXMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:12:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48321 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967Ab3LFXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 009/152] NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()
Date: Fri,  6 Dec 2013 15:08:53 -0800
Message-Id: <1386371476-2477-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a6f951ddbdfb7bd87d31a44f61abe202ed6ce57f upstream.

In nfs4_proc_getlk(), when some error causes a retry of the call to
_nfs4_proc_getlk(), we can end up with Oopses of the form

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000134
 IP: [<ffffffff8165270e>] _raw_spin_lock+0xe/0x30
<snip>
 Call Trace:
  [<ffffffff812f287d>] _atomic_dec_and_lock+0x4d/0x70
  [<ffffffffa053c4f2>] nfs4_put_lock_state+0x32/0xb0 [nfsv4]
  [<ffffffffa053c585>] nfs4_fl_release_lock+0x15/0x20 [nfsv4]
  [<ffffffffa0522c06>] _nfs4_proc_getlk.isra.40+0x146/0x170 [nfsv4]
  [<ffffffffa052ad99>] nfs4_proc_lock+0x399/0x5a0 [nfsv4]

The problem is that we don't clear the request->fl_ops after the first
try and so when we retry, nfs4_set_lock_state() exits early without
setting the lock stateid.
Regression introduced by commit 70cc6487a4e08b8698c0e2ec935fb48d10490162
(locks: make ->lock release private data before returning in GETLK case)

Reported-by: Weston Andros Adamson <dros@netapp.com>
Reported-by: Jorge Mora <mora@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ad967bf..ecc6f12 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4326,6 +4326,7 @@ static int _nfs4_proc_getlk(struct nfs4_state *state, int cmd, struct file_lock
 			status = 0;
 	}
 	request->fl_ops->fl_release_private(request);
+	request->fl_ops = NULL;
 out:
 	return status;
 }
-- 
1.8.3.2

