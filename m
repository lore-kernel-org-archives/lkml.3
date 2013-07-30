Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3G3NPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:15:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:45119 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3G3NPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:15:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Maximiliano Curia <maxy@gnuservers.com.ar>
Subject: Re: Large pastes into readline enabled programs causes breakage from v2.6.31 onwards
Date: Tue, 30 Jul 2013 14:41:14 +0200
Organization: GnuServers
Message-ID: <asokca-mgs.ln1@freak.gnuservers.com.ar>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <51F1B015.50804@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 178-26-57-211-dynip.superkabel.de
Mail-Copies-To: maxy@gnuservers.com.ar
User-Agent: KNode/4.10.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:

> readline is fundamentally incompatible with an active writer.

This wasn't the case with older kernel versions. I don't see any POSIX 
reference that claims user input could be lost setting termios so I think 
this is a serious regression.

Also, consider the readline use cases. bash, for instance, uses readline to 
process the command lines entered, but needs to change the termios to a 
canonical mode for each entered command. I would expect that pasting a 
sequence of commands (of 4K, which is not even 'a lot') to work.

The same is true for psql, where users might paste several KB of queries, or 
almost every readline enabled "shell".

> readline() saves and restores the termios settings for each input
> line it reads. However, tty i/o is asynchronous in the kernel.
> This means that when readline() restores the original termios
> settings, any new data received by the tty will be interpreted
> with the current, original termios settings.

> When a large paste happens, the tty/line discipline read buffer
> quickly fills up (to 4k). When full, further input is forced to
> wait. After readline() reads an input line, more space becomes
> available in the read buffer. Unfortunately, this event roughly
> coincides with restoring the original termios settings, and
> thus increases the probability that more paste data will be
> received with the wrong termios settings.

> That's why the patches that involve scheduling the receive
> buffer work seem to have some effect on the outcome.

It's not totally clear to me why receiving characters with the wrong termios 
settings might lead to this characters being dropped when reading them with 
different settings.

I took a deep look into the code, trying to find where was the code that ended 
up dropping characters, but could not find it.
Could you maybe point me to it?

> As you've already noted, readline() termios settings are
> substantially different than the default termios settings.
> 
> Below I've included a simple test jig that
>   1) sets termios to the same settings as readline()
>   2) uses the same read() method as readline()
>   3) outputs what it reads to stdout
>   4) restores the original termios

I've updated your code the be closer to the readline behaviour. readline 
calls tcsetattr with TCSADRAIN, and not TCSAFLUSH which explictly claims to 
discard the input. I've also reordered the call to process lines, and 
initialized the int c.

--- >% ---
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <stdlib.h>

void init(int *eof, struct termios* save)
{
    int err;
    static struct termios termios;

    err = tcgetattr(STDIN_FILENO, &termios);
    if (err < 0)
        exit(EXIT_FAILURE);
    *save = termios;

    termios.c_lflag &= ~(ICANON | ECHO | ISIG);
    termios.c_iflag &= ~(IXON | IXOFF);
    if ((termios.c_cflag & CSIZE) == CS8)
        termios.c_iflag &= ~(ISTRIP | INPCK);
    termios.c_iflag &= ~(ICRNL | INLCR);
    termios.c_cc[VMIN] = 1;
    termios.c_cc[VTIME] = 0;
    termios.c_cc[VLNEXT] = _POSIX_VDISABLE;
    *eof = termios.c_cc[VEOF];

    err = tcsetattr(STDIN_FILENO, TCSADRAIN, &termios);
    if (err < 0)
        exit(EXIT_FAILURE);
}

void deinit(struct termios* termios)
{
    int err;
    err = tcsetattr(STDIN_FILENO, TCSADRAIN, termios);
    if (err < 0)
        exit(EXIT_FAILURE);
}

int main(int argc, char* argv[])
{
    int c=0, eof;
    ssize_t actual;
    struct termios save;

    while (1) {
        init(&eof, &save);
        while (1) {
            actual = read(fileno(stdin), &c, sizeof(unsigned char));
            if (actual <= 0)
                break;
            if (actual == sizeof(unsigned char)) {
                if (c == eof)
                    break;
                if (c == '\r') {
                    c = '\n';
                }
                fputc(c, stdout);
                fflush(stdout);
                if (c == '\n') break;
            }
        }
        deinit(&save);
        if (c == eof) break;
    }

    return 0;
}
--- >% ---

-- 
"Seek simplicity, and distrust it." -- Whitehead's Rule
Saludos /\/\ /\ >< `/


