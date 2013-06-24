Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3FXLGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:06:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52189 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3FXLGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:06:37 -0400
Date: Mon, 24 Jun 2013 13:06:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Mark Lord <mlord@pobox.com>, Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130624110634.GA18185@amd.pavel.ucw.cz>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
 <51C76858.4060906@pobox.com>
 <20130623215100.GA7414@amd.pavel.ucw.cz>
 <201306240914.29502.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306240914.29502.linux@rainbow-software.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > For ATA, use the "logical sector size".
> > > For all existing drives out there, that's a 512 byte unit.
> >
> > I guessed so. (It would be good to actually document it, as well as
> > documenting exactly why it is dangerous. Is it okay to send patches?)
> >
> > > > ...but it does not do the trick :-(. It behaves strangely as if it was
> > > > still cached somewhere. Do I need to turn off the write back cache?
> > >
> > > No, it works just fine.  You probably have more than one bad sector.
> > > After you see a read failure, run "smartctl -a" and look at the error
> > > logs to see what sector the drive is choking on.
> >
> > Well, I definitely have more than one bad sector, but I did try to
> > read exactly the same sector and it failed. See below.
...
> > Thanks for support,
> > 									Pavel
> 
> Being tired of using hdparm manually, I created a simple hdd_realloc utility
> that reads the disk in big blocks (1 MB). When there's a read error, it reads
> the failed block sector-by-sector and tries to rewrite the sectors that fail
> to read. It work fine for disks with just a couple of pending
> sectors.

Thanks! This should really be part of distribution... And it does
O_DIRECT, O_SYNC...

It seems to have reallocated one more sector (I'm on 6 now).. but
there are still some underlying problems. I guess I should try stock
kernel from Debian?

Or perhaps give up and avoid Seagate in future :-(.

root@amd:/data/pavel/misc# ./hdd_realloc /dev/sda4 8958947328
Position: 8958947328 B (8543 MiB, 8 GiB, sector 17497944), rate 0
MiB/s
Read error: Input/output error
Examining 8958947328
Unable to read at 8959366144, rewriting...OK
Unable to read at 8959366656, rewriting...OK
Unable to read at 8959367168, rewriting...OK
Unable to read at 8959778816, rewriting...OK
Unable to read at 8959779840, rewriting...OK
Position: 8959995904 B (8544 MiB, 8 GiB, sector 17499992), rate 0
MiB/s
Read error: Input/output error
Examining 8959995904
Unable to read at 8960192512, rewriting...OK
Position: 12548222976 B (11966 MiB, 11 GiB^Csector 24506200), rate 10
MiB/s
root@amd:/data/pavel/misc# ./hdd_realloc /dev/sda4 8958947328
Position: 8958947328 B (8543 MiB, 8 GiB, sector 17497944), rate 0
MiB/s
Read error: Input/output error
Examining 8958947328
Unable to read at 8959366656, rewriting...OK
Unable to read at 8959367168, rewriting...OK
Position: 9^C6042624 B (9389 MiB, 9 GiB, sector 19230552), rate 11
MiB/s
root@amd:/data/pavel/misc# 

(s2ram to give disk a chance to reboot).

root@amd:/data/pavel/misc# ./hdd_realloc /dev/sda4 8958947328
Position: 8958947328 B (8543 MiB, 8 GiB, sector 17497944), rate 0
MiB/s
Read error: Input/output error
Examining 8958947328
Unable to read at 8959366656, rewriting...OK
Unable to read at 8959367168, rewriting...OK
Position: 14^C5529088 B (13928 MiB, 13 GiB, sector 28526424), rate 21
MiB/s
root@amd:/data/pavel/misc# ./hdd_realloc /dev/sda4 8958947328
Position: 8958947328 B (8543 MiB, 8 GiB, sector 17497944), rate 0
MiB/s
Read error: Input/output error
Examining 8958947328
Unable to read at 8959366656, rewriting...OK
Unable to read at 8959367168, rewriting...OK
Unable to read at 8959779840, rewriting...OK
Position: 9356357056 B (8921 MiB, 8 GiB, sector 18272088), rate 15
MiB/s

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
