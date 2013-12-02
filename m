Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3LBTS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3LBTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.12 148/212] md: test mddev->flags more safely in md_check_recovery.
Date: Mon,  2 Dec 2013 11:15:39 -0800
Message-Id: <20131202191303.823392615@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 142d44c310819e1965ca70b4d55d7679f5797e25 upstream.

commit 7a0a5355cbc71efa md: Don't test all of mddev->flags at once.
made most tests on mddev->flags safer, but missed one.

When
commit 260fa034ef7a4ff8b7306 md: avoid deadlock when dirty buffers during md_stop.
added MD_STILL_CLOSED, this caused md_check_recovery to misbehave.
It can think there is something to do but find nothing.  This can
lead to the md thread spinning during array shutdown.

https://bugzilla.kernel.org/show_bug.cgi?id=65721

Reported-and-tested-by: Richard W.M. Jones <rjones@redhat.com>
Fixes: 260fa034ef7a4ff8b7306
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7792,7 +7792,7 @@ void md_check_recovery(struct mddev *mdd
 	if (mddev->ro && !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return;
 	if ( ! (
-		(mddev->flags & ~ (1<<MD_CHANGE_PENDING)) ||
+		(mddev->flags & MD_UPDATE_SB_FLAGS & ~ (1<<MD_CHANGE_PENDING)) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		(mddev->external == 0 && mddev->safemode == 1) ||


