Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3FKUEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:04:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab3FKUEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcus Moeller <marcus.moeller@gmx.ch>,
        Ken Fallon <ken.fallon@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [ 49/79] cifs: fix off-by-one bug in build_unc_path_to_root
Date: Tue, 11 Jun 2013 13:03:15 -0700
Message-Id: <20130611195322.546873859@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 1fc29bacedeabb278080e31bb9c1ecb49f143c3b upstream.

commit 839db3d10a (cifs: fix up handling of prefixpath= option) changed
the code such that the vol->prepath no longer contained a leading
delimiter and then fixed up the places that accessed that field to
account for that change.

One spot in build_unc_path_to_root was missed however. When doing the
pointer addition on pos, that patch failed to account for the fact that
we had already incremented "pos" by one when adding the length of the
prepath. This caused a buffer overrun by one byte.

This patch fixes the problem by correcting the handling of "pos".

Reported-by: Marcus Moeller <marcus.moeller@gmx.ch>
Reported-by: Ken Fallon <ken.fallon@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3332,8 +3332,8 @@ build_unc_path_to_root(const struct smb_
 	pos = full_path + unc_len;
 
 	if (pplen) {
-		*pos++ = CIFS_DIR_SEP(cifs_sb);
-		strncpy(pos, vol->prepath, pplen);
+		*pos = CIFS_DIR_SEP(cifs_sb);
+		strncpy(pos + 1, vol->prepath, pplen);
 		pos += pplen;
 	}
 


