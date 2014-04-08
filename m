Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaDHNRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:17:52 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50709 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaDHNRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:17:50 -0400
Date: Tue, 8 Apr 2014 15:17:18 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>, Xiao Jin <jin.xiao@intel.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
Message-ID: <20140408131718.GE25779@localhost>
References: <53436770.9090008@intel.com>
 <20140408073306.GB25779@localhost>
 <1396953211.25633.16.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396953211.25633.16.camel@linux-fkkt.site>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +CC: Alan ]

On Tue, Apr 08, 2014 at 12:33:31PM +0200, Oliver Neukum wrote:
> On Tue, 2014-04-08 at 09:33 +0200, Johan Hovold wrote:
> > On Tue, Apr 08, 2014 at 11:05:20AM +0800, Xiao Jin wrote:
> 
> > > (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> > > close. If acm resume callback run after ASYNCB_INITIALIZED flag
> > > cleared, there will have no chance for delayed write to start.
> > > That lead to acm_wb.use can't be cleared. If user space open
> > > acm tty again and try to setd, tty will be blocked in
> > > tty_wait_until_sent for ever.
> > >
> > > This patch have two modification.
> > > (1) use list_head to save the write acm_wb during acm suspend.
> > > It can ensure no acm write abandoned.
> > > (2) enable flush buffer callback when acm tty close. acm delayed
> > > wb will start before acm port shutdown callback, it make sure
> > > the delayed acm_wb.use to be cleared. The patch also clear
> > > acm_wb.use and acm.transmitting when port shutdown.
> > 
> > This is not the right way to do this. See below.
> 
> If I see this correctly, then ASYNCB_INITIALIZED is cleared in
> tty_port_close() we is called from acm_tty_close(). Thus it should
> be enough to make sure that the device is resumed at the beginning
> of acm_tty_close() and acm_resume() will do the job automatically.
> What do you think?

But the device should already be about to be resumed, right? If the port
is closed fast enough that resume hasn't had time to run before
shutdown is called I think the right thing to do is simply to discard
the delayed bytes (in shutdown).

Johan
