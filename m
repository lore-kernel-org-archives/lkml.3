Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3CNPSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:18:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035Ab3CNPSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:18:48 -0400
Date: Thu, 14 Mar 2013 12:18:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Kevin Baradon <kevin.baradon@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 2/2] media/rc/imon.c: avoid flooding syslog with
 "unknown keypress" when keypad is pressed
Message-ID: <20130314121841.574d2d0f@redhat.com>
In-Reply-To: <1361737170-4687-3-git-send-email-kevin.baradon@gmail.com>
References: <1361737170-4687-1-git-send-email-kevin.baradon@gmail.com>
	<1361737170-4687-3-git-send-email-kevin.baradon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 24 Feb 2013 21:19:30 +0100
Kevin Baradon <kevin.baradon@gmail.com> escreveu:

> My 15c2:0036 device floods syslog when a keypad key is pressed:
> 
> Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fff2
> Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fef2
> Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fff2
> Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fff2
> Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fff2
> 
> This patch lowers severity of this message when key appears to be coming from keypad.
> 
> Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>
> ---
>  drivers/media/rc/imon.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
> index a3e66a0..bca03d4 100644
> --- a/drivers/media/rc/imon.c
> +++ b/drivers/media/rc/imon.c
> @@ -1499,7 +1499,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
>  	int i;
>  	u64 scancode;
>  	int press_type = 0;
> -	int msec;
> +	int msec, is_pad_key = 0;
>  	struct timeval t;
>  	static struct timeval prev_time = { 0, 0 };
>  	u8 ktype;
> @@ -1562,6 +1562,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
>  	    ((len == 8) && (buf[0] & 0x40) &&
>  	     !(buf[1] & 0x1 || buf[1] >> 2 & 0x1))) {
>  		len = 8;
> +		is_pad_key = 1;
>  		imon_pad_to_keys(ictx, buf);
>  	}
>  
> @@ -1625,8 +1626,16 @@ static void struct imon_context *ictx,
>  
>  unknown_key:
>  	spin_unlock_irqrestore(&ictx->kc_lock, flags);
> -	dev_info(dev, "%s: unknown keypress, code 0x%llx\n", __func__,
> -		 (long long)scancode);
> +	/*
> +	 * On some devices syslog is flooded with unknown keypresses when keypad
> +	 * is pressed. Lower message severity in that case.
> +	 */
> +	if (!is_pad_key)
> +		dev_info(dev, "%s: unknown keypress, code 0x%llx\n", __func__,
> +			 (long long)scancode);
> +	else
> +		dev_dbg(dev, "%s: unknown keypad keypress, code 0x%llx\n",
> +			__func__, (long long)scancode);

Hmmm... this entire logic looks weird to me. IMO, the proper fix is to
remove this code snippet from imon_incoming_packet():

	spin_lock_irqsave(&ictx->kc_lock, flags);
	if (ictx->kc == KEY_UNKNOWN)
		goto unknown_key;
	spin_unlock_irqrestore(&ictx->kc_lock, flags);

and similar logic from other parts of the code, and just let rc_keydown()
to be handled for KEY_UNKNOWN.

rc_keydown() actually produces two input events:
	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
	input_event(dev, EV_KEY, code, !!value);

(the last one, indirectly, by calling input_report_key)

In this particular case, the fist event will allow userspace programs
like "rc-keycode -t" to detect that an unknown scancode was produced,
helping the user to properly fill the scancode table for a particular device.

In the case of your remote, you'll likely will want to add support for those
currently unknown scancodes.

Those "unkonwn keypad keypress" type of messages are now obsolete, as users
can get it anytime in userspace, using the appropriate tool (ir-keytable,
with is part of v4l-utils).

Regards,
Mauro
