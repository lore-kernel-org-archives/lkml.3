Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaJLVgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 17:36:49 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:50348 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaJLVgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 17:36:47 -0400
From: Nix <nix@esperi.org.uk>
To: Johan Hovold <johan@kernel.org>
Cc: Paul Martin <pm@debian.org>, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <878um4tg09.fsf@spindle.srvr.nix>
	<1409569752.24385.12.camel@linux-fkkt.site>
	<874mwnosz1.fsf@spindle.srvr.nix> <871tqe2zqt.fsf_-_@spindle.srvr.nix>
	<20141011195108.GA8275@thinkpad.nowster.org.uk>
	<87y4smz1l0.fsf@spindle.srvr.nix> <20141012185845.GB2786@localhost>
Emacs: no job too big... no job.
Date: Sun, 12 Oct 2014 22:36:30 +0100
In-Reply-To: <20141012185845.GB2786@localhost> (Johan Hovold's message of
	"Sun, 12 Oct 2014 20:58:45 +0200")
Message-ID: <878uklynq9.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-INFN-TO-Metrics: spindle 1233; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Oct 2014, Johan Hovold verbalised:

> On Sat, Oct 11, 2014 at 11:24:59PM +0100, Nix wrote:
>> On 11 Oct 2014, Paul Martin spake thusly:
>> 
>> > Having been privy to the firmware of the eKey, it is very simplisting,
>> > with no implementation whatsoever of any flow control.
>> 
>> That's what I thought. (Why would something that just provides data at a
>> constant rate way below that of even the slowest USB bus *need* flow
>> control?)
>> 
>> One presumes therefore that the kernel suddenly trying to do flow
>> control on shutdown would fubar the firmware's internal state, leading
>> to the symptoms I see.
>
> The cdc-acm driver was dropping DTR/RTS on shutdown (close) also before
> the commit you refer to. One thing it did change however is that this is
> now only done if HUPCL is set. Might setting that flag be enough to
> prevent the device firmware from crashing?

If I read the ekeyd 1.1.5 source code correctly, this is already
happening:

,----[ host/stream.c:estream_open() ]
|     } else if (S_ISCHR(sbuf.st_mode)) {
|         /* Open the file as a character device/tty */
|         fd = open(uri, O_RDWR | O_NOCTTY);
|         if ((fd != -1) && (isatty(fd))) {
|             if (tcgetattr(fd, &settings) == 0 ) {
|                 settings.c_cflag &= ~(CSIZE | CSTOPB | PARENB | CLOCAL |
|                                       CREAD | PARODD | CRTSCTS);
|                 settings.c_iflag &= ~(BRKINT | IGNPAR | PARMRK | INPCK |
|                                       ISTRIP | INLCR | IGNCR | ICRNL | IXON |
|                                       IXOFF  | IXANY | IMAXBEL);
|                 settings.c_iflag |= IGNBRK;
|                 settings.c_oflag &= ~(OPOST | OCRNL | ONOCR | ONLRET);
|                 settings.c_lflag &= ~(ISIG | ICANON | IEXTEN | ECHO |
|                                       ECHOE | ECHOK | ECHONL | NOFLSH |
|                                       TOSTOP | ECHOPRT | ECHOCTL | ECHOKE);
|                 settings.c_cflag |= CS8 | HUPCL | CREAD | CLOCAL;
| #ifdef EKEY_FULL_TERMIOS
|                 settings.c_cflag &= ~(CBAUD);
| 		  settings.c_iflag &= ~(IUTF8 | IUCLC);
|                 settings.c_oflag &= ~(OFILL | OFDEL | NLDLY | CRDLY | TABDLY |
|                                       BSDLY | VTDLY | FFDLY | OLCUC );
|                 settings.c_oflag |= NL0 | CR0 | TAB0 | BS0 | VT0 | FF0;
|                 settings.c_lflag &= ~(XCASE);
| #endif
|                 settings.c_cflag |= B115200;
|                 if (tcsetattr(fd, TCSANOW, &settings) < 0) {
`----

Note the HUPCL in there.

I have checked: this code is being executed against a symlink that
points to /dev/ttyACM0, and the tcsetattr() succeeds. (At least, it's
succeeding on the kernel I'm running now, but of course that's 3.16.5
with this commit reverted...)

Of course the daemon is stopped before the reboot, closing the device.
(But even if it wasn't, one would assume that the fact the system was
rebooting would be considered tantamount to a close!)

-- 
NULL && (void)
