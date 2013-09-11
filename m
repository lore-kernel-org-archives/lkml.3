Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3IKFXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:23:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3IKE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:28 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=LHjWgZsI7oAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OHEMfjaMVskA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=sM9MO2aXLGW59yvERogA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042909.760193824@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Harshula Jayasuriya <harshula@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [105/251] nfsd: nfsd_open: when dentry_open returns an error do not propagate
 as struct file
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0105-nfsd-nfsd_open-when-dentry_open-returns-an-error-do-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Harshula Jayasuriya <harshula@redhat.com>

[ Upstream commit e4daf1ffbe6cc3b12aab4d604e627829e93e9914 ]

The following call chain:
------------------------------------------------------------
nfs4_get_vfs_file
- nfsd_open
  - dentry_open
    - do_dentry_open
      - __get_file_write_access
        - get_write_access
          - return atomic_inc_unless_negative(&inode->i_writecount) ? 0 : -ETXTBSY;
------------------------------------------------------------

can result in the following state:
------------------------------------------------------------
struct nfs4_file {
...
  fi_fds = {0xffff880c1fa65c80, 0xffffffffffffffe6, 0x0},
  fi_access = {{
      counter = 0x1
    }, {
      counter = 0x0
    }},
...
------------------------------------------------------------

1) First time around, in nfs4_get_vfs_file() fp->fi_fds[O_WRONLY] is
NULL, hence nfsd_open() is called where we get status set to an error
and fp->fi_fds[O_WRONLY] to -ETXTBSY. Thus we do not reach
nfs4_file_get_access() and fi_access[O_WRONLY] is not incremented.

2) Second time around, in nfs4_get_vfs_file() fp->fi_fds[O_WRONLY] is
NOT NULL (-ETXTBSY), so nfsd_open() is NOT called, but
nfs4_file_get_access() IS called and fi_access[O_WRONLY] is incremented.
Thus we leave a landmine in the form of the nfs4_file data structure in
an incorrect state.

3) Eventually, when __nfs4_file_put_access() is called it finds
fi_access[O_WRONLY] being non-zero, it decrements it and calls
nfs4_file_put_fd() which tries to fput -ETXTBSY.
------------------------------------------------------------
...
     [exception RIP: fput+0x9]
     RIP: ffffffff81177fa9  RSP: ffff88062e365c90  RFLAGS: 00010282
     RAX: ffff880c2b3d99cc  RBX: ffff880c2b3d9978  RCX: 0000000000000002
     RDX: dead000000100101  RSI: 0000000000000001  RDI: ffffffffffffffe6
     RBP: ffff88062e365c90   R8: ffff88041fe797d8   R9: ffff88062e365d58
     R10: 0000000000000008  R11: 0000000000000000  R12: 0000000000000001
     R13: 0000000000000007  R14: 0000000000000000  R15: 0000000000000000
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
  #9 [ffff88062e365c98] __nfs4_file_put_access at ffffffffa0562334 [nfsd]
 #10 [ffff88062e365cc8] nfs4_file_put_access at ffffffffa05623ab [nfsd]
 #11 [ffff88062e365ce8] free_generic_stateid at ffffffffa056634d [nfsd]
 #12 [ffff88062e365d18] release_open_stateid at ffffffffa0566e4b [nfsd]
 #13 [ffff88062e365d38] nfsd4_close at ffffffffa0567401 [nfsd]
 #14 [ffff88062e365d88] nfsd4_proc_compound at ffffffffa0557f28 [nfsd]
 #15 [ffff88062e365dd8] nfsd_dispatch at ffffffffa054543e [nfsd]
 #16 [ffff88062e365e18] svc_process_common at ffffffffa04ba5a4 [sunrpc]
 #17 [ffff88062e365e98] svc_process at ffffffffa04babe0 [sunrpc]
 #18 [ffff88062e365eb8] nfsd at ffffffffa0545b62 [nfsd]
 #19 [ffff88062e365ee8] kthread at ffffffff81090886
 #20 [ffff88062e365f48] kernel_thread at ffffffff8100c14a
------------------------------------------------------------

Cc: stable@vger.kernel.org
Signed-off-by: Harshula Jayasuriya <harshula@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfsd/vfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a9269f1..1db47bc 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -802,9 +802,10 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 			flags = O_WRONLY|O_LARGEFILE;
 	}
 	*filp = dentry_open(&path, flags, current_cred());
-	if (IS_ERR(*filp))
+	if (IS_ERR(*filp)) {
 		host_err = PTR_ERR(*filp);
-	else {
+		*filp = NULL;
+	} else {
 		host_err = ima_file_check(*filp, may_flags);
 
 		if (may_flags & NFSD_MAY_64BIT_COOKIE)
-- 
1.7.10.4


