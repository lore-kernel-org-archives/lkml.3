Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3EJI0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:26:40 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63294 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3EJIZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:25:53 -0400
Date: Fri, 10 May 2013 10:25:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't
 already
Message-ID: <20130510082548.GA6892@gmail.com>
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
 <20130501113352.GA29571@pd.tnic>
 <20130501163404.GA6286@thunk.org>
 <518145F6.3060800@zytor.com>
 <CALCETrX0WEGJ0UZz6PyQ4DrnpGg52S0cArDYLQ9Yjz3uic_N4A@mail.gmail.com>
 <51815252.4010103@zytor.com>
 <CALCETrWa64s2bMVq9xJ5FBg2NH8501V-YThVO7CrJa7-0-TVHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWa64s2bMVq9xJ5FBg2NH8501V-YThVO7CrJa7-0-TVHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> > What do you want WT for, anyway?
> 
> Generically, memory regions in which writes have side effects but reads 
> are just reads and should be cached.
> 
> In particular, persistent (i.e. nonvolatile) memory.  There's an NDA 
> involved, but I can safely say (at least): there seem to be nifty 
> devices that aren't quite RAM that are nonetheless presented to the 
> system as RAM.  Write are durable, but only if they make it out of cache 
> before power fails or the CPU resets in such a way that caches are 
> invalidated but not written back.  UC and WC are a bit heavy-handed 
> because read caching is fine.  (PowerPC has nice instructions for things 
> like "write this back now", but x86 seems to be missing any way other 
> than WT to force data out to RAM without invalidating the cache line.)
> 
> Making this work with a WT MTRR is probably doable, but it's IMO rather 
> ugly.  Even if I go that route, I'd still want to convince graphics 
> drivers to stop wasting MTRRs, since they don't need them and they tend 
> to be in short supply.
> 
> Here's an example:
> 
> http://www.tomshardware.com/news/Viking-ArxCis-NV-NVDIMM-RAM,21892.html

This looks potentially useful.

I'd consider your cache-attributes review and cleanups to drivers and 
infrastructure to be the main upstream benefit we win from your effort.

So as long as your patches go in that general direction, and the PAT code 
and its usage gets cleaner and more organized, and there's no showstopper 
issue discovered, the fact that you gain ioremap_wt() for your driver is 
mostly just a happy coincidence that we don't mind that much.

Maybe in the end we'd have to hide it behind some sort of 
CONFIG_COMPAT_PAT trigger and turn it off on old/buggy systems - but in 
the first approximation it would be nice to try and make this just a 
single variant with no Kconfig complexity?

Thanks,

	Ingo
