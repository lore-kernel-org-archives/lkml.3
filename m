Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaDAQJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaDAQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>, Chris Davis <chrismd@google.com>,
        Carlo Contavalli <ccontavalli@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 04/86] net: fix 'ip rule' iif/oif device rename
Date: Tue,  1 Apr 2014 09:07:17 -0700
Message-Id: <1396368519-12728-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/fib_rules.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 8c9b04b..90b200c 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -720,6 +720,13 @@ static int fib_rules_event(struct notifier_block *this, unsigned long event,
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
1.8.3.2

