Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340AbaFJAsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:48:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843AbaFJAVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:21:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.4 08/88] md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
Date: Mon,  9 Jun 2014 17:24:18 -0700
Message-Id: <20140610002424.818257683@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 3991b31ea072b070081ca3bfa860a077eda67de5 upstream.

If mddev->ro is set, md_to_sync will (correctly) abort.
However in that case MD_RECOVERY_INTR isn't set.

If a RESHAPE had been requested, then ->finish_reshape() will be
called and it will think the reshape was successful even though
nothing happened.

Normally a resync will not be requested if ->ro is set, but if an
array is stopped while a reshape is on-going, then when the array is
started, the reshape will be restarted.  If the array is also set
read-only at this point, the reshape will instantly appear to success,
resulting in data corruption.

Consequently, this patch is suitable for any -stable kernel.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7071,8 +7071,10 @@ void md_do_sync(struct mddev *mddev)
 	/* just incase thread restarts... */
 	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 		return;
-	if (mddev->ro) /* never try to sync a read-only array */
+	if (mddev->ro) {/* never try to sync a read-only array */
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		return;
+	}
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))


