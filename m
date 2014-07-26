Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaGZTmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:42:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaGZTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.15 014/109] iio:core: Handle error when mask type is not separate
Date: Sat, 26 Jul 2014 12:01:36 -0700
Message-Id: <20140726190224.260014820@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/industrialio-event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -341,6 +341,9 @@ static int iio_device_add_event(struct i
 			&indio_dev->event_interface->dev_attr_list);
 		kfree(postfix);
 
+		if ((ret == -EBUSY) && (shared_by != IIO_SEPARATE))
+			continue;
+
 		if (ret)
 			return ret;
 


