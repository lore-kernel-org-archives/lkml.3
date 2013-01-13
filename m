Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3AMRzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:55:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34964 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755297Ab3AMRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:25 -0500
Message-Id: <20130113174257.700603226@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>,
        Tim Perry <tdparmor-sambabugs@yahoo.com>,
        Steve French <smfrench@gmail.com>
Subject: [ 09/49] cifs: adjust sequence number downward after signing NT_CANCEL
 request
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/cifs/transport.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -485,6 +485,13 @@ send_nt_cancel(struct TCP_Server_Info *s
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
 


