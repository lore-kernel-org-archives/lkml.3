Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964770AbaF3MTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:19:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51950 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sachin Prabhu <sprabhu@redhat.com>,
        Steve French <smfrench@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 020/181] cifs: Set client guid on per connection basis
Date: Mon, 30 Jun 2014 13:50:41 +0200
Message-Id: <8f7e86ca1df5a1766b9566540a62ff2804104bd4.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Prabhu <sprabhu@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 39552ea8120a699dbd0360848c4d949f9f0e6deb upstream.

When mounting from a Windows 2012R2 server, we hit the following
problem:
1) Mount with any of the following versions - 2.0, 2.1 or 3.0
2) unmount
3) Attempt a mount again using a different SMB version >= 2.0.

You end up with the following failure:
Status code returned 0xc0000203 STATUS_USER_SESSION_DELETED
CIFS VFS: Send error in SessSetup = -5
CIFS VFS: cifs_mount failed w/return code = -5

I cannot reproduce this issue using a Windows 2008 R2 server.

This appears to be caused because we use the same client guid for the
connection on first mount which we then disconnect and attempt to mount
again using a different protocol version. By generating a new guid each
time a new connection is Negotiated, we avoid hitting this problem.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/cifsfs.c   | 8 --------
 fs/cifs/cifsglob.h | 1 +
 fs/cifs/connect.c  | 3 +++
 fs/cifs/smb2pdu.c  | 5 +++--
 fs/cifs/smb2pdu.h  | 2 --
 5 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b38bd052ce6d..b9f5709b54ca 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -87,10 +87,6 @@ extern mempool_t *cifs_mid_poolp;
 
 struct workqueue_struct	*cifsiod_wq;
 
-#ifdef CONFIG_CIFS_SMB2
-__u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
-#endif
-
 /*
  * Bumps refcount for cifs super block.
  * Note that it should be only called if a referece to VFS super block is
@@ -1192,10 +1188,6 @@ init_cifs(void)
 	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
-#ifdef CONFIG_CIFS_SMB2
-	get_random_bytes(cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
-#endif
-
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
 		cifs_dbg(FYI, "cifs_max_pending set to min of 2\n");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b6e1b2f36b69..465b65488b27 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -547,6 +547,7 @@ struct TCP_Server_Info {
 	int echo_credits;  /* echo reserved slots */
 	int oplock_credits;  /* oplock break reserved slots */
 	bool echoes:1; /* enable echoes */
+	__u8 client_guid[SMB2_CLIENT_GUID_SIZE]; /* Client GUID */
 #endif
 	u16 dialect; /* dialect index that server chose */
 	bool oplocks:1; /* enable oplocks */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a279ffc0bc29..89b5519085c2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2144,6 +2144,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	       sizeof(tcp_ses->srcaddr));
 	memcpy(&tcp_ses->dstaddr, &volume_info->dstaddr,
 		sizeof(tcp_ses->dstaddr));
+#ifdef CONFIG_CIFS_SMB2
+	get_random_bytes(tcp_ses->client_guid, SMB2_CLIENT_GUID_SIZE);
+#endif
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c54d7eb39b41..37de258d9a34 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -375,7 +375,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 
 	req->Capabilities = cpu_to_le32(ses->server->vals->req_capabilities);
 
-	memcpy(req->ClientGUID, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
+	memcpy(req->ClientGUID, server->client_guid, SMB2_CLIENT_GUID_SIZE);
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
@@ -478,7 +478,8 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	vneg_inbuf.Capabilities =
 			cpu_to_le32(tcon->ses->server->vals->req_capabilities);
-	memcpy(vneg_inbuf.Guid, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
+	memcpy(vneg_inbuf.Guid, tcon->ses->server->client_guid,
+					SMB2_CLIENT_GUID_SIZE);
 
 	if (tcon->ses->sign)
 		vneg_inbuf.SecurityMode =
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 870f97303ef3..6133a4e45c6e 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -166,8 +166,6 @@ struct smb2_symlink_err_rsp {
 
 #define SMB2_CLIENT_GUID_SIZE 16
 
-extern __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
-
 struct smb2_negotiate_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 36 */
-- 
2.0.0

