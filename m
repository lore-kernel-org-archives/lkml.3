Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523Ab3EFXqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:46:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3EFW5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 49/63] nfsd4: dont close read-write opens too soon
Date: Mon,  6 May 2013 15:56:27 -0700
Message-Id: <20130506225326.683329231@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 0c7c3e67ab91ec6caa44bdf1fc89a48012ceb0c5 upstream.

Don't actually close any opens until we don't need them at all.

This means being left with write access when it's not really necessary,
but that's better than putting a file that might still have posix locks
held on it, as we have been.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -213,13 +213,7 @@ static void __nfs4_file_put_access(struc
 {
 	if (atomic_dec_and_test(&fp->fi_access[oflag])) {
 		nfs4_file_put_fd(fp, oflag);
-		/*
-		 * It's also safe to get rid of the RDWR open *if*
-		 * we no longer have need of the other kind of access
-		 * or if we already have the other kind of open:
-		 */
-		if (fp->fi_fds[1-oflag]
-			|| atomic_read(&fp->fi_access[1 - oflag]) == 0)
+		if (atomic_read(&fp->fi_access[1 - oflag]) == 0)
 			nfs4_file_put_fd(fp, O_RDWR);
 	}
 }


