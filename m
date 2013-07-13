Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3GMGog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:44:36 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58304 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3GMGod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:44:33 -0400
Date: Fri, 12 Jul 2013 23:44:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexander Levitskiy <sanek@google.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Henrik Rydberg <rydberg@euromail.se>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 001/001] [Input:] Propagate hardware generated event
 timestamp to evdev.
Message-ID: <20130713064430.GA20979@core.coreip.homeip.net>
References: <CAJVTVr=rbkYHD93N4H9ANy1Hsivdd_XFLONXxOBp+TR9LfAyaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJVTVr=rbkYHD93N4H9ANy1Hsivdd_XFLONXxOBp+TR9LfAyaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On Wed, Jul 10, 2013 at 01:38:00PM -0700, Alexander Levitskiy wrote:
> From: Sasha Levitskiy <sanek@google.com>
> 
> Input: Propagate hardware event timestamp to evdev.
> 
> Convey hardware generated timestamp associated with the current event packet.
> The use of these event codes by hardware drivers is optional.
> Used to reduce jitter and improve velocity tracking in ABS_MT and other timing
> sensitive devices.
> 
> kernel v. 3.4
> 
> Signed-off-by: Sasha Levitskiy <sanek@google.com>
> ---
> diff --git a/Documentation/input/event-codes.txt
> b/Documentation/input/event-codes.txt
> index 53305bd..f0f0e07 100644
> --- a/Documentation/input/event-codes.txt
> +++ b/Documentation/input/event-codes.txt
> @@ -91,6 +91,15 @@ sent in the evdev event stream.
>      event and query the device (using EVIOCG* ioctls) to obtain its
>      current state.
> 
> +* SYN_TIME_SEC, SYN_TIME_NSEC:
> +  - Used to convey hardware timestamp associated with the current
> +    event packet. The use of these event codes by hardware drivers
> +    is optional. If used, the hardware driver should send the timestamp
> +    ahead of any other events associated with this packet. The timestamp
> +    should be adjusted to CLOCK_MONOTONIC base.
> +    This becomes useful for drivers of hardware that handle batching
> +    without involving the main CPU.

We already have MSC_TIMESTAMP (which is in usec), do you really need
nsec resolution?

> +
>  EV_KEY:
>  ----------
>  EV_KEY events take the form KEY_<name> or BTN_<name>. For example,
> KEY_A is used
> diff --git a/Documentation/input/multi-touch-protocol.txt
> b/Documentation/input/multi-touch-protocol.txt
> index 543101c..71af317 100644
> --- a/Documentation/input/multi-touch-protocol.txt
> +++ b/Documentation/input/multi-touch-protocol.txt
> @@ -80,6 +80,10 @@ Userspace can detect that a driver can report more
> total contacts than slots
>  by noting that the largest supported BTN_TOOL_*TAP event is larger than the
>  total number of type B slots reported in the absinfo for the ABS_MT_SLOT axis.
> 
> +Velocity tracking and temporal precision can be improved if device provides
> +exact timestamp for touches reported through SYN_TIME_SEC and SYN_TIME_NSEC.
> +The timestamp should be reported ahead of everything else in the packet.
> +
>  Protocol Example A
>  ------------------
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 41f79be..48baf6f 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -37,6 +37,8 @@ struct evdev {
>   struct mutex mutex;
>   struct device dev;
>   bool exist;
> + int hw_ts_sec;
> + int hw_ts_nsec;
>  };
> 
>  struct evdev_client {
> @@ -109,7 +111,20 @@ static void evdev_event(struct input_handle *handle,
>   struct input_event event;
>   ktime_t time_mono, time_real;
> 
> - time_mono = ktime_get();
> + if (type == EV_SYN && code == SYN_TIME_SEC) {
> + evdev->hw_ts_sec = value;
> + return;

Why do you need this special handling? Can you simply have MSC_TIMESTAMP
to be delivered as part of the event packet and use it instead of the
event timestamp if userspace chooses to do so?

Thanks.

-- 
Dmitry
