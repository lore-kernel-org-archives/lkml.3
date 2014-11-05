Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaKEWWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:22:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaKEWWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:22:01 -0500
Date: Wed, 5 Nov 2014 23:21:59 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>, andi@firstfloor.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v2 03/13] backports: allow for different backport prefix
Message-ID: <20141105222159.GS12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com> <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com> <1415173596.2589.3.camel@sipsolutions.net> <20141105091610.GM12953@wotan.suse.de> <1415179364.2589.13.camel@sipsolutions.net> <20141105194215.GN12953@wotan.suse.de> <1415222258.7485.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415222258.7485.10.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andi, some reference to some of your old module namespace work below for
a different use case.

On Wed, Nov 05, 2014 at 10:17:38PM +0100, Johannes Berg wrote:
> On Wed, 2014-11-05 at 20:42 +0100, Luis R. Rodriguez wrote:
> 
> > > No, I mean if bp_prefix were to contain some special character like [.
> > > This can't actually happen though.
> > 
> > OK if that can't happen then I don't see the point.
> 
> Where by "can't happen" I mean that Kconfig probably wouldn't be happy
> about it :-)

OK but bp_prefix is also used with a regular print several times and not
just for regexp so this would break either way. To be safe I'll add the
re.escape(bp_prefix) though.

> > How about:
> > 
> > if integrate:
> > 	kconfig_prefix = "CONFIG_"
> > 	project_prefix = "BACKPORT_"
> > else:
> > 	kconfig_prefix = "CPTCFG_"
> > 	# implied by kconfig_prefix
> > 	project_prefix = ""
> > full_prefix = kconfig_prefix + project_prefix
> 
> Yeah, this seems like decent naming.
> 
> > But note that we special case things all over for when the bp_prefix is 'CPTCFG'
> > and the reason is that it is used when the kconfig getenv trick is used. I suppose
> > we can infer that the kconfig trick is used when kconfig_prefix != 'CONFIG_' though.
> > But the question still stands: why do we want to make these configurable? As it
> > stands I actually hard code things mostly, I can clean this up but would prefer
> > to deal with just the above.
> 
> I'm not sure where that's really the case? The one thing you did was use
> CPTCFG_ in some places like the version, but that was independent of
> this and could just be hardcoded there?

In later code I used CPTCFG_ instead of 'not integrate' but this also carries an
implied 'you are using kconfig trick', there were a few cases but surely I can
generalize this with the above and as I mentioned inferring the kconfig trick was
used if needed (can't think off the top of my head where but do think I needed
this). Again though I'd prefer to think more about the *reason* for why we want
congigurability of the prefix Vs thinking about solving the problems for it
right now. My concerns is once code is baked we'll have to support it. Since
people are stupid I expect things to be abused in the most crazy ways possible
here and my fear is of some of these use case to come and haunt us. Worse thing
I can think of is folks doing double integration with two versions of backports,
say backports-3.18, backports-3.19. Obviously this is grotesque and having code
in place to allow for this is begging for abuse.

> > Also note that in some places we use BACKPORT vs BACKPORT_ so a sub or another
> > variable would be needed.
> 
> I also didn't see that, why would that ever be needed?

lib/kconfig.py uses it to negate the built-in symbol for integration for instance
but come to think of it I think we can do this without the 'BACKPORT' and just
use 'BACKPORT_' and no sub'ing, will try...

> > As it stands in the v2 series packaging gets no BACKPORT_ prefix as the
> > kconfig getenv() CTPCFG_ trick is used, however for integration we
> > do add the prefix everywhere as we are carrying code into the kernel,
> > we then use this to easily make this symbol depend on the non backported
> > respective symbol making them mutually exclusive. Because of these two
> > things I think a BACKPORT_ prefix for things we carry in is proper. This
> > applies to the BACKPORT_BPAUTO and versioning entries, BACKPORT_KERNEL_3_18
> > and so on.
> 
> Sure.
> 
> > I am not sure what other prefix we could possibly use here for integration.
> 
> Well, in theory you could imagine having two people backport different
> subsystems and trying to integrate them both into a backport kernel ...
> seems unlikely and will conflict on other levels (e.g. compat.ko) but
> still.

Seems you've though about it too :), indeed sharing compat would be an issue
that would need to be addressed if that is to be a desirable option on
backports.

You know, this use case seems unavoidable so I'll just proceed with the
configurability of it. But note that it seems we're both in agreement
that right now what you described requires more work before in any way
shape or form folks start using it for the exact purpose you described.
I also think Andi Kleen's module namespace might be a much better solution to
that problem [0], we'd just have to carry the code ourselves as I am not
sure if this is ever going to get upstream as it was originally nacked.

[0] https://backports.wiki.kernel.org/index.php/Documentation/backports/hacking/todo#Module_namespaces

> Anyway, I don't really care if you don't make this configurable, but I
> don't like the way you're doing string manipulation to figure out what
> you want :-) That was really the reason for suggesting to split the
> existing prefix variable into two pieces. You have it today, after all,
> in theory you could have gotten rid of it completely and just pass the
> "integrate" flag around.

Yeah point taken. I'll go with the above last proposed variables and
try to remove the other use cases.

  Luis
