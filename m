Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaDXIzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:55:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaDXIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 145/182] target/tcm_fc: Fix use-after-free of ft_tpg
Date: Thu, 24 Apr 2014 09:51:10 +0100
Message-Id: <1398329507-5911-146-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4859505..639fdb3 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -68,6 +68,7 @@ static struct ft_tport *ft_tport_create(struct fc_lport *lport)
 
 	if (tport) {
 		tport->tpg = tpg;
+		tpg->tport = tport;
 		return tport;
 	}
 
-- 
1.9.1

