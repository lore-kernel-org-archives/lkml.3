Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3HBMFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:05:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44036 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3HBMFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:05:18 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-74-51fba039de18
From: Piotr Sarna <p.sarna@partner.samsung.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, b.zolnierkie@samsung.com,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] ext4: fix handling of nodelalloc parameter
Date: Fri, 02 Aug 2013 14:03:46 +0200
Message-id: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t9jAV3LBb8DDab9trH4+qWDxWLjjPWs
	Fmeb3rBbzJx3h83i8q45bBarFkVZtPb8ZHdg92jZXO7RdOYos8fBd3uYPPq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugStj+vv5TAVbeCoWte9gamBcz9XFyMkhIWAi8e/7Y1YIW0ziwr31bCC2
	kMAiRon96wq6GLmA7HYmib+broMl2AT0Jb5cX8MCYosICEpcvvOAGaSIWeAMo8TLJV/YQRLC
	AvYS247OYAKxWQRUJRoOX2MEsXkFvCU+nv0JtI0DaJuCxJxJNhMYuRcwMqxiFE0tSC4oTkrP
	NdIrTswtLs1L10vOz93ECA6QZ9I7GFc1WBxiFOBgVOLhfZD5K1CINbGsuDL3EKMEB7OSCO+f
	2UAh3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjNUtqVIS
	y97+rzzHXehyqEvq5SbJYyExJ6NvlSRtPPj3POMBB4P+Q0YPd1T7u8o9YTZ8ueGGTdUsZUU3
	nRPB8zfv9bSavWMzz8mtE5+uPJdRzLb/duzKLp6T94O+6hscy1Ay3PJ55ctjv7lP76lx6pb0
	XnvQ+VbIcYcrDMZPv++1Y9X/w8DE16XEUpyRaKjFXFScCACd8uJCDAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 26092bf ("ext4: use a table-driven handler for mount options")
introduced buggy handling of nodelalloc parameter in mount command.

After explicitly using delalloc or nodelalloc parameter in mount command,
MOPT_EXPLICIT flag is set. After that, a test ensures that "data=journal"
and "delalloc" parameters are not simultaneously activated.
Unluckily, the mentioned test reports a bug in both situations:
- "data=journal,delalloc"
- "data=journal,nodelalloc"
whereas the second one is perfectly legal and acceptable.

A simple solution to this problem is in setting EXPLICIT_DELALLOC flag
properly. This patch ensures that EXPLICIT_DELALLOC flag is set only
if "delalloc" parameter was used, and not set in case of "nodelalloc".

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 94cc84d..10f9bb0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1467,7 +1467,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
 		return -1;
 	if (m->flags & MOPT_EXPLICIT)
-		set_opt2(sb, EXPLICIT_DELALLOC);
+		if (m->flags & MOPT_SET)
+			set_opt2(sb, EXPLICIT_DELALLOC);
 	if (m->flags & MOPT_CLEAR_ERR)
 		clear_opt(sb, ERRORS_MASK);
 	if (token == Opt_noquota && sb_any_quota_loaded(sb)) {
-- 
1.7.9.5

