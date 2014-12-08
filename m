Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbaLHWWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:22:31 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46077 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbaLHWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:22:24 -0500
Date: Mon, 8 Dec 2014 14:22:20 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Denis Du <dudenis2000@yahoo.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TTY: missing a lock to access the ldisk buffer
Message-ID: <20141208222220.GA9912@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Denis Du <dudenis2000@yahoo.ca>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <694700710.6880446.1418070480521.JavaMail.yahoo@jws10627.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <694700710.6880446.1418070480521.JavaMail.yahoo@jws10627.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis,

This patch won't apply to linux-next 20141208 so I can't test it :-(

Which kernel does this patch apply to?

On Mon, Dec 08, 2014 at 08:28:00PM +0000, Denis Du wrote:
> Hi, Guys:
> I found that the 3.12 kernel tty layer will lose or corrupt data when having a full-duplex communication, especcially in high baudrate, for example 230k for my OMAP5 uart. Eventually I found there is a lock missing between copy data to ldisc layer buffer and copy data from the same buffer to user space. I believe this issue have been existing since 3.8 kernel(since this kernel , it start to remove most of the spin-locks) and I didn't find any fix even through 3.17 kernel. This patch was tested to be works great with no any data loss again.
> 
> 
> I did try to use the existed lock atomic_read_lock, but it doesn’t work. 
> 
> 
> 
> Signed-off-by: Hui Du <dudenis2000@yahoo.ca>
> 
> 
> ---
> 
> --- drivers/tty/n_tty.c    2014-10-16 16:39:35.909350338 -0400
> +++ drivers/tty/n_tty.c    2014-10-16 16:49:00.004930469 -0400
> @@ -124,6 +124,7 @@
> 
> struct mutex atomic_read_lock;
> struct mutex output_lock;
> +    struct mutex read_buf_lock;
> };
> 
> static inline size_t read_cnt(struct n_tty_data *ldata)
> @@ -1686,9 +1687,11 @@
> char *fp, int count)
> {
> int room, n;
> +    struct n_tty_data *ldata = tty->disc_data;
> 
> down_read(&tty->termios_rwsem);
> 
> +    mutex_lock(&ldata->read_buf_lock);
> while (1) {
> room = receive_room(tty);
> n = min(count, room);
> @@ -1703,6 +1706,7 @@
> 
> tty->receive_room = room;
> n_tty_check_throttle(tty);
> +    mutex_unlock(&ldata->read_buf_lock);
> up_read(&tty->termios_rwsem);
> }
> 
> @@ -1713,7 +1717,7 @@
> int room, n, rcvd = 0;
> 
> down_read(&tty->termios_rwsem);
> -
> +    mutex_lock(&ldata->read_buf_lock);
> while (1) {
> room = receive_room(tty);
> n = min(count, room);
> @@ -1732,6 +1736,7 @@
> 
> tty->receive_room = room;
> n_tty_check_throttle(tty);
> +    mutex_unlock(&ldata->read_buf_lock);
> up_read(&tty->termios_rwsem);
> 
> return rcvd;
> @@ -1880,6 +1885,7 @@
> ldata->overrun_time = jiffies;
> mutex_init(&ldata->atomic_read_lock);
> mutex_init(&ldata->output_lock);
> +    mutex_init(&ldata->read_buf_lock);
> 
> tty->disc_data = ldata;
> reset_buffer_flags(tty->disc_data);
> @@ -1945,6 +1951,8 @@
> size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
> 
> retval = 0;
> +
> +    mutex_lock(&ldata->read_buf_lock);
> n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
> n = min(*nr, n);
> if (n) {
> @@ -1960,6 +1968,7 @@
> *b += n;
> *nr -= n;
> }
> +    mutex_unlock(&ldata->read_buf_lock);
> return retval;
> }
> 
> @@ -1990,6 +1999,8 @@
> size_t tail;
> int ret, found = 0;
> bool eof_push = 0;
> + 
> +    mutex_lock(&ldata->read_buf_lock);
> 
> /* N.B. avoid overrun if nr == 0 */
> n = min(*nr, read_cnt(ldata));
> @@ -2049,6 +2060,8 @@
> ldata->line_start = ldata->read_tail;
> tty_audit_push(tty);
> }
> +
> +    mutex_unlock(&ldata->read_buf_lock);
> return eof_push ? -EAGAIN : 0;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
