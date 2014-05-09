Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbaEISnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:43:15 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:24754 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756400AbaEISnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:43:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwXAJUgbVNXQw5R/2dsb2JhbABZgwasTgQBAQEBAQEFAZoUAgKBGRd0gmYcIxiBAiQTiEUB0TyFVoh8hEcBA48kiiIBiwOHf4M4Ow
Date: Fri, 9 May 2014 20:43:09 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/reboot.c: convert simple_strtoul to kstrtoint
Message-Id: <20140509204309.86e06d8793c15a633c8670f5@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace obsolete function.
kstrtoint is used as reboot_cpu is an integer.

Inspired-By: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/reboot.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 662c83f..a3a9e24 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -388,15 +388,22 @@ static int __init reboot_setup(char *str)
 			break;
 
 		case 's':
-			if (isdigit(*(str+1)))
-				reboot_cpu = simple_strtoul(str+1, NULL, 0);
-			else if (str[1] == 'm' && str[2] == 'p' &&
-							isdigit(*(str+3)))
-				reboot_cpu = simple_strtoul(str+3, NULL, 0);
-			else
+		{
+			int rc;
+
+			if (isdigit(*(str+1))) {
+				rc = kstrtoint(str+1, 0, &reboot_cpu);
+				if (rc)
+					return rc;
+			} else if (str[1] == 'm' && str[2] == 'p' &&
+				   isdigit(*(str+3))) {
+				rc = kstrtoint(str+3, 0, &reboot_cpu);
+				if (rc)
+					return rc;
+			} else
 				reboot_mode = REBOOT_SOFT;
 			break;
-
+		}
 		case 'g':
 			reboot_mode = REBOOT_GPIO;
 			break;
-- 
1.8.4.5

