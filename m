Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbaEMJ42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:56:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60841 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760082AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 077/182] target/tcm_fc: Fix use-after-free of ft_tpg
Date: Tue, 13 May 2014 11:27:09 +0200
Message-Id: <1e55112842964dc089dbd4f698868a1757b7be25.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Grover <agrover@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2c42be2dd4f6586728dba5c4e197afd5cfaded78 upstream.

ft_del_tpg checks tpg->tport is set before unlinking the tpg from the
tport when the tpg is being removed. Set this pointer in ft_tport_create,
or the unlinking won't happen in ft_del_tpg and tport->tpg will reference
a deleted object.

This patch sets tpg->tport in ft_tport_create, because that's what
ft_del_tpg checks, and is the only way to get back to the tport to
clear tport->tpg.

The bug was occuring when:

- lport created, tport (our per-lport, per-provider context) is
  allocated.
  tport->tpg = NULL
- tpg created
- a PRLI is received. ft_tport_create is called, tpg is found and
  tport->tpg is set
- tpg removed. ft_tpg is freed in ft_del_tpg. Since tpg->tport was not
  set, tport->tpg is not cleared and points at freed memory
- Future calls to ft_tport_create return tport via first conditional,
  instead of searching for new tpg by calling ft_lport_find_tpg.
  tport->tpg is still invalid, and will access freed memory.

see https://bugzilla.redhat.com/show_bug.cgi?id=1071340

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/tcm_fc/tfc_sess.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4859505ae2ed..639fdb395fb7 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -68,6 +68,7 @@ static struct ft_tport *ft_tport_create(struct fc_lport *lport)
 
 	if (tport) {
 		tport->tpg = tpg;
+		tpg->tport = tport;
 		return tport;
 	}
 
-- 
1.9.3

