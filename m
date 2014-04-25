Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaDYF4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:56:25 -0400
Received: from 1wt.eu ([62.212.114.60]:33024 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaDYF4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:56:24 -0400
Date: Fri, 25 Apr 2014 07:56:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: Bastien Armand <armand.bastien@laposte.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] staging: panel: fix sparse warnings in lcd_write
Message-ID: <20140425055609.GF19929@1wt.eu>
References: <20140418161057.GC1258@plop.dartybox.com> <20140422100144.GE26890@mwanda> <20140423173435.GB10879@plop.dartybox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423173435.GB10879@plop.dartybox.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:35:02PM +0200, Bastien Armand wrote:
> On Tue, Apr 22, 2014 at 01:01:45PM +0300, Dan Carpenter wrote:
> > Btw, this whole function is terrible.  It should be reading larger
> > chunks at once instead of get_user() for each character.

Just for the record, very small character counts may be sent to an LCD
panel, in general these are 2 lines of 16 characters, and at most 2x40,
and changes are very rare. The worst case will be if someone displays
the time of day, it will change every second.

> > > +	if (lcd_enabled && lcd_initialized) {
> > > +		for (; count-- > 0; tmp++) {
> > > +			if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
> > > +				/* let's be a little nice with other processes
> > > +				   that need some CPU */
> > > +				schedule();
> > 
> > This schedule() isn't needed.  It just prints a line or two at start up
> > and some other debug output or something.  Small small.
> > 
> 
> I hesitated to remove it. I leave it here as it was allready in lcd_write.
> Perhaps, I could send another patch to remove it.

I believe it can go. I have some memories of it when I was developing the
driver because I didn't know if some LCDs would need long pauses between
each character. Hmmm well, thinking about it after re-reading the code,
we could wait up to 20+40+120 = 180 microseconds when sending one command
(eg: position change), or 20+40+45 = 105 microseconds when sending one
char. That's basically 180+40*105 = 4.185 milliseconds for one full line,
or 8 milliseconds for two lines of 40 chars. So maybe we should keep the
schedule() in the end...

Best regards,
Willy

