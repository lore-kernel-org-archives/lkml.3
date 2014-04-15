Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaDOSR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:17:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:36497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbaDOSRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,865,1389772800"; 
   d="scan'208";a="493683472"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [Patch v6 3/6] IIO: core: Modify scan element type
Date: Tue, 15 Apr 2014 11:21:10 -0700
Message-Id: <1397586073-31507-4-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1397586073-31507-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1397586073-31507-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current scan element type uses the following format:
  [be|le]:[s|u]bits/storagebits[>>shift].
To specify multiple elements in this type, added a repeat value.
So new format is:
  [be|le]:[s|u]bits/storagebits{X[repeat]}[>>shift].
Here X is specifying how may times, real/storage bits are repeating.

When X is value is 0 or 1, then repeat value is not used in the format,
and it will be same as existing format.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/industrialio-buffer.c | 41 +++++++++++++++++++++++++++++++++------
 include/linux/iio/iio.h           |  7 +++++++
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index e108f2a..aa90c68 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -150,7 +150,16 @@ static ssize_t iio_show_fixed_type(struct device *dev,
 		type = IIO_BE;
 #endif
 	}
-	return sprintf(buf, "%s:%c%d/%d>>%u\n",
+	if (this_attr->c->scan_type.repeat > 1)
+		return sprintf(buf, "%s:%c%d/%d{%d[repeat]}>>%u\n",
+		       iio_endian_prefix[type],
+		       this_attr->c->scan_type.sign,
+		       this_attr->c->scan_type.realbits,
+		       this_attr->c->scan_type.storagebits,
+		       this_attr->c->scan_type.repeat,
+		       this_attr->c->scan_type.shift);
+		else
+			return sprintf(buf, "%s:%c%d/%d>>%u\n",
 		       iio_endian_prefix[type],
 		       this_attr->c->scan_type.sign,
 		       this_attr->c->scan_type.realbits,
@@ -474,14 +483,22 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
 	for_each_set_bit(i, mask,
 			 indio_dev->masklength) {
 		ch = iio_find_channel_from_si(indio_dev, i);
-		length = ch->scan_type.storagebits / 8;
+		if (ch->scan_type.repeat > 1)
+			length = ch->scan_type.storagebits / 8 *
+				ch->scan_type.repeat;
+		else
+			length = ch->scan_type.storagebits / 8;
 		bytes = ALIGN(bytes, length);
 		bytes += length;
 	}
 	if (timestamp) {
 		ch = iio_find_channel_from_si(indio_dev,
 					      indio_dev->scan_index_timestamp);
-		length = ch->scan_type.storagebits / 8;
+		if (ch->scan_type.repeat > 1)
+			length = ch->scan_type.storagebits / 8 *
+				ch->scan_type.repeat;
+		else
+			length = ch->scan_type.storagebits / 8;
 		bytes = ALIGN(bytes, length);
 		bytes += length;
 	}
@@ -957,7 +974,11 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
 					       indio_dev->masklength,
 					       in_ind + 1);
 			ch = iio_find_channel_from_si(indio_dev, in_ind);
-			length = ch->scan_type.storagebits/8;
+			if (ch->scan_type.repeat > 1)
+				length = ch->scan_type.storagebits / 8 *
+					ch->scan_type.repeat;
+			else
+				length = ch->scan_type.storagebits / 8;
 			/* Make sure we are aligned */
 			in_loc += length;
 			if (in_loc % length)
@@ -969,7 +990,11 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
 			goto error_clear_mux_table;
 		}
 		ch = iio_find_channel_from_si(indio_dev, in_ind);
-		length = ch->scan_type.storagebits/8;
+		if (ch->scan_type.repeat > 1)
+			length = ch->scan_type.storagebits / 8 *
+				ch->scan_type.repeat;
+		else
+			length = ch->scan_type.storagebits / 8;
 		if (out_loc % length)
 			out_loc += length - out_loc % length;
 		if (in_loc % length)
@@ -990,7 +1015,11 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
 		}
 		ch = iio_find_channel_from_si(indio_dev,
 			indio_dev->scan_index_timestamp);
-		length = ch->scan_type.storagebits/8;
+		if (ch->scan_type.repeat > 1)
+			length = ch->scan_type.storagebits / 8 *
+				ch->scan_type.repeat;
+		else
+			length = ch->scan_type.storagebits / 8;
 		if (out_loc % length)
 			out_loc += length - out_loc % length;
 		if (in_loc % length)
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 5629c92..ccde917 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -177,6 +177,12 @@ struct iio_event_spec {
  *			shift:		Shift right by this before masking out
  *					realbits.
  *			endianness:	little or big endian
+ *			repeat:		Number of times real/storage bits
+ *					repeats. When the repeat element is
+ *					more than 1, then the type element in
+ *					sysfs will show a repeat value.
+ *					Otherwise, the number of repetitions is
+ *					omitted.
  * @info_mask_separate: What information is to be exported that is specific to
  *			this channel.
  * @info_mask_shared_by_type: What information is to be exported that is shared
@@ -219,6 +225,7 @@ struct iio_chan_spec {
 		u8	realbits;
 		u8	storagebits;
 		u8	shift;
+		u8	repeat;
 		enum iio_endian endianness;
 	} scan_type;
 	long			info_mask_separate;
-- 
1.7.11.7

