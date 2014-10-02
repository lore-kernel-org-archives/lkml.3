Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaJBNiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:38:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:3775 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbaJBNiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:38:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="599806674"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel.baluta@intel.com, irina.tirdea@intel.com
Subject: [RFC PATCH 7/8] iio: dummy: Demonstrate the usage of activity channel
Date: Thu,  2 Oct 2014 16:43:58 +0300
Message-Id: <1412257439-15683-8-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the activity channel in the dummy driver:
- a new channel IIO_ACTIVITY
- support for reading and writing pedometer step counter
- step detect event
- motion detect event

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/staging/iio/iio_simple_dummy.c        | 87 ++++++++++++++++++++++++---
 drivers/staging/iio/iio_simple_dummy.h        |  2 +
 drivers/staging/iio/iio_simple_dummy_events.c | 14 +++++
 3 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/iio/iio_simple_dummy.c b/drivers/staging/iio/iio_simple_dummy.c
index bf78e6f..b3becee 100644
--- a/drivers/staging/iio/iio_simple_dummy.c
+++ b/drivers/staging/iio/iio_simple_dummy.c
@@ -69,6 +69,20 @@ static const struct iio_event_spec iio_dummy_event = {
 	.mask_separate = BIT(IIO_EV_INFO_VALUE) | BIT(IIO_EV_INFO_ENABLE),
 };
 
+/*
+ * simple activity events:
+ * motion: triggered when an activity (walking, running, etc.) is detected
+ * step detect: triggered when a step is detected
+ */
+static const struct iio_event_spec activity_events[] = {
+	{
+		.type = IIO_EV_TYPE_MOTION,
+		.mask_separate = BIT(IIO_EV_INFO_ENABLE),
+	}, {
+		.type = IIO_EV_TYPE_STEP_DETECT,
+		.mask_separate = BIT(IIO_EV_INFO_ENABLE),
+	},
+};
 #endif
 
 /*
@@ -215,6 +229,20 @@ static const struct iio_chan_spec iio_dummy_channels[] = {
 		.indexed = 1,
 		.channel = 0,
 	},
+	{
+		.type = IIO_ACTIVITY,
+		.modified = 1,
+		.channel2 = IIO_MOD_PED_STEPS,
+		.info_mask_shared_by_type =  BIT(IIO_CHAN_INFO_ENABLE),
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
+	},
+#ifdef CONFIG_IIO_SIMPLE_DUMMY_EVENTS
+	{
+		.type = IIO_ACTIVITY,
+		.event_spec = activity_events,
+		.num_event_specs = ARRAY_SIZE(activity_events),
+	},
+#endif /* CONFIG_IIO_SIMPLE_DUMMY_EVENTS */
 };
 
 /**
@@ -259,6 +287,14 @@ static int iio_dummy_read_raw(struct iio_dev *indio_dev,
 			*val = st->accel_val;
 			ret = IIO_VAL_INT;
 			break;
+		case IIO_ACTIVITY:
+			switch (chan->channel2) {
+			case IIO_MOD_PED_STEPS:
+				*val = st->ped_steps;
+				ret = IIO_VAL_INT;
+				break;
+			}
+			break;
 		default:
 			break;
 		}
@@ -298,6 +334,16 @@ static int iio_dummy_read_raw(struct iio_dev *indio_dev,
 		*val2 = 33;
 		ret = IIO_VAL_INT_PLUS_NANO;
 		break;
+	case IIO_CHAN_INFO_ENABLE:
+		switch (chan->type) {
+		case IIO_ACTIVITY:
+			*val = st->ped_enabled;
+			ret = IIO_VAL_INT;
+			break;
+		default:
+			break;
+		}
+		break;
 	default:
 		break;
 	}
@@ -330,14 +376,29 @@ static int iio_dummy_write_raw(struct iio_dev *indio_dev,
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		if (chan->output == 0)
+		switch (chan->type) {
+		case IIO_VOLTAGE:
+			if (chan->output == 0)
+				return -EINVAL;
+
+			/* Locking not required as writing single value */
+			mutex_lock(&st->lock);
+			st->dac_val = val;
+			mutex_unlock(&st->lock);
+			return 0;
+		case IIO_ACTIVITY:
+			switch (chan->channel2) {
+			case IIO_MOD_PED_STEPS:
+				mutex_lock(&st->lock);
+				st->ped_steps = val;
+				mutex_unlock(&st->lock);
+				return 0;
+			default:
+				return -EINVAL;
+			}
+		default:
 			return -EINVAL;
-
-		/* Locking not required as writing single value */
-		mutex_lock(&st->lock);
-		st->dac_val = val;
-		mutex_unlock(&st->lock);
-		return 0;
+		}
 	case IIO_CHAN_INFO_CALIBSCALE:
 		mutex_lock(&st->lock);
 		/* Compare against table - hard matching here */
@@ -356,7 +417,16 @@ static int iio_dummy_write_raw(struct iio_dev *indio_dev,
 		st->accel_calibbias = val;
 		mutex_unlock(&st->lock);
 		return 0;
-
+	case IIO_CHAN_INFO_ENABLE:
+		switch (chan->type) {
+		case IIO_ACTIVITY:
+			mutex_lock(&st->lock);
+			st->ped_enabled = val;
+			mutex_unlock(&st->lock);
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	default:
 		return -EINVAL;
 	}
@@ -395,6 +465,7 @@ static int iio_dummy_init_device(struct iio_dev *indio_dev)
 	st->accel_val = 34;
 	st->accel_calibbias = -7;
 	st->accel_calibscale = &dummy_scales[0];
+	st->ped_steps = 47;
 
 	return 0;
 }
diff --git a/drivers/staging/iio/iio_simple_dummy.h b/drivers/staging/iio/iio_simple_dummy.h
index 1a74e26..1996e3f 100644
--- a/drivers/staging/iio/iio_simple_dummy.h
+++ b/drivers/staging/iio/iio_simple_dummy.h
@@ -34,6 +34,8 @@ struct iio_dummy_state {
 	int accel_calibbias;
 	const struct iio_dummy_accel_calibscale *accel_calibscale;
 	struct mutex lock;
+	int ped_enabled;
+	int ped_steps;
 	struct iio_dummy_regs *regs;
 #ifdef CONFIG_IIO_SIMPLE_DUMMY_EVENTS
 	int event_irq;
diff --git a/drivers/staging/iio/iio_simple_dummy_events.c b/drivers/staging/iio/iio_simple_dummy_events.c
index 719dfa5..94de22a 100644
--- a/drivers/staging/iio/iio_simple_dummy_events.c
+++ b/drivers/staging/iio/iio_simple_dummy_events.c
@@ -161,6 +161,20 @@ static irqreturn_t iio_simple_dummy_event_handler(int irq, void *private)
 					      IIO_EV_TYPE_THRESH, 0, 0, 0),
 			       iio_get_time_ns());
 		break;
+	case 1:
+		iio_push_event(indio_dev,
+			       IIO_EVENT_CODE(IIO_ACTIVITY, 0, IIO_MOD_RUNNING,
+					      IIO_EV_DIR_RISING,
+					      IIO_EV_TYPE_MOTION, 0, 0, 0),
+			       iio_get_time_ns());
+		break;
+	case 2:
+		iio_push_event(indio_dev,
+			       IIO_EVENT_CODE(IIO_ACTIVITY, 0, IIO_NO_MOD,
+					      IIO_EV_DIR_EITHER,
+					      IIO_EV_TYPE_STEP_DETECT, 0, 0, 0),
+			       iio_get_time_ns());
+		break;
 	default:
 		break;
 	}
-- 
1.9.1

