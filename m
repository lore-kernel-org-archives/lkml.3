Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3EHSc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:32:29 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:41465 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757561Ab3EHSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:32:27 -0400
Message-ID: <518A9A37.9000405@hurleysoftware.com>
Date: Wed, 08 May 2013 14:32:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]TTY: Fix tty can't be restarted by TCXONC ioctl request
References: <20130507184734.GA2459@udknight> <20130507185800.GA10713@kroah.com> <20130508015545.GA1937@udknight> <20130508020200.GA15695@kroah.com> <20130508131624.GA1938@udknight> <518A6CAF.9020301@hurleysoftware.com> <20130508171247.GA6925@udknight>
In-Reply-To: <20130508171247.GA6925@udknight>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 01:12 PM, Wang YanQing wrote:
> On Wed, May 08, 2013 at 11:18:07AM -0400, Peter Hurley wrote:
>> On 05/08/2013 09:16 AM, Wang YanQing wrote:
>>> On Tue, May 07, 2013 at 07:02:00PM -0700, Greg KH wrote:
>>>> What about Peter's comments on this patch?
>>>>
>>> Peter's comments will import policy,
>>>
>>> I means we should let userspace to decide whether
>>> and when to restart tty with the mechanism of TCXONC
>>> instead of restart tty accidental when make n_tty_set_termios
>>> call.
>>
>> There would be no accidental restart. Userspace is specifically
>> disabling user-controlled output flow control by clearing
>> IXON in termios. Userspace is _expecting_ a 'started' tty.
>>
>> If you insist that this must be controllable from userspace,
>> then that is already possible:
>>
>> 	tcflow(fd, TCOOFF);
>> 	tcflow(fd, TCOON);
>
> Indeed you can't do what you said with TCOOFF and TCOON
> if you read the codes, that's what this patch fix.

Perhaps you misunderstood. The snippet above does indeed restart
a tty which has been stopped via STOP_CHAR(tty) and the termios
IXON flag cleared.

Below is a testcase which demonstrates the problem and
the userspace workaround from above.

--- >% ---
/**
  *	tty_unstop.c
  *
  *	Description: testcase for unsticking stopped tty from userspace
  *
  *	To build testcase:
  *	  gcc tty_unstop.c -o tty_unstop
  *
  *	To build exemplar userspace workaround:
  *	  gcc -D FIX_STOPPED_TTY tty_unstop.c -o tty_unstop
  */

#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <stdarg.h>

static void error_exit(char *f, ...)
{
	va_list va;

	va_start(va, f);
	vprintf(f, va);
	printf(": %s\n", strerror(errno));
	va_end(va);

	exit(EXIT_FAILURE);
}

int main(int argc, char *argv[]) {
	struct termios termios, save;
	char buffer[MAX_CANON];
	int err;
	ssize_t n;

	printf("Pause terminal now with Ctrl+S\n");
	sleep(5);

	err = tcgetattr(STDIN_FILENO, &termios);
	if (err < 0)
		error_exit("tcgetattr");

	save = termios;
	termios.c_iflag &= ~IXON;

	err = tcsetattr(STDIN_FILENO, TCSANOW, &termios);
	if (err < 0)
		error_exit("tcsetattr");

#ifdef FIX_STOPPED_TTY
	tcflow(STDIN_FILENO, TCOOFF);
	tcflow(STDIN_FILENO, TCOON);
#endif

	printf("Enter some text: ");
	fflush(stdout);
	n = read(STDIN_FILENO, buffer, sizeof(buffer));
	if (n < 0)
		error_exit("read");

	printf("%.*s", (int)n, buffer);

	err = tcsetattr(STDIN_FILENO, TCSAFLUSH, &save);
	if (err < 0)
		error_exit("tcsetattr");
	return 0;
}

