Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaCHBH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:07:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbaCHBHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Perry <tdparmor-sambabugs@yahoo.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 63/99] cifs: adjust sequence number downward after signing NT_CANCEL request
Date: Fri,  7 Mar 2014 17:07:59 -0800
Message-Id: <20140308010613.621347365@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/transport.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -511,6 +511,13 @@ send_nt_cancel(struct TCP_Server_Info *s
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
 


