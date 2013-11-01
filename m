Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3KAObq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:31:46 -0400
Received: from relay.parallels.com ([195.214.232.42]:46418 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3KAObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:31:45 -0400
Subject: [PATCH] mm: add strictlimit knob
To: karl.kiniger@med.ge.com
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, t.artem@lycos.com,
        linux-mm@kvack.org, mgorman@suse.de, tytso@mit.edu,
        akpm@linux-foundation.org, fengguang.wu@intel.com,
        torvalds@linux-foundation.org, mpatlasov@parallels.com
Date: Fri, 01 Nov 2013 18:31:40 +0400
Message-ID: <20131101142941.1161.40314.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131031142612.GA28003@kipc2.localdomain>
References: <20131031142612.GA28003@kipc2.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"strictlimit" feature was introduced to enforce per-bdi dirty limits for
FUSE which sets bdi max_ratio to 1% by default:

http://www.http.com//article.gmane.org/gmane.linux.kernel.mm/105809

However the feature can be useful for other relatively slow or untrusted
BDIs like USB flash drives and DVD+RW. The patch adds a knob to enable the
feature:

echo 1 > /sys/class/bdi/X:Y/strictlimit

Being enabled, the feature enforces bdi max_ratio limit even if global (10%)
dirty limit is not reached. Of course, the effect is not visible until
max_ratio is decreased to some reasonable value.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 mm/backing-dev.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

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

