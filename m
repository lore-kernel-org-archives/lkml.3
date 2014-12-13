Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaLMAyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 19:54:45 -0500
Received: from rs04.intra2net.com ([85.214.66.2]:51617 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbaLMAyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 19:54:44 -0500
Message-ID: <548B8E50.1000106@intra2net.com>
Date: Sat, 13 Dec 2014 01:54:40 +0100
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: [RFC PATCH, untested] Fix off-by-one in tps_comparators[] access
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The array tps_comparators starts at zero,
yet COMP1 starts at 1. So COMP2 is out of bounds.

cppcheck reported:
[drivers/mfd/tps65911-comparator.c:61]: (error) Array 'tps_comparators[2]' accessed at index 2, which is out of bounds.
[drivers/mfd/tps65911-comparator.c:88]: (error) Array 'tps_comparators[2]' accessed at index 2, which is out of bounds.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 drivers/mfd/tps65911-comparator.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tps65911-comparator.c b/drivers/mfd/tps65911-comparator.c
index c0816eb..e8c2e32 100644
--- a/drivers/mfd/tps65911-comparator.c
+++ b/drivers/mfd/tps65911-comparator.c
@@ -58,13 +58,14 @@ static struct comparator tps_comparators[] = {
 
 static int comp_threshold_set(struct tps65910 *tps65910, int id, int voltage)
 {
-	struct comparator tps_comp = tps_comparators[id];
+	struct comparator tps_comp;
 	int curr_voltage = 0;
 	int ret;
 	u8 index = 0, val;
 
-	if (id == COMP)
+	if (id == COMP || id > COMP2)
 		return 0;
+	tps_comp = tps_comparators[id-1];
 
 	while (curr_voltage < tps_comp.uV_max) {
 		curr_voltage = tps_comp.vsel_table[index];
@@ -85,12 +86,13 @@ static int comp_threshold_set(struct tps65910 *tps65910, int id, int voltage)
 
 static int comp_threshold_get(struct tps65910 *tps65910, int id)
 {
-	struct comparator tps_comp = tps_comparators[id];
+	struct comparator tps_comp;
 	int ret;
 	u8 val;
 
-	if (id == COMP)
+	if (id == COMP || id > COMP2)
 		return 0;
+	tps_comp = tps_comparators[id-1];
 
 	ret = tps65910->read(tps65910, tps_comp.reg, 1, &val);
 	if (ret < 0)
-- 
1.9.3

