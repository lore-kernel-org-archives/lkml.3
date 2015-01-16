Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbbAPPk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:40:29 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:52238 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbbAPPk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:40:27 -0500
MIME-Version: 1.0
In-Reply-To: <20150114163905.1c0cf7d1@linux.lan.towertech.it>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-4-git-send-email-xlpang@126.com>
	<20150113171904.6b2327d5@linux.lan.towertech.it>
	<CADcy93WPZCmPLUsa9kmz6GtD7E3+8td1PJteJxnZi0R2mLAYKw@mail.gmail.com>
	<20150114160308.08a7f45b@linux.lan.towertech.it>
	<CADcy93Vo6BoU6noPHXRCy7nYtW3q9DUZFXO4v9LE+iMn=Kk4cw@mail.gmail.com>
	<20150114163905.1c0cf7d1@linux.lan.towertech.it>
Date: Fri, 16 Jan 2015 23:40:26 +0800
Message-ID: <CADcy93V3C8h5RBnZGThJ7cjBJ6pf1vR4HH8bzSPXTqpUe9npXQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/9] rtc/test: Update driver to address y2038/y2106 issues
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Xunlei Pang <xlpang@126.com>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2015 at 23:39, Alessandro Zummo <a.zummo@towertech.it> wrote:
> On Wed, 14 Jan 2015 23:26:37 +0800
> Xunlei Pang <pang.xunlei@linaro.org> wrote:
>
>> But on the other hand, we will have no test for  set_mmss64(),
>> because adding the set_mmss64() will make set_mmss() dysfunctional.
>
>  add a module parameter

Hi Alessandro,

Thanks for your advice, how about the following one?

---
 drivers/rtc/rtc-test.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 8f86fa9..3a2da4c 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -13,6 +13,10 @@
 #include <linux/rtc.h>
 #include <linux/platform_device.h>

+static int test_mmss64;
+module_param(test_mmss64, int, 0644);
+MODULE_PARM_DESC(test_mmss64, "Test struct rtc_class_ops.set_mmss64().");
+
 static struct platform_device *test0 = NULL, *test1 = NULL;

 static int test_rtc_read_alarm(struct device *dev,
@@ -30,7 +34,13 @@ static int test_rtc_set_alarm(struct device *dev,
 static int test_rtc_read_time(struct device *dev,
  struct rtc_time *tm)
 {
- rtc_time_to_tm(get_seconds(), tm);
+ rtc_time64_to_tm(ktime_get_real_seconds(), tm);
+ return 0;
+}
+
+static int test_rtc_set_mmss64(struct device *dev, time64_t secs)
+{
+ dev_info(dev, "%s, secs = %lld\n", __func__, (long long)secs);
  return 0;
 }

@@ -55,7 +65,7 @@ static int test_rtc_alarm_irq_enable(struct device
*dev, unsigned int enable)
  return 0;
 }

-static const struct rtc_class_ops test_rtc_ops = {
+static struct rtc_class_ops test_rtc_ops = {
  .proc = test_rtc_proc,
  .read_time = test_rtc_read_time,
  .read_alarm = test_rtc_read_alarm,
@@ -101,6 +111,11 @@ static int test_probe(struct platform_device *plat_dev)
  int err;
  struct rtc_device *rtc;

+ if (test_mmss64) {
+ test_rtc_ops.set_mmss64 = test_rtc_set_mmss64;
+ test_rtc_ops.set_mmss = NULL;
+ }
+
  rtc = devm_rtc_device_register(&plat_dev->dev, "test",
  &test_rtc_ops, THIS_MODULE);
  if (IS_ERR(rtc)) {
