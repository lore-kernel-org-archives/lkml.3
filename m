Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3L2Cy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:54:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55144 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987Ab3L2CKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:07 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Prarit Bhargava" <prarit@redhat.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.151716239@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 017/185] powerpc/vio: Fix modalias_show return values
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/vio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1351,11 +1351,15 @@ static ssize_t modalias_show(struct devi
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

