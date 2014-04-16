Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaDPKj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:39:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbaDPKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, Thomas Graf <tgraf@suug.ch>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 34/46] netlink: don't compare the nul-termination in nla_strcmp
Date: Wed, 16 Apr 2014 11:31:50 +0100
Message-Id: <1397644322-13905-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira <pablo@netfilter.org>

commit 8b7b932434f5eee495b91a2804f5b64ebb2bc835 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 lib/nlattr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 18eca78..fc67547 100644
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
1.9.1

