Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaFLBpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:45:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60603 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLBpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:45:49 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-16-5399064b687f
From: Yongtaek Lee <ytk.lee@samsung.com>
To: rydberg@euromail.se, dmitry.torokhov@gmail.com, daniels@collabora.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ytk.lee@samsung.com
Subject: [PATCH] Input: evdev - Fix incorrect kfree of err_free_client after
 vzalloc
Date: Thu, 12 Jun 2014 10:45:37 +0900
Message-id: <1402537537-17945-1-git-send-email-ytk.lee@samsung.com>
X-Mailer: git-send-email 1.7.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t8zPV1vtpnBBl1bWCw29W9ltzi86AWj
	xc1P31gtLu+aw2YxZfpMRovH67kd2Dx23F3C6HFg8k02j52z7rJ79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bry64FX9krVh3+yNzAuIeti5GTQ0LAROLEojtQtpjEhXvrgWwuDiGBZYwS
	V6efYYUpmt16kxEisYhRYvP+51DOH0aJDd+2MoFUsQloSOzsXMoCYosIeEr8WzkLqJuDg1kg
	RGJKuxlIWFggTOLo/Alg21gEVCXOnN3MDmLzCjhLnF+6gh1imZzEjtVPmEDmSwh8Z5O4uuUd
	K0SDgMS3yYdYQGZKCMhKbDrADFEvKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXr
	JefnbmKEBOrEHYz3D1gfYkwGGjeRWUo0OR8Y6Hkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoS
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwKin+Hrru9d5+32f/vjylFH53JKPMbnfXn9UeJ6Y
	5fph8vmA0h19SeKrDs1wysmJ1lAxO+y3yki8sbb9e0VY5wbjesOZkq/yNnfmXXAIKpulN2/6
	wjMM81+zF9hNCbraOitDZZdB1W1VmZUBz/qFSiqao+243e5qXGK9sWqjwtngnL6bj7b/eaHE
	UpyRaKjFXFScCAA+2hAPagIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jAV1vtpnBBq+rLTb1b2W3OLzoBaPF
	zU/fWC0u75rDZjFl+kxGi8fruR3YPHbcXcLocWDyTTaPnbPusnv0bVnF6PF5k1wAa1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozXl10LvrJXrDr8kbmBcQ9bFyMnh4SA
	icTs1puMELaYxIV764HiXBxCAosYJTbvf84I4fxhlNjwbSsTSBWbgIbEzs6lLCC2iICnxL+V
	s1i7GDk4mAVCJKa0m4GEhQXCJI7OnwC2gEVAVeLM2c3sIDavgLPE+aUr2CGWyUnsWP2EaQIj
	9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwVHwTGoH48oGi0OMAhyMSjy8EfUzgoVY
	E8uKK3MPMUpwMCuJ8DqeBwrxpiRWVqUW5ccXleakFh9iTAbaPpFZSjQ5HxiheSXxhsYmZkaW
	RmbGJubGxqQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAOH2Pu1Bm5ie7354Hjhla8N39
	fFLzZ5WTn4wbV5zej41rNP81OLjmn4/0fbhYt2PuNnnzpL/Jt/6mrz951uylV6/crZWyv/bp
	n1N3nmIjVBd1tfis3nIP9ZTdU42ET6T+EHx1oXha+9tmvwnvvN1mtE+O2vC+TviBQbykmdiN
	yhfOO0JrxePqlViKMxINtZiLihMBu5pWJcYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was introduced by commit 92eb77d ("Input: evdev - fall back
to vmalloc for client event buffer").

vzalloc is used to alloc memory as fallback in case of failure
of kzalloc. But err_free_client was not considered on below case.
1. kzalloc fail
2. vzalloc success
3. evdev_open_device fail
4. kfree

So that address checking is needed to call correct free function.

Signed-off-by: Yongtaek Lee <ytk.lee@samsung.com>
Reviewed-by: Daniel Stone <daniels@collabora.com>
---
 drivers/input/evdev.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index ce953d8..f60daa0 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -422,7 +422,10 @@ static int evdev_open(struct inode *inode, struct file *file)
 
  err_free_client:
 	evdev_detach_client(evdev, client);
-	kfree(client);
+	if (is_vmalloc_addr(client))
+		vfree(client);
+	else
+		kfree(client);
 	return error;
 }
 
-- 
1.7.1

