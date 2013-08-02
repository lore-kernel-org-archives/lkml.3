Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3HBTlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:41:01 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64643 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab3HBTk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:40:59 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] acpi: video: improve quirk check
Date: Fri,  2 Aug 2013 14:37:09 -0500
Message-Id: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the _BCL package is descending, the first level (br->levels[2]) will
be 0, and if the number of levels matches the number of steps, we might
confuse a returned level to mean the index.

For example:

  current_level = max_level = 100
  test_level = 0
  returned level = 100

In this case 100 means the level, not the index, and _BCM failed. But if
the _BCL package is descending, the index of level 0 is also 100, so we
assume _BQC is indexed, when it's not.

This causes all _BQC calls to return bogus values causing weird behavior
from the user's perspective. For example: xbacklight -set 10; xbacklight
-set 20; would flash to 90% and then slowly down to the desired level
(20).

The solution is simple; test anything other than the first level (e.g.
1).

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---

On top of this we might want to test yet another value, because br->levels[3]
might be the current value (although very unlikely).

 drivers/acpi/video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 0ec434d..e1284b8 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -689,7 +689,7 @@ static int acpi_video_bqc_quirk(struct acpi_video_device *device,
 	 * Some systems always report current brightness level as maximum
 	 * through _BQC, we need to test another value for them.
 	 */
-	test_level = current_level == max_level ? br->levels[2] : max_level;
+	test_level = current_level == max_level ? br->levels[3] : max_level;
 
 	result = acpi_video_device_lcd_set_level(device, test_level);
 	if (result)
-- 
1.8.4.rc1

