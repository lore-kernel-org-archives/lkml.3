Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbaLLGbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:31:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51950 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759327AbaLLGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jens Axboe" <axboe@fb.com>,
        "Jan Kara" <jack@suse.cz>, "Jeff Moyer" <jmoyer@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.511853678@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 105/164] block: Fix computation of merged request priority
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit ece9c72accdc45c3a9484dacb1125ce572647288 upstream.

Priority of a merged request is computed by ioprio_best(). If one of the
requests has undefined priority (IOPRIO_CLASS_NONE) and another request
has priority from IOPRIO_CLASS_BE, the function will return the
undefined priority which is wrong. Fix the function to properly return
priority of a request with the defined priority.

Fixes: d58cdfb89ce0c6bd5f81ae931a984ef298dbda20
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ioprio.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -169,14 +169,16 @@ out:
 
 int ioprio_best(unsigned short aprio, unsigned short bprio)
 {
-	unsigned short aclass = IOPRIO_PRIO_CLASS(aprio);
-	unsigned short bclass = IOPRIO_PRIO_CLASS(bprio);
+	unsigned short aclass;
+	unsigned short bclass;
 
-	if (aclass == IOPRIO_CLASS_NONE)
-		aclass = IOPRIO_CLASS_BE;
-	if (bclass == IOPRIO_CLASS_NONE)
-		bclass = IOPRIO_CLASS_BE;
+	if (!ioprio_valid(aprio))
+		aprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_NORM);
+	if (!ioprio_valid(bprio))
+		bprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_NORM);
 
+	aclass = IOPRIO_PRIO_CLASS(aprio);
+	bclass = IOPRIO_PRIO_CLASS(bprio);
 	if (aclass == bclass)
 		return min(aprio, bprio);
 	if (aclass > bclass)

