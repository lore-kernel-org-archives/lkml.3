Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3G2KZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:25:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60864 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3G2KZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:25:42 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-1f-51f64325b3b3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, konrad.wilk@oracle.com,
        crrodriguez@opensuse.org, p.sarna@partner.samsung.com,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, bob.liu@oracle.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com
Subject: [PATCH resend] staging: zcache: fix "zcache=" kernel parameter
Date: Mon, 29 Jul 2013 12:25:20 +0200
Message-id: <1375093520-17071-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV1V52+BBg2/2S02zljPatF1aiqL
	xb1/05gs9pz5xW7RvHg9m8WyxU8ZLc42vWG3uLxrDpvFq+bvrBarFkU5cHnc23eYxWP/3DXs
	HsdOvmT1+Pj0FovHwXd7mDz6tqxi9Diz4Ai7x+dNcgEcUVw2Kak5mWWpRfp2CVwZS09fZy9o
	Ear4+7+kgbGTv4uRg0NCwERi+oqyLkZOIFNM4sK99WxdjFwcQgLTGSU+v1jIAuF0MUl8frWZ
	BaSKTcBKYmL7KkYQW0RATuLJ7T/MIEXMAq8YJS5/WA1WJCzgLjF131kmEJtFQFVi2oRbbCA2
	r4CHxPun51gg1slLPL3fxzaBkXsBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODweia9
	g3FVg8UhRgEORiUe3gdOXwKFWBPLiitzDzFKcDArifByGH0NFOJNSaysSi3Kjy8qzUktPsQo
	zcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cDI9f01W/iK3UX7PDWWZXLbGfOFfn2tH7BM
	ftEXg/tz5rg/udO6YXPdRtcuf8dNiZcluOZ0CNjfbZD59ccw7fsXt2XrKgKbHJrXzdHe9r4x
	26TGdY5Hen5m99MO80D+J2YXtETuvDLZy2Dz7UxY9IXbV5unsZZc1/Ca/6S7jlGC6cLjh40L
	5PmVWIozEg21mIuKEwENZTF6KwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Piotr Sarna <p.sarna@partner.samsung.com>

Commit 835f2f5 ("staging: zcache: enable zcache to be built/loaded as
a module") introduced an incorrect handling of "zcache=" parameter.

Inside zcache_comp_init() function, zcache_comp_name variable is
checked for being empty. If not empty, the above variable is tested
for being compatible with Crypto API. Unfortunately, after that
function ends unconditionally (by the "goto out" directive) and returns:
- non-zero value if verification succeeded, wrongly indicating an error
- zero value if verification failed, falsely informing that function
  zcache_comp_init() ended properly.

A solution to this problem is as following:
1. Move the "goto out" directive inside the "if (!ret)" statement
2. In case that crypto_has_comp() returned 0, change the value of ret
   to non-zero before "goto out" to indicate an error.

This patch replaces an earlier one from Michal Hocko (based on report
from Cristian Rodriguez):

	http://permalink.gmane.org/gmane.linux.kernel.mm/102484

It also addressed the same issue but didn't fix the zcache_comp_init()
for case when the compressor data passed to "zcache=" option was invalid
or unsupported.

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
[bzolnier: updated patch description]
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Cristian Rodriguez <crrodriguez@opensuse.org>
Cc: Bob Liu <bob.liu@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index dcceed2..81972fa 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1811,10 +1811,12 @@ static int zcache_comp_init(void)
 #else
 	if (*zcache_comp_name != '\0') {
 		ret = crypto_has_comp(zcache_comp_name, 0, 0);
-		if (!ret)
+		if (!ret) {
 			pr_info("zcache: %s not supported\n",
 					zcache_comp_name);
-		goto out;
+			ret = 1;
+			goto out;
+		}
 	}
 	if (!ret)
 		strcpy(zcache_comp_name, "lzo");
-- 
1.8.2.3

