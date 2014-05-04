Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbaEDPnC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:43:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaEDPm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.4 28/43] target/tcm_fc: Fix use-after-free of ft_tpg
Date: Sun,  4 May 2014 11:42:22 -0400
Message-Id: <20140504154228.094704435@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/tcm_fc/tfc_sess.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -69,6 +69,7 @@ static struct ft_tport *ft_tport_create(
 
 	if (tport) {
 		tport->tpg = tpg;
+		tpg->tport = tport;
 		return tport;
 	}
 


