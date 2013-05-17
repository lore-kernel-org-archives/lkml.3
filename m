Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3EQVmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:42:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab3EQViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Boot <bootc@bootc.net>, Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 088/102] target/iblock: Fix WCE=1 + DPOFUA=1 backend WRITE regression
Date: Fri, 17 May 2013 14:36:43 -0700
Message-Id: <20130517213253.527651373@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit d2bdbee0d91a5d3ba2e439ce889e20bfe6fd4f1b upstream.

This patch fixes a regression bug introduced in v3.9-rc1 where if the
underlying struct block_device for a IBLOCK backend is configured with
WCE=1 + DPOFUA=1 settings, the rw = WRITE assignment no longer occurs
in iblock_execute_rw(), and rw = 0 is passed to iblock_submit_bios()
in effect causing a READ bio operation to occur.

The offending commit is:

commit d0c8b259f8970d39354c1966853363345d401330
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Tue Jan 29 22:10:06 2013 -0800

    target/iblock: Use backend REQ_FLUSH hint for WriteCacheEnabled status

Note the WCE=1 + DPOFUA=0, WCE=0 + DPOFUA=1, and WCE=0 + DPOFUA=0 cases
are not affected by this regression bug.

Reported-by: Chris Boot <bootc@bootc.net>
Tested-by: Chris Boot <bootc@bootc.net>
Reported-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_iblock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -679,6 +679,8 @@ iblock_execute_rw(struct se_cmd *cmd)
 				rw = WRITE_FUA;
 			else if (!(q->flush_flags & REQ_FLUSH))
 				rw = WRITE_FUA;
+			else
+				rw = WRITE;
 		} else {
 			rw = WRITE;
 		}


