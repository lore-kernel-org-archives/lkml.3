Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3ASBQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:16:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3ASBOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:14:50 -0500
Subject: [PATCH 5/6] ocfs2: Wait for page writeback to provide stable pages
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, darrick.wong@oracle.com,
        ericvh@gmail.com, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
        tytso@mit.edu
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: martin.petersen@oracle.com, neilb@suse.de, Mark Fasheh <mfasheh@suse.com>,
        david@fromorbit.com, gnehzuil.liu@gmail.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        ocfs2-devel@oss.oracle.com, bharrosh@panasas.com, jlayton@samba.org,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        hirofumi@mail.parknet.co.jp, Joel Becker <jlbec@evilplan.org>
Date: Fri, 18 Jan 2013 17:13:08 -0800
Message-ID: <20130119011308.20902.44871.stgit@blackbox.djwong.org>
In-Reply-To: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When stable pages are required, we have to wait if the page is just
going to disk and we want to modify it. Add proper callback to
ocfs2_grab_pages_for_write().

CC: ocfs2-devel@oss.oracle.com
CC: Joel Becker <jlbec@evilplan.org>
CC: Mark Fasheh <mfasheh@suse.com>
From: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6577432..9796330 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1194,6 +1194,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 				goto out;
 			}
 		}
+		wait_for_stable_page(wc->w_pages[i]);
 
 		if (index == target_index)
 			wc->w_target_page = wc->w_pages[i];

