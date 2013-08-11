Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3HKVje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 17:39:34 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33561 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3HKVjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 17:39:31 -0400
Date: Sun, 11 Aug 2013 23:39:23 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Kevin Hilman <khilman@linaro.org>, sedat.dilek@gmail.com,
        "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux kbuild ML <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-ID: <20130811213923.GA5312@free.fr>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
 <CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
 <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
 <87zjsted0c.fsf@linaro.org>
 <20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au>
 <20130808103614.a039da2f236154b52329b28b@canb.auug.org.au>
 <20130808191650.GB3282@free.fr>
 <20130808215449.GD3282@free.fr>
 <20130809114248.GA5691@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130809114248.GA5691@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, All,

On 2013-08-09 13:42 +0200, Sam Ravnborg spake thusly:
> On Thu, Aug 08, 2013 at 11:54:49PM +0200, Yann E. MORIN wrote:
> > Stephen, All,
> > 
> > On 2013-08-08 21:16 +0200, Yann E. MORIN spake thusly:
> > > On 2013-08-08 10:36 +1000, Stephen Rothwell spake thusly:
> > > > On Thu, 8 Aug 2013 10:22:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
> > > > wrote:
> > > > >
> > > > > More quick testing with an empty file: v3.9 is OK, v3.10 gives
> > > > > CONFIG_MODULES unset.
> > > 
> > > Sorry, I don't understand the above. Can you elaborate on what you did,
> > > what you got, what expected, so I can try to reproduce and fix this,
> > > please?
> > 
> > Ok, I've had a look in the linux-next archives, and I think I got it.
> > Is the following right?
> > 
> >     git clean -d; git clean -dX     # To be sure tree is clean
> >     touch empty
> >     make KCONFIG_ALLCONFIG=empty allmodconfig
> >     grep MODULES .config
> >     $ CONFIG_MODULES is not set
> > 
> > If so, I think I found the reason: the modules symbol is _always_ set to
> > being valid as soon as KCONFIG_ALLCONFIG is read, even if it was not
> > present in that file.
> > 
> > Since it is set to be valid, the following change means it is not
> > affected another value later on.
> > 
> > So, I wonder what the best option is:
> >   1- revert the following, and find another solution,
> >   2- de-specialise the modules symbol,
> >   3- or further specialise the modules symbol.
> 
> If we drop the special handling of "MODULES" and introduced
> the following in we may fix it - hopefully:
> 
> config MODULES
> 	option modules
> 
> The option handling is already in place. It is even documented :-)

Yes, indeed, that one is pretty easy! :-)

> At least we could then drop the sym_lookup here (zconf.y):
>         if (!modules_sym->prop) {
>                 struct property *prop;
> 
>                 prop = prop_alloc(P_DEFAULT, modules_sym);
>                 prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
>         }
> Without the sym_lookup I think the symbol will not be defined and tus not marked valid.

Sorry, I don't understand what we should do here.

>From what I understand, here's what happens:
  - there's no symbol that declared the 'modules' option, so the
    modules_sym->prop is NULL;
  - so we look for the symbol 'MODULES' and use that as the symbol used
    to evaluate if tristates are enabled.

So, now we have 'option modules' added to MODULES, we never enter this
if() condition.

But what would happen to other projects that do not have a symbol set
with 'option modules' and no 'MODULES' symbol? Surely, those projects do
not need tristates, but what should the code do in this case?

So, I don't know what to replace this 'sym_lookup("MODULES", 0)' with.

> Soory - no patch as I am busy with day-time job stuff.

I hope you can share some guidnce here, please... ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
