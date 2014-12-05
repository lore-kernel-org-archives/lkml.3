Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaLEWrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:47:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaLEWqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Gaurav Minocha <gaurav.minocha.os@gmail.com>
Subject: [PATCH 3.17 076/122] of/selftest: Fix off-by-one error in removal path
Date: Fri,  5 Dec 2014 14:44:10 -0800
Message-Id: <20141205223317.227994267@linuxfoundation.org>
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

From: Grant Likely <grant.likely@linaro.org>

commit c1a2086e2d8c4eb4e8630ba752e911ec180dec67 upstream.

The removal path for selftest data has an off by one error that causes
the code to dereference beyond the end of the nodes[] array on the first
pass through. The old code only worked by chance on a lot of platforms,
but the bug was recently exposed on aarch64.

The fix is simple. Decrement the node count before dereferencing, not
after.

Reported-by: Kevin Hilman <khilman@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Gaurav Minocha <gaurav.minocha.os@gmail.com>

---
 drivers/of/selftest.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -799,7 +799,7 @@ static void selftest_data_remove(void)
 		return;
 	}
 
-	while (last_node_index >= 0) {
+	while (last_node_index-- > 0) {
 		if (nodes[last_node_index]) {
 			np = of_find_node_by_path(nodes[last_node_index]->full_name);
 			if (strcmp(np->full_name, "/aliases") != 0) {
@@ -812,7 +812,6 @@ static void selftest_data_remove(void)
 				}
 			}
 		}
-		last_node_index--;
 	}
 }
 


