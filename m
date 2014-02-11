Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaBKUaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:30:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaBKTGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tommy Apel <tommyapeldk@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.13 087/120] target: Fix percpu_ref_put race in transport_lun_remove_cmd
Date: Tue, 11 Feb 2014 11:05:28 -0800
Message-Id: <20140211184826.094276598@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 5259a06ef97068b710f45d092a587e8d740f750f upstream.

This patch fixes a percpu_ref_put race for se_lun->lun_ref in
transport_lun_remove_cmd() where ->lun_ref could end up being
put more than once per command via different target completion
and fabric release contexts.

It adds a cmpxchg() for se_cmd->lun_ref_active to ensure that
percpu_ref_put() is only ever called once per se_cmd.

This bug was manifesting itself as a LUN shutdown regression
bug in >= v3.13 code, where percpu_ref_kill() would end up
hanging indefinately due to the incorrect percpu_ref count.

(Change se_cmd->lun_ref_active from bool -> int to force at
 least a 4-byte cmpxchg with MIPS ll/sc ins. - Fengguang)

Reported-by: Tommy Apel <tommyapeldk@gmail.com>
Cc: Tommy Apel <tommyapeldk@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    5 +++--
 include/target/target_core_base.h      |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -568,10 +568,11 @@ static void transport_lun_remove_cmd(str
 {
 	struct se_lun *lun = cmd->se_lun;
 
-	if (!lun || !cmd->lun_ref_active)
+	if (!lun)
 		return;
 
-	percpu_ref_put(&lun->lun_ref);
+	if (cmpxchg(&cmd->lun_ref_active, true, false))
+		percpu_ref_put(&lun->lun_ref);
 }
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -497,7 +497,7 @@ struct se_cmd {
 	void			*priv;
 
 	/* Used for lun->lun_ref counting */
-	bool			lun_ref_active;
+	int			lun_ref_active;
 };
 
 struct se_ua {


