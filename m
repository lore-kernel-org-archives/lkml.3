Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaFDX4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:56:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaFDXXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jun Wu <jwu@stormojo.com>, Mark Rustad <mark.d.rustad@intel.com>,
        Robert Love <robert.w.love@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 193/228] tcm_fc: Fix free-after-use regression in ft_free_cmd
Date: Wed,  4 Jun 2014 16:23:42 -0700
Message-Id: <20140604232354.221396695@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit ed8ec8f707ed4760c124d47b27c93df8ec5b1eba upstream.

This patch fixes a free-after-use regression in ft_free_cmd(), where
ft_sess_put() is called with cmd->sess after percpu_ida_free() has
already released the tag.

Fix this bug by saving the ft_sess pointer ahead of percpu_ida_free(),
and pass it directly to ft_sess_put().

The regression was originally introduced in v3.13-rc1 commit:

  commit 5f544cfac956971099e906f94568bc3fd1a7108a
  Author: Nicholas Bellinger <nab@daterainc.com>
  Date:   Mon Sep 23 12:12:42 2013 -0700

      tcm_fc: Convert to per-cpu command map pre-allocation of ft_cmd

Reported-by: Jun Wu <jwu@stormojo.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>
Cc: Robert Love <robert.w.love@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/tcm_fc/tfc_cmd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -90,18 +90,18 @@ static void ft_free_cmd(struct ft_cmd *c
 {
 	struct fc_frame *fp;
 	struct fc_lport *lport;
-	struct se_session *se_sess;
+	struct ft_sess *sess;
 
 	if (!cmd)
 		return;
-	se_sess = cmd->sess->se_sess;
+	sess = cmd->sess;
 	fp = cmd->req_frame;
 	lport = fr_dev(fp);
 	if (fr_seq(fp))
 		lport->tt.seq_release(fr_seq(fp));
 	fc_frame_free(fp);
-	percpu_ida_free(&se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
-	ft_sess_put(cmd->sess);	/* undo get from lookup at recv */
+	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	ft_sess_put(sess);	/* undo get from lookup at recv */
 }
 
 void ft_release_cmd(struct se_cmd *se_cmd)


