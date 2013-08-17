Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3HQUtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 16:49:32 -0400
Received: from mail.ispras.ru ([83.149.199.45]:37828 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab3HQUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:49:31 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] dvb_demux: fix deadlock in dmx_section_feed_release_filter()
Date: Sat, 17 Aug 2013 23:48:51 +0300
Message-Id: <1376772531-8963-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmx_section_feed_release_filter() locks dvbdmx->mutex and
if the feed is still filtering, it calls feed->stop_filtering(feed).
stop_filtering() is implemented by dmx_section_feed_stop_filtering()
that first of all try to lock the same mutex: dvbdmx->mutex.
That leads to a deadlock.

It does not happen often in practice because all callers of
release_filter() stop filtering by themselves.
So the problem can happen in case of race condition only.

The patch proposes to unlock dvbdmx->mutex before call feed->stop_filtering(feed)
and recheck feed->is_filtering after reacquiring mutex.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb-core/dvb_demux.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 3485655..9d517af 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -1027,8 +1027,11 @@ static int dmx_section_feed_release_filter(struct dmx_section_feed *feed,
 		return -EINVAL;
 	}
 
-	if (feed->is_filtering)
+	while (feed->is_filtering) {
+		mutex_unlock(&dvbdmx->mutex);
 		feed->stop_filtering(feed);
+		mutex_lock(&dvbdmx->mutex);
+	}
 
 	spin_lock_irq(&dvbdmx->lock);
 	f = dvbdmxfeed->filter;
-- 
1.8.1.2

