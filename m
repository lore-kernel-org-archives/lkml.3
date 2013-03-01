Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3CAODW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:03:22 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:59871 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3CAODU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:03:20 -0500
Message-ID: <1362146595.3352.17.camel@thor.lan>
Subject: Re: [PATCH] tty: fix ldisc flush and termios setting race
From: Peter Hurley <peter@hurleysoftware.com>
To: Min Zhang <mzhang@mvista.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Mar 2013 09:03:15 -0500
In-Reply-To: <alpine.LNX.2.00.1302221848440.15944@linux-acr3.site>
References: <alpine.LNX.2.00.1302221848440.15944@linux-acr3.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 19:00 -0800, Min Zhang wrote:
> From: Min Zhang <mzhang@mvista.com>
> 
> A race condition can clear tty ldisc icanon bit unintentionally which 
> could stop n_tty from processing received characters. It can occur when
> tty receiver buffer was full, e.g. 4096 chars received, 8250 serial driver
> interrupt tried to flush_to_ldisc them, but other shell thread tried
> to change_termios the tty setting too. Then n_tty_receive_char and
> n_tty_set_termios both tried to modify n_tty_data fields.
> 
> Specifically the icanon and its neighbor fields are defines as bits:
> 
>     unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
> 
> However they are not atomically accessed in the follow race condition:
> 
> serial8250_handle_irq
>   serail8250_rx_chars
>     tty_flip_buffer_push
>       schdule_work -------> flush_to_ldisc
>                               n_tty_receive_buf
>                                 n_tty_receive_char
>                                   (holds no lock)
> ioctl
>   set_termios
>     tty_set_termios
>       n_tty_set_termios
>         (holds termios_mutex)

Excellent analysis.

But I would rather have n_tty_receive_buf() claim the termios_mutex for
the entire extent of processing (but not including the tty_throttle()
test and call).

Or even better, convert termios_mutex to a rw semaphore which would
require:
  1) add a new mutex to serialize throttle/unthrottle
  2) claim a read lock (down_read/up_read) around the same extent of
     processing in n_tty_receive_buf().
  3) audit the other users of termios_mutex and convert them to
     either a read lock or write lock.
It would be ok that n_tty_receive_buf() would be modifying the lnext and
erasing bitfields with only a read lock because flush_to_ldisc() is
serialized wrt itself and would be serialized with all other write
locks.

This is what I was planning on doing after I fix the problem with the
receive_room races and stuck throttled driver.

Regards,
Peter Hurley

> The patch let change_termios to use TTY_LDISC_FLUSHING to prevent
> flush_to_ldisc from running, and flush_to_ldisc use TTY_FLUSHING
> to make change_termios wait until the flag is cleared.
> 
> The patch also replaces flush_to_ldisc's wake_up with wake_up_all,
> because it can now wake up both TTY_FLUSHING and TTY_FLUSHPENDING
> on the same tty->read_wait queue. Event waiters need check which event.
> 
> Signed-off-by: Min Zhang <mzhang@mvista.com>
> ---
>  drivers/tty/tty_buffer.c |   12 +++++++++++-
>  drivers/tty/tty_ioctl.c  |   27 ++++++++++++++++++++++++++-
>  2 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> index 45d9161..37f4818 100644
> --- a/drivers/tty/tty_buffer.c
> +++ b/drivers/tty/tty_buffer.c
> @@ -482,6 +482,13 @@ static void flush_to_ldisc(struct work_struct *work)
>  
>         spin_lock_irqsave(&buf->lock, flags);
>  
> +       /* Ldisc change by change_termios can race with ldisc receive_buf, esp
> +          to access N_TTY line discipline field in tty_struct, so we defer */
> +       if (test_bit(TTY_LDISC_CHANGING, &tty->flags)) {
> +               schedule_delayed_work(&buf->work, 1);
> +               goto out;
> +       }
> +
>         if (!test_and_set_bit(TTYP_FLUSHING, &port->iflags)) {
>                 struct tty_buffer *head;
>                 while ((head = buf->head) != NULL) {
> @@ -522,8 +529,11 @@ static void flush_to_ldisc(struct work_struct *work)
>         if (test_bit(TTYP_FLUSHPENDING, &port->iflags)) {
>                 __tty_buffer_flush(port);
>                 clear_bit(TTYP_FLUSHPENDING, &port->iflags);
> -               wake_up(&tty->read_wait);
>         }
> +
> +       /* wake up tasks waiting for TTYP_FLUSHING or TTYP_FLUSHPENDING */
> +       wake_up_all(&tty->read_wait);
> +out:
>         spin_unlock_irqrestore(&buf->lock, flags);
>  
>         tty_ldisc_deref(disc);
> diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
> index 8481b29..36a1bfa 100644
> --- a/drivers/tty/tty_ioctl.c
> +++ b/drivers/tty/tty_ioctl.c
> @@ -546,8 +546,33 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
>  
>         ld = tty_ldisc_ref(tty);
>         if (ld != NULL) {
> -               if (ld->ops->set_termios)
> +               unsigned long   flags;
> +               struct tty_port *port = tty->port;
> +               struct tty_bufhead *buf = &port->buf;
> +               if (!ld->ops->set_termios)
> +                       goto no_set_termios;
> +
> +               /* Wait if the data is being pushed to the tty layer */
> +               spin_lock_irqsave(&buf->lock, flags);
> +               while (test_bit(TTYP_FLUSHING, &port->iflags)) {
> +                       spin_unlock_irqrestore(&buf->lock, flags);
> +                       printk(KERN_CRIT "%s flushing\n", __FUNCTION__);
> +                       wait_event(tty->read_wait,
> +                                  test_bit(TTYP_FLUSHING, &port->iflags) == 0);
> +                       spin_lock_irqsave(&buf->lock, flags);
> +               }
> +               printk(KERN_CRIT "%s survived flushing\n", __FUNCTION__);
> +
> +               /* Prevent future flush_to_ldisc while we are setting */
> +               if (!test_and_set_bit(TTY_LDISC_CHANGING, &tty->flags)) {
> +                       spin_unlock_irqrestore(&buf->lock, flags);
>                         (ld->ops->set_termios)(tty, &old_termios);
> +                       spin_lock_irqsave(&buf->lock, flags);
> +                       clear_bit(TTY_LDISC_CHANGING, &tty->flags);
> +               }
> +               spin_unlock_irqrestore(&buf->lock, flags);
> +
> +no_set_termios:
>                 tty_ldisc_deref(ld);
>         }
>         mutex_unlock(&tty->termios_mutex);
> -- 
> 1.7.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


