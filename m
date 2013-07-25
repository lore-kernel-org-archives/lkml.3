Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3GYKOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:14:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8753 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3GYKO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:14:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7efe6d000007b11-db-51f0fa834f75
Content-transfer-encoding: 8BIT
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, konrad.wilk@oracle.com,
        crrodriguez@opensuse.org, p.sarna@partner.samsung.com,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, bob.liu@oracle.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com
Subject: [PATCH] staging: zcache: fix "zcache=" kernel parameter
Date: Thu, 25 Jul 2013 12:13:54 +0200
Message-id: <1374747234-11237-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t9jQd3mXx8CDXYc5bHYOGM9q0XXqaks
	Fvf+TWOy2HPmF7tF8+L1bBbLFj9ltDjb9Ibd4vKuOWwWr5q/s1qsWhTlwOVxb99hFo/9c9ew
	exw7+ZLV4+PTWyweB9/tYfLo27KK0ePMgiPsHp83yQVwRHHZpKTmZJalFunbJXBlTJv6nKmg
	Taiis+0KYwNjN38XIyeHhICJxNPpu9khbDGJC/fWs3UxcnEICUxnlPh3o40NJMErICjxY/I9
	li5GDg5mAXmJI5eyQcLMAuoSk+YtYoao72KSWHT1DdggNgEriYntqxhBbBEBOYknt/+AFTEL
	vGKUuPxhNQtIQljAQWL53XtMIDaLgKpE48pGdohlHhKznzxlhLhIXuLp/T62CYx8s5DcMQvh
	jllI7ljAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjcn0nvYFzVYHGIUYCDUYmHd8X3
	94FCrIllxZW5hxglOJiVRHhjKz4ECvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliS
	mp2aWpBaBJNl4uCUamBsPiVyj6HA2mXu9+YwEQ2Zz79S1pdtL17+3fFs7COr3ombFmZ/Fzh/
	72Br2Z/0A4Fb2KQKD+6Xz/BWtX9hrit/+FqRztLFStmTM4NPTeu083hmyPt4f2Lyf6mw+u60
	+jgvF0n5SyarNzpyX2ThOLtYV741bYPm3yXS71b62+29Odfy5s+LS44osRRnJBpqMRcVJwIA
	0AkPhXMCAAA=
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
from Cristian Rodríguez):

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
Cc: Cristian Rodríguez <crrodriguez@opensuse.org>
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

