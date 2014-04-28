Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaD1Ba3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43062 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbaD1B3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Andy Grover" <agrover@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.263417861@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 87/94] target/tcm_fc: Fix use-after-free of ft_tpg
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/tcm_fc/tfc_sess.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -72,6 +72,7 @@ static struct ft_tport *ft_tport_create(
 
 	if (tport) {
 		tport->tpg = tpg;
+		tpg->tport = tport;
 		return tport;
 	}
 

