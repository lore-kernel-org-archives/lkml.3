Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaIOTbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:31:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbaIOTbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:31:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.16 129/158] md/raid10: Fix memory leak when raid10 reshape completes.
Date: Mon, 15 Sep 2014 12:26:08 -0700
Message-Id: <20140915192546.753538439@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b39685526f46976bcd13aa08c82480092befa46c upstream.

When a raid10 commences a resync/recovery/reshape it allocates
some buffer space.
When a resync/recovery completes the buffer space is freed.  But not
when the reshape completes.
This can result in a small memory leak.

There is a subtle side-effect of this bug.  When a RAID10 is reshaped
to a larger array (more devices), the reshape is immediately followed
by a "resync" of the new space.  This "resync" will use the buffer
space which was allocated for "reshape".  This can cause problems
including a "BUG" in the SCSI layer.  So this is suitable for -stable.

Fixes: 3ea7daa5d7fde47cd41f4d56c2deb949114da9d6
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2953,6 +2953,7 @@ static sector_t sync_request(struct mdde
 		 */
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
 			end_reshape(conf);
+			close_sync(conf);
 			return 0;
 		}
 


