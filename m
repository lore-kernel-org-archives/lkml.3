Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3GXRE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:04:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35111 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3GXRE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:04:26 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-55-51f009195ca6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, konrad.wilk@oracle.com,
        Cristian =?ISO-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        bob.liu@oracle.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH staging] zcache: fix "zcache=" kernel parameter
Date: Wed, 24 Jul 2013 19:04:14 +0200
Message-id: <1954608.bCh4ljCYe6@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jAV1Jzg+BBptncVh0nZrKYnHv3zQm
	iz1nfrFbNC9ez2axbPFTRouzTW/YLS7vmsNm8ar5O6vFqkVRDpwe9/YdZvHYP3cNu8exky9Z
	PT4+vcXicfDdHiaPvi2rGD3OLDjC7vF5k1wARxSXTUpqTmZZapG+XQJXxp/lxQUzhCuW37/G
	1MC4VKCLkZNDQsBEovnMXxYIW0ziwr31bF2MXBxCAosYJfavmsAOkhASaGGSuPxOCcRmE7CS
	mNi+ihHEFhHQkHh59BYLSAOzwHImiYXrpjCBJIQF7CW6p+wFs1kEVCVabvawgti8ApoSa+d+
	YwOxRQVcJc4t+sECEReU+DH5HpjNLKAt8eTdBVYIW0ei9/s35gmMfLOQlM1CUjYLSdkCRuZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFB/kx6B+OqBotDjAIcjEo8vCu+vw8UYk0sK67M
	PcQowcGsJML79gFQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwT
	B6dUA6O5WfK9iWt0a/N3C8z92FDxIOP58ifCM+wCNktGHn03TWb9qYyLnb9WJss2zn93bOrC
	o9tqVz2Z+yjXXieWp8MvyXUyk3O5xb6VlxsFoy5ero17u+cw70ne0w0qrfZ+jcuP9/u4bEq5
	rb5T7ODPR10160xmfLY9e9Qud5X+xpdpq7dbdLySWxWqxFKckWioxVxUnAgAcO2N3m4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Piotr Sarna <p.sarna@partner.samsung.com>
Subject: [PATCH] zcache: fix "zcache=" kernel parameter

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
Cc: Cristian Rodríguez <crrodriguez@opensuse.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Bob Liu <bob.liu@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |    6 ++++--
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
1.7.9.5



