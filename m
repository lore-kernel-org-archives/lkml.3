Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3JCEOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:14:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3JCEOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:14:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 04/52] bcache: Strip endline when writing the label through sysfs
Date: Wed,  2 Oct 2013 21:05:22 -0700
Message-Id: <20131003040522.491836485@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/md/bcache/sysfs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -214,7 +214,13 @@ STORE(__cached_dev)
 	}
 
 	if (attr == &sysfs_label) {
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


