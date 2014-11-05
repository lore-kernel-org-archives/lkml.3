Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaKEJQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:16:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaKEJQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:16:12 -0500
Date: Wed, 5 Nov 2014 10:16:10 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v2 03/13] backports: allow for different backport prefix
Message-ID: <20141105091610.GM12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com> <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com> <1415173596.2589.3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415173596.2589.3.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 08:46:36AM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 19:18 -0800, Luis R. Rodriguez wrote:
> 
> > @@ -71,6 +71,9 @@ def read_dependencies(depfilename):
> >                  ret[sym].append(kconfig_exp)
> >          else:
> >              sym, dep = item.split()
> > +            if bp_prefix != 'CPTCFG_':
> > +                dep_prefix = re.sub(r'^CONFIG_(.*)', r'\1', bp_prefix)
> > +                sym = dep_prefix + sym
> 
> I'm not sure I like the way you're framing this here. For one, you could
> do the re.sub() outside the loop (minimal performance optimisation).

Indeed.

> The more interesting part though is that you're parsing the prefix, I
> don't think that's a good idea because it breaks making the prefix
> generic.

Makes me wonder if we should even bother really making the prefix configurable,
once we do this we'll have to support it. The code would be a lot simpler if
we only had two prefixes.

> IMHO this would be better handled in the code that uses the return value
> to add things to the Kconfig dependencies, there you could just go
>   if integrate:
>     deplist[sym] = ["BACKPORT_" + x for x in new]
>   else:
>     deplist[sym] = new

I like it, thanks.

I will note how you still provided "BACKPORT_" here rather than the prefix,
that's why I did the sub thing, but I'm more inclined to remove the dynamic
nature of the prefix for integration. Not sure why that'd be a good idea
and could only make things harder to support / change in the future as
we are learning with CPTCFG_.

Thoughts?

> That would probably belong into another patch though.

OK

> >      # rewrite Makefile and source symbols
> >      regexes = []
> > -    for some_symbols in [symbols[i:i + 50] for i in range(0, len(symbols), 50)]:
> > -        r = 'CONFIG_((' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
> 
> I'm not even really sure any more what this was meant to do?

>From what I can understand this looks iterates over the symbols list 50 at a time,
then for each it uses that 50 batch make a huge fucking or statement or possible
configs that might be possible.

> > +    all_symbols = orig_symbols + symbols
> > +    for some_symbols in [all_symbols[i:i + 50] for i in range(0, len(all_symbols), 50)]:
> > +        r = 'CONFIG_((?!BACKPORT)(' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
> 
> But this seems odd, why would you have BACKPORT_ already in some
> existing Makefile?

Yeah that I think we can ignore now the other internal stuff was addressed,
that was to account for the bpauto and kernel version things.

> It doesn't seem like that would ever happen, so it
> seems you could and should drop this change.

I think that's true now. Nuked and will test at the end.

> > @@ -838,7 +863,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
> >          for f in files:
> >              data = open(os.path.join(root, f), 'r').read()
> >              for r in regexes:
> > -                data = r.sub(r'CPTCFG_\1', data)
> > +                data = r.sub(r'' + bp_prefix + '\\1', data)
> 
> technically, that should be re.escape(bp_prefix)

We want to support bp_prefix having a regexp ? Sorry I didn't get that.

> (btw, it might be clearer if you used %s instead of +'ing the bp_prefix
> in)

Wasn't quite sure how'd well that'd look with the r'' prefix thing, and
still not sure, r.sub(r"%s\\1" % bp_prefix, data) ? If so that looks rather
like hell to me.

> >      for some_symbols in [disable_makefile[i:i + 50] for i in range(0, len(disable_makefile), 50)]:
> > -        r = '^([^#].*((CPTCFG|CONFIG)_(' + '|'.join([s for s in some_symbols]) + ')))'
> > +        r = '^([^#].*((CPTCFG|CONFIG_BACKPORT|CONFIG)_(' + '|'.join([s for s in some_symbols]) + ')))'
> 
> should just use bp_prefix instead of the various options

OK will try that.

> > -cfg_line = re.compile(r'^(config|menuconfig)\s+(?P<sym>[^\s]*)')
> > +cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
> >  sel_line = re.compile(r'^(?P<spc>\s+)select\s+(?P<sym>[^\s]*)\s*$')
> >  backport_line = re.compile(r'^\s+#(?P<key>[ch]-file|module-name)\s*(?P<name>.*)')
> > +ignore_parse_p = re.compile(r'^\s*#(?P<key>ignore-parser-package)')
> 
> Since you're later splitting it into separate files, maybe you should
> just ignore a whole file instead of having to annotate each symbol?
> That'd be easier to maintain (and easier to parse as well :) )

Neat yea good idea.

> > +    def _mod_kconfig_line(self, l, orig_symbols, bp_prefix):
> > +        if bp_prefix != 'CPTCFG_':
> > +            prefix = re.sub(r'^CONFIG_(.*)', r'\1', bp_prefix)
> 
> Another case like above ... maybe you should have bp_prefix and
> bp_kconf_prefix separately. Actually that seems like a good idea.
> bp_kconf_prefix is empty for the backport package case, so you could add
> it in unconditionally, and bp_prefix would be CONFIG_

You mean CONFIG_BACKPORT_ ?

> or CPTCFG_ for the
> two cases. Yes, I think that would make a lot of sense and allow you to
> get rid of this regular expression magic while making the code easier to
> read/understand.

Once this is clear sure, I do prefer it but only once we evaluate if we
really need to make the prefixes configurable.

> > +    def adjust_backported_configs(self, integrate, orig_symbols, bp_prefix):
> 
> This is only used for integrated though, no?

Right now yes, but I'm hinting that perhaps it should also be used for
packaging since it deals with negating a symbol if its built-in on
the kernel already. There should be other ways to do this for packaging,
the checks.h does it but that's just for two modules, we should be doing
this for much other symbols as well.

  Luis
