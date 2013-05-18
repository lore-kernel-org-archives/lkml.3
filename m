Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab3ERDLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:11:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725Ab3ERDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:19 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GuGtdQBDxkkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1uapdZkCo_IA:10 a=ykoPv_dRAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=hGjLu6hZXNMA:10 a=H_jQXghYZ-gA:10 a=jeBq3FmKZ4MA:10 a=G7E0Co7JJYmvrUCJ:21 a=Np5JTxzaNomwHBIa:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021657.753067019@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@gnumonks.org>
Subject: [ 100/136 ] netfilter: nf_ct_helper: dont discard helper if it is actually the
 same
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0100-netfilter-nf_ct_helper-don-t-discard-helper-if-it-is.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6e2f0aa8cf8892868bf2c19349cb5d7c407f690d ]

commit (32f5376 netfilter: nf_ct_helper: disable automatic helper
re-assignment of different type) broke transparent proxy scenarios.

For example, initial helper lookup might yield "ftp" (dport 21),
while re-lookup after REDIRECT yields "ftp-2121".

This causes the autoassign code to toss the ftp helper, even
though these are just different instances of the same helper.

Change the test to check for the helper function address instead
of the helper address, as suggested by Pablo.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@gnumonks.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netfilter/nf_conntrack_helper.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index c4bc637..622dd4d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -232,7 +232,9 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 		/* We only allow helper re-assignment of the same sort since
 		 * we cannot reallocate the helper extension area.
 		 */
-		if (help->helper != helper) {
+		struct nf_conntrack_helper *tmp = rcu_dereference(help->helper);
+
+		if (tmp && tmp->help != helper->help) {
 			RCU_INIT_POINTER(help->helper, NULL);
 			goto out;
 		}
-- 
1.7.10.4


