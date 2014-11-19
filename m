Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362AbaKSVaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:30:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796AbaKSVOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.10 30/70] block: Fix computation of merged request priority
Date: Wed, 19 Nov 2014 12:52:21 -0800
Message-Id: <20141119205211.934056705@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ioprio.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -157,14 +157,16 @@ out:
 
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


