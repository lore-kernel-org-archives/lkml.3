Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbaCDVQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:16:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbaCDUDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@meshcoding.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.13 068/172] batman-adv: fix potential orig_node reference leak
Date: Tue,  4 Mar 2014 12:02:32 -0800
Message-Id: <20140304200301.915790892@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wunderlich <sw@simonwunderlich.de>

[ Upstream commit b2262df7fcf2c395eca564df83238e931d88d7bf ]

Since batadv_orig_node_new() sets the refcount to two, assuming that
the calling function will use a reference for putting the orig_node into
a hash or similar, both references must be freed if initialization of
the orig_node fails. Otherwise that object may be leaked in that error
case.

Reported-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -256,6 +256,8 @@ batadv_iv_ogm_orig_get(struct batadv_pri
 free_bcast_own:
 	kfree(orig_node->bat_iv.bcast_own);
 free_orig_node:
+	/* free twice, as batadv_orig_node_new sets refcount to 2 */
+	batadv_orig_node_free_ref(orig_node);
 	batadv_orig_node_free_ref(orig_node);
 
 	return NULL;


