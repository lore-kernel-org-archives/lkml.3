Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaC3X2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:28:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36600 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203AbaC3XZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Davis" <chrismd@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Carlo Contavalli" <ccontavalli@google.com>,
        "Willem de Bruijn" <willemb@google.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.15801300@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 187/200] net: fix 'ip rule' iif/oif device rename
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 946c032e5a53992ea45e062ecb08670ba39b99e3 ]

ip rules with iif/oif references do not update:
(detach/attach) across interface renames.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
CC: Willem de Bruijn <willemb@google.com>
CC: Eric Dumazet <edumazet@google.com>
CC: Chris Davis <chrismd@google.com>
CC: Carlo Contavalli <ccontavalli@google.com>

Google-Bug-Id: 12936021
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/fib_rules.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index c0c21b1..6af54f2 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -718,6 +718,13 @@ static int fib_rules_event(struct notifier_block *this, unsigned long event,
 			attach_rules(&ops->rules_list, dev);
 		break;
 
+	case NETDEV_CHANGENAME:
+		list_for_each_entry(ops, &net->rules_ops, list) {
+			detach_rules(&ops->rules_list, dev);
+			attach_rules(&ops->rules_list, dev);
+		}
+		break;
+
 	case NETDEV_UNREGISTER:
 		list_for_each_entry(ops, &net->rules_ops, list)
 			detach_rules(&ops->rules_list, dev);

