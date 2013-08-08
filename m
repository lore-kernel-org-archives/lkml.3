Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966762Ab3HHVy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:54:58 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59920 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab3HHVyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:54:55 -0400
Date: Thu, 8 Aug 2013 23:54:49 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Kevin Hilman <khilman@linaro.org>, sedat.dilek@gmail.com,
        "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux kbuild ML <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-ID: <20130808215449.GD3282@free.fr>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
 <CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
 <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
 <87zjsted0c.fsf@linaro.org>
 <20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au>
 <20130808103614.a039da2f236154b52329b28b@canb.auug.org.au>
 <20130808191650.GB3282@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130808191650.GB3282@free.fr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, All,

On 2013-08-08 21:16 +0200, Yann E. MORIN spake thusly:
> On 2013-08-08 10:36 +1000, Stephen Rothwell spake thusly:
> > On Thu, 8 Aug 2013 10:22:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
> > wrote:
> > >
> > > More quick testing with an empty file: v3.9 is OK, v3.10 gives
> > > CONFIG_MODULES unset.
> 
> Sorry, I don't understand the above. Can you elaborate on what you did,
> what you got, what expected, so I can try to reproduce and fix this,
> please?

Ok, I've had a look in the linux-next archives, and I think I got it.
Is the following right?

    git clean -d; git clean -dX     # To be sure tree is clean
    touch empty
    make KCONFIG_ALLCONFIG=empty allmodconfig
    grep MODULES .config
    $ CONFIG_MODULES is not set

If so, I think I found the reason: the modules symbol is _always_ set to
being valid as soon as KCONFIG_ALLCONFIG is read, even if it was not
present in that file.

Since it is set to be valid, the following change means it is not
affected another value later on.

So, I wonder what the best option is:
  1- revert the following, and find another solution,
  2- de-specialise the modules symbol,
  3- or further specialise the modules symbol.

I'd be inclined to go for 1, but I have no straightforward idea so far.
It's late here, so I'll look more thouroughly this WE.

> > Bisecting gives:
> > 
> > cfa98f2e0ae956feca935573e977d7661a9561b9 is the first bad commit
> > commit cfa98f2e0ae956feca935573e977d7661a9561b9
> > Author: Yann E. MORIN <yann.morin.1998@free.fr>
> > Date:   Wed Apr 24 22:00:04 2013 +0200
> > 
> >     kconfig: do not override symbols already set
> >     
> >     For randconfig, if a list of required symbols is specified with
> >     KCONFIG_ALLCONFIG, such symbols do not "have a value" as per
> >     sym_has_value(), but have the "valid" flag set.
> >     
> >     Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > And reverting that commit in v3.10 gives me CONFIG_MODULES=y.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
