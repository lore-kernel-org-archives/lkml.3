Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3FPW3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:29:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46303 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532Ab3FPWIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Joe Perches" <joe@perches.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.304418802@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [23/83] net: Add net_ratelimited_function and net_<level>_ratelimited
 macros
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/net.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -249,6 +249,29 @@ extern struct socket *sockfd_lookup(int
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
 

