Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3JKTf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:35:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab3JKTfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:35:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Marcus Meissner <meissner@suse.de>,
        Sebastian Krahmer <krahmer@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 39/39] Tools: hv: verify origin of netlink connector message
Date: Fri, 11 Oct 2013 12:35:23 -0700
Message-Id: <20131011193215.108157669@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193210.843963685@linuxfoundation.org>
References: <20131011193210.843963685@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

commit bcc2c9c3fff859e0eb019fe6fec26f9b8eba795c upstream.

The SuSE security team suggested to use recvfrom instead of recv to be
certain that the connector message is originated from kernel.

CVE-2012-2669

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Marcus Meissner <meissner@suse.de>
Signed-off-by: Sebastian Krahmer <krahmer@suse.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>

---
 drivers/staging/hv/tools/hv_kvp_daemon.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/staging/hv/tools/hv_kvp_daemon.c
+++ b/drivers/staging/hv/tools/hv_kvp_daemon.c
@@ -378,14 +378,18 @@ int main(void)
 	pfd.fd = fd;
 
 	while (1) {
+		struct sockaddr *addr_p = (struct sockaddr *) &addr;
+		socklen_t addr_l = sizeof(addr);
 		pfd.events = POLLIN;
 		pfd.revents = 0;
 		poll(&pfd, 1, -1);
 
-		len = recv(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0);
+		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
+				addr_p, &addr_l);
 
-		if (len < 0) {
-			syslog(LOG_ERR, "recv failed; error:%d", len);
+		if (len < 0 || addr.nl_pid) {
+			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
+					addr.nl_pid, errno, strerror(errno));
 			close(fd);
 			return -1;
 		}


