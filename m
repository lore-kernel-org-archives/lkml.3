Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaCaJh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:37:58 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34357 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753740AbaCaJhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:37:55 -0400
Date: Mon, 31 Mar 2014 12:37:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC 4/8] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20140331093721.GC4522@valkosipuli.retiisi.org.uk>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-5-git-send-email-j.anaszewski@samsung.com>
 <20140324000834.GC2054@valkosipuli.retiisi.org.uk>
 <533595A9.8000904@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533595A9.8000904@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi jacek,

On Fri, Mar 28, 2014 at 04:30:49PM +0100, Jacek Anaszewski wrote:
...
> >>+static int v4l2_flash_set_intensity(struct v4l2_flash *flash,
> >>+				    unsigned int intensity)
> >>+{
> >>+	struct led_classdev *led_cdev = flash->led_cdev;
> >>+	unsigned int fault;
> >>+	int ret;
> >>+
> >>+	ret = led_get_flash_fault(led_cdev, &fault);
> >>+	if (ret < 0 || fault)
> >>+		return -EINVAL;
> >
> >Is it meaningful to check the faults here?
> >
> >The existing flash controller drivers mostly do not. The responsibility is
> >left to the user --- something the user should probably do after the strobe
> >has expectedly finished. This isn't particularly very well documented in the
> >spec, though.
> 
> I was influenced by the documentation which says that sometimes strobing
> the flash may not be possible due to faults. But I agree that checking
> the faults should be user's responsibility.

What that means is that the presence of the fault *on the chip* may limit
the device's willingness to actually strobe. The driver does not need to
enforce it; the chip does.

> >Also, the presence of every fault does not prevent using the flash.
> >
> >>+	led_set_brightness(led_cdev, intensity);
> >
> >Where do you convert between the LED framework brightness and the value used
> >by the V4L2 controls?
> 
> I think that there is no need for conversion. AFAIK the LED subsystem
> doesn't specify units of the brightness. It specifies LED_FULL enum
> value but not all LED drivers stick to it. Moreover it limits
> brightness resolution to 256 levels.

The V4L2 control's unit is mA. Does this mean that the unit in the LED API
also becomes mA then?

> >>+
> >>+	return ret;
> >>+}
> >>+
> >>+static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
> >>+{
> >>+	struct v4l2_flash *flash = ctrl_to_flash(c);
> >>+	struct led_classdev *led_cdev = flash->led_cdev;
> >>+	int ret = 0;
> >>+
> >>+	switch (c->id) {
> >>+	case V4L2_CID_FLASH_LED_MODE:
> >>+		switch (c->val) {
> >>+		case V4L2_FLASH_LED_MODE_NONE:
> >>+			/* clear flash mode on releae */
> >
> >It's not uncommon for the user to leave the mode to something else than none
> >when the user goes away. Could there be other ways to mediate access?
> 
> IMHO user space application should release the mode on exit as any other
> resource it acquires. However if it is terminated unexpectedly

The application's resources are released by the kernel when the application
exists but V4L2 control's don't behave that way.

> the sysfs will remain locked forever. Maybe a dedicated sysfs
> attribute should be provided in the LED subsystem for controlling the
> sysfs lock state? It would have to be always available for the user
> though.

How about using the information on open file handles to the flash sub-device
instead? If someone holds a file handle there, sure then the device is in
use by that program? The advantage compared to the control value is that the
file handles are released when the application quits whether or not any
cleanup is performed by the application. I don't immediately see other
reasons to keep a file handle to a V4L2 flash sub-device open, except, well,
to find about its capabilities.

> >>+static int v4l2_flash_init_controls(struct v4l2_flash *flash,
> >>+				struct v4l2_flash_ctrl_config *config)
> >>+
> >>+{
> >>+	unsigned int mask;
> >>+	struct v4l2_ctrl *ctrl;
> >>+	struct v4l2_ctrl_config *ctrl_cfg;
> >>+	bool has_flash = config->flags & V4L2_FLASH_CFG_LED_FLASH;
> >>+	bool has_torch = config->flags & V4L2_FLASH_CFG_LED_TORCH;
> >>+	int ret, num_ctrls;
> >>+
> >>+	if (!has_flash && !has_torch)
> >>+		return -EINVAL;
> >>+
> >>+	num_ctrls = has_flash ? 8 : 2;
> >>+	if (config->flags & V4L2_FLASH_CFG_FAULTS_MASK)
> >>+		++num_ctrls;
> >>+
> >>+	v4l2_ctrl_handler_init(&flash->hdl, num_ctrls);
> >>+
> >>+	mask = 1 << V4L2_FLASH_LED_MODE_NONE;
> >>+	if (has_flash)
> >>+		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
> >>+	if (has_torch)
> >>+		mask |= 1 << V4L2_FLASH_LED_MODE_TORCH;
> >
> >I don't expect to see this on LED flash devices. :-)
> 
> I don't get your point here. Could you be more specific? :)
> Torch only mode is supported by V4L2_CID_FLASH_LED_MODE control,
> isn't it?

Have you seen a LED flash controller which does not implement the torch
mode?

I have no objections to keeping the check though, but there were more
important things missing at the time.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
