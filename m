Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaD1Ba1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42831 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Heiner Kallweit" <heiner.kallweit@web.de>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.287254403@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 06/94] ipv6: Avoid unnecessary temporary addresses
 being  generated
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <heiner.kallweit@web.de>

[ Upstream commit ecab67015ef6e3f3635551dcc9971cf363cc1cd5 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/addrconf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -900,8 +900,11 @@ retry:
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

