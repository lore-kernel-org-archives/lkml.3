Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaHZPir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:38:47 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51593 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaHZPip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:38:45 -0400
Message-ID: <53FCAA04.40009@gmail.com>
Date: Tue, 26 Aug 2014 23:38:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/xen/grant-table.c: Be sure of unsigned value never
 comparing with 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In grow_gnttab_list(), 'i' is 'unsigned int', and 'nr_glist_frames' may
be 0 because 'nr_grant_frames' may be 0. So 'i' may never be less than
'nr_glist_frames' in failure processing, which cause infinite looping.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/xen/grant-table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index c254ae0..be07645 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -592,8 +592,8 @@ static int grow_gnttab_list(unsigned int more_frames)
 	return 0;
 
 grow_nomem:
-	for ( ; i >= nr_glist_frames; i--)
-		free_page((unsigned long) gnttab_list[i]);
+	while (i > nr_glist_frames)
+		free_page((unsigned long) gnttab_list[--i]);
 	return -ENOMEM;
 }
 
-- 
1.9.3
