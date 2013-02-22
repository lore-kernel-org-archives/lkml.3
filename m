Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3BVB0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:26:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43919 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3BVB0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:26:42 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: ebiederm@xmission.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kexec: prevent double free on image allocation failure
Date: Thu, 21 Feb 2013 20:26:15 -0500
Message-Id: <1361496375-30994-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kimage_normal_alloc() fails to initialize an allocated kimage, it will free
the image but would still set 'rimage', as a result kexec_load will try
to free it again.

This would explode as part of the freeing process is accessing internal
members which point to uninitialized memory.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/kexec.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2348bd6..855bfbb 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -242,8 +242,6 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 	if (result)
 		goto out;
 
-	*rimage = image;
-
 	/*
 	 * Find a location for the control code buffer, and add it
 	 * the vector of segments so that it's pages will also be
-- 
1.8.1.2

