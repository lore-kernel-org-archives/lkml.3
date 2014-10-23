Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaJWMsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:48:12 -0400
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:36234 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323AbaJWMsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:48:08 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: introduce some sample size manipulation functions
Date: Thu, 23 Oct 2014 13:47:51 +0100
Message-Id: <1414068471-25575-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a few static inline helper functions:

`comedi_bytes_per_sample(s)` is the same as the existing
`bytes_per_sample(s)` and determines the size of a comedi sample in
bytes.  (`bytes_per_sample(s)` will be removed.)

`comedi_sample_shift(s)` determines the log2 of the comedi sample size,
so it can be used in bit-shift operations to multiply or divide by the
sample size.

`comedi_bytes_to_samples(s, nbytes)` converts a number of bytes to a
number of samples (rounding down).

`comedi_samples_to_bytes(s, nsamples)` converts a number of samples to a
number of bytes.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h | 63 +++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 1b2bbd5..69cf6fe 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -391,12 +391,67 @@ static inline unsigned int comedi_offset_munge(struct comedi_subdevice *s,
 	return val ^ s->maxdata ^ (s->maxdata >> 1);
 }
 
-static inline unsigned int bytes_per_sample(const struct comedi_subdevice *subd)
+/**
+ * comedi_bytes_per_sample - determine subdevice sample size
+ * @s:		comedi_subdevice struct
+ *
+ * The sample size will be 4 (sizeof int) or 2 (sizeof short) depending on
+ * whether the SDF_LSAMPL subdevice flag is set or not.
+ *
+ * Returns the subdevice sample size.
+ */
+static inline unsigned int comedi_bytes_per_sample(struct comedi_subdevice *s)
 {
-	if (subd->subdev_flags & SDF_LSAMPL)
-		return sizeof(unsigned int);
+	return s->subdev_flags & SDF_LSAMPL ? sizeof(int) : sizeof(short);
+}
 
-	return sizeof(short);
+/* to be removed */
+static inline unsigned int bytes_per_sample(struct comedi_subdevice *s)
+{
+	return comedi_bytes_per_sample(s);
+}
+
+/**
+ * comedi_sample_shift - determine log2 of subdevice sample size
+ * @s:		comedi_subdevice struct
+ *
+ * The sample size will be 4 (sizeof int) or 2 (sizeof short) depending on
+ * whether the SDF_LSAMPL subdevice flag is set or not.  The log2 of the
+ * sample size will be 2 or 1 and can be used as the right operand of a
+ * bit-shift operator to multiply or divide something by the sample size.
+ *
+ * Returns log2 of the subdevice sample size.
+ */
+static inline unsigned int comedi_sample_shift(struct comedi_subdevice *s)
+{
+	return s->subdev_flags & SDF_LSAMPL ? 2 : 1;
+}
+
+/**
+ * comedi_bytes_to_samples - converts a number of bytes to a number of samples
+ * @s:		comedi_subdevice struct
+ * @nbytes:	number of bytes
+ *
+ * Returns the number of bytes divided by the subdevice sample size.
+ */
+static inline unsigned int comedi_bytes_to_samples(struct comedi_subdevice *s,
+						   unsigned int nbytes)
+{
+	return nbytes >> comedi_sample_shift(s);
+}
+
+/**
+ * comedi_samples_to_bytes - converts a number of samples to a number of bytes
+ * @s:		comedi_subdevice struct
+ * @nsamples:	number of samples
+ *
+ * Returns the number of samples multiplied by the subdevice sample size.
+ * Does not check for arithmetic overflow.
+ */
+static inline unsigned int comedi_samples_to_bytes(struct comedi_subdevice *s,
+						   unsigned int nsamples)
+{
+	return nsamples << comedi_sample_shift(s);
 }
 
 /*
-- 
2.1.1

