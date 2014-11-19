Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbaKSWll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:41:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaKSUxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 011/141] net: ppp: Dont call bpf_prog_create() in ppp_lock
Date: Wed, 19 Nov 2014 12:50:34 -0800
Message-Id: <20141119205151.044852751@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5748eb8f8e989a9da1ac7c96dc73d68cbdedf7df ]

In ppp_ioctl(), bpf_prog_create() is called inside ppp_lock, which
eventually calls vmalloc() and hits BUG_ON() in vmalloc.c.  This patch
works around the problem by moving the allocation outside the lock.

The bug was revealed by the recent change in net/core/filter.c, as it
allocates via vmalloc() instead of kmalloc() now.

Reported-and-tested-by: Stefan Seyfried <stefan.seyfried@googlemail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/ppp_generic.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -755,23 +755,23 @@ static long ppp_ioctl(struct file *file,
 
 		err = get_filter(argp, &code);
 		if (err >= 0) {
+			struct bpf_prog *pass_filter = NULL;
 			struct sock_fprog_kern fprog = {
 				.len = err,
 				.filter = code,
 			};
 
-			ppp_lock(ppp);
-			if (ppp->pass_filter) {
-				bpf_prog_destroy(ppp->pass_filter);
-				ppp->pass_filter = NULL;
+			err = 0;
+			if (fprog.filter)
+				err = bpf_prog_create(&pass_filter, &fprog);
+			if (!err) {
+				ppp_lock(ppp);
+				if (ppp->pass_filter)
+					bpf_prog_destroy(ppp->pass_filter);
+				ppp->pass_filter = pass_filter;
+				ppp_unlock(ppp);
 			}
-			if (fprog.filter != NULL)
-				err = bpf_prog_create(&ppp->pass_filter,
-						      &fprog);
-			else
-				err = 0;
 			kfree(code);
-			ppp_unlock(ppp);
 		}
 		break;
 	}
@@ -781,23 +781,23 @@ static long ppp_ioctl(struct file *file,
 
 		err = get_filter(argp, &code);
 		if (err >= 0) {
+			struct bpf_prog *active_filter = NULL;
 			struct sock_fprog_kern fprog = {
 				.len = err,
 				.filter = code,
 			};
 
-			ppp_lock(ppp);
-			if (ppp->active_filter) {
-				bpf_prog_destroy(ppp->active_filter);
-				ppp->active_filter = NULL;
+			err = 0;
+			if (fprog.filter)
+				err = bpf_prog_create(&active_filter, &fprog);
+			if (!err) {
+				ppp_lock(ppp);
+				if (ppp->active_filter)
+					bpf_prog_destroy(ppp->active_filter);
+				ppp->active_filter = active_filter;
+				ppp_unlock(ppp);
 			}
-			if (fprog.filter != NULL)
-				err = bpf_prog_create(&ppp->active_filter,
-						      &fprog);
-			else
-				err = 0;
 			kfree(code);
-			ppp_unlock(ppp);
 		}
 		break;
 	}


