Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab3DBWNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:13:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab3DBWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 121/124] net: fix the use of this_cpu_ptr
Date: Tue,  2 Apr 2013 15:11:43 -0700
Message-Id: <20130402221118.214679783@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 50eab0503a7579ada512e4968738b7c9737cf36e ]

flush_tasklet is not percpu var, and percpu is percpu var, and
	this_cpu_ptr(&info->cache->percpu->flush_tasklet)
is not equal to
	&this_cpu_ptr(info->cache->percpu)->flush_tasklet

1f743b076(use this_cpu_ptr per-cpu helper) introduced this bug.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -329,7 +329,7 @@ static void flow_cache_flush_per_cpu(voi
 	struct flow_flush_info *info = data;
 	struct tasklet_struct *tasklet;
 
-	tasklet = this_cpu_ptr(&info->cache->percpu->flush_tasklet);
+	tasklet = &this_cpu_ptr(info->cache->percpu)->flush_tasklet;
 	tasklet->data = (unsigned long)info;
 	tasklet_schedule(tasklet);
 }


