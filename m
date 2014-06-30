Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbaF3MQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:16:01 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51956 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Sachin Prabhu <sprabhu@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/181] Do not send ClientGUID on SMB2.02 dialect
Date: Mon, 30 Jun 2014 13:50:42 +0200
Message-Id: <c82b3dd92c24207c8c0d6b4334a53e1245cc13d6.1404128997.git.jslaby@suse.cz>
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

commit 3c5f9be108783c05cade918d29c8711b236acb1d upstream.

ClientGUID must be zero for SMB2.02 dialect.  See section 2.2.3
of MS-SMB2. For SMB2.1 and later it must be non-zero.

Signed-off-by: Steve French <smfrench@gmail.com>
CC: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 37de258d9a34..5818d2ca66f1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -375,7 +375,12 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 
 	req->Capabilities = cpu_to_le32(ses->server->vals->req_capabilities);
 
-	memcpy(req->ClientGUID, server->client_guid, SMB2_CLIENT_GUID_SIZE);
+	/* ClientGUID must be zero for SMB2.02 dialect */
+	if (ses->server->vals->protocol_id == SMB20_PROT_ID)
+		memset(req->ClientGUID, 0, SMB2_CLIENT_GUID_SIZE);
+	else
+		memcpy(req->ClientGUID, server->client_guid,
+			SMB2_CLIENT_GUID_SIZE);
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
-- 
2.0.0

