Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3JGVEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:04:34 -0400
Received: from mail.ispras.ru ([83.149.199.45]:56093 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab3JGVEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:04:33 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH v2] [media] dvb_demux: fix deadlock in dmx_section_feed_release_filter()
Date: Tue,  8 Oct 2013 01:04:21 +0400
Message-Id: <1381179861-16408-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130926140808.729bad49@samsung.com>
References: <20130926140808.729bad49@samsung.com>
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

The patch releases dvbdmx->mutex before call to feed->stop_filtering(feed)
and reacquires the mutex after that.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb-core/dvb_demux.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 3485655..6de3bd0 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -1027,8 +1027,13 @@ static int dmx_section_feed_release_filter(struct dmx_section_feed *feed,
 		return -EINVAL;
 	}
 
-	if (feed->is_filtering)
+	if (feed->is_filtering) {
+		/* release dvbdmx->mutex as far as 
+		   it is acquired by stop_filtering() itself */
+		mutex_unlock(&dvbdmx->mutex);
 		feed->stop_filtering(feed);
+		mutex_lock(&dvbdmx->mutex);
+	}
 
 	spin_lock_irq(&dvbdmx->lock);
 	f = dvbdmxfeed->filter;
-- 
1.8.1.2

