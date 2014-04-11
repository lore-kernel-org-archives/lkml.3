Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488AbaDKQIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:08:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401AbaDKQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Leach <matthew.leach@arm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 16/41] net: socket: error on a negative msg_namelen
Date: Fri, 11 Apr 2014 09:09:47 -0700
Message-Id: <20140411160933.987830898@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Leach <matthew.leach@arm.com>

[ Upstream commit dbb490b96584d4e958533fb637f08b557f505657 ]

When copying in a struct msghdr from the user, if the user has set the
msg_namelen parameter to a negative value it gets clamped to a valid
size due to a comparison between signed and unsigned values.

Ensure the syscall errors when the user passes in a negative value.

Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1964,6 +1964,10 @@ static int copy_msghdr_from_user(struct
 {
 	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
 		return -EFAULT;
+
+	if (kmsg->msg_namelen < 0)
+		return -EINVAL;
+
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
 		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	return 0;


