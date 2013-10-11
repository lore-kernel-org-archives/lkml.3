Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3JKTfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:35:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3JKTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:35:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 20/39] powerpc/vio: Fix modalias_show return values
Date: Fri, 11 Oct 2013 12:35:04 -0700
Message-Id: <20131011193213.086472383@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193210.843963685@linuxfoundation.org>
References: <20131011193210.843963685@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/vio.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1345,11 +1345,15 @@ static ssize_t modalias_show(struct devi
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


