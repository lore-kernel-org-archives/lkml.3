Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaLSRlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:41:10 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30188 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaLSRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:40:54 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d6-549463243d46
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v2 2/3] iio: kfifo: Add resource management
 devm_iio_kfifo_allocate/free
Date: Fri, 19 Dec 2014 18:39:25 +0100
Message-id: <1419010766-13557-3-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419010766-13557-1-git-send-email-k.wrona@samsung.com>
References: <1419010766-13557-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4NV2V5CkhBpeeaVpsnLGe1eJB0yom
	i1PL9jNZ7Pr/htnibNMbdoslk+ezWsw78o7F4vKuOWwWv3cdY7fYs24LkwOXx85Zd9k9PnyM
	89i0qpPNY8mbQ6we55uPMHr0bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXRuPvFuaCPUIVGx43
	sTUwrubvYuTkkBAwkej9sooFwhaTuHBvPVsXIxeHkMBSRolpd2ayQjh9TBItM5cyg1SxCahL
	NO9YzAySEBG4wChx/NAWFhCHWWANo8SZsxPYQaqEBaIkzjxfzARiswioSiz7PQ3M5hVwlji0
	9hWQzQG0T0FiziQbkDCngIvE8iu9bCC2EFDJ+/5u1gmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YW
	l+al6yXn525ihATi1x2MS49ZHWIU4GBU4uH90Dg5RIg1say4MvcQowQHs5IIr6H7lBAh3pTE
	yqrUovz4otKc1OJDjEwcnFINjCJtO3P0deZ5LnXwUe50f3zycuxN5xlTS/IUlgfeV0orf/86
	YY3IozChsl1pyuI6T9bvnGH22Gf5eRPndGVd0wWHnx49r7X2mmzuPtc5wV+WPdiksrHg+O+I
	lK1v3tcW7GHWyVW6paAjza60d2HQuxs/TjYGSsyXV3hzPuPge62D8ac+7+RV2qXEUpyRaKjF
	XFScCAAuCSEFIgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iio kfifo allocate/free gained their devm_ wrappers.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Suggested-by: Jonathan Cameron <jic23@kernel.org>
---
 drivers/iio/kfifo_buf.c       |   54 +++++++++++++++++++++++++++++++++++++++++
 include/linux/iio/kfifo_buf.h |    3 +++
 2 files changed, 57 insertions(+)

diff --git a/drivers/iio/kfifo_buf.c b/drivers/iio/kfifo_buf.c
index a383291..5d44099 100644
--- a/drivers/iio/kfifo_buf.c
+++ b/drivers/iio/kfifo_buf.c
@@ -191,4 +191,58 @@ void iio_kfifo_free(struct iio_buffer *r)
 }
 EXPORT_SYMBOL(iio_kfifo_free);
 
+static void devm_iio_kfifo_release(struct device *dev, void *res)
+{
+	iio_kfifo_free(*(struct iio_buffer **)res);
+}
+
+static int devm_iio_kfifo_match(struct device *dev, void *res, void *data)
+{
+	struct iio_buffer **r = res;
+
+	if (WARN_ON(!r || !*r))
+		return 0;
+
+	return *r == data;
+}
+
+/**
+ * devm_iio_fifo_allocate - Resource-managed iio_kfifo_allocate()
+ * @dev:		Device to allocate kfifo buffer for
+ *
+ * RETURNS:
+ * Pointer to allocated iio_buffer on success, NULL on failure.
+ */
+struct iio_buffer *devm_iio_kfifo_allocate(struct device *dev)
+{
+	struct iio_buffer **ptr, *r;
+
+	ptr = devres_alloc(devm_iio_kfifo_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	r = iio_kfifo_allocate();
+	if (r) {
+		*ptr = r;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return r;
+}
+EXPORT_SYMBOL(devm_iio_kfifo_allocate);
+
+/**
+ * devm_iio_fifo_free - Resource-managed iio_kfifo_free()
+ * @dev:		Device the buffer belongs to
+ * @r:			The buffer associated with the device
+ */
+void devm_iio_kfifo_free(struct device *dev, struct iio_buffer *r)
+{
+	WARN_ON(devres_release(dev, devm_iio_kfifo_release,
+			       devm_iio_kfifo_match, r));
+}
+EXPORT_SYMBOL(devm_iio_kfifo_free);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/iio/kfifo_buf.h b/include/linux/iio/kfifo_buf.h
index 1a8d57a..1683bc7 100644
--- a/include/linux/iio/kfifo_buf.h
+++ b/include/linux/iio/kfifo_buf.h
@@ -8,4 +8,7 @@
 struct iio_buffer *iio_kfifo_allocate(void);
 void iio_kfifo_free(struct iio_buffer *r);
 
+struct iio_buffer *devm_iio_kfifo_allocate(struct device *dev);
+void devm_iio_kfifo_free(struct device *dev, struct iio_buffer *r);
+
 #endif
-- 
1.7.9.5

