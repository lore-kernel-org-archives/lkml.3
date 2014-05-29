Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaE2U4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:56:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaE2U4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:56:19 -0400
Date: Thu, 29 May 2014 13:59:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: DaeSeok Youn <daeseok.youn@gmail.com>, devel <devel@driverdev.osuosl.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] staging: dgap: implement proper error handling in
 dgap_firmware_load()
Message-ID: <20140529205955.GA15646@kroah.com>
References: <20140527070937.GA21621@devel.8.8.4.4>
 <20140527102002.GI17724@mwanda>
 <CAHb8M2AceJeFv-KonF+bAFJ-+xssFxx5ytEKhMNZ1c3xm2jvZA@mail.gmail.com>
 <20140528070233.GP17724@mwanda>
 <CAHb8M2ABVCaoNR0m5mLmWv-ei60PDRu462QTqDgEJwAf63oteg@mail.gmail.com>
 <20140528101153.GU15585@mwanda>
 <CAHb8M2C-+1OexGdb7EUMVJ3Vq+M3bWSkCgkXX-O9OFj4=Dr=oQ@mail.gmail.com>
 <20140529064039.GW17724@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529064039.GW17724@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:40:39AM +0300, Dan Carpenter wrote:
> On Thu, May 29, 2014 at 09:17:09AM +0900, DaeSeok Youn wrote:
> > Hi, Dan.
> > 
> > 2014-05-28 19:11 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > > On Wed, May 28, 2014 at 06:29:38PM +0900, DaeSeok Youn wrote:
> > >> > In your patch it has:
> > >> > +       dgap_tty_uninit(brd, false);
> > >> >
> > >> > But it should only be "false" if dgap_tty_init() failed.  If
> > >> > dgap_tty_register_ports() fails then it should be "true".  Another
> > >> Yes, you're right. There were no error handle for tty_port_register_device() and
> > >> dgap_create_tty_sysfs() in dgap_tty_register_ports(). I didn't catch it. :-(
> > >> It need to add error handlers for them, right?
> > >
> > > Eventually, yes.  But I don't see a simple way to fix
> > > dgap_firmware_load() until after the code is cleaned up.
> > >
> > >>
> > >> > problem is that as you say, the earlier function are allocating
> > >> > resources like dgap_tty_register() but only the last two function calls
> > >> > have a "goto err_cleanup;" so the error handling is incomplete.
> > >> So remove "goto" in dgap_firmware_load() and add error handler in
> > >> dgap_tty_init()
> > >
> > > In the current code there isn't a goto in dgap_firmware_load().  Remove
> > > the call to dgap_tty_uninit() and add error handling in dgap_tty_init().
> > Yes. I will try to fix it.
> > >
> > > That will clean up the code, and fix some NULL dereference bugs inside
> > > dgap_tty_uninit().
> > >
> > >> and dgap_tty_register_ports(), right?
> > >
> > > Inside dgap_tty_register_ports(), then we should add a
> > > kfree(brd->serial_ports) if the "brd->printer_ports" allocation fails.
> > > That is not a complete fix, but it is a part fix and it is clean.
> > Actually, I sent a patch which is removing "kfree(brd->serial_ports)" and pushed
> > into staging-next branch.
> > see the 0ade4a34fd43 staging: dgap: remove unneeded kfree() in
> > dgap_tty_register_ports()
> > Because I think dgap_tty_uninit() will free "brd->serial_ports" with this patch.
> > 
> > Can I send a patch after revert "0ade4a34fd43" commit?
> 
> Oh, crud.  I missed that.  Yeah.  Let's revert it.

Now reverted.
