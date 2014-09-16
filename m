Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaIPHQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:16:44 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:60557 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaIPHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:16:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140916063115.GF17875@mwanda>
References: <20140916033333.GA26821@devel>
	<20140916063115.GF17875@mwanda>
Date: Tue, 16 Sep 2014 16:16:42 +0900
Message-ID: <CAHb8M2DN+FyctZVeQjR5jOQ=GPUYVDCAy2f_Q145TPU2Cg0dTg@mail.gmail.com>
Subject: Re: [PATCH] staging: dgap: use schedule_timeout_interruptible()
 instead of dgap_ms_sleep()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-09-16 15:31 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
>
> On Tue, Sep 16, 2014 at 12:33:33PM +0900, Daeseok Youn wrote:
> > @@ -2297,12 +2273,12 @@ static void dgap_tty_close(struct tty_struct *tty, struct file *file)
> >                        * Go to sleep to ensure RTS/DTR
> >                        * have been dropped for modems to see it.
> >                        */
> > -                     if (ch->ch_close_delay) {
> > -                             spin_unlock_irqrestore(&ch->ch_lock,
> > -                                                    lock_flags);
> > -                             dgap_ms_sleep(ch->ch_close_delay);
> > -                             spin_lock_irqsave(&ch->ch_lock, lock_flags);
> > -                     }
> > +                     spin_unlock_irqrestore(&ch->ch_lock,
> > +                                     lock_flags);
> > +                     /* .25 second delay for dropping RTS/DTR */
> > +                     schedule_timeout_interruptible(msecs_to_jiffies(250));
> > +                     signal_pending(current);
>
> There is no point in calling signal_pending() if you don't care about
> the return value.
Yes, you're right.
Originally it didn't have any handling of the return value from
signal_pending().
So, I will re-send this patch after removing signal_pending().

Thanks.

regards,
Daeseok Youn
>
> > +                     spin_lock_irqsave(&ch->ch_lock, lock_flags);
> >               }
> >
>
> regards,
> dan carpenter
