Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab3APQKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:10:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab3APQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 195/222] cifs: adjust sequence number downward after signing NT_CANCEL request
Date: Wed, 16 Jan 2013 13:56:35 -0200
Message-Id: <1358351822-7675-196-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 31efee60f489c759c341454d755a9fd13de8c03d upstream.

When a call goes out, the signing code adjusts the sequence number
upward by two to account for the request and the response. An NT_CANCEL
however doesn't get a response of its own, it just hurries the server
along to get it to respond to the original request more quickly.
Therefore, we must adjust the sequence number back down by one after
signing a NT_CANCEL request.

Reported-by: Tim Perry <tdparmor-sambabugs@yahoo.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/cifs/smb1ops.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 6dec38f..a288ec2a 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -51,6 +51,13 @@ send_nt_cancel(struct TCP_Server_Info *server, void *buf,
 		mutex_unlock(&server->srv_mutex);
 		return rc;
 	}
+
+	/*
+	 * The response to this call was already factored into the sequence
+	 * number when the call went out, so we must adjust it back downward
+	 * after signing here.
+	 */
+	--server->sequence_number;
 	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	mutex_unlock(&server->srv_mutex);
 
-- 
1.7.9.5

