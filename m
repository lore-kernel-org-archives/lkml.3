Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3KFPGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:06:04 -0500
Received: from relay.parallels.com ([195.214.232.42]:55719 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3KFPGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:06:02 -0500
Subject: [PATCH] mm: add strictlimit knob -v2
To: akpm@linux-foundation.org
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: karl.kiniger@med.ge.com, tytso@mit.edu, linux-kernel@vger.kernel.org,
        t.artem@lycos.com, linux-mm@kvack.org, mgorman@suse.de, jack@suse.cz,
        fengguang.wu@intel.com, torvalds@linux-foundation.org,
        mpatlasov@parallels.com
Date: Wed, 06 Nov 2013 19:05:57 +0400
Message-ID: <20131106150515.25906.55017.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131104140104.7936d263258a7a6753eb325e@linux-foundation.org>
References: <20131104140104.7936d263258a7a6753eb325e@linux-foundation.org>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"strictlimit" feature was introduced to enforce per-bdi dirty limits for
FUSE which sets bdi max_ratio to 1% by default:

http://article.gmane.org/gmane.linux.kernel.mm/105809

However the feature can be useful for other relatively slow or untrusted
BDIs like USB flash drives and DVD+RW. The patch adds a knob to enable the
feature:

echo 1 > /sys/class/bdi/X:Y/strictlimit

Being enabled, the feature enforces bdi max_ratio limit even if global (10%)
dirty limit is not reached. Of course, the effect is not visible until
/sys/class/bdi/X:Y/max_ratio is decreased to some reasonable value.

Changed in v2:
 - updated patch description and documentation

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 Documentation/ABI/testing/sysfs-class-bdi |    8 +++++++
 mm/backing-dev.c                          |   35 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-bdi b/Documentation/ABI/testing/sysfs-class-bdi
index d773d56..3187a18 100644
--- a/Documentation/ABI/testing/sysfs-class-bdi
+++ b/Documentation/ABI/testing/sysfs-class-bdi
@@ -53,3 +53,11 @@ stable_pages_required (read-only)
 
 	If set, the backing device requires that all pages comprising a write
 	request must not be changed until writeout is complete.
+
+strictlimit (read-write)
+
+	Forces per-BDI checks for the share of given device in the write-back
+	cache even before the global background dirty limit is reached. This
+	is useful in situations where the global limit is much higher than
+	affordable for given relatively slow (or untrusted) device. Turning
+	strictlimit on has no visible effect if max_ratio is equal to 100%.
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ce682f7..4ee1d64 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -234,11 +234,46 @@ static ssize_t stable_pages_required_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(stable_pages_required);
 
+static ssize_t strictlimit_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	unsigned int val;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	switch (val) {
+	case 0:
+		bdi->capabilities &= ~BDI_CAP_STRICTLIMIT;
+		break;
+	case 1:
+		bdi->capabilities |= BDI_CAP_STRICTLIMIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return count;
+}
+static ssize_t strictlimit_show(struct device *dev,
+		struct device_attribute *attr, char *page)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n",
+			!!(bdi->capabilities & BDI_CAP_STRICTLIMIT));
+}
+static DEVICE_ATTR_RW(strictlimit);
+
 static struct attribute *bdi_dev_attrs[] = {
 	&dev_attr_read_ahead_kb.attr,
 	&dev_attr_min_ratio.attr,
 	&dev_attr_max_ratio.attr,
 	&dev_attr_stable_pages_required.attr,
+	&dev_attr_strictlimit.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(bdi_dev);

