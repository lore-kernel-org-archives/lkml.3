Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab3GaNqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:46:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46877 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759659Ab3GaNZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Harshula Jayasuriya" <harshula@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.695849188@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [69/84] nfsd: nfsd_open: when dentry_open returns an error do not
 propagate as struct file
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Harshula Jayasuriya <harshula@redhat.com>

commit e4daf1ffbe6cc3b12aab4d604e627829e93e9914 upstream.

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

Signed-off-by: Harshula Jayasuriya <harshula@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -782,9 +782,10 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	}
 	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt),
 			    flags, current_cred());
-	if (IS_ERR(*filp))
+	if (IS_ERR(*filp)) {
 		host_err = PTR_ERR(*filp);
-	else
+		*filp = NULL;
+	} else
 		host_err = ima_file_check(*filp, access);
 out_nfserr:
 	err = nfserrno(host_err);

