Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaG0LtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 07:49:00 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52010 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaG0Ls6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 07:48:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390: net: claw.c:  Fix a define larger than in a sizeof in conjunction with strncpy
Date: Sun, 27 Jul 2014 13:50:22 +0200
Message-Id: <1406461822-11249-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406461822-11249-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406461822-11249-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX_NAME_LEN is larger than sizeof, which could potentially
giving lots of error here.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/s390/net/claw.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index d837c3c..0172ce8 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -3068,12 +3068,15 @@ claw_hname_write(struct device *dev, struct device_attribute *attr,
 	if (!priv)
 		return -ENODEV;
 	p_env = priv->p_env;
-	if (count > MAX_NAME_LEN+1)
+	if (count >= sizeof(p_env->host_name) && count > 0)
 		return -EINVAL;
-	memset(p_env->host_name, 0x20, MAX_NAME_LEN);
+
 	strncpy(p_env->host_name,buf, count);
-	p_env->host_name[count-1] = 0x20;  /* clear extra 0x0a */
-	p_env->host_name[MAX_NAME_LEN] = 0x00;
+	/* clear extra 0x0a */
+	memset(&p_env->host_name[count - 1],
+			' ', sizeof(p_env->host_name) - count);
+	p_env->host_name[sizeof(p_env->host_name) - 1] = '\0';
+
 	CLAW_DBF_TEXT(2, setup, "HstnSet");
 	CLAW_DBF_TEXT_(2, setup, "%s", p_env->host_name);
 
@@ -3106,12 +3109,14 @@ claw_adname_write(struct device *dev, struct device_attribute *attr,
 	if (!priv)
 		return -ENODEV;
 	p_env = priv->p_env;
-	if (count > MAX_NAME_LEN+1)
+	if (count >= sizeof(p_env->adapter_name) && count > 0)
 		return -EINVAL;
-	memset(p_env->adapter_name, 0x20, MAX_NAME_LEN);
+
 	strncpy(p_env->adapter_name,buf, count);
-	p_env->adapter_name[count-1] = 0x20; /* clear extra 0x0a */
-	p_env->adapter_name[MAX_NAME_LEN] = 0x00;
+	/* clear extra 0x0a */
+	memset(&p_env->adapter_name[count - 1],
+			' ', sizeof(p_env->adapter_name) - count);
+	p_env->adapter_name[sizeof(p_env->adapter_name) - 1] = '\0';
 	CLAW_DBF_TEXT(2, setup, "AdnSet");
 	CLAW_DBF_TEXT_(2, setup, "%s", p_env->adapter_name);
 
@@ -3145,12 +3150,14 @@ claw_apname_write(struct device *dev, struct device_attribute *attr,
 	if (!priv)
 		return -ENODEV;
 	p_env = priv->p_env;
-	if (count > MAX_NAME_LEN+1)
+	if (count >= sizeof(p_env->api_type) && count > 0)
 		return -EINVAL;
-	memset(p_env->api_type, 0x20, MAX_NAME_LEN);
+
 	strncpy(p_env->api_type,buf, count);
-	p_env->api_type[count-1] = 0x20;  /* we get a loose 0x0a */
-	p_env->api_type[MAX_NAME_LEN] = 0x00;
+	/* we get a loose 0x0a */
+	memset(&p_env->api_type[count - 1],
+			' ', sizeof(p_env->api_type) - count);
+	p_env->api_type[sizeof(p_env->api_type) - 1] = '\0';
 	if(strncmp(p_env->api_type,WS_APPL_NAME_PACKED,6) == 0) {
 		p_env->read_size=DEF_PACK_BUFSIZE;
 		p_env->write_size=DEF_PACK_BUFSIZE;
-- 
1.7.10.4

