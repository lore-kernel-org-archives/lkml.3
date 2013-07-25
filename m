Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3GYXJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:09:16 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37701 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756972Ab3GYXJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:09:13 -0400
Message-ID: <51F1B015.50804@hurleysoftware.com>
Date: Thu, 25 Jul 2013 19:09:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Margarita Manterola <margamanterola@gmail.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        Maximiliano Curia <maxy@gnuservers.com.ar>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
In-Reply-To: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 07:29 AM, Margarita Manterola wrote:
> Hi,
>
> The problem:
> Large pastes (5k or more) into a readline enabled program fail when
> running kernels larger than v2.6.31-rc5.  "Fail" means that some lines
> are incomplete.  From v2.6.39-rc1 onwards, "some lines" become "almost
> all lines after the first 4k".  This turns up at least in Fedora,
> Debian, Ubuntu and Gentoo.  From our findings, it should happen in any
> readline enabled program on a system running kernels later than the
> mentioned ones.
>
> The problematic commits in the kernel tree:
> 1 - 2009-07-27 (never shipped) -
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3a54297478e6578f96fd54bf4daa1751130aca86
>
> After this commit, pastes start breaking.  For a 35k file, about 50%
> of the times one or two lines are partially incomplete.
>
> 2 - 2009-07-29 (v2.6.31-rc5) -
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
>
> This commit reverts the previous one, but adds one extra call to
> flush_to_ldisc.  Pastes still break, commenting out the function call
> prevents breakage *up to 2.6.39-rc1*.
>
> 3 - 2011-03-22 (v2.6.39-rc1) -
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f23eb2b2b28547fc70df82dd5049eb39bec5ba12
>
> This commit changes many schedule/flush/cancel_delayed_work calls into
> schedule/flush/cancel_work.  After this commit, the big breakage
> starts: for the 35k example file, it starts breaking at aprox. 4k and
> then every line is partially incomplete or directly not there.
>
> Still after this commit, commenting out the tty_flush_to_ldisc(tty)
> call added by e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 prevents the
> breakage.
>
> 4 - 2011-04-04 (v2.6.39-rc2) -
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a5660b41af6a28f8004e70eb261e1202ad55c5e3
>
> This commit modifies the behaviour of how the ttys are polled.  After
> this commit, commenting out the tty_flush_to_ldisc(tty) call doesn't
> prevent breakage anymore.
>
> But then re-adding the call to schedule_work(&tty->buf.work) that was
> removed in this commit, prevents the breakage even up to 3.11-rc2.
> I'm attaching a diff of the patch that we applied, just to show what
> had to be done, this is not a proposed fix, because this does cause a
> busy loop that is particularly noticeable in VMs.
>
> We haven't yet found a good fix for this issue, but we believe that
> pasting into readline enabled programs shouldn't cause characters to
> get lost, and it should be possible to do that properly without the
> busy loop.
>
> ***
> This was originally reported as a bug in readline, but it was found
> that going back to very old kernels prevented the issue, regardless of
> the version of readline.
>
> Original Report (2012-06-25):
> http://lists.gnu.org/archive/html/bug-readline/2012-06/msg00006.html
> Follow Up thread (2013-07-22):
> http://lists.gnu.org/archive/html/bug-readline/2013-07/msg00006.html
>
> I'm attaching here a very simple readline enabled program that helps
> with performing tests.  Compile, run, then copy and paste a large
> enough file into it, close and diff.
>
> Looking at the code in readline, the issue is triggered by these lines
> in rltty.c, while preparing the input:
>
> tiop->c_lflag &= ~(ICANON | ECHO);
> (...)
> tiop->c_iflag &= ~(ICRNL | INLCR);
>
> If those two lines are replaced by:
>
> tiop->c_lflag &= ~(ECHO);
> (...)
> tiop->c_iflag &= ~(INLCR);
>
> Then the pastes work fine: no lines are missing.  Of course, this
> means that readline doesn't work properly, but this is just to note
> that those are the terminal settings that cause the issue to pop-up.
>
> Credit: this investigation was done together with Maximiliano Curia.
>

readline is fundamentally incompatible with an active writer.

readline() saves and restores the termios settings for each input
line it reads. However, tty i/o is asynchronous in the kernel.
This means that when readline() restores the original termios
settings, any new data received by the tty will be interpreted
with the current, original termios settings.

When a large paste happens, the tty/line discipline read buffer
quickly fills up (to 4k). When full, further input is forced to
wait. After readline() reads an input line, more space becomes
available in the read buffer. Unfortunately, this event roughly
coincides with restoring the original termios settings, and
thus increases the probability that more paste data will be
received with the wrong termios settings.

That's why the patches that involve scheduling the receive
buffer work seem to have some effect on the outcome.

As you've already noted, readline() termios settings are
substantially different than the default termios settings.

Below I've included a simple test jig that
  1) sets termios to the same settings as readline()
  2) uses the same read() method as readline()
  3) outputs what it reads to stdout
  4) restores the original termios

Note that the test jig differs from readline() in that
it reads _all_ the available input without changing
termios.

The test jig will identically duplicate a large paste. Feel
free to modify the test jig to change the termios settings
per-line.

Regards,
Peter Hurley


[ NB: In the test jig, I didn't bother with ensuring eof is
the first input of a new line.

I converted CR -> NL because that's what your test
program does, in conjunction with readline(). Pasted lines
are CR-terminated; readline() returns the input line less the
CR; your test program prints the line followed by NL.

]

--- >% ---
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {

	int c, eof;
         ssize_t actual;
	struct termios termios, save;
	int err;

	err = tcgetattr(STDIN_FILENO, &termios);
	if (err < 0)
		exit(EXIT_FAILURE);

	save = termios;

	termios.c_lflag &= ~(ICANON | ECHO | ISIG);
	termios.c_iflag &= ~(IXON | IXOFF);
	if ((termios.c_cflag & CSIZE) == CS8)
		termios.c_iflag &= ~(ISTRIP | INPCK);
	termios.c_iflag &= ~(ICRNL | INLCR);
	termios.c_cc[VMIN] = 1;
	termios.c_cc[VTIME] = 0;
	termios.c_cc[VLNEXT] = _POSIX_VDISABLE;
	eof = termios.c_cc[VEOF];

	err = tcsetattr(STDIN_FILENO, TCSANOW, &termios);
	if (err < 0)
		exit(EXIT_FAILURE);

	while (1) {
		actual = read( fileno(stdin), &c, sizeof(unsigned char));
		if (actual <= 0)
			break;
		if (actual == sizeof(unsigned char)) {
			if (c == eof)
				break;
			if (c == '\r')
				c = '\n';
			fputc(c, stdout);
		}
		fflush(stdout);
	}

	err = tcsetattr(STDIN_FILENO, TCSAFLUSH, &save);
	if (err < 0)
		exit(EXIT_FAILURE);

	return 0;
}

