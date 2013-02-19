Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3BSMC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:02:56 -0500
Received: from mout.gmx.net ([212.227.17.20]:50056 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab3BSMCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:02:55 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18TyyFuu1sTv38Ws3jdh7Y0IOwLrP08U/OfemyZeB
	WwnBU1LMCBJufH
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging/sep: Fix smatch false positive about potential NULL dereference in sep_main.c
Date: Tue, 19 Feb 2013 13:07:27 +0100
Message-Id: <1361275648-6259-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains about a potential NULL pointer dereference:

sep_main.c:2312 sep_construct_dma_tables_from_lli() error: potential
NULL dereference 'info_out_entry_ptr'.

info_out_entry_ptr is initialized with NULL and if info_in_entry_ptr is
not NULL it gets derefenced.
However info_out_entry_ptr is only NULL in the first iteration of the
while loop and in this case info_in_entry_ptr is also NULL (as indicated
by the comment /* If info entry is null - this is the first table built */
-> this is a false positive.

Nevertheless we add a check for info_out_entry_ptr to silence this
warning and make it more robust in regard to code changes.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/sep/sep_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 30e8d25..366d56b 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -2276,7 +2276,7 @@ static int sep_construct_dma_tables_from_lli(
 			table_data_size);
 
 		/* If info entry is null - this is the first table built */
-		if (info_in_entry_ptr == NULL) {
+		if (info_in_entry_ptr == NULL || info_out_entry_ptr == NULL) {
 			/* Set the output parameters to physical addresses */
 			*lli_table_in_ptr =
 			sep_shared_area_virt_to_bus(sep, dma_in_lli_table_ptr);
-- 
1.7.8.6

