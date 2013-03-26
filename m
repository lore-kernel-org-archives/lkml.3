Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3CZW5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:57:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab3CZWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Hozza <thozza@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 68/72] tools: hv: Netlink source address validation allows DoS
Date: Tue, 26 Mar 2013 15:51:51 -0700
Message-Id: <20130326224926.664561468@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Hozza <thozza@redhat.com>

commit 95a69adab9acfc3981c504737a2b6578e4d846ef upstream.

The source code without this patch caused hypervkvpd to exit when it processed
a spoofed Netlink packet which has been sent from an untrusted local user.
Now Netlink messages with a non-zero nl_pid source address are ignored
and a warning is printed into the syslog.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/hv/hv_kvp_daemon.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -727,13 +727,19 @@ int main(void)
 		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
 				addr_p, &addr_l);
 
-		if (len < 0 || addr.nl_pid) {
+		if (len < 0) {
 			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
 					addr.nl_pid, errno, strerror(errno));
 			close(fd);
 			return -1;
 		}
 
+		if (addr.nl_pid) {
+			syslog(LOG_WARNING, "Received packet from untrusted pid:%u",
+					addr.nl_pid);
+			continue;
+		}
+
 		incoming_msg = (struct nlmsghdr *)kvp_recv_buffer;
 		incoming_cn_msg = (struct cn_msg *)NLMSG_DATA(incoming_msg);
 		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;


