Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3IKAOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:14:33 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62441 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3IKAOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:14:31 -0400
Date: Tue, 10 Sep 2013 17:14:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: rydberg@euromail.se, carl@ok-labs.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] uinput: Support injecting multiple events in one
 write() call
Message-ID: <20130911001428.GB5840@core.coreip.homeip.net>
References: <1378855973-11595-1-git-send-email-rmallon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378855973-11595-1-git-send-email-rmallon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On Wed, Sep 11, 2013 at 09:32:52AM +1000, Ryan Mallon wrote:
> Rework the code in uinput_inject_event so that it matches the code in
> evdev_write and allows injecting more than one event, or zero events.
> 
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>
> ---
>  drivers/input/misc/uinput.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index a0a4bba..6aea346 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -434,16 +434,20 @@ static ssize_t uinput_inject_event(struct uinput_device *udev,
>  				   const char __user *buffer, size_t count)
>  {
>  	struct input_event ev;
> +	size_t bytes = 0;
>  
> -	if (count < input_event_size())
> +	if (count != 0 && count < input_event_size())
>  		return -EINVAL;
>  
> -	if (input_event_from_user(buffer, &ev))
> -		return -EFAULT;
> +	while (bytes + input_event_size() <= count) {
> +		if (input_event_from_user(buffer + bytes, &ev))
> +			return -EFAULT;

Unless the failure is in the very first packet we should tell the user
how many bytes we have transferred successfully instead of returning
-EFAULT.

Thanks.

-- 
Dmitry
