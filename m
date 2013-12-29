Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3L2C7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:59:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55024 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab3L2CJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Trond Myklebust" <Trond.Myklebust@netapp.com>,
        "Jorge Mora" <mora@netapp.com>,
        "Weston Andros Adamson" <dros@netapp.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.199624110@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 002/185] NFSv4: Fix a use-after-free situation in
 _nfs4_proc_getlk()
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4052,6 +4052,7 @@ static int _nfs4_proc_getlk(struct nfs4_
 			status = 0;
 	}
 	request->fl_ops->fl_release_private(request);
+	request->fl_ops = NULL;
 out:
 	return status;
 }

