Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3ERDCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:02:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab3ERDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:33 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=r6hHaLvwI3gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Q_0Km_qodfwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yUWOJpb58Fc9lSpJz_EA:9 a=jEp0ucaQiEUA:10 a=_RhRFcbxBZMA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021652.583355654@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        <stable@kernel.org>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 067/136 ] nfsd4: dont close read-write opens too soon
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0067-nfsd4-don-t-close-read-write-opens-too-soon.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 0c7c3e67ab91ec6caa44bdf1fc89a48012ceb0c5 ]

Don't actually close any opens until we don't need them at all.

This means being left with write access when it's not really necessary,
but that's better than putting a file that might still have posix locks
held on it, as we have been.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Cc: stable@kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfsd/nfs4state.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 5b3224c..0ecd408 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -217,13 +217,7 @@ static void __nfs4_file_put_access(struct nfs4_file *fp, int oflag)
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
-- 
1.7.10.4


