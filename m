Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3JCEUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:20:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab3JCEUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:20:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 04/57] bcache: Strip endline when writing the label through sysfs
Date: Wed,  2 Oct 2013 21:08:30 -0700
Message-Id: <20131003040636.907317685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel de Perthuis <g2p.code@gmail.com>

commit aee6f1cfff3ce240eb4b43b41ca466b907acbd2e upstream.

sysfs attributes with unusual characters have crappy failure modes
in Squeeze (udev 164); later versions of udev are unaffected.

This should make these characters more unusual.

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/sysfs.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -223,8 +223,13 @@ STORE(__cached_dev)
 	}
 
 	if (attr == &sysfs_label) {
-		/* note: endlines are preserved */
-		memcpy(dc->sb.label, buf, SB_LABEL_SIZE);
+		if (size > SB_LABEL_SIZE)
+			return -EINVAL;
+		memcpy(dc->sb.label, buf, size);
+		if (size < SB_LABEL_SIZE)
+			dc->sb.label[size] = '\0';
+		if (size && dc->sb.label[size - 1] == '\n')
+			dc->sb.label[size - 1] = '\0';
 		bch_write_bdev_super(dc, NULL);
 		if (dc->disk.c) {
 			memcpy(dc->disk.c->uuids[dc->disk.id].label,


