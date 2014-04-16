Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbaDPKck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:32:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51698 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbaDPKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiner Kallweit <heiner.kallweit@web.de>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 20/46] ipv6: Avoid unnecessary temporary addresses being generated
Date: Wed, 16 Apr 2014 11:31:36 +0100
Message-Id: <1397644322-13905-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <heiner.kallweit@web.de>

commit ecab67015ef6e3f3635551dcc9971cf363cc1cd5 upstream.

tmp_prefered_lft is an offset to ifp->tstamp, not now. Therefore
age needs to be added to the condition.

Age calculation in ipv6_create_tempaddr is different from the one
in addrconf_verify and doesn't consider ADDRCONF_TIMER_FUZZ_MINUS.
This can cause age in ipv6_create_tempaddr to be less than the one
in addrconf_verify and therefore unnecessary temporary address to
be generated.
Use age calculation as in addrconf_modify to avoid this.

Signed-off-by: Heiner Kallweit <heiner.kallweit@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/addrconf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 0f99f7b..a6ddced 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1113,8 +1113,11 @@ retry:
 	 * Lifetime is greater than REGEN_ADVANCE time units.  In particular,
 	 * an implementation must not create a temporary address with a zero
 	 * Preferred Lifetime.
+	 * Use age calculation as in addrconf_verify to avoid unnecessary
+	 * temporary addresses being generated.
 	 */
-	if (tmp_prefered_lft <= regen_advance) {
+	age = (now - tmp_tstamp + ADDRCONF_TIMER_FUZZ_MINUS) / HZ;
+	if (tmp_prefered_lft <= regen_advance + age) {
 		in6_ifa_put(ifp);
 		in6_dev_put(idev);
 		ret = -1;
-- 
1.9.1

