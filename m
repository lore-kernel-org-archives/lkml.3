Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967577Ab3HILmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:42:53 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:27967 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934248Ab3HILmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:42:51 -0400
Date: Fri, 9 Aug 2013 13:42:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Kevin Hilman <khilman@linaro.org>, sedat.dilek@gmail.com,
        "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux kbuild ML <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-ID: <20130809114248.GA5691@merkur.ravnborg.org>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au> <CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com> <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au> <87zjsted0c.fsf@linaro.org> <20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au> <20130808103614.a039da2f236154b52329b28b@canb.auug.org.au> <20130808191650.GB3282@free.fr> <20130808215449.GD3282@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808215449.GD3282@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:54:49PM +0200, Yann E. MORIN wrote:
> Stephen, All,
> 
> On 2013-08-08 21:16 +0200, Yann E. MORIN spake thusly:
> > On 2013-08-08 10:36 +1000, Stephen Rothwell spake thusly:
> > > On Thu, 8 Aug 2013 10:22:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
> > > wrote:
> > > >
> > > > More quick testing with an empty file: v3.9 is OK, v3.10 gives
> > > > CONFIG_MODULES unset.
> > 
> > Sorry, I don't understand the above. Can you elaborate on what you did,
> > what you got, what expected, so I can try to reproduce and fix this,
> > please?
> 
> Ok, I've had a look in the linux-next archives, and I think I got it.
> Is the following right?
> 
>     git clean -d; git clean -dX     # To be sure tree is clean
>     touch empty
>     make KCONFIG_ALLCONFIG=empty allmodconfig
>     grep MODULES .config
>     $ CONFIG_MODULES is not set
> 
> If so, I think I found the reason: the modules symbol is _always_ set to
> being valid as soon as KCONFIG_ALLCONFIG is read, even if it was not
> present in that file.
> 
> Since it is set to be valid, the following change means it is not
> affected another value later on.
> 
> So, I wonder what the best option is:
>   1- revert the following, and find another solution,
>   2- de-specialise the modules symbol,
>   3- or further specialise the modules symbol.

If we drop the special handling of "MODULES" and introduced
the following in we may fix it - hopefully:

config MODULES
	option modules

The option handling is already in place. It is even documented :-)

At least we could then drop the sym_lookup here (zconf.y):
        if (!modules_sym->prop) {
                struct property *prop;

                prop = prop_alloc(P_DEFAULT, modules_sym);
                prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
        }
Without the sym_lookup I think the symbol will not be defined and tus not marked valid.

Soory - no patch as I am busy with day-time job stuff.

	Sam
