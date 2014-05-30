Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396AbaE3UGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:06:20 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63798 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaE3UGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:06:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org
Subject: [RFC 20/32] afs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:44 +0200
Message-Id: <1401480116-1973111-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WJ/u6hMjnTC/qx7jxsNaoEQrtrsTWx5WBbiPI4fq6Ty
 zTxpCN1gkrFYeimPWLu4RWcV01SYs6MNMdaf/8A24CFUl0IYPW
 Xl6LhUOHBWqHwXWgIHPhUE7dXfT7jmXIP1Bc1Fz19KrD4Rh/Lo
 /i7EbSmgo3ogSyWe/4TG51x3TP0iscN92lqGBE24wInkfVJ+ZD
 67hcewwGiaB5F7jxi98qOnNbe98KvbV7dALSCaSpPuYovrCL7x
 ENh5l2N4XIqjPLEJgpq0FIT+qpLzP19q9qvVqwkujyMe7Kx3Gd
 UBpay6mgYWdobpio9TFBm91PMMR7OHSsLTUJ9bDaG76YV4IWPB
 uVReB3U34Rt3VYRC6yiuralPNrrIOQkwcDUwBewbm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

afs uses an unsigned 32-bit seconds numbers for inode timestamps on the
wire, which will work for the next 92 years, but the code internally
uses a signed time_t, which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in afs, and changes the afs code to use an unsigned
number internally.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org
---
 fs/afs/afs.h      | 6 +++---
 fs/afs/fsclient.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/afs/afs.h b/fs/afs/afs.h
index 3c462ff..53113a8 100644
--- a/fs/afs/afs.h
+++ b/fs/afs/afs.h
@@ -125,8 +125,8 @@ struct afs_file_status {
 	afs_access_t		anon_access;	/* access rights for unauthenticated caller */
 	umode_t			mode;		/* UNIX mode */
 	struct afs_fid		parent;		/* parent dir ID for non-dirs only */
-	time_t			mtime_client;	/* last time client changed data */
-	time_t			mtime_server;	/* last time server changed data */
+	u32			mtime_client;	/* last time client changed data */
+	u32			mtime_server;	/* last time server changed data */
 	s32			lock_count;	/* file lock count (0=UNLK -1=WRLCK +ve=#RDLCK */
 };
 
@@ -144,7 +144,7 @@ struct afs_file_status {
  * AFS volume synchronisation information
  */
 struct afs_volsync {
-	time_t			creation;	/* volume creation time */
+	u32			creation;	/* volume creation time */
 };
 
 /*
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index c2e930e..7c0f4a5 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -85,7 +85,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 	}
 	status->mode &= S_IALLUGO;
 
-	_debug("vnode time %lx, %lx",
+	_debug("vnode time %x, %x",
 	       status->mtime_client, status->mtime_server);
 
 	if (vnode) {
-- 
1.8.3.2

