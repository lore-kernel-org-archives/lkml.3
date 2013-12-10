Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3LJICk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:02:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3LJICf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.12 56/62] n_tty: Fix missing newline echo
Date: Tue, 10 Dec 2013 00:01:27 -0800
Message-Id: <20131210080101.337569507@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 39434abd942c8e4b9c14c06a03b3245beaf8467f upstream.

When L_ECHONL is on, newlines are echoed regardless of the L_ECHO
state; if set, ensure accumulated echoes are flushed before finishing
the current input processing and before more output.

Reported-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com
Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -810,7 +810,8 @@ static void process_echoes(struct tty_st
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t echoed;
 
-	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_tail)
+	if ((!L_ECHO(tty) && !L_ECHONL(tty)) ||
+	    ldata->echo_commit == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
@@ -825,7 +826,8 @@ static void flush_echoes(struct tty_stru
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
-	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_head)
+	if ((!L_ECHO(tty) && !L_ECHONL(tty)) ||
+	    ldata->echo_commit == ldata->echo_head)
 		return;
 
 	mutex_lock(&ldata->output_lock);


