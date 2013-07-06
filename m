Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3GFMPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 08:15:44 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56676 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GFMPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 08:15:20 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 1/3] nfs: add lock annotations to squelch sparse warnings
Date: Sat,  6 Jul 2013 17:41:24 +0530
Message-Id: <1373112686-28501-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.733.gf8abaeb
In-Reply-To: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
References: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse, being a static analyzer, emits the following warnings:

  context imbalance in 'nfs_server_list_start' - wrong count at exit
  context imbalance in 'nfs_server_list_start' - unexpected unlock
  context imbalance in 'nfs_volume_list_start' - wrong count at exit
  context imbalance in 'nfs_volume_list_start' - unexpected unlock

Help it by annotating the pairs of functions with __acquires and
__releases.

Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 fs/nfs/client.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index c513b0c..2a32ac8 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1253,6 +1253,7 @@ static int nfs_server_list_open(struct inode *inode, struct file *file)
  * set up the iterator to start reading from the server list and return the first item
  */
 static void *nfs_server_list_start(struct seq_file *m, loff_t *_pos)
+	__acquires(&nn->nfs_client_lock)
 {
 	struct nfs_net *nn = net_generic(m->private, nfs_net_id);
 
@@ -1275,6 +1276,7 @@ static void *nfs_server_list_next(struct seq_file *p, void *v, loff_t *pos)
  * clean up after reading from the transports list
  */
 static void nfs_server_list_stop(struct seq_file *p, void *v)
+	__releases(&nn->nfs_client_lock)
 {
 	struct nfs_net *nn = net_generic(p->private, nfs_net_id);
 
@@ -1338,6 +1340,7 @@ static int nfs_volume_list_open(struct inode *inode, struct file *file)
  * set up the iterator to start reading from the volume list and return the first item
  */
 static void *nfs_volume_list_start(struct seq_file *m, loff_t *_pos)
+	__acquires(&nn->nfs_client_lock)
 {
 	struct nfs_net *nn = net_generic(m->private, nfs_net_id);
 
@@ -1360,6 +1363,7 @@ static void *nfs_volume_list_next(struct seq_file *p, void *v, loff_t *pos)
  * clean up after reading from the transports list
  */
 static void nfs_volume_list_stop(struct seq_file *p, void *v)
+	__releases(&nn->nfs_client_lock)
 {
 	struct nfs_net *nn = net_generic(p->private, nfs_net_id);
 
-- 
1.8.3.2.733.gf8abaeb

