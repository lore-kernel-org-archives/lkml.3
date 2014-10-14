Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaJNIcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:32:22 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47376 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaJNIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:32:18 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 14 Oct 2014 10:34:32 +0200
From: Johan Hovold <johan@kernel.org>
To: Nix <nix@esperi.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Paul Martin <pm@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141014083432.GB7958@localhost>
References: <878um4tg09.fsf@spindle.srvr.nix>
 <1409569752.24385.12.camel@linux-fkkt.site>
 <874mwnosz1.fsf@spindle.srvr.nix>
 <871tqe2zqt.fsf_-_@spindle.srvr.nix>
 <20141011195108.GA8275@thinkpad.nowster.org.uk>
 <87y4smz1l0.fsf@spindle.srvr.nix>
 <20141012185845.GB2786@localhost>
 <878uklynq9.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uklynq9.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 10:36:30PM +0100, Nix wrote:
> On 12 Oct 2014, Johan Hovold verbalised:
> 
> > On Sat, Oct 11, 2014 at 11:24:59PM +0100, Nix wrote:
> >> On 11 Oct 2014, Paul Martin spake thusly:
> >> 
> >> > Having been privy to the firmware of the eKey, it is very simplisting,
> >> > with no implementation whatsoever of any flow control.
> >> 
> >> That's what I thought. (Why would something that just provides data at a
> >> constant rate way below that of even the slowest USB bus *need* flow
> >> control?)
> >> 
> >> One presumes therefore that the kernel suddenly trying to do flow
> >> control on shutdown would fubar the firmware's internal state, leading
> >> to the symptoms I see.
> >
> > The cdc-acm driver was dropping DTR/RTS on shutdown (close) also before
> > the commit you refer to. One thing it did change however is that this is
> > now only done if HUPCL is set. Might setting that flag be enough to
> > prevent the device firmware from crashing?
> 
> If I read the ekeyd 1.1.5 source code correctly, this is already
> happening:
> 
> ,----[ host/stream.c:estream_open() ]
> |     } else if (S_ISCHR(sbuf.st_mode)) {
> |         /* Open the file as a character device/tty */
> |         fd = open(uri, O_RDWR | O_NOCTTY);
> |         if ((fd != -1) && (isatty(fd))) {
> |             if (tcgetattr(fd, &settings) == 0 ) {
> |                 settings.c_cflag &= ~(CSIZE | CSTOPB | PARENB | CLOCAL |
> |                                       CREAD | PARODD | CRTSCTS);
> |                 settings.c_iflag &= ~(BRKINT | IGNPAR | PARMRK | INPCK |
> |                                       ISTRIP | INLCR | IGNCR | ICRNL | IXON |
> |                                       IXOFF  | IXANY | IMAXBEL);
> |                 settings.c_iflag |= IGNBRK;
> |                 settings.c_oflag &= ~(OPOST | OCRNL | ONOCR | ONLRET);
> |                 settings.c_lflag &= ~(ISIG | ICANON | IEXTEN | ECHO |
> |                                       ECHOE | ECHOK | ECHONL | NOFLSH |
> |                                       TOSTOP | ECHOPRT | ECHOCTL | ECHOKE);
> |                 settings.c_cflag |= CS8 | HUPCL | CREAD | CLOCAL;
> | #ifdef EKEY_FULL_TERMIOS
> |                 settings.c_cflag &= ~(CBAUD);
> | 		  settings.c_iflag &= ~(IUTF8 | IUCLC);
> |                 settings.c_oflag &= ~(OFILL | OFDEL | NLDLY | CRDLY | TABDLY |
> |                                       BSDLY | VTDLY | FFDLY | OLCUC );
> |                 settings.c_oflag |= NL0 | CR0 | TAB0 | BS0 | VT0 | FF0;
> |                 settings.c_lflag &= ~(XCASE);
> | #endif
> |                 settings.c_cflag |= B115200;
> |                 if (tcsetattr(fd, TCSANOW, &settings) < 0) {
> `----
> 
> Note the HUPCL in there.
> 
> I have checked: this code is being executed against a symlink that
> points to /dev/ttyACM0, and the tcsetattr() succeeds. (At least, it's
> succeeding on the kernel I'm running now, but of course that's 3.16.5
> with this commit reverted...)

You could verify that by enabling debugging in the cdc-acm driver and
making sure that the corresponding control messages are indeed sent on
close.

But you haven't seen any fw crashes since you reverted the commit in
question?

Another thing you could try is to add back the 

	acm_set_control(acm, 0);

just after the dev_info message in probe.

Johan
