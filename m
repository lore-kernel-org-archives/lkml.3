Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbbANH7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:59:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692AbbANHfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:35:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Riesch <christian.riesch@omicron.at>
Subject: [PATCH 3.14 48/77] n_tty: Fix read_buf race condition, increment read_head after pushing data
Date: Tue, 13 Jan 2015 23:23:28 -0800
Message-Id: <20150114072226.897876398@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Riesch <christian.riesch@omicron.at>

commit 8bfbe2de769afda051c56aba5450391670e769fc upstream.

Commit 19e2ad6a09f0c06dbca19c98e5f4584269d913dd ("n_tty: Remove overflow
tests from receive_buf() path") moved the increment of read_head into
the arguments list of read_buf_addr(). Function calls represent a
sequence point in C. Therefore read_head is incremented before the
character c is placed in the buffer. Since the circular read buffer is
a lock-less design since commit 6d76bd2618535c581f1673047b8341fd291abc67
("n_tty: Make N_TTY ldisc receive path lockless"), this creates a race
condition that leads to communication errors.

This patch modifies the code to increment read_head _after_ the data
is placed in the buffer and thus fixes the race for non-SMP machines.
To fix the problem for SMP machines, memory barriers must be added in
a separate patch.

Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -321,7 +321,8 @@ static void n_tty_check_unthrottle(struc
 
 static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 {
-	*read_buf_addr(ldata, ldata->read_head++) = c;
+	*read_buf_addr(ldata, ldata->read_head) = c;
+	ldata->read_head++;
 }
 
 /**


