Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992441AbaEPWxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:53:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbaEPWwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:52:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 5/9] net: Add net_ratelimited_function and net_<level>_ratelimited macros
Date: Fri, 16 May 2014 15:55:28 -0700
Message-Id: <20140516225458.805467686@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140516225458.512693003@linuxfoundation.org>
References: <20140516225458.512693003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

commit 3a3bfb61e64476ff1e4ac3122cb6dec9c79b795c upstream.

__ratelimit() can be considered an inverted bool test because
it returns true when not ratelimited.  Several tests in the
kernel tree use this __ratelimit() function incorrectly.

No net_ratelimit uses are incorrect currently though.

Most uses of net_ratelimit are to log something via printk or
pr_<level>.

In order to minimize the uses of net_ratelimit, and to start
standardizing the code style used for __ratelimit() and net_ratelimit(),
add a net_ratelimited_function() macro and net_<level>_ratelimited()
logging macros similar to pr_<level>_ratelimited that use the global
net_ratelimit instead of a static per call site "struct ratelimit_state".

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/net.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -259,6 +259,29 @@ extern struct socket *sockfd_lookup(int
 #define		     sockfd_put(sock) fput(sock->file)
 extern int	     net_ratelimit(void);
 
+#define net_ratelimited_function(function, ...)			\
+do {								\
+	if (net_ratelimit())					\
+		function(__VA_ARGS__);				\
+} while (0)
+
+#define net_emerg_ratelimited(fmt, ...)				\
+	net_ratelimited_function(pr_emerg, fmt, ##__VA_ARGS__)
+#define net_alert_ratelimited(fmt, ...)				\
+	net_ratelimited_function(pr_alert, fmt, ##__VA_ARGS__)
+#define net_crit_ratelimited(fmt, ...)				\
+	net_ratelimited_function(pr_crit, fmt, ##__VA_ARGS__)
+#define net_err_ratelimited(fmt, ...)				\
+	net_ratelimited_function(pr_err, fmt, ##__VA_ARGS__)
+#define net_notice_ratelimited(fmt, ...)			\
+	net_ratelimited_function(pr_notice, fmt, ##__VA_ARGS__)
+#define net_warn_ratelimited(fmt, ...)				\
+	net_ratelimited_function(pr_warn, fmt, ##__VA_ARGS__)
+#define net_info_ratelimited(fmt, ...)				\
+	net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
+#define net_dbg_ratelimited(fmt, ...)				\
+	net_ratelimited_function(pr_debug, fmt, ##__VA_ARGS__)
+
 #define net_random()		random32()
 #define net_srandom(seed)	srandom32((__force u32)seed)
 


