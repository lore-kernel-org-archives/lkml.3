Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184Ab3DOXLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:11:23 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63500 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440Ab3DOXLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:11:21 -0400
Date: Mon, 15 Apr 2013 16:11:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>, Oskar.Andero@sonymobile.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] lowmemorykiller: prevent multiple instances of low memory
 killer
In-Reply-To: <20130415194947.GA26557@kroah.com>
Message-ID: <alpine.DEB.2.02.1304151608040.13614@chino.kir.corp.google.com>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com> <20130415131815.GG6638@mwanda> <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net> <20130415141358.GO6692@mwanda> <20130415150356.GA22161@caracas.corpusers.net>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC84@seldmbx01.corpusers.net> <20130415194947.GA26557@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Greg Kroah-Hartman wrote:

> > The positive numbers are used to return information on the remaining
> > cache size (again, see the comment I pasted above). We could use
> > -EBUSY, but we'd have to change vmscan.c, which checks specifically
> > for -1. I can't see a technical reason why -EBUSY couldn't have been
> > chosen instead, but there's also no real reason to change it now.
> 
> If it's not the correct thing to do, sure we can change it, just send a
> patch.  It makes way more sense than some random -1 return value to me.
> 
> Care to send a series of patches fixing this up properly?
> 

The comment in shrinker.h is misleading, not the source code.  
do_shrinker_shrink() will fail for anything negative and 0.  The patch 
being discussed could easily use -1 or 0 hardcoded into the return value, 
forget the definition of LMK_BUSY.

Also, please consider using an atomic chmpxchg instead of a spinlock: if 
you're only ever doing spin_trylock() then you don't need a spinlock.
