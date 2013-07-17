Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965038Ab3GQXGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:06:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab3GQW4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen@asianux.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 072/145] netfilter: ipt_ULOG: fix non-null terminated string in the nf_log path
Date: Wed, 17 Jul 2013 15:46:44 -0700
Message-Id: <1374101277-7915-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 4f36ea6eed2081340c7a7aa98c73187ecfccebff upstream.

If nf_log uses ipt_ULOG as logging output, we can deliver non-null
terminated strings to user-space since the maximum length of the
prefix that is passed by nf_log is NF_LOG_PREFIXLEN but pm->prefix
is 32 bytes long (ULOG_PREFIX_LEN).

This is actually happening already from nf_conntrack_tcp if ipt_ULOG
is used, since it is passing strings longer than 32 bytes.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/netfilter/ipt_ULOG.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index b5ef3cb..db5f368 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -217,8 +217,10 @@ static void ipt_ulog_packet(unsigned int hooknum,
 	put_unaligned(tv.tv_usec, &pm->timestamp_usec);
 	put_unaligned(skb->mark, &pm->mark);
 	pm->hook = hooknum;
-	if (prefix != NULL)
-		strncpy(pm->prefix, prefix, sizeof(pm->prefix));
+	if (prefix != NULL) {
+		strncpy(pm->prefix, prefix, sizeof(pm->prefix) - 1);
+		pm->prefix[sizeof(pm->prefix) - 1] = '\0';
+	}
 	else if (loginfo->prefix[0] != '\0')
 		strncpy(pm->prefix, loginfo->prefix, sizeof(pm->prefix));
 	else
-- 
1.8.1.2

