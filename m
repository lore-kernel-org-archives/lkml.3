Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3EJOwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:52:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56855 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753725Ab3EJOTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>,
        "fanchaoting" <fanchaoting@cn.fujitsu.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.23602413@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [016/118] nfsd: don't run get_file if nfs4_preprocess_stateid_op
 return error
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: fanchaoting <fanchaoting@cn.fujitsu.com>

commit b022032e195ffca83d7002d6b84297d796ed443b upstream.

we should return error status directly when nfs4_preprocess_stateid_op
return error.

Signed-off-by: fanchaoting <fanchaoting@cn.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4proc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -880,14 +880,14 @@ nfsd4_write(struct svc_rqst *rqstp, stru
 
 	nfs4_lock_state();
 	status = nfs4_preprocess_stateid_op(cstate, stateid, WR_STATE, &filp);
-	if (filp)
-		get_file(filp);
-	nfs4_unlock_state();
-
 	if (status) {
+		nfs4_unlock_state();
 		dprintk("NFSD: nfsd4_write: couldn't process stateid!\n");
 		return status;
 	}
+	if (filp)
+		get_file(filp);
+	nfs4_unlock_state();
 
 	cnt = write->wr_buflen;
 	write->wr_how_written = write->wr_stable_how;

