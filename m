Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899AbaH0OMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:12:00 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:45529
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934604AbaH0OL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:11:58 -0400
Message-ID: <53FDE6A3.3080303@freescale.com>
Date: Wed, 27 Aug 2014 17:09:39 +0300
From: Laurentiu Tudor <b10716@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
CC: Laurentiu Tudor <Laurentiu.Tudor@freescale.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] of: make sure of_alias is initialized before accessing it
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.166.1]
X-ClientProxiedBy: DB4PR05CA0006.eurprd05.prod.outlook.com (25.160.40.16) To
 BLUPR03MB312.namprd03.prod.outlook.com (10.141.48.28)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(6049001)(189002)(199003)(87266999)(99396002)(85306004)(46102001)(64706001)(50466002)(80022001)(102836001)(36756003)(21056001)(50986999)(81342001)(4396001)(33656002)(59896002)(74662001)(95666004)(54356999)(107046002)(65816999)(64126003)(229853001)(77096002)(65806001)(65956001)(47776003)(77982001)(20776003)(74502001)(66066001)(31966008)(105586002)(85852003)(83322001)(19580405001)(106356001)(81542001)(87976001)(80316001)(19580395003)(92726001)(92566001)(101416001)(90102001)(79102001)(76482001)(83506001)(23756003)(83072002)(42262002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB312;H:[10.171.73.112];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply swap of_alias and of_chosen initialization so
that of_alias ends up read first. This must be done
because it is accessed couple of lines below when
trying to initialize the of_stdout using the alias
based legacy method.

[Fixes a752ee5 - tty: Update hypervisor tty drivers to                          
use core stdout parsing code]

Signed-off-by: Laurentiu Tudor <Laurentiu.Tudor@freescale.com>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index d8574ad..52f8506 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1847,6 +1847,10 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 {
 	struct property *pp;
 
+	of_aliases = of_find_node_by_path("/aliases");
+	if (!of_aliases)
+		return;
+
 	of_chosen = of_find_node_by_path("/chosen");
 	if (of_chosen == NULL)
 		of_chosen = of_find_node_by_path("/chosen@0");
@@ -1862,10 +1866,6 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 			of_stdout = of_find_node_by_path(name);
 	}
 
-	of_aliases = of_find_node_by_path("/aliases");
-	if (!of_aliases)
-		return;
-
 	for_each_property_of_node(of_aliases, pp) {
 		const char *start = pp->name;
 		const char *end = start + strlen(start);
-- 
1.8.3.1
