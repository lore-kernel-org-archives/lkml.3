Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3ASBRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:17:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:56284 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab3ASBRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Martin Svec <martin.svec@zoner.cz>, Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 08/33] target: Fix missing CMD_T_ACTIVE bit regression for pending WRITEs
Date: Fri, 18 Jan 2013 17:16:33 -0800
Message-Id: <20130119010348.734283044@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit e627c615553a356f6f70215ebb3933c6e057553e upstream.

This patch fixes a regression bug introduced during v3.6.x code with
the following commit to drop transport_add_cmd_to_queue(), which
originally re-set CMD_T_ACTIVE during pending WRITE I/O submission:

commit af8772926f019b7bddd7477b8de5f3b0f12bad21
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sun Jul 8 15:58:49 2012 -0400

    target: replace the processing thread with a TMR work queue

The following sequence happens for write commands (or any other
commands with a data out phase):

 - The transport calls target_submit_cmd(), which sets CMD_T_ACTIVE in
   cmd->transport_state and sets cmd->t_state to TRANSPORT_NEW_CMD.
 - Things go on transport_generic_new_cmd(), which notices that the
   command needs to transfer data, so it sets cmd->t_state to
   TRANSPORT_WRITE_PENDING and calls transport_cmd_check_stop().
 - transport_cmd_check_stop() clears CMD_T_ACTIVE in cmd->transport_state
   and returns in the normal case.
 - Then we continue on to call ->se_tfo->write_pending().
 - The data comes back from the initiator, and the transport calls
   target_execute_cmd(), which sets cmd->t_state to TRANSPORT_PROCESSING
   and calls into the backend to actually write the data.

At this point, the backend might take a long time to complete the
command, since it has to do real IO.  If an abort request comes in for
this command at this point, it will not wait for the command to finish
since CMD_T_ACTIVE is not set.  Then when the command does finally
finish, we blow up with use-after-free.

Avoid this by setting CMD_T_ACTIVE in target_execute_cmd() so that
transport_wait_for_tasks() waits for the command to finish executing.
This matches the behavior from before commit 1389533ef944 ("target:
remove transport_generic_handle_data"), when data was signaled via
transport_generic_handle_data(), which set CMD_T_ACTIVE because it
called transport_add_cmd_to_queue().

Signed-off-by: Roland Dreier <roland@purestorage.com>
Reported-by: Martin Svec <martin.svec@zoner.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1853,6 +1853,7 @@ void target_execute_cmd(struct se_cmd *c
 	}
 
 	cmd->t_state = TRANSPORT_PROCESSING;
+	cmd->transport_state |= CMD_T_ACTIVE;
 	spin_unlock_irq(&cmd->t_state_lock);
 
 	if (dev->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)


