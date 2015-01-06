Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbbAFVRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:17:44 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:55787 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbAFVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:17:43 -0500
Date: Tue, 6 Jan 2015 22:17:32 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Tristan Lelong <tristan@lelong.xyz>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add soft kill switch for input devices
Message-ID: <20150106221732.1cbbe3ae@neptune.home>
In-Reply-To: <1420352645-3706-1-git-send-email-tristan@lelong.xyz>
References: <1420352645-3706-1-git-send-email-tristan@lelong.xyz>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 January 2015 Tristan Lelong <tristan@lelong.xyz> wrote:
> This adds a sysfs attribute named 'mute' to all input devices.
> It allows to disable them by software in a generic way.
> 
> It can be set to 0 or 1:
> echo 1 > /sys/class/input/inputX/mute: will set all the input_events() call to return immediately.
> echo 0 > /sys/class/input/inputX/mute: will reset to default behavior.
> 
> mute is set to 0 by default when calling alloc_input_device().
> 
> Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
> ---
> Hi,
> 
> I created this patch to answer a need on my machine: I want to be able to disable momentarily the touchscreen
> in order to wipe out a dust or clean the display without creating a mess on my desktop and opened docs.
> It seemed consistent to have that kill switch at a central point, and moreover,
> it doesn't depend on any tool linked to a specifc X server, graphical toolkit, desktop environment...
> 
> This patch uses the 0/1 values to enable or disable the mute, but I could update it to use
> enable/disable instead if it is preferred.
> Also, the permissions are write for group or ownoer only.
> I thought about setting it world writable in order to allow easy shortcut creation, but it might also be a security flaw.
> 
> Let me know what you think about all this, at least it is really useful in my case, linked to a keyboard shortcut.
> 
> Best regards
> ---
>  drivers/input/input.c | 30 +++++++++++++++++++++++++++++-
>  include/linux/input.h |  1 +
>  2 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index a1e609a..2f80fee 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -425,7 +425,7 @@ void input_event(struct input_dev *dev,
>  {
>  	unsigned long flags;
>  
> -	if (is_event_supported(type, dev->evbit, EV_MAX)) {
> +	if (!dev->mute && is_event_supported(type, dev->evbit, EV_MAX)) {
>  
>  		spin_lock_irqsave(&dev->event_lock, flags);
>  		input_handle_event(dev, type, code, value);
> @@ -1384,10 +1384,38 @@ static ssize_t input_dev_show_properties(struct device *dev,
> <snip>

One big issue I see here is that you start dropping all events at a random
point in time.
You may end up within a gesture or just while a button is down and remain
so until that same button gets pressed again on unmute.

On your touchscreen, how do things behave if you trigger the muting while
you are dragging or doing some gesture (and unmute when noone touches
the touchscreen)?

If applied to a keyboard, what happens when you mute while keys are pressed
and unmute when they have long been released?


If you could send a "reset" event to input listeners when muting you could
work around most issues as any application making use of events would know
that after this "reset" event things should not depend on any past state.


Possibly a better way to achieve your aim is to just unbind and re-bind
the device from device driver, causing software hotplug.
That way you are sure no application will perform incorrect guesses while
device is "muted".

Bruno
