Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3JKKrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:47:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab3JKKoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Prarit Bhargava <prarit@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 090/100] powerpc/vio: Fix modalias_show return values
Date: Fri, 11 Oct 2013 11:42:00 +0100
Message-Id: <1381488130-30235-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit e82b89a6f19bae73fb064d1b3dd91fcefbb478f4 upstream.

modalias_show() should return an empty string on error, not -ENODEV.

This causes the following false and annoying error:

> find /sys/devices -name modalias -print0 | xargs -0 cat >/dev/null
cat: /sys/devices/vio/4000/modalias: No such device
cat: /sys/devices/vio/4001/modalias: No such device
cat: /sys/devices/vio/4002/modalias: No such device
cat: /sys/devices/vio/4004/modalias: No such device
cat: /sys/devices/vio/modalias: No such device

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/vio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index cb87301..b161bae 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1520,11 +1520,15 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 	const char *cp;
 
 	dn = dev->of_node;
-	if (!dn)
-		return -ENODEV;
+	if (!dn) {
+		strcat(buf, "\n");
+		return strlen(buf);
+	}
 	cp = of_get_property(dn, "compatible", NULL);
-	if (!cp)
-		return -ENODEV;
+	if (!cp) {
+		strcat(buf, "\n");
+		return strlen(buf);
+	}
 
 	return sprintf(buf, "vio:T%sS%s\n", vio_dev->type, cp);
 }
-- 
1.8.3.2

