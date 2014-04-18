Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaDRJ1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:27:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46038 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431AbaDRJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pablo Neira <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 64/72] netlink: don't compare the nul-termination in nla_strcmp
Date: Fri, 18 Apr 2014 11:22:37 +0200
Message-Id: <066bde36d333845215f6317a56d6c8d9c593c5b6.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pablo Neira <pablo@netfilter.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 8b7b932434f5eee495b91a2804f5b64ebb2bc835 ]

nla_strcmp compares the string length plus one, so it's implicitly
including the nul-termination in the comparison.

 int nla_strcmp(const struct nlattr *nla, const char *str)
 {
        int len = strlen(str) + 1;
        ...
                d = memcmp(nla_data(nla), str, len);

However, if NLA_STRING is used, userspace can send us a string without
the nul-termination. This is a problem since the string
comparison will not match as the last byte may be not the
nul-termination.

Fix this by skipping the comparison of the nul-termination if the
attribute data is nul-terminated. Suggested by Thomas Graf.

Cc: Florian Westphal <fw@strlen.de>
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/nlattr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 18eca7809b08..fc6754720ced 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -303,9 +303,15 @@ int nla_memcmp(const struct nlattr *nla, const void *data,
  */
 int nla_strcmp(const struct nlattr *nla, const char *str)
 {
-	int len = strlen(str) + 1;
-	int d = nla_len(nla) - len;
+	int len = strlen(str);
+	char *buf = nla_data(nla);
+	int attrlen = nla_len(nla);
+	int d;
 
+	if (attrlen > 0 && buf[attrlen - 1] == '\0')
+		attrlen--;
+
+	d = attrlen - len;
 	if (d == 0)
 		d = memcmp(nla_data(nla), str, len);
 
-- 
1.9.2

