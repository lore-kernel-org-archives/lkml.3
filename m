Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3IMAZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:25:16 -0400
Received: from asmtp.lnxw.com ([207.21.185.2]:46854 "EHLO stitch.lnxw.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754562Ab3IMAZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:25:12 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 20:25:12 EDT
From: Alexey Neyman <stilor@att.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix coalescing of host bridge windows in arch/x86/pci/acpi.c
Date: Thu, 12 Sep 2013 17:19:16 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34-020634-generic; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FolMSkFDWOWq0aE"
Message-Id: <201309121719.17447.stilor@att.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_FolMSkFDWOWq0aE
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

I have a board with a BIOS bug that reports the following I/O port regions in 
_CRS on one of the host bridges:

0x0000-0x03af // #0
0x03e0-0x0cf7 // #1
0x03b0-0x03bb // #2
0x03c0-0x03df // #3
0x0000-0xdfff // #4
0xf000-0xffff // #5

Obviously, region number #4 is erroneous as it overlaps with regions #0..3. 
However, code in coalesce_windows() in arch/x86/pci/acpi.c attempts to recover 
from such kind of BIOS bugs by merging the overlapping regions. Current code 
expands region #0 to 0x0000-0xdffff and makes region #4 ignored. As a result, 
overlap of the expanded region #0 with regions #1..3 remains undetected. As a 
result, regions #1..3 are inserted into the resource tree as if they were 
consumers of the 0x0000-0xdfff regions, and devices that have resources in one 
of these regions (e.g. 0x3f6 for legacy IDE) have a resource conflict - the 
kernel does not initialize them.

The attached patch makes the code in coalesce_windows() instead ignore res1 
(which is already dealt with), possibly expanding res2 instead. As res2 has 
not been reached in the outer loop in coalesce_windows(), the code will then 
check for overlaps of the just-expanded resource with the rest of the 
resources.

Regards,
Alexey.

--Boundary-00=_FolMSkFDWOWq0aE
Content-Type: text/x-patch;
  charset="UTF-8";
  name="acpi.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="acpi.c.diff"

--- arch/x86/pci/acpi.c.orig	2013-09-12 16:23:06.113813150 -0700
+++ arch/x86/pci/acpi.c	2013-09-12 16:23:56.605813117 -0700
@@ -357,12 +357,12 @@
 			 * the kernel resource tree doesn't allow overlaps.
 			 */
 			if (resource_overlaps(res1, res2)) {
-				res1->start = min(res1->start, res2->start);
-				res1->end = max(res1->end, res2->end);
+				res2->start = min(res1->start, res2->start);
+				res2->end = max(res1->end, res2->end);
 				dev_info(&info->bridge->dev,
 					 "host bridge window expanded to %pR; %pR ignored\n",
-					 res1, res2);
-				res2->flags = 0;
+					 res2, res1);
+				res1->flags = 0;
 			}
 		}
 	}

--Boundary-00=_FolMSkFDWOWq0aE--
