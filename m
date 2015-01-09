Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbbAITJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:09:55 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34059 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbAITJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:09:51 -0500
Message-ID: <54B02777.20604@hurleysoftware.com>
Date: Fri, 09 Jan 2015 14:09:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Riesch <christian.riesch@omicron.at>
CC: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] n_tty: Fix unordered accesses to lockless read buffer
References: <1419941156-5303-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1419941156-5303-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ reviewing my own patch :) ]

On 12/30/2014 07:05 AM, Peter Hurley wrote:
> Add commit_head buffer index, which the producer-side publishes
> after input processing. This ensures the consumer-side observes
> correctly-ordered writes in raw mode (ie., the buffer data is
> written before the buffer index is advanced).
> 
> Further, remove read_cnt() and expand inline, using ACCESS_ONCE()
> on the relevant buffer index; read_tail from the producer-side
> and canon_head/commit_head from the consumer-side, or both in shared
> paths such as receive_room().
> 
> Based on work by Christian Riesch <christian.riesch@omicron.at>
> 
> NB: Exclusive access is still guaranteed with termios_rwsem write
> lock, eg. by n_tty_set_termios() and in n_tty_ioctl(); in this
> circumstance, commit_head is equivalent to read_head.
> 
> Cc: Christian Riesch <christian.riesch@omicron.at>
> Cc: <stable@vger.kernel.org> # v3.14.x (will need backport to v3.12.x)
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/n_tty.c | 80 ++++++++++++++++++++++++++---------------------------
>  1 file changed, 40 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index d2b4967..a618b10 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -90,6 +90,7 @@
>  struct n_tty_data {
>  	/* producer-published */
>  	size_t read_head;
> +	size_t commit_head;	/* == read_head when not receiving */

commit_head is now the observable producer-side buffer index when
termios is !icanon || L_EXTPROC mode.

>  	size_t canon_head;
>  	size_t echo_head;
>  	size_t echo_commit;
> @@ -127,11 +128,6 @@ struct n_tty_data {
>  	struct mutex output_lock;
>  };
>  
> -static inline size_t read_cnt(struct n_tty_data *ldata)
> -{
> -	return ldata->read_head - ldata->read_tail;
> -}
> -

Can keep read_cnt(). Will continue to be used in several places. See
other comments.

>  static inline unsigned char read_buf(struct n_tty_data *ldata, size_t i)
>  {
>  	return ldata->read_buf[i & (N_TTY_BUF_SIZE - 1)];
> @@ -164,15 +160,17 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
>  static int receive_room(struct tty_struct *tty)
>  {
>  	struct n_tty_data *ldata = tty->disc_data;
> +	size_t head = ACCESS_ONCE(ldata->commit_head);
> +	size_t tail = ACCESS_ONCE(ldata->read_tail);

Producer-side receive_room() needs to be special-cased for the
call from the n_tty_receive_buf_common() i/o loop, because the
read_tail access needs to be:

	size_t tail = smp_load_acquire(ldata->read_tail);

Paired with the consumer-side smp_store_release(read_tail), will
guarantee that the consumer has finished loading from the
read_buf before the producer may overwrite that data.

The producer-side receive_room() doesn't need the ACCESS_ONCE()s because
the commit_head and canon_head are only modified by itself (as the
producer).

The consumer-side receive_room() doesn't need the ACCESS_ONCE()s either.
At least one compiler barrier is passed through on each loop in
n_tty_read(), and at least once before starting the loop.

>  	int left;
>  
>  	if (I_PARMRK(tty)) {
> -		/* Multiply read_cnt by 3, since each byte might take up to
> +		/* Multiply count by 3, since each byte might take up to
>  		 * three times as many spaces when PARMRK is set (depending on
>  		 * its flags, e.g. parity error). */
> -		left = N_TTY_BUF_SIZE - read_cnt(ldata) * 3 - 1;
> +		left = N_TTY_BUF_SIZE - (head - tail) * 3 - 1;
>  	} else
> -		left = N_TTY_BUF_SIZE - read_cnt(ldata) - 1;
> +		left = N_TTY_BUF_SIZE - (head - tail) - 1;
>  
>  	/*
>  	 * If we are doing input canonicalization, and there are no
> @@ -181,7 +179,7 @@ static int receive_room(struct tty_struct *tty)
>  	 * characters will be beeped.
>  	 */
>  	if (left <= 0)
> -		left = ldata->icanon && ldata->canon_head == ldata->read_tail;
> +		left = ldata->icanon && ACCESS_ONCE(ldata->canon_head) == tail;
>  
>  	return left;
>  }
> @@ -224,9 +222,9 @@ static ssize_t chars_in_buffer(struct tty_struct *tty)
>  	ssize_t n = 0;
>  
>  	if (!ldata->icanon)
> -		n = read_cnt(ldata);
> +		n = ACCESS_ONCE(ldata->commit_head) - ldata->read_tail;
>  	else
> -		n = ldata->canon_head - ldata->read_tail;
> +		n = ACCESS_ONCE(ldata->canon_head) - ldata->read_tail;

Existing compiler barriers in the consumer-side i/o loop make
these ACCESS_ONCE()s unnecessary (as with receive_room() and input_available_p()).

>  	return n;
>  }
>  
> @@ -313,10 +311,6 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
>   *
>   *	n_tty_receive_buf()/producer path:
>   *		caller holds non-exclusive termios_rwsem
> - *		modifies read_head
> - *
> - *	read_head is only considered 'published' if canonical mode is
> - *	not active.
>   */
>  
>  static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
> @@ -340,6 +334,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
>  {
>  	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
>  	ldata->echo_head = ldata->echo_tail = ldata->echo_commit = 0;
> +	ldata->commit_head = 0;

Ok.

>  	ldata->echo_mark = 0;
>  	ldata->line_start = 0;
>  
> @@ -987,10 +982,6 @@ static inline void finish_erasing(struct n_tty_data *ldata)
>   *
>   *	n_tty_receive_buf()/producer path:
>   *		caller holds non-exclusive termios_rwsem
> - *		modifies read_head
> - *
> - *	Modifying the read_head is not considered a publish in this context
> - *	because canonical mode is active -- only canon_head publishes
>   */
>  
>  static void eraser(unsigned char c, struct tty_struct *tty)
> @@ -1139,7 +1130,7 @@ static void isig(int sig, struct tty_struct *tty)
>   *
>   *	n_tty_receive_buf()/producer path:
>   *		caller holds non-exclusive termios_rwsem
> - *		publishes read_head via put_tty_queue()
> + *		publishes read_head as commit_head
>   *
>   *	Note: may get exclusive termios_rwsem if flushing input buffer
>   */
> @@ -1166,6 +1157,8 @@ static void n_tty_receive_break(struct tty_struct *tty)
>  		put_tty_queue('\0', ldata);
>  	}
>  	put_tty_queue('\0', ldata);
> +	/* publish read_head to consumer */
> +	smp_store_release(&ldata->commit_head, ldata->read_head);
>  	if (waitqueue_active(&tty->read_wait))
>  		wake_up_interruptible_poll(&tty->read_wait, POLLIN);

I intend to remove the wake_up (along with the comment changes above)
rather than add the publish.

It turns out that the wake_up cannot cause a userspace observable change,
that the wake_up() in __receive_buf() would not also guarantee.

Analysis:

Case 1) ICANON == true && L_EXTPROC == 0

        The canon_head has not advanced because there is no newline so
        input_available_p() is false for both n_tty_read() and n_tty_poll(),
        so nothing happens.

Case 2) ICANON == true && L_EXTPROC != 0

	The wake_up in __receive_buf() still happens when the input block
        finishes processing, which is an insignificant delay.

Case 3) ICANON == false and the following matrix applies:

        MIN_CHAR == 0             |          MIN_CHAR == 0
        TIME_CHAR != 0            |          TIME_CHAR == 0
                                  |
     minimum_to_wake => 1         |       minimum_to_wake => 1
                                  |
    ##  same as Case 2  ##        |      ##  same as Case 2  ##
                                  |
--------------------------------------------------------------------
                                  |
        MIN_CHAR != 0             |          MIN_CHAR != 0
        TIME_CHAR != 0            |          TIME_CHAR == 0
                                  |
     minimum_to_wake => 1         |     minimum_to_wake => MIN_CHAR()
                                  |
    ##  same as Case 2  ##        |        ##  see below  ##
                                  |

When MIN_CHAR != 0 && TIME_CHAR == 0, input_available_p() is false when
called from n_tty_poll() until minimum_to_wake # of chars has accumulated,
which is the same condition under which the wake_up will occur in __receive_buf().

Similarly, although input_available_p() is true when called from n_tty_read(),
the reader i/o loop will not return the buffer back to userspace until
minimum_to_wake # of chars has accumulated, which is the same condition under which
the wake_up will occur in __receive_buf().

>  }
> @@ -1209,7 +1202,7 @@ static void n_tty_receive_overrun(struct tty_struct *tty)
>   *
>   *	n_tty_receive_buf()/producer path:
>   *		caller holds non-exclusive termios_rwsem
> - *		publishes read_head via put_tty_queue()
> + *		publishes read_head as commit_head
>   */
>  static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
>  {
> @@ -1226,6 +1219,8 @@ static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
>  			put_tty_queue('\0', ldata);
>  	} else
>  		put_tty_queue(c, ldata);
> +	/* publish read_head to consumer */
> +	smp_store_release(&ldata->commit_head, ldata->read_head);
>  	if (waitqueue_active(&tty->read_wait))
>  		wake_up_interruptible_poll(&tty->read_wait, POLLIN);

Same as above.

>  }
> @@ -1263,7 +1258,6 @@ n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
>   *	n_tty_receive_buf()/producer path:
>   *		caller holds non-exclusive termios_rwsem
>   *		publishes canon_head if canonical mode is active
> - *		otherwise, publishes read_head via put_tty_queue()
>   *
>   *	Returns 1 if LNEXT was received, else returns 0
>   */
> @@ -1376,7 +1370,7 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
>  handle_newline:
>  			set_bit(ldata->read_head & (N_TTY_BUF_SIZE - 1), ldata->read_flags);
>  			put_tty_queue(c, ldata);
> -			ldata->canon_head = ldata->read_head;
> +			smp_store_release(&ldata->canon_head, ldata->read_head);

Required.

>  			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
>  			if (waitqueue_active(&tty->read_wait))
>  				wake_up_interruptible_poll(&tty->read_wait, POLLIN);
> @@ -1526,7 +1520,7 @@ n_tty_receive_char_lnext(struct tty_struct *tty, unsigned char c, char flag)
>   *
>   *	n_tty_receive_buf()/producer path:
>   *		claims non-exclusive termios_rwsem
> - *		publishes read_head and canon_head
> + *		publishes canon_head or commit_head

Ok.

>   */
>  
>  static void
> @@ -1534,10 +1528,11 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
>  			   char *fp, int count)
>  {
>  	struct n_tty_data *ldata = tty->disc_data;
> +	size_t tail = ACCESS_ONCE(ldata->read_tail);

Forcing the compiler to load from memory is not necessary here
since the read_tail will be loaded on each loop through
producer_side receive_room().

>  	size_t n, head;
>  
>  	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
> -	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
> +	n = N_TTY_BUF_SIZE - max(ldata->read_head - tail, head);

Not required since above change is unnecessary.

>  	n = min_t(size_t, count, n);
>  	memcpy(read_buf_addr(ldata, head), cp, n);
>  	ldata->read_head += n;
> @@ -1545,7 +1540,7 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
>  	count -= n;
>  
>  	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
> -	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
> +	n = N_TTY_BUF_SIZE - max(ldata->read_head - tail, head);

Same.

>  	n = min_t(size_t, count, n);
>  	memcpy(read_buf_addr(ldata, head), cp, n);
>  	ldata->read_head += n;
> @@ -1649,6 +1644,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
>  {
>  	struct n_tty_data *ldata = tty->disc_data;
>  	bool preops = I_ISTRIP(tty) || (I_IUCLC(tty) && L_IEXTEN(tty));
> +	size_t c;

Unnecessary. See next 2 comments.
>  
>  	if (ldata->real_raw)
>  		n_tty_receive_buf_real_raw(tty, cp, fp, count);
> @@ -1676,8 +1672,11 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
>  			tty->ops->flush_chars(tty);
>  	}
>  
> -	if ((!ldata->icanon && (read_cnt(ldata) >= ldata->minimum_to_wake)) ||
> -		L_EXTPROC(tty)) {
> +	/* publish read_head to consumer */
> +	smp_store_release(&ldata->commit_head, ldata->read_head);
> +	c = ldata->read_head - ACCESS_ONCE(ldata->read_tail);

ACCESS_ONCE(read_tail) is not required since the smp_store_release() is a
compiler barrier, so there can be no local cache of ldata->read_tail for
the compiler to skip loading read_tail.

> +
> +	if ((!ldata->icanon && c >= ldata->minimum_to_wake) || L_EXTPROC(tty)) {

At this point, the read_head == commit_head on this cpu so read_cnt() is
equivalent.

>  		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
>  		if (waitqueue_active(&tty->read_wait))
>  			wake_up_interruptible_poll(&tty->read_wait, POLLIN);
> @@ -1755,13 +1754,13 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
>  	if (!old || (old->c_lflag ^ tty->termios.c_lflag) & ICANON) {
>  		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
>  		ldata->line_start = ldata->read_tail;
> -		if (!L_ICANON(tty) || !read_cnt(ldata)) {
> +		if (!L_ICANON(tty) || ldata->commit_head == ldata->read_tail) {
>  			ldata->canon_head = ldata->read_tail;
>  			ldata->push = 0;
>  		} else {
> -			set_bit((ldata->read_head - 1) & (N_TTY_BUF_SIZE - 1),
> +			set_bit((ldata->commit_head - 1) & (N_TTY_BUF_SIZE - 1),
>  				ldata->read_flags);
> -			ldata->canon_head = ldata->read_head;
> +			ldata->canon_head = ldata->commit_head;

None of this is necessary because read_head == commit_head when the termios_rwsem
is write locked (as is the case here).


>  			ldata->push = 1;
>  		}
>  		ldata->erasing = 0;
> @@ -1903,9 +1902,9 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
>  	int amt = poll && !TIME_CHAR(tty) && MIN_CHAR(tty) ? MIN_CHAR(tty) : 1;
>  
>  	if (ldata->icanon && !L_EXTPROC(tty))
> -		return ldata->canon_head != ldata->read_tail;
> +		return ACCESS_ONCE(ldata->canon_head) != ldata->read_tail;

Unnecessary. At least one compiler barrier has been passed through to get here,
either by looping or first time.

>  	else
> -		return read_cnt(ldata) >= amt;
> +		return ACCESS_ONCE(ldata->commit_head) - ldata->read_tail >= amt;

The ACCESS_ONCE() is not required, for the same reason as above.
But using commit_head instead of read_head is required, so this should be:

		return ldata->commit_head - ldata->read_tail >= amt;

>  }
>  
>  /**
> @@ -1938,9 +1937,10 @@ static int copy_from_read_buf(struct tty_struct *tty,
>  	size_t n;
>  	bool is_eof;
>  	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
> +	size_t head = smp_load_acquire(&ldata->commit_head);
>  
>  	retval = 0;
> -	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
> +	n = min(head - ldata->read_tail, N_TTY_BUF_SIZE - tail);



>  	n = min(*nr, n);
>  	if (n) {
>  		retval = copy_to_user(*b, read_buf_addr(ldata, tail), n);
> @@ -1948,9 +1948,10 @@ static int copy_from_read_buf(struct tty_struct *tty,
>  		is_eof = n == 1 && read_buf(ldata, tail) == EOF_CHAR(tty);
>  		tty_audit_add_data(tty, read_buf_addr(ldata, tail), n,
>  				ldata->icanon);
> -		ldata->read_tail += n;
> +		smp_store_release(&ldata->read_tail, ldata->read_tail + n);

Absolutely required. Ensures that the read_buf data has actually been loaded
by this cpu before the other cpu running the producer side can observe the
read_tail advancing and overwriting the read_buf data.

>  		/* Turn single EOF into zero-length read */
> -		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !read_cnt(ldata))
> +		if (L_EXTPROC(tty) && ldata->icanon && is_eof &&
> +		    (head == ldata->read_tail))

Required since commit_head is now the observed producer buffer index
(instead of read_head).

>  			n = 0;
>  		*b += n;
>  		*nr -= n;
> @@ -1993,7 +1994,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
>  	bool eof_push = 0;
>  
>  	/* N.B. avoid overrun if nr == 0 */
> -	n = min(*nr, read_cnt(ldata));
> +	n = min(*nr, smp_load_acquire(&ldata->canon_head) - ldata->read_tail);

Absolutely required to guarantee the buffer data has been written by the
producer. Keep.

>  	if (!n)
>  		return 0;
>  
> @@ -2043,8 +2044,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
>  
>  	if (found)
>  		clear_bit(eol, ldata->read_flags);
> -	smp_mb__after_atomic();
> -	ldata->read_tail += c;
> +	smp_store_release(&ldata->read_tail, ldata->read_tail + c);

Strictly speaking, this is the same thing so not really necessary, but
I think it does a better job of self-documenting. Keep.

>  
>  	if (found) {
>  		if (!ldata->push)
> @@ -2458,7 +2458,7 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
>  		if (L_ICANON(tty))
>  			retval = inq_canon(ldata);
>  		else
> -			retval = read_cnt(ldata);
> +			retval = ldata->commit_head - ldata->read_tail;

Unnecessary. read_head == commit_head when termios_rwsem is write-locked,
as is the case here.

>  		up_write(&tty->termios_rwsem);
>  		return put_user(retval, (unsigned int __user *) arg);
>  	default:
> 

