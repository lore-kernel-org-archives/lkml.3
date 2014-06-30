Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaF3MPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:15:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51939 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
        David Disseldorp <ddiss@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 019/181] Check SMB3 dialects against downgrade attacks
Date: Mon, 30 Jun 2014 13:50:40 +0200
Message-Id: <16e57e5502a55b6a844d4a3de9b5cc2f8e41d3c8.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve French <smfrench@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ff1c038addc4f205d5f1ede449426c7d316c0eed upstream.

When we are running SMB3 or SMB3.02 connections which are signed
we need to validate the protocol negotiation information,
to ensure that the negotiate protocol response was not tampered with.

Add the missing FSCTL which is sent at mount time (immediately after
the SMB3 Tree Connect) to validate that the capabilities match
what we think the server sent.

"Secure dialect negotiation is introduced in SMB3 to protect against
man-in-the-middle attempt to downgrade dialect negotiation.
The idea is to prevent an eavesdropper from downgrading the initially
negotiated dialect and capabilities between the client and the server."

For more explanation see 2.2.31.4 of MS-SMB2 or
http://blogs.msdn.com/b/openspecification/archive/2012/06/28/smb3-secure-dialect-negotiation.aspx

Reviewed-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Steve French <smfrench@gmail.com>
[ddiss@suse.de: backported atop kernel without clone_range support]
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/smb2ops.c   |  1 +
 fs/cifs/smb2pdu.c   | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   | 12 ++++++---
 fs/cifs/smb2proto.h |  1 +
 fs/cifs/smbfsctl.h  |  2 +-
 6 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2f6f1ac52d3f..b6e1b2f36b69 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -391,6 +391,7 @@ struct smb_version_operations {
 			const char *, u32 *);
 	int (*set_acl)(struct cifs_ntsd *, __u32, struct inode *, const char *,
 			int);
+	int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 13e505191364..4ac88f89a5e5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1059,6 +1059,7 @@ struct smb_version_operations smb30_operations = {
 	.set_oplock_level = smb3_set_oplock_level,
 	.create_lease_buf = smb3_create_lease_buf,
 	.parse_lease_buf = smb3_parse_lease_buf,
+	.validate_negotiate = smb3_validate_negotiate,
 };
 
 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 06d29e3f5d10..c54d7eb39b41 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -456,6 +456,81 @@ neg_exit:
 	return rc;
 }
 
+int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
+{
+	int rc = 0;
+	struct validate_negotiate_info_req vneg_inbuf;
+	struct validate_negotiate_info_rsp *pneg_rsp;
+	u32 rsplen;
+
+	cifs_dbg(FYI, "validate negotiate\n");
+
+	/*
+	 * validation ioctl must be signed, so no point sending this if we
+	 * can not sign it.  We could eventually change this to selectively
+	 * sign just this, the first and only signed request on a connection.
+	 * This is good enough for now since a user who wants better security
+	 * would also enable signing on the mount. Having validation of
+	 * negotiate info for signed connections helps reduce attack vectors
+	 */
+	if (tcon->ses->server->sign == false)
+		return 0; /* validation requires signing */
+
+	vneg_inbuf.Capabilities =
+			cpu_to_le32(tcon->ses->server->vals->req_capabilities);
+	memcpy(vneg_inbuf.Guid, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
+
+	if (tcon->ses->sign)
+		vneg_inbuf.SecurityMode =
+			cpu_to_le16(SMB2_NEGOTIATE_SIGNING_REQUIRED);
+	else if (global_secflags & CIFSSEC_MAY_SIGN)
+		vneg_inbuf.SecurityMode =
+			cpu_to_le16(SMB2_NEGOTIATE_SIGNING_ENABLED);
+	else
+		vneg_inbuf.SecurityMode = 0;
+
+	vneg_inbuf.DialectCount = cpu_to_le16(1);
+	vneg_inbuf.Dialects[0] =
+		cpu_to_le16(tcon->ses->server->vals->protocol_id);
+
+	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
+		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
+		(char *)&vneg_inbuf, sizeof(struct validate_negotiate_info_req),
+		(char **)&pneg_rsp, &rsplen);
+
+	if (rc != 0) {
+		cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", rc);
+		return -EIO;
+	}
+
+	if (rsplen != sizeof(struct validate_negotiate_info_rsp)) {
+		cifs_dbg(VFS, "invalid size of protocol negotiate response\n");
+		return -EIO;
+	}
+
+	/* check validate negotiate info response matches what we got earlier */
+	if (pneg_rsp->Dialect !=
+			cpu_to_le16(tcon->ses->server->vals->protocol_id))
+		goto vneg_out;
+
+	if (pneg_rsp->SecurityMode != cpu_to_le16(tcon->ses->server->sec_mode))
+		goto vneg_out;
+
+	/* do not validate server guid because not saved at negprot time yet */
+
+	if ((le32_to_cpu(pneg_rsp->Capabilities) | SMB2_NT_FIND |
+	      SMB2_LARGE_FILES) != tcon->ses->server->capabilities)
+		goto vneg_out;
+
+	/* validate negotiate successful */
+	cifs_dbg(FYI, "validate negotiate info successful\n");
+	return 0;
+
+vneg_out:
+	cifs_dbg(VFS, "protocol revalidation - security settings mismatch\n");
+	return -EIO;
+}
+
 int
 SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 		const struct nls_table *nls_cp)
@@ -821,6 +896,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	    ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
 		cifs_dbg(VFS, "DFS capability contradicts DFS flag\n");
 
+	if (tcon->ses->server->ops->validate_negotiate)
+		rc = tcon->ses->server->ops->validate_negotiate(xid, tcon);
 tcon_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	kfree(unc_path);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index b83d0118a757..870f97303ef3 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -546,13 +546,19 @@ struct copychunk_ioctl {
 	__u32 Reserved2;
 } __packed;
 
-/* Response and Request are the same format */
-struct validate_negotiate_info {
+struct validate_negotiate_info_req {
 	__le32 Capabilities;
 	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
 	__le16 SecurityMode;
 	__le16 DialectCount;
-	__le16 Dialect[1];
+	__le16 Dialects[1]; /* dialect (someday maybe list) client asked for */
+} __packed;
+
+struct validate_negotiate_info_rsp {
+	__le32 Capabilities;
+	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
+	__le16 SecurityMode;
+	__le16 Dialect; /* Dialect in use for the connection */
 } __packed;
 
 #define RSS_CAPABLE	0x00000001
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 7db5db0eef18..d18b19ec1145 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -158,5 +158,6 @@ extern int smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 		      struct smb2_lock_element *buf);
 extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 			    __u8 *lease_key, const __le32 lease_state);
+extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
 
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index a4b2391fe66e..0e538b5c9622 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -90,7 +90,7 @@
 #define FSCTL_LMR_REQUEST_RESILIENCY 0x001401D4 /* BB add struct */
 #define FSCTL_LMR_GET_LINK_TRACK_INF 0x001400E8 /* BB add struct */
 #define FSCTL_LMR_SET_LINK_TRACK_INF 0x001400EC /* BB add struct */
-#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204 /* BB add struct */
+#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204
 /* Perform server-side data movement */
 #define FSCTL_SRV_COPYCHUNK 0x001440F2
 #define FSCTL_SRV_COPYCHUNK_WRITE 0x001480F2
-- 
2.0.0

