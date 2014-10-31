Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbaJaUKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:10:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaJaUKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:10:04 -0400
Date: Fri, 31 Oct 2014 21:10:02 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stefan Assmann <sassmann@kpanic.de>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz
Subject: Re: [RFC v2 4/4] backports: add kernl integration support to
	gentree.py
Message-ID: <20141031201002.GD12953@wotan.suse.de>
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com> <1414570902-5675-5-git-send-email-mcgrof@do-not-panic.com> <5451099B.7090102@kpanic.de> <20141029160003.GW28966@wotan.suse.de> <1414741851.3014.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414741851.3014.13.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 08:50:51AM +0100, Johannes Berg wrote:
> On Wed, 2014-10-29 at 17:00 +0100, Luis R. Rodriguez wrote:
> 
> >  backport/Kconfig                              |  54 --------
> >  backport/Kconfig.package                      |  31 +++++
> >  backport/Kconfig.sources                      |  23 ++++
> 
> I think you should do this split as a separate patch.

Indeed, will do.

> > +# these will be generated
> > +source "$BACKPORT_DIR/Kconfig.kernel"
> > +source "$BACKPORT_DIR/Kconfig.versions"
> > +source "$BACKPORT_DIR/Kconfig.sources"
> 
> Not true - Kconfig.sources exists below?

Will fix comment.

> > +ifneq ($(BACKPORT_PACKAGE),)
> 
> I think it'd be easier to understand if you called this
> 
> BACKPORT_INTEGRATED

Sure.

> and inverted the logic.

OK.

> > +        # Only the kconfig 'mainmenu' entries grok variables, we want to keep
> > +        # this the main Kconfig as part of our program to be able to give it
> > +        # enough dynamic information
> > +        k = open(os.path.join(args.outdir, 'Kconfig'), 'w')
> > +        k.write('config BACKPORT_DIR\n')
> > +        k.write('\tstring\n')
> > +        k.write('\tdefault "backports/"\n')
> > +        k.write('config BACKPORTS_VERSION\n')
> > +        k.write('\tstring\n')
> > +        k.write('\tdefault "%s"\n' % backports_version)
> > +        k.write('config BACKPORTED_KERNEL_VERSION\n')
> > +        k.write('\tstring\n')
> > +        k.write('\tdefault "%s"\n' % kernel_version)
> > +        k.write('config BACKPORTED_KERNEL_NAME\n')
> > +        k.write('\tstring\n')
> > +        k.write('\tdefault "%s"\n' % args.base_name)
> > +        k.write('\n')
> > +        k.write('menuconfig BACKPORT_LINUX\n')
> > +        k.write('\tbool "Backport %s %s (backports %s)"\n' % (args.base_name, kernel_version, backports_version))
> > +        k.write('\tdefault n\n')
> > +        k.write('\t---help--- \n')
> > +        k.write('\t  Enabling this will let give you the opportunity to use\n')
> > +        k.write('\t  features and drivers backported from %s %s\n' % (args.base_name, kernel_version))
> > +        k.write('\t  on the kernel your are using. This is experimental and you should\n')
> > +        k.write('\t  say no unless you\'d like to help test things.\n')
> > +        k.write('\n')
> > +        k.write('if BACKPORT_LINUX\n')
> > +        k.write('\n')
> > +        k.write('source "$BACKPORT_DIR/Kconfig.versions"\n')
> > +        k.write('source "$BACKPORT_DIR/Kconfig.sources"\n')
> > +        k.write('\n')
> > +        k.write('endif # BACKPORT_LINUX\n')
> 
> This is really really ugly - please just have a file template, and maybe
> replace some things in it or provide them as env variables through the
> Makefile or so.

That's the thing, we can pass variables on the Makefile but based on my tests
Kconfig will only interpret them on "mainmenu", but not others. This is why
I kept it embedded completely as part of the program. A template and easy
search / replace should make it nicer to edit for sure, will give that a shot.

> > +    if args.integrate:
> > +        f = open(os.path.join(args.outdir, '../arch/x86/Kconfig'), 'a')
> > +        f.write('source "backports/Kconfig"\n')
> 
> That seems like a bad idea - maybe better integrate it under some
> arch-independent file?

I like that idea, the only one that would make sense would be top level then.
Will modify that then.

> > +        f.close()
> > +        git_debug_snapshot(args, "hooked backport Kconfig to supported architectures")
> > +
> > +        f = open(os.path.join(args.outdir, '../MAINTAINERS'), 'a')
> > +        f.write('M:\tHauke Mehrtens <hauke@hauke-m.de>\n')
> > +        f.write('M:\tLuis R. Rodriguez <mcgrof@do-not-panic.com>\n')
> > +        f.write('L:\tbackports@vger.kernel.org\n')
> > +        f.write('T:\tgit://git.kernel.org/pub/scm/linux/kernel/git/backports/backports.git\n')
> > +        f.write('F:\tbackports/\n')
> > +        f.close()
> 
> That's ... odd? doesn't even fit the MAINTAINERS file style? Anyway I
> think it's probably not necessary.

OK.

> > +        git_debug_snapshot(args, "add backport maintainers entry")
> > +
> > +        f = open(os.path.join(args.outdir, '../Makefile'), 'a')
> > +        f.write('ifeq ($(KBUILD_EXTMOD),)\n')
> > +        f.write('backports-y := backports/\n')
> > +        f.write('vmlinux-dirs += $(patsubst %/,%,$(filter %/, $(backports-y) $(backports-m)))\n')
> > +        f.write('vmlinux-alldirs += $(patsubst %/,%,$(filter %/, $(backports-n) $(backports-)))\n')
> > +        f.write('backports-y       := $(patsubst %/, %/built-in.o, $(backports-y))\n')
> > +        f.write('KBUILD_VMLINUX_MAIN += $(backports-y)\n')
> > +        f.write('endif\n')
> > +        f.close()
> 
> That could be a template file again that you just copy.

In the end wend with a patch since the above doesn't work well as there
is tons of places where the variables are re-used. I will allow for
integration patches then, that will be part of my next respin.

> [... I need more time to review, don't have much this morning ...]

OK.

  Luis
