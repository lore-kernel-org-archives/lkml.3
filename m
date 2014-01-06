Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbaAGAOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:14:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbaAFWiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Karl Dahlke <eklhad@comcast.net>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.12 008/144] n_tty: Fix apparent order of echoed output
Date: Mon,  6 Jan 2014 14:36:09 -0800
Message-Id: <20140106223745.568086451@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 1075a6e2dc7e2a96efc417b98dd98f57fdae985d upstream.

With block processing of echoed output, observed output order is still
required. Push completed echoes and echo commands prior to output.

Introduce echo_mark echo buffer index, which tracks completed echo
commands; ie., those submitted via commit_echoes but which may not
have been committed. Ensure that completed echoes are output prior
to subsequent terminal writes in process_echoes().

Fixes newline/prompt output order in cooked mode shell.

Reported-by: Karl Dahlke <eklhad@comcast.net>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Tested-by: Karl Dahlke <eklhad@comcast.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -93,6 +93,7 @@ struct n_tty_data {
 	size_t canon_head;
 	size_t echo_head;
 	size_t echo_commit;
+	size_t echo_mark;
 	DECLARE_BITMAP(char_map, 256);
 
 	/* private to n_tty_receive_overrun (single-threaded) */
@@ -336,6 +337,7 @@ static void reset_buffer_flags(struct n_
 {
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
 	ldata->echo_head = ldata->echo_tail = ldata->echo_commit = 0;
+	ldata->echo_mark = 0;
 	ldata->line_start = 0;
 
 	ldata->erasing = 0;
@@ -787,6 +789,7 @@ static void commit_echoes(struct tty_str
 	size_t head;
 
 	head = ldata->echo_head;
+	ldata->echo_mark = head;
 	old = ldata->echo_commit - ldata->echo_tail;
 
 	/* Process committed echoes if the accumulated # of bytes
@@ -811,10 +814,11 @@ static void process_echoes(struct tty_st
 	size_t echoed;
 
 	if ((!L_ECHO(tty) && !L_ECHONL(tty)) ||
-	    ldata->echo_commit == ldata->echo_tail)
+	    ldata->echo_mark == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
+	ldata->echo_commit = ldata->echo_mark;
 	echoed = __process_echoes(tty);
 	mutex_unlock(&ldata->output_lock);
 
@@ -822,6 +826,7 @@ static void process_echoes(struct tty_st
 		tty->ops->flush_chars(tty);
 }
 
+/* NB: echo_mark and echo_head should be equivalent here */
 static void flush_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;


