Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaHVUmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:42:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaHVUmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:42:06 -0400
Date: Fri, 22 Aug 2014 13:42:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: y@samsung.com
Cc: a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCHv2 1/5] rtc: s3c: Define s3c_rtc structure to remove
 global variables.
Message-Id: <20140822134204.1fa5be7aeb76a50b45ccc5f5@linux-foundation.org>
In-Reply-To: <1407808871-6046-2-git-send-email-y@samsung.com>
References: <y@samsung.com>
	<1407808871-6046-1-git-send-email-y@samsung.com>
	<1407808871-6046-2-git-send-email-y@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014 11:01:07 +0900 y@samsung.com wrote:

> This patch define s3c_rtc structure including necessary variables for S3C RTC
> device instead of global variables. This patch improves the readability by
> removing global variables.

Below is the v1->v2 delta.

Why were all those tests of info->base added?  Can it really be zero? 
I don't see how.

--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables-v2
+++ a/drivers/rtc/rtc-s3c.c
@@ -121,6 +121,9 @@ static int s3c_rtc_setaie(struct device
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int tmp;
 
+	if (!info->base)
+		return -EINVAL;
+
 	dev_dbg(info->dev, "%s: aie=%d\n", __func__, enabled);
 
 	clk_enable(info->rtc_clk);
@@ -180,6 +183,9 @@ static int s3c_rtc_gettime(struct device
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int have_retried = 0;
 
+	if (!info->base)
+		return -EINVAL;
+
 	clk_enable(info->rtc_clk);
  retry_get_time:
 	rtc_tm->tm_min  = readb(info->base + S3C2410_RTCMIN);
@@ -224,6 +230,9 @@ static int s3c_rtc_settime(struct device
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 	int year = tm->tm_year - 100;
 
+	if (!info->base)
+		return -EINVAL;
+
 	dev_dbg(dev, "set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -255,6 +264,9 @@ static int s3c_rtc_getalarm(struct devic
 	struct rtc_time *alm_tm = &alrm->time;
 	unsigned int alm_en;
 
+	if (!info->base)
+		return -EINVAL;
+
 	clk_enable(info->rtc_clk);
 	alm_tm->tm_sec  = readb(info->base + S3C2410_ALMSEC);
 	alm_tm->tm_min  = readb(info->base + S3C2410_ALMMIN);
@@ -317,6 +329,9 @@ static int s3c_rtc_setalarm(struct devic
 	struct rtc_time *tm = &alrm->time;
 	unsigned int alrm_en;
 
+	if (!info->base)
+		return -EINVAL;
+
 	clk_enable(info->rtc_clk);
 	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
@@ -357,6 +372,9 @@ static int s3c_rtc_proc(struct device *d
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int ticnt;
 
+	if (!info->base)
+		return -EINVAL;
+
 	clk_enable(info->rtc_clk);
 	if (info->cpu_type == TYPE_S3C64XX) {
 		ticnt = readw(info->base + S3C2410_RTCCON);
@@ -548,7 +566,7 @@ static int s3c_rtc_probe(struct platform
 		rtc_tm.tm_min	= 0;
 		rtc_tm.tm_sec	= 0;
 
-		s3c_rtc_settime(NULL, &rtc_tm);
+		s3c_rtc_settime(&pdev->dev, &rtc_tm);
 
 		dev_warn(&pdev->dev, "warning: invalid RTC value so initializing it\n");
 	}
_

