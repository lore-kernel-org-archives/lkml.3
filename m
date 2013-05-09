Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab3EIWdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:33:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab3EIWcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@gnumonks.org>
Subject: [ 22/73] netfilter: nf_ct_helper: dont discard helper if it is actually the same
Date: Thu,  9 May 2013 15:31:45 -0700
Message-Id: <20130509222800.385566595@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 6e2f0aa8cf8892868bf2c19349cb5d7c407f690d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_helper.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -236,7 +236,9 @@ int __nf_ct_try_assign_helper(struct nf_
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


