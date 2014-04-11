Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206AbaDKQIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:08:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406AbaDKQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiner Kallweit <heiner.kallweit@web.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 17/41] ipv6: Avoid unnecessary temporary addresses being generated
Date: Fri, 11 Apr 2014 09:09:48 -0700
Message-Id: <20140411160934.054394679@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1111,8 +1111,11 @@ retry:
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


