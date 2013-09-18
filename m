Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab3IRPUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:20:38 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54599 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3IRPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130918144420.GB16424@core.coreip.homeip.net>
References: <52399E2C.7000805@gmail.com>
	<20130918144420.GB16424@core.coreip.homeip.net>
Date: Wed, 18 Sep 2013 19:20:34 +0400
Message-ID: <CABWXVkNPET48b_Ru=y=WRFEFBKOMYLoxAGSsco36KNtzTFd1kQ@mail.gmail.com>
Subject: Re: [PATCH] Input: i8042 - i8042_flush fix for a full 8042 buffer
From: Andrey Moiseev <o2g.org.ru@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice. That should be of no interest for the outside world how much
junk 8042 contained, so that's better.

On Wed, Sep 18, 2013 at 6:44 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Andrey,
>
> On Wed, Sep 18, 2013 at 04:35:56PM +0400, Andrey Moiseev wrote:
>> When 8042 internal data buffer is full, the driver
>> erroneously decides that the controller is not present.
>>
>> I've already sent this 2 weeks ago, but that message received no comments.
>>
>
> Sorry about the delay. How about we rework it a bit and make flush
> return success/error instead of number of bytes read, like in the patch
> below?
>
> Thanks.
>
> --
> Dmitry
>
> Input: i8042 - i8042_flush fix for a full 8042 buffer
>
> From: Andrey Moiseev <o2g.org.ru@gmail.com>
>
> When 8042 internal data buffer is full, the driver
> erroneously decides that the controller is not present.
>
> i8042_flush returns the number of flushed bytes, which is
> in 0 - I8042_BUFFER_SIZE range inclusive. Therefore, i8042_flush
> has no way to indicate an error. Moreover i8042_controller_check
> takes initially full buffer (i8042_flush returned
> I8042_BUFFER_SIZE) as a sign of absence of the controller.
>
> Let's change i8042 to return success/error instead and make sure
> we do not return error prematurely.
>
> Signed-off-by: Andrey Moiseev <o2g.org.ru@gmail.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/serio/i8042.c |   23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index 78e4de4..52c9ebf 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -223,21 +223,26 @@ static int i8042_flush(void)
>  {
>         unsigned long flags;
>         unsigned char data, str;
> -       int i = 0;
> +       int count = 0;
> +       int retval = 0;
>
>         spin_lock_irqsave(&i8042_lock, flags);
>
> -       while (((str = i8042_read_status()) & I8042_STR_OBF) && (i < I8042_BUFFER_SIZE)) {
> -               udelay(50);
> -               data = i8042_read_data();
> -               i++;
> -               dbg("%02x <- i8042 (flush, %s)\n",
> -                   data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
> +       while ((str = i8042_read_status()) & I8042_STR_OBF) {
> +               if (count++ < I8042_BUFFER_SIZE) {
> +                       udelay(50);
> +                       data = i8042_read_data();
> +                       dbg("%02x <- i8042 (flush, %s)\n",
> +                           data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
> +               } else {
> +                       retval = -EIO;
> +                       break;
> +               }
>         }
>
>         spin_unlock_irqrestore(&i8042_lock, flags);
>
> -       return i;
> +       return retval;
>  }
>
>  /*
> @@ -849,7 +854,7 @@ static int __init i8042_check_aux(void)
>
>  static int i8042_controller_check(void)
>  {
> -       if (i8042_flush() == I8042_BUFFER_SIZE) {
> +       if (i8042_flush()) {
>                 pr_err("No controller found\n");
>                 return -ENODEV;
>         }
>
