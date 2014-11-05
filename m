Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaKETmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:42:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaKETmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:42:17 -0500
Date: Wed, 5 Nov 2014 20:42:15 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v2 03/13] backports: allow for different backport prefix
Message-ID: <20141105194215.GN12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com> <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com> <1415173596.2589.3.camel@sipsolutions.net> <20141105091610.GM12953@wotan.suse.de> <1415179364.2589.13.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415179364.2589.13.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 10:22:44AM +0100, Johannes Berg wrote:
> On Wed, 2014-11-05 at 10:16 +0100, Luis R. Rodriguez wrote:
> 
> > > IMHO this would be better handled in the code that uses the return value
> > > to add things to the Kconfig dependencies, there you could just go
> > >   if integrate:
> > >     deplist[sym] = ["BACKPORT_" + x for x in new]
> > >   else:
> > >     deplist[sym] = new
> > 
> > I like it, thanks.
> > 
> > I will note how you still provided "BACKPORT_" here rather than the prefix,
> > that's why I did the sub thing, but I'm more inclined to remove the dynamic
> > nature of the prefix for integration. Not sure why that'd be a good idea
> > and could only make things harder to support / change in the future as
> > we are learning with CPTCFG_.
> > 
> > Thoughts?
> 
> I think the splitting of bp_kconf_prefix and bp_prefix I suggested would
> help. Now that I look at it again, the names don't really make sense
> though.
> 
> > > > @@ -838,7 +863,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
> > > >          for f in files:
> > > >              data = open(os.path.join(root, f), 'r').read()
> > > >              for r in regexes:
> > > > -                data = r.sub(r'CPTCFG_\1', data)
> > > > +                data = r.sub(r'' + bp_prefix + '\\1', data)
> > > 
> > > technically, that should be re.escape(bp_prefix)
> > 
> > We want to support bp_prefix having a regexp ? Sorry I didn't get that.
> 
> No, I mean if bp_prefix were to contain some special character like [.
> This can't actually happen though.

OK if that can't happen then I don't see the point.

> > > (btw, it might be clearer if you used %s instead of +'ing the bp_prefix
> > > in)
> > 
> > Wasn't quite sure how'd well that'd look with the r'' prefix thing, and
> > still not sure, r.sub(r"%s\\1" % bp_prefix, data) ? If so that looks rather
> > like hell to me.
> 
> Ok sure :) + is fine with me.

:)

> > > > +    def _mod_kconfig_line(self, l, orig_symbols, bp_prefix):
> > > > +        if bp_prefix != 'CPTCFG_':
> > > > +            prefix = re.sub(r'^CONFIG_(.*)', r'\1', bp_prefix)
> > > 
> > > Another case like above ... maybe you should have bp_prefix and
> > > bp_kconf_prefix separately. Actually that seems like a good idea.
> > > bp_kconf_prefix is empty for the backport package case, so you could add
> > > it in unconditionally, and bp_prefix would be CONFIG_
> > 
> > You mean CONFIG_BACKPORT_ ?
> 
> No, I did mean CONFIG_. One prefix for kconfig, and one prefix for
> "additional renaming".
> 
> The names I gave them here were really bad though. Maybe
> bp_prefix = "CONFIG_"
> additional_prefix = "BACKPORT_"
>
> (or bp_prefix = "CPTCFG_" / additional_prefix = "")
> 
> or so?

How about:

if integrate:
	kconfig_prefix = "CONFIG_"
	project_prefix = "BACKPORT_"
else:
	kconfig_prefix = "CPTCFG_"
	# implied by kconfig_prefix
	project_prefix = ""
full_prefix = kconfig_prefix + project_prefix

But note that we special case things all over for when the bp_prefix is 'CPTCFG'
and the reason is that it is used when the kconfig getenv trick is used. I suppose
we can infer that the kconfig trick is used when kconfig_prefix != 'CONFIG_' though.
But the question still stands: why do we want to make these configurable? As it
stands I actually hard code things mostly, I can clean this up but would prefer
to deal with just the above.

Also note that in some places we use BACKPORT vs BACKPORT_ so a sub or another
variable would be needed.

> > > or CPTCFG_ for the
> > > two cases. Yes, I think that would make a lot of sense and allow you to
> > > get rid of this regular expression magic while making the code easier to
> > > read/understand.
> > 
> > Once this is clear sure, I do prefer it but only once we evaluate if we
> > really need to make the prefixes configurable.
> 
> Yeah I guess we don't really, but I'd also hate to hardcode BACKPORT_
> everywhere?

As it stands in the v2 series packaging gets no BACKPORT_ prefix as the
kconfig getenv() CTPCFG_ trick is used, however for integration we
do add the prefix everywhere as we are carrying code into the kernel,
we then use this to easily make this symbol depend on the non backported
respective symbol making them mutually exclusive. Because of these two
things I think a BACKPORT_ prefix for things we carry in is proper. This
applies to the BACKPORT_BPAUTO and versioning entries, BACKPORT_KERNEL_3_18
and so on.

I am not sure what other prefix we could possibly use here for integration.

> > > > +    def adjust_backported_configs(self, integrate, orig_symbols, bp_prefix):
> > > 
> > > This is only used for integrated though, no?
> > 
> > Right now yes, but I'm hinting that perhaps it should also be used for
> > packaging since it deals with negating a symbol if its built-in on
> > the kernel already. There should be other ways to do this for packaging,
> > the checks.h does it but that's just for two modules, we should be doing
> > this for much other symbols as well.
> 
> Yeah that might be worthwhile.

If CPTCFG was dropped, as I had orignally proposed this would be shared :)

  Luis
