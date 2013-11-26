Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3KZCOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:14:25 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49230 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3KZCOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:14:23 -0500
Date: Mon, 25 Nov 2013 18:14:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Julian Shandorov <jshandorov@gmail.com>,
        Aleksej Makarov <aleksej.makarov@sonymobile.com>
Subject: Re: [PATCH v2] input: don't call input_dev_release_keys() in resume
Message-ID: <20131126021415.GB31517@core.coreip.homeip.net>
References: <1385126824-20446-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385126824-20446-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

On Fri, Nov 22, 2013 at 02:27:04PM +0100, Oskar Andero wrote:
> From: Aleksej Makarov <aleksej.makarov@sonymobile.com>
> 
> When waking up the platform by pressing a specific key, sending a
> release on that key makes it impossible to react on the event in
> user-space. This is fixed by moving the input_reset_device() call to
> resume instead.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: Aleksej Makarov <aleksej.makarov@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  drivers/input/input.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 846ccdd..511d490 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -1676,22 +1676,13 @@ static int input_dev_suspend(struct device *dev)
>  {
>  	struct input_dev *input_dev = to_input_dev(dev);
>  
> -	mutex_lock(&input_dev->mutex);
> -
> -	if (input_dev->users)
> -		input_dev_toggle(input_dev, false);
> -
> -	mutex_unlock(&input_dev->mutex);
> +	input_reset_device(input_dev);
>  
>  	return 0;
>  }
>  
>  static int input_dev_resume(struct device *dev)
>  {
> -	struct input_dev *input_dev = to_input_dev(dev);
> -
> -	input_reset_device(input_dev);

We still need to restore LED state after resume. Does the patch below
work for you?

Thanks.

-- 
Dmitry


Input: don't call input_dev_release_keys() in resume

From: Aleksej Makarov <aleksej.makarov@sonymobile.com>

When waking up the platform by pressing a specific key, sending a
release on that key makes it impossible to react on the event in
user-space. This is fixed by moving the input_reset_device() call to
resume instead.

[dmitry.torokhov@gmail.com: make sure we still restore LED/sound state
after resume, handle hibernation properly]

Signed-off-by: Aleksej Makarov <aleksej.makarov@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/input.c |   76 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 57 insertions(+), 19 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 846ccdd..692435a 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1653,35 +1653,36 @@ static void input_dev_toggle(struct input_dev *dev, bool activate)
  */
 void input_reset_device(struct input_dev *dev)
 {
-	mutex_lock(&dev->mutex);
+	unsigned long flags;
 
-	if (dev->users) {
-		input_dev_toggle(dev, true);
+	mutex_lock(&dev->mutex);
+	spin_lock_irqsave(&dev->event_lock, flags);
 
-		/*
-		 * Keys that have been pressed at suspend time are unlikely
-		 * to be still pressed when we resume.
-		 */
-		spin_lock_irq(&dev->event_lock);
-		input_dev_release_keys(dev);
-		spin_unlock_irq(&dev->event_lock);
-	}
+	input_dev_toggle(dev, true);
+	input_dev_release_keys(dev);
 
+	spin_unlock_irqrestore(&dev->event_lock, flags);
 	mutex_unlock(&dev->mutex);
 }
 EXPORT_SYMBOL(input_reset_device);
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int input_dev_suspend(struct device *dev)
 {
 	struct input_dev *input_dev = to_input_dev(dev);
 
-	mutex_lock(&input_dev->mutex);
+	spin_lock_irq(&input_dev->event_lock);
 
-	if (input_dev->users)
-		input_dev_toggle(input_dev, false);
+	/*
+	 * Keys that are pressed now are unlikely to be
+	 * still pressed when we resume.
+	 */
+	input_dev_release_keys(input_dev);
 
-	mutex_unlock(&input_dev->mutex);
+	/* Turn off LEDs and sounds, if any are active. */
+	input_dev_toggle(input_dev, false);
+
+	spin_unlock_irq(&input_dev->event_lock);
 
 	return 0;
 }
@@ -1690,7 +1691,43 @@ static int input_dev_resume(struct device *dev)
 {
 	struct input_dev *input_dev = to_input_dev(dev);
 
-	input_reset_device(input_dev);
+	spin_lock_irq(&input_dev->event_lock);
+
+	/* Restore state of LEDs and sounds, if any were active. */
+	input_dev_toggle(input_dev, true);
+
+	spin_unlock_irq(&input_dev->event_lock);
+
+	return 0;
+}
+
+static int input_dev_freeze(struct device *dev)
+{
+	struct input_dev *input_dev = to_input_dev(dev);
+
+	spin_lock_irq(&input_dev->event_lock);
+
+	/*
+	 * Keys that are pressed now are unlikely to be
+	 * still pressed when we resume.
+	 */
+	input_dev_release_keys(input_dev);
+
+	spin_unlock_irq(&input_dev->event_lock);
+
+	return 0;
+}
+
+static int input_dev_poweroff(struct device *dev)
+{
+	struct input_dev *input_dev = to_input_dev(dev);
+
+	spin_lock_irq(&input_dev->event_lock);
+
+	/* Turn off LEDs and sounds, if any are active. */
+	input_dev_toggle(input_dev, false);
+
+	spin_unlock_irq(&input_dev->event_lock);
 
 	return 0;
 }
@@ -1698,7 +1735,8 @@ static int input_dev_resume(struct device *dev)
 static const struct dev_pm_ops input_dev_pm_ops = {
 	.suspend	= input_dev_suspend,
 	.resume		= input_dev_resume,
-	.poweroff	= input_dev_suspend,
+	.freeze		= input_dev_freeze,
+	.poweroff	= input_dev_poweroff,
 	.restore	= input_dev_resume,
 };
 #endif /* CONFIG_PM */
@@ -1707,7 +1745,7 @@ static struct device_type input_dev_type = {
 	.groups		= input_dev_attr_groups,
 	.release	= input_dev_release,
 	.uevent		= input_dev_uevent,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.pm		= &input_dev_pm_ops,
 #endif
 };
