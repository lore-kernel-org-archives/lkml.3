Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbbARWv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 17:51:58 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:46868 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbARWv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 17:51:56 -0500
Message-ID: <54BC2F0A.8040404@symas.com>
Date: Sun, 18 Jan 2015 22:09:14 +0000
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0 SeaMonkey/2.34a1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:
> Commit 26df6d13406d1 ("tty: Add EXTPROC support for LINEMODE") added
> the undocumented EXTPROC input processing mode, which ignores the ICANON
> setting and forces pty slave input to be processed in non-canonical
> mode.
>
> Although intended to provide a transparent mechanism for local line
> edit with telnetd (and other remote shell protocols), the transparency
> is limited.
>
> Userspace usage is abandoned; telnetd does not even compile with
> LINEMODE support. readline/bash and sshd never supported this.

I object to this. Code for all of the above exists and works. I use this 
code daily.

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=585527
http://lists.gnu.org/archive/html/bug-readline/2011-01/msg00004.html
https://github.com/hyc/OpenSSH-LINEMODE

The lack of LINEMODE support in upstream sshd can only be considered a 
security hole.

http://www.metzdowd.com/pipermail/cryptography/2015-January/024288.html

>
> Cc: Howard Chu <hyc@symas.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>   drivers/tty/n_tty.c | 22 ++++++----------------
>   drivers/tty/pty.c   | 24 +-----------------------
>   2 files changed, 7 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index eb9f114..5120d2b 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -1562,10 +1562,6 @@ n_tty_receive_buf_standard(struct tty_struct *tty, const unsigned char *cp,
>   				c &= 0x7f;
>   			if (I_IUCLC(tty) && L_IEXTEN(tty))
>   				c = tolower(c);
> -			if (L_EXTPROC(tty)) {
> -				put_tty_queue(c, ldata);
> -				continue;
> -			}
>   			if (!test_bit(c, ldata->char_map))
>   				n_tty_receive_char_inline(tty, c);
>   			else if (n_tty_receive_char_special(tty, c) && count) {
> @@ -1613,9 +1609,9 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
>
>   	if (ldata->real_raw)
>   		n_tty_receive_buf_real_raw(tty, cp, fp, count);
> -	else if (ldata->raw || (L_EXTPROC(tty) && !preops))
> +	else if (ldata->raw)
>   		n_tty_receive_buf_raw(tty, cp, fp, count);
> -	else if (tty->closing && !L_EXTPROC(tty))
> +	else if (tty->closing)
>   		n_tty_receive_buf_closing(tty, cp, fp, count);
>   	else {
>   		if (ldata->lnext) {
> @@ -1637,13 +1633,13 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
>   			tty->ops->flush_chars(tty);
>   	}
>
> -	if (ldata->icanon && !L_EXTPROC(tty))
> +	if (ldata->icanon)
>   		return;
>
>   	/* publish read_head to consumer */
>   	smp_store_release(&ldata->commit_head, ldata->read_head);
>
> -	if ((read_cnt(ldata) >= ldata->minimum_to_wake) || L_EXTPROC(tty)) {
> +	if (read_cnt(ldata) >= ldata->minimum_to_wake) {
>   		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
>   		if (waitqueue_active(&tty->read_wait))
>   			wake_up_interruptible_poll(&tty->read_wait, POLLIN);
> @@ -1939,7 +1935,7 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
>   	struct n_tty_data *ldata = tty->disc_data;
>   	int amt = poll && !TIME_CHAR(tty) && MIN_CHAR(tty) ? MIN_CHAR(tty) : 1;
>
> -	if (ldata->icanon && !L_EXTPROC(tty))
> +	if (ldata->icanon)
>   		return ldata->canon_head != ldata->read_tail;
>   	else
>   		return ldata->commit_head - ldata->read_tail >= amt;
> @@ -1973,7 +1969,6 @@ static int copy_from_read_buf(struct tty_struct *tty,
>   	struct n_tty_data *ldata = tty->disc_data;
>   	int retval;
>   	size_t n;
> -	bool is_eof;
>   	size_t head = smp_load_acquire(&ldata->commit_head);
>   	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
>
> @@ -1983,14 +1978,9 @@ static int copy_from_read_buf(struct tty_struct *tty,
>   	if (n) {
>   		retval = copy_to_user(*b, read_buf_addr(ldata, tail), n);
>   		n -= retval;
> -		is_eof = n == 1 && read_buf(ldata, tail) == EOF_CHAR(tty);
>   		tty_audit_add_data(tty, read_buf_addr(ldata, tail), n,
>   				ldata->icanon);
>   		smp_store_release(&ldata->read_tail, ldata->read_tail + n);
> -		/* Turn single EOF into zero-length read */
> -		if (L_EXTPROC(tty) && ldata->icanon && is_eof &&
> -		    (head == ldata->read_tail))
> -			n = 0;
>   		*b += n;
>   		*nr -= n;
>   	}
> @@ -2257,7 +2247,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
>   			continue;
>   		}
>
> -		if (ldata->icanon && !L_EXTPROC(tty)) {
> +		if (ldata->icanon) {
>   			retval = canon_copy_from_read_buf(tty, &b, &nr);
>   			if (retval == -EAGAIN) {
>   				retval = 0;
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index ee06b77..01ac182 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -192,20 +192,6 @@ static int pty_get_pktmode(struct tty_struct *tty, int __user *arg)
>   	return put_user(pktmode, arg);
>   }
>
> -/* Send a signal to the slave */
> -static int pty_signal(struct tty_struct *tty, int sig)
> -{
> -	struct pid *pgrp;
> -
> -	if (tty->link) {
> -		pgrp = tty_get_pgrp(tty->link);
> -		if (pgrp)
> -			kill_pgrp(pgrp, sig, 1);
> -		put_pid(pgrp);
> -	}
> -	return 0;
> -}
> -
>   static void pty_flush_buffer(struct tty_struct *tty)
>   {
>   	struct tty_struct *to = tty->link;
> @@ -254,15 +240,13 @@ static void pty_set_termios(struct tty_struct *tty,
>   {
>   	/* See if packet mode change of state. */
>   	if (tty->link && tty->link->packet) {
> -		int extproc = (old_termios->c_lflag & EXTPROC) |
> -				(tty->termios.c_lflag & EXTPROC);
>   		int old_flow = ((old_termios->c_iflag & IXON) &&
>   				(old_termios->c_cc[VSTOP] == '\023') &&
>   				(old_termios->c_cc[VSTART] == '\021'));
>   		int new_flow = (I_IXON(tty) &&
>   				STOP_CHAR(tty) == '\023' &&
>   				START_CHAR(tty) == '\021');
> -		if ((old_flow != new_flow) || extproc) {
> +		if (old_flow != new_flow) {
>   			spin_lock_irq(&tty->ctrl_lock);
>   			if (old_flow != new_flow) {
>   				tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
> @@ -271,8 +255,6 @@ static void pty_set_termios(struct tty_struct *tty,
>   				else
>   					tty->ctrl_status |= TIOCPKT_NOSTOP;
>   			}
> -			if (extproc)
> -				tty->ctrl_status |= TIOCPKT_IOCTL;
>   			spin_unlock_irq(&tty->ctrl_lock);
>   			wake_up_interruptible(&tty->link->read_wait);
>   		}
> @@ -482,8 +464,6 @@ static int pty_bsd_ioctl(struct tty_struct *tty,
>   		return pty_set_pktmode(tty, (int __user *)arg);
>   	case TIOCGPKT: /* Get PT packet mode */
>   		return pty_get_pktmode(tty, (int __user *)arg);
> -	case TIOCSIG:    /* Send signal to other side of pty */
> -		return pty_signal(tty, (int) arg);
>   	case TIOCGPTN: /* TTY returns ENOTTY, but glibc expects EINVAL here */
>   		return -EINVAL;
>   	}
> @@ -607,8 +587,6 @@ static int pty_unix98_ioctl(struct tty_struct *tty,
>   		return pty_get_pktmode(tty, (int __user *)arg);
>   	case TIOCGPTN: /* Get PT Number */
>   		return put_user(tty->index, (unsigned int __user *)arg);
> -	case TIOCSIG:    /* Send signal to other side of pty */
> -		return pty_signal(tty, (int) arg);
>   	}
>
>   	return -ENOIOCTLCMD;
>


-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
