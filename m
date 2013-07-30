Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3G3QIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:08:20 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:44391 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751040Ab3G3QIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:08:19 -0400
Message-ID: <51F7E4ED.4050409@hurleysoftware.com>
Date: Tue, 30 Jul 2013 12:08:13 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maximiliano Curia <maxy@gnuservers.com.ar>
CC: Margarita Manterola <margamanterola@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <51F1B015.50804@hurleysoftware.com> <20130730124117.41DC55E4006@freak.gnuservers.com.ar>
In-Reply-To: <20130730124117.41DC55E4006@freak.gnuservers.com.ar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't drop CCs.

[ +cc Margarita Manterola, Greg Kroah-Hartman, Jiri Slaby, linux-kernel ]

On 07/30/2013 08:41 AM, Maximiliano Curia wrote:
> Peter Hurley wrote:
>
>> readline is fundamentally incompatible with an active writer.
>
> This wasn't the case with older kernel versions. I don't see any POSIX
> reference that claims user input could be lost setting termios so I think
> this is a serious regression.

I'm only interested in this discussion on the basis of a kernel
regression, because this behavior is fully POSIX compliant.

 From POSIX 2008, Section 11. General Terminal Interface, Part 11.1.6.
Canonical Mode Input Processing:

      In canonical mode input processing, terminal input is processed in
      units of lines. A line is delimited by a <newline> character (NL),
      an end-of-file character (EOF), or an end-of-line (EOL) character.
      See Special Characters for more information on EOF and EOL. This
      means that a read request shall not return until an entire line has
      been typed or a signal has been received. Also, no matter how many
      bytes are requested in the read() call, at most one line shall be
      returned. It is not, however, necessary to read a whole line at once;
      any number of bytes, even one, may be requested in a read() without
      losing information.

      If {MAX_CANON} is defined for this terminal device, it shall be a
      limit on the number of bytes in a line. The behavior of the system
      when this limit is exceeded is implementation-defined.


In other words, while processing input in canonical mode, the system may
discard input in excess of MAX_CANON until a NL character is received.
Linux defines MAX_CANON as 255.


> Also, consider the readline use cases. bash, for instance, uses readline to
> process the command lines entered, but needs to change the termios to a
> canonical mode for each entered command. I would expect that pasting a
> sequence of commands (of 4K, which is not even 'a lot') to work.
>
> The same is true for psql, where users might paste several KB of queries, or
> almost every readline enabled "shell".
>
>> readline() saves and restores the termios settings for each input
>> line it reads. However, tty i/o is asynchronous in the kernel.
>> This means that when readline() restores the original termios
>> settings, any new data received by the tty will be interpreted
>> with the current, original termios settings.
>
>> When a large paste happens, the tty/line discipline read buffer
>> quickly fills up (to 4k). When full, further input is forced to
>> wait. After readline() reads an input line, more space becomes
>> available in the read buffer. Unfortunately, this event roughly
>> coincides with restoring the original termios settings, and
>> thus increases the probability that more paste data will be
>> received with the wrong termios settings.
>
>> That's why the patches that involve scheduling the receive
>> buffer work seem to have some effect on the outcome.
>
> It's not totally clear to me why receiving characters with the wrong termios
> settings might lead to this characters being dropped when reading them with
> different settings.

Many termios settings are applied when the input is received rather than when
the application reads them.

Here's an example sequence:

1. termios is set to non-canonical mode
2. the input buffer is filled with paste data (although unknown to the kernel
    there is more paste data which has not yet been received). The paste data
    contains CR as line delimiter.
3. the input buffer is read character-by-character until the first CR is found.
4. termios is set to canonical mode but ICRNL is not set.
5. the writer thread is woken because more space has become available in the
    input buffer.
6. more paste data is received in canonical mode but a NL cannot be found
    (because there are only CRs in the paste data).
7. the system discards this input to prevent already received data from being
    overrun and continues to do so until a NL is found (or termios is set back
    to non-canonical mode).


> I took a deep look into the code, trying to find where was the code that ended
> up dropping characters, but could not find it.
> Could you maybe point me to it?

n_tty_set_room() in drivers/tty/n_tty.c (3.10 mainline)

 From n_tty_set_room():

	/*
	 * If we are doing input canonicalization, and there are no
	 * pending newlines, let characters through without limit, so
	 * that erase characters will be handled.  Other excess
	 * characters will be beeped.
	 */
	if (left <= 0)
		left = ldata->icanon && !ldata->canon_data;
	old_left = tty->receive_room;
	tty->receive_room = left;


The code means that if the input buffer is full and ICANON is set and
a NL has not been received yet, still report that space for 1 char
is available in the input buffer.

When the character is actually received and interpreted, if there is
no space in the input buffer, the character is dropped. If ECHO is set,
a '\a' (bell) is written to the tty's output.


>> As you've already noted, readline() termios settings are
>> substantially different than the default termios settings.
>>
>> Below I've included a simple test jig that
>>    1) sets termios to the same settings as readline()
>>    2) uses the same read() method as readline()
>>    3) outputs what it reads to stdout
>>    4) restores the original termios
>
> I've updated your code the be closer to the readline behaviour.

That's why I wrote the test jig: to show the paste data was
received error-free with _exactly_ the same termios settings
that readline() uses.

Re-introducing setting and unsetting termios simply confirms
what I already diagnosed.

Regards,
Peter Hurley


> readline calls tcsetattr with TCSADRAIN, and not TCSAFLUSH which explictly
> claims to discard the input. I've also reordered the call to process lines,
> and initialized the int c.
>
> --- >% ---
> #include <stdio.h>
> #include <termios.h>
> #include <unistd.h>
> #include <stdlib.h>
>
> void init(int *eof, struct termios* save)
> {
>      int err;
>      static struct termios termios;
>
>      err = tcgetattr(STDIN_FILENO, &termios);
>      if (err < 0)
>          exit(EXIT_FAILURE);
>      *save = termios;
>
>      termios.c_lflag &= ~(ICANON | ECHO | ISIG);
>      termios.c_iflag &= ~(IXON | IXOFF);
>      if ((termios.c_cflag & CSIZE) == CS8)
>          termios.c_iflag &= ~(ISTRIP | INPCK);
>      termios.c_iflag &= ~(ICRNL | INLCR);
>      termios.c_cc[VMIN] = 1;
>      termios.c_cc[VTIME] = 0;
>      termios.c_cc[VLNEXT] = _POSIX_VDISABLE;
>      *eof = termios.c_cc[VEOF];
>
>      err = tcsetattr(STDIN_FILENO, TCSADRAIN, &termios);
>      if (err < 0)
>          exit(EXIT_FAILURE);
> }
>
> void deinit(struct termios* termios)
> {
>      int err;
>      err = tcsetattr(STDIN_FILENO, TCSADRAIN, termios);
>      if (err < 0)
>          exit(EXIT_FAILURE);
> }
>
> int main(int argc, char* argv[])
> {
>      int c=0, eof;
>      ssize_t actual;
>      struct termios save;
>
>      while (1) {
>          init(&eof, &save);
>          while (1) {
>              actual = read(fileno(stdin), &c, sizeof(unsigned char));
>              if (actual <= 0)
>                  break;
>              if (actual == sizeof(unsigned char)) {
>                  if (c == eof)
>                      break;
>                  if (c == '\r') {
>                      c = '\n';
>                  }
>                  fputc(c, stdout);
>                  fflush(stdout);
>                  if (c == '\n') break;
>              }
>          }
>          deinit(&save);
>          if (c == eof) break;
>      }
>
>      return 0;
> }
> --- >% ---
>

