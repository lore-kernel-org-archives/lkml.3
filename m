Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3EOGON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:14:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28167 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3EOGOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:14:09 -0400
X-Spam-Score: -100.8
Message-ID: <5193277A.3040506@asianux.com>
Date: Wed, 15 May 2013 14:13:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/workqueue.c: need call device_remove_file() when failure
 occurs after called device_create_file()
References: <51922D30.8000809@asianux.com> <20130514151752.GB6795@mtj.dyndns.org> <5192EFE0.4040903@asianux.com>
In-Reply-To: <5192EFE0.4040903@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In workqueue_sysfs_register(), when failure occurs after called
device_create_file(), need call device_remove_file() to release the
related resources, then call device_unregister().

Or it will cause issue.

For individual 'device_attributs' (just like our case), need call
device_remove_file() explictly and then call device_unregister(),
please reference drivers/base/*.c (e.g node.c or cpu.c).


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/workqueue.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1ae6028..de11dae 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3323,6 +3323,8 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 		for (attr = wq_sysfs_unbound_attrs; attr->attr.name; attr++) {
 			ret = device_create_file(&wq_dev->dev, attr);
 			if (ret) {
+				while (--attr >= wq_sysfs_unbound_attrs)
+					device_remove_file(&wq_dev->dev, attr);
 				device_unregister(&wq_dev->dev);
 				wq->wq_dev = NULL;
 				return ret;
-- 
1.7.7.6
