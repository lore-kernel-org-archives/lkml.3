Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934457AbaGOXjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:39:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937AbaGOXOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.15 41/84] dm mpath: fix IO hang due to logic bug in multipath_busy
Date: Tue, 15 Jul 2014 16:17:38 -0700
Message-Id: <20140715231714.428197443@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

commit 7a7a3b45fed9a144dbf766ee842a4c5d0632b81d upstream.

Commit e80991773 ("dm mpath: push back requests instead of queueing")
modified multipath_busy() to return true if !pg_ready().  pg_ready()
checks the current state of the multipath device and may return false
even if a new IO is needed to change the state.

Bart Van Assche reported that he had multipath IO lockup when he was
performing cable pull tests.  Analysis showed that the multipath
device had a single path group with both paths active, but that the
path group itself was not active.  During the multipath device state
transitions 'queue_io' got set but nothing could clear it.  Clearing
'queue_io' only happens in __choose_pgpath(), but it won't be called
if multipath_busy() returns true due to pg_ready() returning false
when 'queue_io' is set.

As such the !pg_ready() check in multipath_busy() is wrong because new
IO will not be sent to multipath target and the multipath state change
won't happen.  That results in multipath IO lockup.

The intent of multipath_busy() is to avoid unnecessary cycles of
dequeue + request_fn + requeue if it is known that the multipath
device will requeue.

Such "busy" situations would be:
  - path group is being activated
  - there is no path and the multipath is setup to requeue if no path

Fix multipath_busy() to return "busy" early only for these specific
situations.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1620,8 +1620,9 @@ static int multipath_busy(struct dm_targ
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	/* pg_init in progress, requeue until done */
-	if (!pg_ready(m)) {
+	/* pg_init in progress or no paths available */
+	if (m->pg_init_in_progress ||
+	    (!m->nr_valid_paths && m->queue_if_no_path)) {
 		busy = 1;
 		goto out;
 	}


