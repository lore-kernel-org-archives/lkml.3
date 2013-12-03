Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3LCATG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:19:06 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38418 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766Ab3LCATC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:19:02 -0500
Message-ID: <529D236E.4020002@hurleysoftware.com>
Date: Mon, 02 Dec 2013 19:18:54 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Stas Sergeev <stsp@users.sourceforge.net>
CC: Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <5291E92F.7010609@hurleysoftware.com> <1385428582-5577-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1385428582-5577-1-git-send-email-peter@hurleysoftware.com>
Content-Type: multipart/mixed;
 boundary="------------080503040809070104070708"
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080503040809070104070708
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/2013 08:16 PM, Peter Hurley wrote:
> On 11/24/2013 06:55 AM, Peter Hurley wrote:
>> On 11/23/2013 07:29 PM, One Thousand Gnomes wrote:
>>>> 7) Rescan line discipline buffer when changing from non-canonical to canonical
>>>> mode. The real problem with this approach (besides the inefficiency) is that this
>>>> solution could break some (admittedly unknown) program that contrived to exchange
>>>> data in non-canonical mode but read in canonical mode (just not exceeding the
>>>> line discipline buffer limit).
>>>
>>> See bugzilla 55981, 55991 btw
>>
>> Thanks for the bug references, Alan.
>>
>> The solution proposed in 55991 (to perform an EOF push when switching from
>> non-canon to canon) would further break paste to readline().
>>
>> The caller to readline() may not actually perform any read() but may
>> simply loop, calling readline();  in this case, when readline()
>> switches back to non-canonical, it will eventually read the inserted '\0'.
>> That would be bad.
>
> Stas Sergeev (the reporter of kernel bug# 55991) had proposed a
> solution allowing data in the read buffer to become immediately
> available for read when switching to canonical mode.
>
> With one minor change, the proposed solution appears to solve the
> readline() paste overflow problem (at least, that's the result of
> my testing on the test bench originally provided by Margarita
> earlier in the thread).
>
> This patch should apply cleanly to 3.13-rc1+ (or to 3.12-final+ with
> 'git am -C1 <patch_file_name>'.
>
> Please test ASAP as I'd like to see this in 3.13. I'll backport it
> to the stable kernels once this is in mainline.

Unfortunately, this patch breaks EOF push handling.

Normally, when an EOF is found not at the line start, the output
is made available to a canonical reader (without the EOF) -- this is
commonly referred to as EOF push. An EOF at the beginning of a line
forces the read to return 0 bytes read, which the caller interprets
as an end-of-file and discontinues reading.

Since this patch simulates an EOF push, an actual EOF push that
follows will appear to be an EOF at the beginning of a line and
cause read to return 0, thus indicating premature end-of-file.

I've attached a simulation testcase that shows the unexpected EOF.

I think this general approach is still the way forward with this bug
but I need to ponder how the simulated EOF push state can properly be
distinguished from the other eol conditions in canon_copy_from_read_buf()
so line_start is not reset to the read_tail.

Regards,
Peter Hurley

> --- >% ---
> Subject: [PATCH v2] n_tty: Fix buffer overruns with larger-than-4k pastes
>
> readline() inadvertently triggers an error recovery path when
> pastes larger than 4k overrun the line discipline buffer. The
> error recovery path discards input when the line discipline buffer
> is full and operating in canonical mode and no newline has been
> received. Because readline() changes the termios to non-canonical
> mode to read the line char-by-char, the line discipline buffer
> can become full, and then when readline() restores termios back
> to canonical mode for the caller, the now-full line discipline
> buffer triggers the error recovery.
>
> When changing termios from non-canon to canon mode and the read
> buffer contains data, simulate an EOF push _without_ the
> DISABLED_CHAR in the read buffer. canon_copy_to_read_buf()
> correctly interprets this condition and will return data in the
> read buffer as one line.
>
> Importantly for the readline() problem, the termios can be
> changed back to non-canonical mode without changes to the read
> buffer occurring; ie., as if the previous termios change had not
> happened (as long as no intervening read took place).
>
> Patch based on original proposal and discussion here
> https://bugzilla.kernel.org/show_bug.cgi?id=55991
> by Stas Sergeev <stsp@users.sourceforge.net>
>
> Reported-by: Margarita Manterola <margamanterola@gmail.com>
> Cc: Maximiliano Curia <maxy@gnuservers.com.ar>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
> Acked-by: Stas Sergeev <stsp@users.sourceforge.net>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>   drivers/tty/n_tty.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 3919ced..2184d7b 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -1778,7 +1778,13 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
>
>   	if (!old || (old->c_lflag ^ tty->termios.c_lflag) & ICANON) {
>   		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
> -		ldata->line_start = ldata->canon_head = ldata->read_tail;
> +		if (!L_ICANON(tty) || !read_cnt(ldata))
> +			ldata->line_start = ldata->canon_head = ldata->read_tail;
> +		else {
> +			set_bit((ldata->read_head - 1) & (N_TTY_BUF_SIZE - 1),
> +				ldata->read_flags);
> +			ldata->canon_head = ldata->read_head;
> +		}
>   		ldata->erasing = 0;
>   		ldata->lnext = 0;
>   	}
> @@ -1993,6 +1999,12 @@ static int copy_from_read_buf(struct tty_struct *tty,
>    *	it copies one line of input up to and including the line-delimiting
>    *	character into the user-space buffer.
>    *
> + *	NB: When termios is changed from non-canonical to canonical mode and
> + *	the read buffer contains data, n_tty_set_termios() simulates an EOF
> + *	push (as if C-d were input) _without_ the DISABLED_CHAR in the buffer.
> + *	This causes data already processed as input to be immediately available
> + *	as input although a newline has not been received.
> + *
>    *	Called under the atomic_read_lock mutex
>    *
>    *	n_tty_read()/consumer path:
>


--------------080503040809070104070708
Content-Type: text/x-csrc;
 name="canon_switch2.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="canon_switch2.c"

/*
 * canon_switch2.c
 *
 * Test read() after non-canon -> canon switch
 *  w/ EOL push immediately after
 *
 *    gcc -Wall -o canon_switch canon_switch.c
 *
 * Based on orginal code by Ilya Zykov <ilya@ilyx.ru>
 */

#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <poll.h>
#include <sys/wait.h>

static int fd;

static void error_exit(char *f, ...) {
	va_list va;

	va_start(va, f);
	vprintf(f, va);
	if (errno)
		printf(": %s (code: %d)\n", strerror(errno), errno);
	else
		printf("\n");
	va_end(va);

	if (fd >= 0)
		close(fd);

	exit(EXIT_FAILURE);
}

static void fill_pattern(char *pattern, size_t len) {
	size_t i, n;
	const char test[] = "1234567890";

	n = strlen(test);
	for (i = 0; i <= len - n; i += n)
		strncpy(&pattern[i], test, n);
	strncpy(&pattern[i], test, len % n);
}

int main(int argc, char *argv[]) {
	int child_id;
	char pts_name[24];
	int ptn, unlock = 0;
	struct termios termios, save;

	setbuf(stdout, NULL);

	fd = open("/dev/ptmx", O_RDWR);
	if (fd < 0)
		error_exit("opening pty master");
	if (ioctl(fd, TIOCGPTN, &ptn) < 0)
		error_exit("getting pty #");
	if (ioctl(fd, TIOCSPTLCK, &unlock) < 0)
                error_exit("unlocking pty pair");
        snprintf(pts_name, sizeof(pts_name), "/dev/pts/%d", ptn);

	if (tcgetattr(fd, &termios) < 0)
		error_exit("tcgetattr");
	save = termios;
	termios.c_lflag &= ~(ICANON | ECHO | ISIG);
	termios.c_iflag &= ~(IXON | IXOFF | ICRNL | INLCR);
	if ((termios.c_cflag & CSIZE) == CS8)
		termios.c_cflag &= ~(ISTRIP | INPCK);
	termios.c_cc[VMIN] = 1;
	termios.c_cc[VTIME] = 0;
	termios.c_cc[VLNEXT] = _POSIX_VDISABLE;
	termios.c_oflag &= ~OPOST;
	if (tcsetattr(fd, TCSAFLUSH, &termios) < 0)
		error_exit("tcsetattr master");

	child_id = fork();
	switch (child_id) {
	case -1: error_exit("forking child");

	case 0:	{ /* child */
		printf("Child [%ld] on slave pty %s\n", (long)getpid(), pts_name);

		close(fd);	/* master pty no longer needed */

		fd = open(pts_name, O_RDWR);
		if (fd < 0)
			error_exit("opening pty slave");

		/* wait for master write in non-canon mode */
		{
			struct pollfd pollfds[1] = { { fd, POLLIN },
						   };
			poll(pollfds, 1, -1);
		}

		sleep(1);

		if (tcsetattr(fd, TCSANOW, &save))
			error_exit("tcsetattr restore");

		{
			char buf[8192];
			int n;

			n = read(fd, buf, sizeof(buf));
			if (n < 0)
				error_exit("slave reading");
			printf("read: %d\n", n);
			printf("%.*s", n, buf);

			n = read(fd, buf, sizeof(buf));
			if (n < 0)
				error_exit("slave reading");
			printf("read: %d\n", n);
			if (n == 0)
				error_exit("unexpected EOF");
			printf("%.*s", n, buf);

			n = read(fd, buf, sizeof(buf));
			if (n < 0)
				error_exit("slave reading");
			printf("read: %d\n", n);
			printf("%.*s", n, buf);
		}

		close(fd);
		}
		return 0;

	default: { /* parent */
		int n, id, status, c;

		char pattern[4096];
		char pattern2[] = "The quick brown fox jumped over the lazy dog.\r";

		/* Simulate an input pattern that was supposed to be
		 * all 4096 chars of pattern (which terminates in an EOF push)
		 * but was received as 4095 (because that's the maximum raw mode
		 * allows in the input buffer at once).
		 */
		fill_pattern(pattern, sizeof(pattern));
		pattern[4095] = termios.c_cc[VEOF];
		c = 4096;
		n = write(fd, pattern, c);
		if (n < 0)
			error_exit("master writing");
		printf("write: %d, wrote: %d\n", c, n);

		c = strlen(pattern2);
		n = write(fd, pattern2, c);
		if (n < 0)
			error_exit("master writing");
		printf("write: %d, wrote: %d\n", c, n);

		id = waitpid(child_id, &status, 0);
		if (id < 0 || id != child_id)
			error_exit("waiting for child");
		printf("[%ld] exited status: %d\n", (long) child_id, status);
		}
		return 0;
	}
}

--------------080503040809070104070708--
