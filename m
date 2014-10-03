Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaJCWYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:24:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaJCWXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:23:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.10 008/143] drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
Date: Fri,  3 Oct 2014 14:33:23 -0700
Message-Id: <20141003213314.729682018@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 11e504cc705e8ccb06ac93a276e11b5e8fee4d40 upstream.

list_empty(&_manager->pools) being false before taking _manager->lock
does not guarantee that _manager->npools != 0 after taking _manager->lock
because _manager->npools is updated under _manager->lock.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1016,6 +1016,8 @@ static int ttm_dma_pool_mm_shrink(struct
 		return 0;
 
 	mutex_lock(&_manager->lock);
+	if (!_manager->npools)
+		goto out;
 	pool_offset = pool_offset % _manager->npools;
 	list_for_each_entry(p, &_manager->pools, pools) {
 		unsigned nr_free;
@@ -1033,6 +1035,7 @@ static int ttm_dma_pool_mm_shrink(struct
 			 p->pool->dev_name, p->pool->name, current->pid,
 			 nr_free, shrink_pages);
 	}
+out:
 	mutex_unlock(&_manager->lock);
 	/* return estimated number of unused pages in pool */
 	return ttm_dma_pool_get_num_unused_pages();


