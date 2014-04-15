Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaDOMTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:19:39 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46523 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDOMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:19:38 -0400
Date: Tue, 15 Apr 2014 14:19:08 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Xiao Jin <jin.xiao@intel.com>, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com
Subject: Re: [PATCH] USB: cdc-acm: fix broken runtime suspend
Message-ID: <20140415121908.GC24422@localhost>
References: <20140411093715.GA17522@localhost>
 <1397505492-10018-1-git-send-email-jhovold@gmail.com>
 <1397550919.3307.39.camel@linux-fkkt.site>
 <20140415091317.GB24422@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415091317.GB24422@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:13:17AM +0200, Johan Hovold wrote:
> On Tue, Apr 15, 2014 at 10:35:19AM +0200, Oliver Neukum wrote:
> > On Mon, 2014-04-14 at 21:58 +0200, Johan Hovold wrote:
> > 
> > > Fix this by implementing a delayed-write queue using urb anchors and
> > > making sure to discard the queue properly at shutdown.
> > 
> > Looks very good, with one exception: acm_tty_close() must
> > synchronously resume the device so that the anchor is emptied
> > before ASYNCB is cleared.
> 
> That isn't necessary as the device is already about to be resumed and
> the initialised flag will not be cleared until chars_in_buffer() returns
> 0 or closing wait times out.
> 
> In the first case, the queue has been emptied as the urbs are submitted
> at resume(), and in the second case the queue is discarded at
> shutdown().

Turns out that the usb_wwan (and thus ipw, option, and qcserial) and
sierra usb-serial drivers also fail to get runtime-suspend right. The
first one leaks urbs and the second does synchronous resume and submits
urbs during shutdown.

I'll fix it up.

Johan
