Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaDNN2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:28:09 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60644 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaDNN2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:28:06 -0400
Date: Mon, 14 Apr 2014 15:27:34 +0200
From: Johan Hovold <jhovold@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>, Oliver Neukum <oneukum@suse.de>,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, Xiao Jin <jin.xiao@intel.com>,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Subject: Re: [RFC 1/2] n_tty: fix dropped output characters
Message-ID: <20140414132734.GA27724@localhost>
References: <20140411093715.GA17522@localhost>
 <1397209285-15471-1-git-send-email-jhovold@gmail.com>
 <20140414135333.1057aac8@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414135333.1057aac8@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 01:53:33PM +0100, One Thousand Gnomes wrote:
> On Fri, 11 Apr 2014 11:41:24 +0200
> Johan Hovold <jhovold@gmail.com> wrote:
> 
> > Fix characters being dropped by n_tty_write() due to a failure to
> > check the return value of tty_put_char() in do_output_char().
> > 
> > Characters are currently being dropped by write if a tty driver claims
> > to have write room available, but still fails to buffer any data
> 
> Your driver is buggy. If you advertise a buffer you must honour it and
> neither shrink nor revoke it. 

Very well, that settles the question.
 
> For an URB based device you almost certainly want internal buffering so
> you can do proper packetisation. USB serial these days gets it right - see
> drivers/usb/serial/generic.c for a fairly simple kfifo based approach.

I'm quite aware of the usb-serial approach as I implemented it. ;)

I have considered "porting" it to the ACM driver, and unless anyone is
against the extra copy the fifo would imply, I'll go ahead and do just
that (although, I know of at least one buggy ACM device that violates
the ACM specification and cannot handle merged writes...).

> Whether applying it to cdc_acm would make sense I don't know but it looks
> like it might be simpler over-all than the current arrangement.

With the current fifo-less implementation, the ACM driver could use the
approach taken by the usb-wwan and sierra usb-serial drivers, which
queue up all there write urbs while suspended. That way the available
buffer space never shrinks.

Thanks,
Johan
