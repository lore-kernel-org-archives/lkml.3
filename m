Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaKEHqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:46:44 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:59884 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaKEHql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:46:41 -0500
Message-ID: <1415173596.2589.3.camel@sipsolutions.net>
Subject: Re: [PATCH v2 03/13] backports: allow for different backport prefix
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 05 Nov 2014 08:46:36 +0100
In-Reply-To: <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20141105_042207_583428_D09CF507)
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141105_042207_583428_D09CF507)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 19:18 -0800, Luis R. Rodriguez wrote:

> @@ -71,6 +71,9 @@ def read_dependencies(depfilename):
>                  ret[sym].append(kconfig_exp)
>          else:
>              sym, dep = item.split()
> +            if bp_prefix != 'CPTCFG_':
> +                dep_prefix = re.sub(r'^CONFIG_(.*)', r'\1', bp_prefix)
> +                sym = dep_prefix + sym

I'm not sure I like the way you're framing this here. For one, you could
do the re.sub() outside the loop (minimal performance optimisation).

The more interesting part though is that you're parsing the prefix, I
don't think that's a good idea because it breaks making the prefix
generic.

IMHO this would be better handled in the code that uses the return value
to add things to the Kconfig dependencies, there you could just go
  if integrate:
    deplist[sym] = ["BACKPORT_" + x for x in new]
  else:
    deplist[sym] = new

or so.

That would probably belong into another patch though.

> @@ -724,7 +740,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
>              sys.exit(1)
>  
>      copy_list = read_copy_list(args.copy_list)
> -    deplist = read_dependencies(os.path.join(source_dir, 'dependencies'))
> +    deplist = read_dependencies(os.path.join(source_dir, 'dependencies'), bp_prefix)

Another way to look at it would be to say that reading a file shouldn't
modify the data :-)


>      # rewrite Makefile and source symbols
>      regexes = []
> -    for some_symbols in [symbols[i:i + 50] for i in range(0, len(symbols), 50)]:
> -        r = 'CONFIG_((' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'

I'm not even really sure any more what this was meant to do?

> +    all_symbols = orig_symbols + symbols
> +    for some_symbols in [all_symbols[i:i + 50] for i in range(0, len(all_symbols), 50)]:
> +        r = 'CONFIG_((?!BACKPORT)(' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'

But this seems odd, why would you have BACKPORT_ already in some
existing Makefile? It doesn't seem like that would ever happen, so it
seems you could and should drop this change.

> @@ -838,7 +863,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
>          for f in files:
>              data = open(os.path.join(root, f), 'r').read()
>              for r in regexes:
> -                data = r.sub(r'CPTCFG_\1', data)
> +                data = r.sub(r'' + bp_prefix + '\\1', data)

technically, that should be re.escape(bp_prefix)

(btw, it might be clearer if you used %s instead of +'ing the bp_prefix
in)

>      for some_symbols in [disable_makefile[i:i + 50] for i in range(0, len(disable_makefile), 50)]:
> -        r = '^([^#].*((CPTCFG|CONFIG)_(' + '|'.join([s for s in some_symbols]) + ')))'
> +        r = '^([^#].*((CPTCFG|CONFIG_BACKPORT|CONFIG)_(' + '|'.join([s for s in some_symbols]) + ')))'

should just use bp_prefix instead of the various options

> -cfg_line = re.compile(r'^(config|menuconfig)\s+(?P<sym>[^\s]*)')
> +cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
>  sel_line = re.compile(r'^(?P<spc>\s+)select\s+(?P<sym>[^\s]*)\s*$')
>  backport_line = re.compile(r'^\s+#(?P<key>[ch]-file|module-name)\s*(?P<name>.*)')
> +ignore_parse_p = re.compile(r'^\s*#(?P<key>ignore-parser-package)')

Since you're later splitting it into separate files, maybe you should
just ignore a whole file instead of having to annotate each symbol?
That'd be easier to maintain (and easier to parse as well :) )

> +    def _mod_kconfig_line(self, l, orig_symbols, bp_prefix):
> +        if bp_prefix != 'CPTCFG_':
> +            prefix = re.sub(r'^CONFIG_(.*)', r'\1', bp_prefix)

Another case like above ... maybe you should have bp_prefix and
bp_kconf_prefix separately. Actually that seems like a good idea.
bp_kconf_prefix is empty for the backport package case, so you could add
it in unconditionally, and bp_prefix would be CONFIG_ or CPTCFG_ for the
two cases. Yes, I think that would make a lot of sense and allow you to
get rid of this regular expression magic while making the code easier to
read/understand.

> +    def adjust_backported_configs(self, integrate, orig_symbols, bp_prefix):

This is only used for integrated though, no?

johannes

