Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbaHHVEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:04:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41344 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691AbaHHUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 128/259] iio:core: Handle error when mask type is not separate
Date: Fri,  8 Aug 2014 13:39:11 -0700
Message-Id: <1407530482-4483-129-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 78b3321610bf920d7fceb1a0236faa881be0bcf3 upstream.

When event spec is shared by multiple channels, which has definition
for mask_shared_by_type, iio_device_register_eventset fails.

For example:
static const struct iio_event_spec iio_dummy_events[] = {
	{
		.type = IIO_EV_TYPE_THRESH,
		.dir = IIO_EV_DIR_RISING,
		.mask_separate = BIT(IIO_EV_INFO_ENABLE),
		.mask_shared_by_type = BIT(IIO_EV_INFO_VALUE),
	}, {
		.type = IIO_EV_TYPE_THRESH,
		.dir = IIO_EV_DIR_FALLING,
		.mask_separate = BIT(IIO_EV_INFO_ENABLE),a
		.mask_shared_by_type = BIT(IIO_EV_INFO_VALUE),
	}
};

If two channels use this event spec, this will result in error.

This change handles EBUSY error similar to iio_device_add_info_mask_type().

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/industrialio-event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index c10eab6..c531839 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -362,6 +362,9 @@ static int iio_device_add_event(struct iio_dev *indio_dev,
 			&indio_dev->event_interface->dev_attr_list);
 		kfree(postfix);
 
+		if ((ret == -EBUSY) && (shared_by != IIO_SEPARATE))
+			continue;
+
 		if (ret)
 			return ret;
 
-- 
1.9.1

