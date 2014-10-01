Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaJAQg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:36:56 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:54522 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaJAQgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:36:55 -0400
MIME-Version: 1.0
In-Reply-To: <1412179187-15107-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412179187-15107-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 1 Oct 2014 18:36:54 +0200
Message-ID: <CANq1E4QGPWNBSLzd3_5NJVNkCjBELREN=_twVdcdSe6efOOJ2Q@mail.gmail.com>
Subject: Re: [PATCH] HID: uHID: fix excepted report type
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: David Herrmann <dh.herrmann@googlemail.com>, Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Oct 1, 2014 at 5:59 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> When uhid_get_report() or uhid_set_report() are called, they emit on the
> char device a UHID_GET_REPORT or UHID_SET_REPORT message. Then, the
> protocol says that the user space asnwers with UHID_GET_REPORT_REPLY
> or UHID_SET_REPORT_REPLY.
>
> Unfortunatelly, the current code waits for an event of type UHID_GET_REPORT
> or UHID_SET_REPORT instead of the reply one.
> Add 1 to UHID_GET_REPORT or UHID_SET_REPORT to actually wait for the
> reply, and validate the reply.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>
> Hi David,
>
> while playing with a Bluetooth LE mouse, I noticed that uhid did not validate
> properly the get_report feature. With this patch and some work on bluez, this
> part now works almost (at least I manage to get reports from the device, there
> is still a 0x0b header I can not rely to anything, so there will be some work
> to do in Bordeaux :) )
>
> Cheers,
> Benjamin
>
>  drivers/hid/uhid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
> index f6ec5ea..e094c57 100644
> --- a/drivers/hid/uhid.c
> +++ b/drivers/hid/uhid.c
> @@ -154,7 +154,7 @@ static int __uhid_report_queue_and_wait(struct uhid_device *uhid,
>
>         spin_lock_irqsave(&uhid->qlock, flags);
>         *report_id = ++uhid->report_id;
> -       uhid->report_type = ev->type;
> +       uhid->report_type = ev->type + 1;

Nice catch. We always need the *_REPLY type as response:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks for trying to fix this! I will try to get my Arc-Surface
working until Bordeaux. We should be able to get all that stuff
figured out together then. And it will still be in time for 3.18-fixes
then.

Thanks
David

>         uhid->report_running = true;
>         uhid_queue(uhid, ev);
>         spin_unlock_irqrestore(&uhid->qlock, flags);
> --
> 1.9.3
>
