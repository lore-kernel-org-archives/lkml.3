Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbbA2GGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:06:39 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47517 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbbA2GGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:06:36 -0500
Date: Thu, 29 Jan 2015 11:36:14 +0530
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] afs: Migrate vlocation fields to 64-bit
Message-ID: <20150129060614.GA3456@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_seconds() returns real wall-clock seconds. On 32-bit systems
this value will overflow in year 2038 and beyond. This patch changes
afs's vlocation record to use ktime_get_real_seconds() instead, for the
fields time_of_death and update_at.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 fs/afs/callback.c  |  7 ++++---
 fs/afs/internal.h  |  7 ++++---
 fs/afs/server.c    |  6 +++---
 fs/afs/vlocation.c | 16 +++++++++-------
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 7ef637d..7d54efd 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -362,7 +362,7 @@ static void afs_callback_updater(struct work_struct *work)
 {
 	struct afs_server *server;
 	struct afs_vnode *vnode, *xvnode;
-	time_t now;
+	time64_t now;
 	long timeout;
 	int ret;
 
@@ -370,7 +370,7 @@ static void afs_callback_updater(struct work_struct *work)
 
 	_enter("");
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 
 	/* find the first vnode to update */
 	spin_lock(&server->cb_lock);
@@ -424,7 +424,8 @@ static void afs_callback_updater(struct work_struct *work)
 
 	/* and then reschedule */
 	_debug("reschedule");
-	vnode->update_at = get_seconds() + afs_vnode_update_timeout;
+	vnode->update_at = ktime_get_real_seconds() +
+			afs_vnode_update_timeout;
 
 	spin_lock(&server->cb_lock);
 
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 71d5982..63c97e2 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -11,6 +11,7 @@
 
 #include <linux/compiler.h>
 #include <linux/kernel.h>
+#include <linux/ktime.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/skbuff.h>
@@ -247,7 +248,7 @@ struct afs_cache_vhash {
  */
 struct afs_vlocation {
 	atomic_t		usage;
-	time_t			time_of_death;	/* time at which put reduced usage to 0 */
+	time64_t		time_of_death;	/* time at which put reduced usage to 0 */
 	struct list_head	link;		/* link in cell volume location list */
 	struct list_head	grave;		/* link in master graveyard list */
 	struct list_head	update;		/* link in master update list */
@@ -258,7 +259,7 @@ struct afs_vlocation {
 	struct afs_cache_vlocation vldb;	/* volume information DB record */
 	struct afs_volume	*vols[3];	/* volume access record pointer (index by type) */
 	wait_queue_head_t	waitq;		/* status change waitqueue */
-	time_t			update_at;	/* time at which record should be updated */
+	time64_t		update_at;	/* time at which record should be updated */
 	spinlock_t		lock;		/* access lock */
 	afs_vlocation_state_t	state;		/* volume location state */
 	unsigned short		upd_rej_cnt;	/* ENOMEDIUM count during update */
@@ -271,7 +272,7 @@ struct afs_vlocation {
  */
 struct afs_server {
 	atomic_t		usage;
-	time_t			time_of_death;	/* time at which put reduced usage to 0 */
+	time64_t		time_of_death;	/* time at which put reduced usage to 0 */
 	struct in_addr		addr;		/* server address */
 	struct afs_cell		*cell;		/* cell in which server resides */
 	struct list_head	link;		/* link in cell's server list */
diff --git a/fs/afs/server.c b/fs/afs/server.c
index f342acf..3bc1a46 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -237,7 +237,7 @@ void afs_put_server(struct afs_server *server)
 	spin_lock(&afs_server_graveyard_lock);
 	if (atomic_read(&server->usage) == 0) {
 		list_move_tail(&server->grave, &afs_server_graveyard);
-		server->time_of_death = get_seconds();
+		server->time_of_death = ktime_get_real_seconds();
 		queue_delayed_work(afs_wq, &afs_server_reaper,
 				   afs_server_timeout * HZ);
 	}
@@ -272,9 +272,9 @@ static void afs_reap_server(struct work_struct *work)
 	LIST_HEAD(corpses);
 	struct afs_server *server;
 	unsigned long delay, expiry;
-	time_t now;
+	time64_t now;
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 	spin_lock(&afs_server_graveyard_lock);
 
 	while (!list_empty(&afs_server_graveyard)) {
diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
index 5297678..ee9015c 100644
--- a/fs/afs/vlocation.c
+++ b/fs/afs/vlocation.c
@@ -340,7 +340,8 @@ static void afs_vlocation_queue_for_updates(struct afs_vlocation *vl)
 	struct afs_vlocation *xvl;
 
 	/* wait at least 10 minutes before updating... */
-	vl->update_at = get_seconds() + afs_vlocation_update_timeout;
+	vl->update_at = ktime_get_real_seconds() +
+			afs_vlocation_update_timeout;
 
 	spin_lock(&afs_vlocation_updates_lock);
 
@@ -506,7 +507,7 @@ void afs_put_vlocation(struct afs_vlocation *vl)
 	if (atomic_read(&vl->usage) == 0) {
 		_debug("buried");
 		list_move_tail(&vl->grave, &afs_vlocation_graveyard);
-		vl->time_of_death = get_seconds();
+		vl->time_of_death = ktime_get_real_seconds();
 		queue_delayed_work(afs_wq, &afs_vlocation_reap,
 				   afs_vlocation_timeout * HZ);
 
@@ -543,11 +544,11 @@ static void afs_vlocation_reaper(struct work_struct *work)
 	LIST_HEAD(corpses);
 	struct afs_vlocation *vl;
 	unsigned long delay, expiry;
-	time_t now;
+	time64_t now;
 
 	_enter("");
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 	spin_lock(&afs_vlocation_graveyard_lock);
 
 	while (!list_empty(&afs_vlocation_graveyard)) {
@@ -622,13 +623,13 @@ static void afs_vlocation_updater(struct work_struct *work)
 {
 	struct afs_cache_vlocation vldb;
 	struct afs_vlocation *vl, *xvl;
-	time_t now;
+	time64_t now;
 	long timeout;
 	int ret;
 
 	_enter("");
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 
 	/* find a record to update */
 	spin_lock(&afs_vlocation_updates_lock);
@@ -684,7 +685,8 @@ static void afs_vlocation_updater(struct work_struct *work)
 
 	/* and then reschedule */
 	_debug("reschedule");
-	vl->update_at = get_seconds() + afs_vlocation_update_timeout;
+	vl->update_at = ktime_get_real_seconds() +
+			afs_vlocation_update_timeout;
 
 	spin_lock(&afs_vlocation_updates_lock);
 
-- 
2.2.0.rc0.207.ga3a616c

