Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaELBmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:49 -0400
Received: from 1wt.eu ([62.212.114.60]:34624 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbaELBmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:47 -0400
Message-Id: <20140512003204.752495005@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Maciej Zenczykowski <maze@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>, Chris Davis <chrismd@google.com>,
        Carlo Contavalli <ccontavalli@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 099/143] net: fix ip rule iif/oif device rename
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Zenczykowski <maze@google.com>

[ Upstream commit 946c032e5a53992ea45e062ecb08670ba39b99e3 ]

ip rules with iif/oif references do not update:
(detach/attach) across interface renames.

Signed-off-by: Maciej Zenczykowski <maze@google.com>
CC: Willem de Bruijn <willemb@google.com>
CC: Eric Dumazet <edumazet@google.com>
CC: Chris Davis <chrismd@google.com>
CC: Carlo Contavalli <ccontavalli@google.com>

Google-Bug-Id: 12936021
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/fib_rules.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index de9eac9..06bdee7 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -633,6 +633,13 @@ static int fib_rules_event(struct notifier_block *this, unsigned long event,
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
-- 
1.7.12.2.21.g234cd45.dirty



