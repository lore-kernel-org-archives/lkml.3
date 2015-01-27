Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbbA0Mk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:40:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35098 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbbA0MSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 052/126] netfilter: ipset: small potential read beyond the end of buffer
Date: Tue, 27 Jan 2015 12:15:57 +0000
Message-Id: <1422361031-19364-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 2196937e12b1b4ba139806d132647e1651d655df upstream.

We could be reading 8 bytes into a 4 byte buffer here.  It seems
harmless but adding a check is the right thing to do and it silences a
static checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/ipset/ip_set_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6582dce828b5..6850c3c4d6d3 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1838,6 +1838,12 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 	if (*op < IP_SET_OP_VERSION) {
 		/* Check the version at the beginning of operations */
 		struct ip_set_req_version *req_version = data;
+
+		if (*len < sizeof(struct ip_set_req_version)) {
+			ret = -EINVAL;
+			goto done;
+		}
+
 		if (req_version->version != IPSET_PROTOCOL) {
 			ret = -EPROTO;
 			goto done;
-- 
2.1.4

