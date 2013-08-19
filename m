Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3HSMZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:25:24 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:56609 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328Ab3HSMZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:25:23 -0400
Message-ID: <52120EAE.5060906@hurleysoftware.com>
Date: Mon, 19 Aug 2013 08:25:18 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maximiliano Curia <maxy@debian.org>
CC: Margarita Manterola <margamanterola@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <51F1B015.50804@hurleysoftware.com> <20130730124117.41DC55E4006@freak.gnuservers.com.ar> <51F7E4ED.4050409@hurleysoftware.com> <20130808175839.GB21618@gnuservers.com.ar>
In-Reply-To: <20130808175839.GB21618@gnuservers.com.ar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 01:58 PM, Maximiliano Curia wrote:
> Hi,
>
>> n_tty_set_room() in drivers/tty/n_tty.c (3.10 mainline)
>
>>  From n_tty_set_room():
>
>> 	/*
>> 	 * If we are doing input canonicalization, and there are no
>> 	 * pending newlines, let characters through without limit, so
>> 	 * that erase characters will be handled.  Other excess
>> 	 * characters will be beeped.
>> 	 */
>> 	if (left <= 0)
>> 		left = ldata->icanon && !ldata->canon_data;
>> 	old_left = tty->receive_room;
>> 	tty->receive_room = left;
>
> I took a long look at this code and thought about how it could be made to work
> for readline's case and also for the canonical readers.  I came up with this
> simple patch:
>
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 4bf0fc0..2ba7f4e 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -149,7 +149,8 @@ static int set_room(struct tty_struct *tty)
>           * characters will be beeped.
>           */
>          if (left <= 0)
> -               left = ldata->icanon && !ldata->canon_data;
> +               if (waitqueue_active(&tty->read_wait))
> +                       left = ldata->icanon && !ldata->canon_data;
>          old_left = tty->receive_room;
>          tty->receive_room = left;
>
> This is of course just an idea, but I tested this and it worked correctly for
> the cases I was testing.
>
> The effect of this patch is that when there is a canonical reader waiting for
> input, it maintains the previous behavior, but when there's no reader (like
> when readline is changing modes), it blocks and doesn't lose any characters.

Apologies for taking so long to reply.

My primary concern is canonical readers not become stuck with a full
read buffer, even with bogus input data (IOW, that an error condition will
not prevent a reader from making forward progress). I believe that won't
happen with this change, but what I really need in this case is a detailed
analysis from you of why that won't happen. That analysis should be in
the patch changelog. (Feel free to send me private mail if you need help
preparing a patch.)

And the patch above has a bug that allows a negative 'left' to be
assigned to tty->receive_room which will be interpreted as a very large
positive value.

This approach still has several drawbacks.

1) Since additional state is reset when the termios is changed by
readline(), the canonical line buffer state will be bogus.
This renders the termios change by readline() pointless; the
caller will not be able to retrieve expected input properly.

2) Since the input data is interpreted with the current termios when
data is received, any embedded control characters will not be
interpreted properly; again, the caller will not be able to retrieve
expected input properly.

> Another approach would be to recalculate the size of canon_data when the mode
> is changed, but this would probably be much more invasive, and awfully less
> efficient since it would imply going through the buffer.

This approach is not possible prior to linux-next since the input worker
thread and the reader thread are not locked out of access to the read buffer
while changing the termios.

And while rescanning the read buffer is possible in linux-next (eg, to
compute the read_flags bitmap indicating the position of NLs), this doesn't
address embedded control characters not being reinterpreted. And completely
reinterpreting the read buffer makes interpreting when receiving pointless.

> What do you think? Is the proposed solution, or something along those lines,
> acceptable?

I'm wondering if this problem might be best addressed on the paste side
instead of the read side. Although this wouldn't be a magic bullet, it
would be easier to control when more paste data is added.

Regards,
Peter Hurley


