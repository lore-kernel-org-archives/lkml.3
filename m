Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaCEOh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:37:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbaCEOhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>, Chris Davis <chrismd@google.com>,
        Carlo Contavalli <ccontavalli@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 29/62] net: fix 'ip rule' iif/oif device rename
Date: Wed,  5 Mar 2014 14:36:33 +0000
Message-Id: <1394030226-26652-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>

commit 946c032e5a53992ea45e062ecb08670ba39b99e3 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/fib_rules.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index d660ad4..cef5e71 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -716,6 +716,13 @@ static int fib_rules_event(struct notifier_block *this, unsigned long event,
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
1.9.0

