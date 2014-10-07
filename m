Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaJGXjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:39:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaJGXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilovsky@samba.org>
Subject: [PATCH 3.16 14/26] Fix problem recognizing symlinks
Date: Tue,  7 Oct 2014 16:19:30 -0700
Message-Id: <20141007231848.913560773@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit 19e81573fca7b87ced7701e01ba164b968d929bd upstream.

Changeset eb85d94bd introduced a problem where if a cifs open
fails during query info of a file we
will still try to close the file (happens with certain types
of reparse points) even though the file handle is not valid.

In addition for SMB2/SMB3 we were not mapping the return code returned
by Windows when trying to open a file (like a Windows NFS symlink)
which is a reparse point.

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb1ops.c      |    2 +-
 fs/cifs/smb2maperror.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -586,7 +586,7 @@ cifs_query_path_info(const unsigned int
 		tmprc = CIFS_open(xid, &oparms, &oplock, NULL);
 		if (tmprc == -EOPNOTSUPP)
 			*symlink = true;
-		else
+		else if (tmprc == 0)
 			CIFSSMBClose(xid, tcon, fid.netfid);
 	}
 
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -256,6 +256,8 @@ static const struct status_to_posix_erro
 	{STATUS_DLL_MIGHT_BE_INCOMPATIBLE, -EIO,
 	"STATUS_DLL_MIGHT_BE_INCOMPATIBLE"},
 	{STATUS_STOPPED_ON_SYMLINK, -EOPNOTSUPP, "STATUS_STOPPED_ON_SYMLINK"},
+	{STATUS_IO_REPARSE_TAG_NOT_HANDLED, -EOPNOTSUPP,
+	"STATUS_REPARSE_NOT_HANDLED"},
 	{STATUS_DEVICE_REQUIRES_CLEANING, -EIO,
 	"STATUS_DEVICE_REQUIRES_CLEANING"},
 	{STATUS_DEVICE_DOOR_OPEN, -EIO, "STATUS_DEVICE_DOOR_OPEN"},


