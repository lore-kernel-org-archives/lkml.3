Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3KTAV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:21:58 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:34677 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3KTAVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:21:55 -0500
MIME-Version: 1.0
In-Reply-To: <1383850796-24300-1-git-send-email-peter@hurleysoftware.com>
References: <20131017211236.GA6155@kroah.com>
	<1383850796-24300-1-git-send-email-peter@hurleysoftware.com>
Date: Tue, 19 Nov 2013 16:21:54 -0800
X-Google-Sender-Auth: Qp0Koh8AHFERpe6uCRvjS1FiITg
Message-ID: <CA+55aFwYps=q14pQ04yWYThFwi3NnR__MeggU8N3M4Q0vrk+nQ@mail.gmail.com>
Subject: Re: [PATCH] n_tty: Ensure reader restarts worker for next reader
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, "# .39.x" <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,
 what happened to this patch? Is it still waiting in some random tree
of yours, or did it get lost?

                    Linus

On Thu, Nov 7, 2013 at 10:59 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> A departing reader must restart a flush_to_ldisc() worker _before_
> the next reader enters the read loop; this is to avoid the new reader
> concluding no more i/o is available and prematurely exiting, when the
> old reader simply hasn't re-started the worker yet.
>
> Cc: stable@kernel.org # 3.12
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/n_tty.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 7a744b6..ce11cd5 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -2250,6 +2250,9 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
>                 if (time)
>                         timeout = time;
>         }
> +       n_tty_set_room(tty);
> +       up_read(&tty->termios_rwsem);
> +
>         mutex_unlock(&ldata->atomic_read_lock);
>         remove_wait_queue(&tty->read_wait, &wait);
>
> @@ -2260,8 +2263,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
>         if (b - buf)
>                 retval = b - buf;
>
> -       n_tty_set_room(tty);
> -       up_read(&tty->termios_rwsem);
>         return retval;
>  }
>
> --
> 1.8.1.2
>
