Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3KZNvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:51:00 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26606 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3KZNut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:50:49 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-a4-5294a7315ef3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 5/5] rtc: s5m: Enable IRQ wake during suspend
Date: Tue, 26 Nov 2013 14:50:28 +0100
Message-id: <1385473828-31078-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
References: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4FV3D5VOCDBasZbJYcvEqu8WzW3uZ
	LF6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF/s4ORovT3awWF1d8YXLg8tgz8SSbx51re9g8
	Dh3uYPSYdzLQo2/LKkaP6fN+Mnl83iQXwB7FZZOSmpNZllqkb5fAlXF63XnWgn/cFV3LLrE1
	MD7n7GLk5JAQMJE4e2AFK4QtJnHh3nq2LkYuDiGBpYwScye+ZIVw+pgkFp5+DlbFJmAssXn5
	ErAqEYGrjBITlyxmB3GYBXYxSrz9uYsRpEpYwFZi+8E97CA2i4CqxPXJx8DivALuEgsa1gPF
	OYD2KUjMmWQDEuYU8JCY2bOMBcQWAio5d3AX0wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS
	9ZLzczcxQoLw6w7GpcesDjEKcDAq8fBKdE4OEmJNLCuuzD3EKMHBrCTCGzt9SpAQb0piZVVq
	UX58UWlOavEhRiYOTqkGxt0Sma63W649OnZykvXmdYmOS42PMVhdbpWXuyEmtT4oYP6n9EP2
	IreuTw8X4AmIX3TG7uiEKyayxbNaU6u2eW17xCxy08bz0P1IPvHjr4xvtou+UHH9dEqytqdN
	9nxt8YwdDF68V7mXx4g1zbvjt5yH+cbk2AVS88/4JLNFOMQmRn6P/tC5UYmlOCPRUIu5qDgR
	AM29tOogAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PM suspend/resume ops to rtc-s5m driver and enable IRQ wake during
suspend so the RTC would act like a wake up source. This allows waking
up from suspend to RAM on RTC alarm interrupt.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s5m.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 51471c1..ae8119d 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -639,6 +639,30 @@ static void s5m_rtc_shutdown(struct platform_device *pdev)
 	s5m_rtc_enable_smpl(info, false);
 }
 
+static int s5m_rtc_resume(struct device *dev)
+{
+	struct s5m_rtc_info *info = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (device_may_wakeup(dev))
+		ret = disable_irq_wake(info->irq);
+
+	return ret;
+}
+
+static int s5m_rtc_suspend(struct device *dev)
+{
+	struct s5m_rtc_info *info = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (device_may_wakeup(dev))
+		ret = enable_irq_wake(info->irq);
+
+	return ret;
+}
+
+static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
+
 static const struct platform_device_id s5m_rtc_id[] = {
 	{ "s5m-rtc", 0 },
 };
@@ -647,6 +671,7 @@ static struct platform_driver s5m_rtc_driver = {
 	.driver		= {
 		.name	= "s5m-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &s5m_rtc_pm_ops,
 	},
 	.probe		= s5m_rtc_probe,
 	.shutdown	= s5m_rtc_shutdown,
-- 
1.7.9.5

