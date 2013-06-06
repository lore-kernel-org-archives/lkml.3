Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab3FFMCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:02:51 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64842 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3FFMCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:02:49 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [RFC PATCH v1 4/4] firmware loader: don't allow to request firmware via relative path
Date: Thu,  6 Jun 2013 20:01:50 +0800
Message-Id: <1370520110-32293-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
References: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't a good pratice to request firmware via relative path, also
might have security issue, so don't do it.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 051db83..d381db9 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -356,6 +356,10 @@ static bool fw_get_file_fw_from_paths(const char *paths, char *path,
 		strncpy(path, &paths[start], len);
 		snprintf(&path[len], PATH_MAX - len, "/%s", buf->fw_id);
 
+		/* relative path isn't allowed */
+		if (strstr(path, "../"))
+			continue;
+
 		if (fw_get_file_firmware(path, buf))
 			return true;
 	} while (pos && end < strlen(paths) - 1);
@@ -1031,6 +1035,13 @@ _request_firmware_prepare(struct firmware **firmware_p, const char *name,
 		return 0; /* assigned */
 	}
 
+	/* relative path isn't allowed */
+	if (strstr(name, "../")) {
+		dev_err(device, "%s: relative path isn't allowed\n",
+			name);
+		return -EINVAL;
+	}
+
 	ret = fw_lookup_and_allocate_buf(name, &fw_cache, &buf);
 
 	/*
-- 
1.7.9.5

