Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3ILBga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:36:30 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38747 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750861Ab3ILBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:36:29 -0400
Message-ID: <52311A98.9040603@hurleysoftware.com>
Date: Wed, 11 Sep 2013 21:36:24 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maximiliano Curia <maxy@gnuservers.com.ar>
CC: Margarita Manterola <margamanterola@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <51F1B015.50804@hurleysoftware.com> <20130730124117.41DC55E4006@freak.gnuservers.com.ar> <51F7E4ED.4050409@hurleysoftware.com> <20130808175839.GB21618@gnuservers.com.ar> <52120EAE.5060906@hurleysoftware.com> <20130903211253.GA22253@gnuservers.com.ar>
In-Reply-To: <20130903211253.GA22253@gnuservers.com.ar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 05:12 PM, Maximiliano Curia wrote:
> ¡Hola Peter!
>
> El 2013-08-19 a las 08:25 -0400, Peter Hurley escribió:
>> My primary concern is canonical readers not become stuck with a full
>> read buffer, even with bogus input data (IOW, that an error condition will
>> not prevent a reader from making forward progress). I believe that won't
>> happen with this change, but what I really need in this case is a detailed
>> analysis from you of why that won't happen. That analysis should be in
>> the patch changelog. (Feel free to send me private mail if you need help
>> preparing a patch.)
>
> I'm not sure what level of analysis you are looking for.

For example, why will CPU 0 (the reader) not hang forever under the following
circumstances?

CPU 0                                | CPU 1
                                      |
n_tty_read()                         | n_tty_receive_buf2()
   .                                  |   receive_room
   .                                  |     .
   .                                  |     is waitqueue_active()? no
   add_wait_queue()                   |       .
     .                                |       .
     is input_available_p()?          |       .
       no - schedule_timeout()  <-- reader sleeps

                                      |       .
                                      |       return 0
                                      | exit i/o loop in flush_to_ldisc() work function
                                      |


A complete and detailed analysis would go a long way to getting this patch
accepted. If you show that your patch won't hang readers _and_ fixes the
larger-than-4k-paste bug, then the readline() deficiencies will probably be
overlooked.

> The driver will block
> when there are no readers but as soon as there is a read call it unblocks.
> I've added this information to the patch description that I'm including below.
>
>> And the patch above has a bug that allows a negative 'left' to be
>> assigned to tty->receive_room which will be interpreted as a very large
>> positive value.
>
> Ok, fixed with an else clause. It could also use an extra &&, but it looks a
> bit confusing.
>
>> This approach still has several drawbacks.
>
>> 1) Since additional state is reset when the termios is changed by
>> readline(), the canonical line buffer state will be bogus.
>> This renders the termios change by readline() pointless; the
>> caller will not be able to retrieve expected input properly.
>
>> 2) Since the input data is interpreted with the current termios when
>> data is received, any embedded control characters will not be
>> interpreted properly; again, the caller will not be able to retrieve
>> expected input properly.
>
> Indeed this is correct, however this is not an issue of this patch but of the
> current interaction between the kernel and readline.

My point here was this: the whole point of readline() flipping termios settings
back and forth is to allow readline() to use one setting while the caller
uses a different setting.

If you don't care that the readline() caller doesn't receives its input
properly when pasted, why is the solution to this problem patching the
linux kernel instead of ripping out the termios-flipping that readline()
does?

> In order to fix this, the
> reading buffer should always be in raw and only when responding to a read call
> for canonical mode should it be interpreted. This is a very big change, and
> I'm not sure if anybody will be interested in implementing it.

So the receiver only echoes input once it's been read???  Because if implemented
as you suggest, until the input has been read you wouldn't know what termios
settings to apply for the echoed chars (or even if to echo).

>>> What do you think? Is the proposed solution, or something along those lines,
>>> acceptable?
>
>> I'm wondering if this problem might be best addressed on the paste side
>> instead of the read side. Although this wouldn't be a magic bullet, it
>> would be easier to control when more paste data is added.
>
> I don't see how this could work, could you elaborate?

Well, the vt driver already supports a PASTE_SELECTION ioctl
which bypasses the flip buffers. Something similar might be suitable
for line-oriented pasting, where only one line is written at a time.
I haven't given too much thought to how/what would perform the wake
up of the paster; right now, the vt driver implements unthrottle to
continue pasting.

> This is the patch proposal, for comments:
>
>  From 81afd3b666cbf94bb9923ebf87fb2017a7cd645e Mon Sep 17 00:00:00 2001
> From: Maximiliano Curia <maxy@gnuservers.com.ar>
> Date: Tue, 3 Sep 2013 22:48:34 +0200
> Subject: [PATCH] Only let characters through when there are active readers.
>
> If there is an active reader, previous behavior is in place. When there is no
> active reader, input is blocked until the next read call unblocks it.
>
> This fixes a long standing issue with readline when pasting more than 4096
> bytes.
> ---
>   drivers/tty/n_tty.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 4bf0fc0..cdc3b19 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -147,9 +147,16 @@ static int set_room(struct tty_struct *tty)
>   	 * pending newlines, let characters through without limit, so
>   	 * that erase characters will be handled.  Other excess
>   	 * characters will be beeped.
> +	 * If there is no reader waiting for the input, block instead of
> +	 * letting the characters through.
>   	 */
>   	if (left <= 0)
> -		left = ldata->icanon && !ldata->canon_data;
> +		if (waitqueue_active(&tty->read_wait)) {
> +			left = ldata->icanon && !ldata->canon_data;
> +		} else {
> +			left = 0;
> +		}

Style nitpick. Single-line if-else shouldn't have braces.

> +
>   	old_left = tty->receive_room;
>   	tty->receive_room = left;
>
>

