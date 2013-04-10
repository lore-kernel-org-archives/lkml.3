Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965205Ab3DJRX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:23:28 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:41353 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964846Ab3DJRXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:23:25 -0400
Date: Wed, 10 Apr 2013 12:23:22 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] rootmpfs
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Byron Stanoszek <bstanoszek@comtime.com>, linux-kernel@vger.kernel.org
In-Reply-To: <51644FB5.9050103@infradead.org> (from rdunlap@infradead.org on
	Tue Apr  9 12:28:21 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1365614602.18069.65@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 12:28:21 PM, Randy Dunlap wrote:
> On 04/09/13 07:52, Rob Landley wrote:
> > On 04/05/2013 02:53:12 PM, Byron Stanoszek wrote:
> >> Rob,
> >>
> >> FWIW I have a patch to do something like this. It even gives you a  
> rdsize=xxx
> >> tunable kernel parameter that lets you specify the size of the  
> tmpfs, which
> >> acts like the -osize= mount flag (so phrases like 100M or 20%  
> works). So doing
> >> things like 'cat /dev/zero > filename' will not run you out of all  
> available
> >> memory. (Note: If you don't specify rdsize= on the kernel command  
> line, it will
> >> not convert rootfs to tmpfs).
> >
> > In init/do_mounts.c the boot infrastructure already has kernel  
> command line options "rootflags=" and "rootfstype=", so the logical  
> thing to do is probably to hook those up to rootfs. (That way instead  
> of special casing a new option we use the existing tmpfs option  
> parsing.)
> >
> > The default tmpfs size is 50%, which solves the "trivial to exhaust  
> memory and panic a kernel running under rootfs" problem. Having one  
> tmpfs also fixes the case that multiple tmpfs mounts (for /home and  
> /var, for example,) have separate memory limits that don't coordinate  
> with each other, so if /home can use 30% and /var can use 30%, that's  
> 60% plus whatever rootfs is already using, so you can easily squeeze  
> the kernel against the wall without meaning to. (Yes, you can make  
> one tmpfs mount and --bind mount from there to elsewhere, I've seen  
> that done. Having rootfs just _be_ tmpfs makes this much easier to  
> track.)
> >
> >> See attached.
> >
> > You're not actually changing the type of rootfs, you're  
> overmounting it with a second filesystem instance. (Mine hasn't got a  
> "change", it just mounts it correctly the first time, and there's  
> just one rootfs instance.)
> >
> > What _is_ wrong with my version is that if you select tmpfs as a  
> module bad things happen; it tries to use code that's not there. I  
> dunno of an #ifdef that distinguishes between module and builtin, so  
> I think I have to add another kconfig symbol...
> 
> See include/linux/kconfig.h:  IS_MODULE() and IS_BUILTIN().

Good to know, thanks.

(It turns out I was looking at a distro kernel directory and vanilla  
only lets TMPFS be static anyway, but I should still use that in case  
it changes, and I think I still need to wire up a rootfsflags argument.)

Rob