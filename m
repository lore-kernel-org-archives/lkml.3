Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaLEWu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:50:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaLEWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kevin Cernekee <cernekee@gmail.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH 3.17 075/122] of: Fix crash if an earlycon driver is not found
Date: Fri,  5 Dec 2014 14:44:09 -0800
Message-Id: <20141205223317.075077519@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Cernekee <cernekee@gmail.com>

commit ab74d00a39f70e1bc34a01322bb59f3750ca7a8c upstream.

__earlycon_of_table_sentinel.compatible is a char[128], not a pointer, so
it will never be NULL.  Checking it against NULL causes the match loop to
run past the end of the array, and eventually match a bogus entry, under
the following conditions:

 - Kernel command line specifies "earlycon" with no parameters
 - DT has a stdout-path pointing to a UART node
 - The UART driver doesn't use OF_EARLYCON_DECLARE (or maybe the console
   driver is compiled out)

Fix this by checking to see if match->compatible is a non-empty string.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/fdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -773,7 +773,7 @@ int __init early_init_dt_scan_chosen_ser
 	if (offset < 0)
 		return -ENODEV;
 
-	while (match->compatible) {
+	while (match->compatible[0]) {
 		unsigned long addr;
 		if (fdt_node_check_compatible(fdt, offset, match->compatible)) {
 			match++;


