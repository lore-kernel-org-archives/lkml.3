Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaHWLZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:25:25 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1748 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbaHWLY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:24:58 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90829920"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] lustre: obdclass: use c99 initializers in structures
Date: Sat, 23 Aug 2014 13:20:27 +0200
Message-Id: <1408792831-25615-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use c99 initializers for structures.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
initializer list[decl.n] is;
@@

struct i1 i2 = { is,
+ .fld = e
- e
 ,...};
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

 drivers/staging/lustre/lustre/obdclass/obd_mount.c      |   10 ++++++++--
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c |    5 ++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index d972f71..54ba8df 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -1276,7 +1276,10 @@ EXPORT_SYMBOL(lustre_register_kill_super_cb);
 struct dentry *lustre_mount(struct file_system_type *fs_type, int flags,
 				const char *devname, void *data)
 {
-	struct lustre_mount_data2 lmd2 = { data, NULL };
+	struct lustre_mount_data2 lmd2 = {
+		.lmd2_data = data,
+		.lmd2_mnt = NULL
+	};
 
 	return mount_nodev(fs_type, flags, &lmd2, lustre_fill_super);
 }
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 8309d4c..1c5c1c9 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1572,7 +1572,10 @@ lproc_exp_hash_seq_show(struct seq_file *m, void *unused)
 {
 	struct nid_stat *stats = (struct nid_stat *)m->private;
 	struct obd_device *obd = stats->nid_obd;
-	struct exp_hash_cb_data cb_data = {m, true};
+	struct exp_hash_cb_data cb_data = {
+		.m = m,
+		.first = true
+	};
 
 	cfs_hash_for_each_key(obd->obd_nid_hash, &stats->nid,
 			      lprocfs_exp_print_hash, &cb_data);

