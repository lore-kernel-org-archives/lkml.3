Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab3CMO1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:27:09 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:42479 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab3CMO1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:27:06 -0400
Subject: Re: [PATCH 07/16] TTY: quatech2, remove unneeded is_open
To: jslaby@suse.cz (Jiri Slaby)
Date: Wed, 13 Mar 2013 10:27:05 -0400
Cc: gregkh@linuxfoundation.org, peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <51408A88.20202@suse.cz>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130313142705.E8E8880208@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby writes:
> 
> On 03/13/2013 02:46 PM, Bill Pemberton wrote:
> > Jiri Slaby writes:
> >>
> >> tty->ops->break_ctl cannot be called outside the gap between open and
> >> close. So there is no need to check whether the port is open in
> >> break_ctl in quatech2. Remove the check and also that member
> >> completely.
> >>
> > 
> > We can't get rid of is_open.  The devices use 1 read urb for all ports
> > and will send various things about ports that haven't actually been
> > opened.  So the driver needs to know if a port has actually been
> > opened or not.  In fact, I was about to send a patch that fixes a
> > warning caused by commit 2e124b4a390ca85325fae75764bef92f0547fa25
> > causing the driver to try to write to ttys that weren't actually
> > opened.
> 
> As long as tty_port exists for the port, calling tty buffer functions is
> OK. The warning you mention is now bogus and there is a patch flying
> around to disable that at the moment.
> 

Ah, ok, I assumed the warning was telling me the driver was doing
something stupid by calling tty_flip_buffer_push() on a port that
wasn't opened (which did sound like a stupid thing to do to me).  If
that's actually harmless, then yes, the is_open stuff can be dropped
and my recent patch to check is_open before calling
tty_flip_buffer_push() can be ignored.


> It is also that is_open was completely racy, right?
> 

Does it simply need a lock around it or is there something else I'm
missing?  In any event, if it can go, that's great -- it's only used
for the above "don't call tty_flip_buffer_push() on an unopened port"
logic.

-- 
Bill
