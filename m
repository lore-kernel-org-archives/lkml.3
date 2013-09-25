Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab3IYAUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab3IYAUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 075/117] HID: sensor-hub: validate feature report details
Date: Tue, 24 Sep 2013 17:19:01 -0700
Message-Id: <20130925001749.143419456@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 9e8910257397372633e74b333ef891f20c800ee4 upstream.

A HID device could send a malicious feature report that would cause the
sensor-hub HID driver to read past the end of heap allocation, leaking
kernel memory contents to the caller.

CVE-2013-2898

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-sensor-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -221,7 +221,8 @@ int sensor_hub_get_feature(struct hid_se
 
 	mutex_lock(&data->mutex);
 	report = sensor_hub_report(report_id, hsdev->hdev, HID_FEATURE_REPORT);
-	if (!report || (field_index >=  report->maxfield)) {
+	if (!report || (field_index >=  report->maxfield) ||
+	    report->field[field_index]->report_count < 1) {
 		ret = -EINVAL;
 		goto done_proc;
 	}


