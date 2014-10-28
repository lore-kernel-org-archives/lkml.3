Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaJ1DkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:40:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaJ1DkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:40:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.17 092/146] xfs: fix agno increment in xfs_inumbers() loop
Date: Tue, 28 Oct 2014 11:33:54 +0800
Message-Id: <20141028033347.398884046@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@sandeen.net>

commit a8b1ee8bafc765ebf029d03c5479a69aebff9693 upstream.

caused a regression in xfs_inumbers, which in turn broke
xfsdump, causing incomplete dumps.

The loop in xfs_inumbers() needs to fill the user-supplied
buffers, and iterates via xfs_btree_increment, reading new
ags as needed.

But the first time through the loop, if xfs_btree_increment()
succeeds, we continue, which triggers the ++agno at the bottom
of the loop, and we skip to soon to the next ag - without
the proper setup under next_ag to read the next ag.

Fix this by removing the agno increment from the loop conditional,
and only increment agno if we have actually hit the code under
the next_ag: target.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_itable.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -639,7 +639,8 @@ next_ag:
 		xfs_buf_relse(agbp);
 		agbp = NULL;
 		agino = 0;
-	} while (++agno < mp->m_sb.sb_agcount);
+		agno++;
+	} while (agno < mp->m_sb.sb_agcount);
 
 	if (!error) {
 		if (bufidx) {


