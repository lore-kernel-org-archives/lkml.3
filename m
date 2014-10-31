Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbaJaHvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:51:04 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:50362 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbaJaHvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:51:00 -0400
Message-ID: <1414741851.3014.13.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC v2 4/4] backports: add kernl integration support to
 gentree.py
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Stefan Assmann <sassmann@kpanic.de>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz
Date: Fri, 31 Oct 2014 08:50:51 +0100
In-Reply-To: <20141029160003.GW28966@wotan.suse.de> (sfid-20141029_170034_600454_10CE6011)
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
	 <1414570902-5675-5-git-send-email-mcgrof@do-not-panic.com>
	 <5451099B.7090102@kpanic.de> <20141029160003.GW28966@wotan.suse.de>
	 (sfid-20141029_170034_600454_10CE6011)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 17:00 +0100, Luis R. Rodriguez wrote:

>  backport/Kconfig                              |  54 --------
>  backport/Kconfig.package                      |  31 +++++
>  backport/Kconfig.sources                      |  23 ++++

I think you should do this split as a separate patch.

> +# these will be generated
> +source "$BACKPORT_DIR/Kconfig.kernel"
> +source "$BACKPORT_DIR/Kconfig.versions"
> +source "$BACKPORT_DIR/Kconfig.sources"

Not true - Kconfig.sources exists below?

> +ifneq ($(BACKPORT_PACKAGE),)

I think it'd be easier to understand if you called this

BACKPORT_INTEGRATED

and inverted the logic.

> +        # Only the kconfig 'mainmenu' entries grok variables, we want to keep
> +        # this the main Kconfig as part of our program to be able to give it
> +        # enough dynamic information
> +        k = open(os.path.join(args.outdir, 'Kconfig'), 'w')
> +        k.write('config BACKPORT_DIR\n')
> +        k.write('\tstring\n')
> +        k.write('\tdefault "backports/"\n')
> +        k.write('config BACKPORTS_VERSION\n')
> +        k.write('\tstring\n')
> +        k.write('\tdefault "%s"\n' % backports_version)
> +        k.write('config BACKPORTED_KERNEL_VERSION\n')
> +        k.write('\tstring\n')
> +        k.write('\tdefault "%s"\n' % kernel_version)
> +        k.write('config BACKPORTED_KERNEL_NAME\n')
> +        k.write('\tstring\n')
> +        k.write('\tdefault "%s"\n' % args.base_name)
> +        k.write('\n')
> +        k.write('menuconfig BACKPORT_LINUX\n')
> +        k.write('\tbool "Backport %s %s (backports %s)"\n' % (args.base_name, kernel_version, backports_version))
> +        k.write('\tdefault n\n')
> +        k.write('\t---help--- \n')
> +        k.write('\t  Enabling this will let give you the opportunity to use\n')
> +        k.write('\t  features and drivers backported from %s %s\n' % (args.base_name, kernel_version))
> +        k.write('\t  on the kernel your are using. This is experimental and you should\n')
> +        k.write('\t  say no unless you\'d like to help test things.\n')
> +        k.write('\n')
> +        k.write('if BACKPORT_LINUX\n')
> +        k.write('\n')
> +        k.write('source "$BACKPORT_DIR/Kconfig.versions"\n')
> +        k.write('source "$BACKPORT_DIR/Kconfig.sources"\n')
> +        k.write('\n')
> +        k.write('endif # BACKPORT_LINUX\n')

This is really really ugly - please just have a file template, and maybe
replace some things in it or provide them as env variables through the
Makefile or so.

> +    if args.integrate:
> +        f = open(os.path.join(args.outdir, '../arch/x86/Kconfig'), 'a')
> +        f.write('source "backports/Kconfig"\n')

That seems like a bad idea - maybe better integrate it under some
arch-independent file?

> +        f.close()
> +        git_debug_snapshot(args, "hooked backport Kconfig to supported architectures")
> +
> +        f = open(os.path.join(args.outdir, '../MAINTAINERS'), 'a')
> +        f.write('M:\tHauke Mehrtens <hauke@hauke-m.de>\n')
> +        f.write('M:\tLuis R. Rodriguez <mcgrof@do-not-panic.com>\n')
> +        f.write('L:\tbackports@vger.kernel.org\n')
> +        f.write('T:\tgit://git.kernel.org/pub/scm/linux/kernel/git/backports/backports.git\n')
> +        f.write('F:\tbackports/\n')
> +        f.close()

That's ... odd? doesn't even fit the MAINTAINERS file style? Anyway I
think it's probably not necessary.

> +        git_debug_snapshot(args, "add backport maintainers entry")
> +
> +        f = open(os.path.join(args.outdir, '../Makefile'), 'a')
> +        f.write('ifeq ($(KBUILD_EXTMOD),)\n')
> +        f.write('backports-y := backports/\n')
> +        f.write('vmlinux-dirs += $(patsubst %/,%,$(filter %/, $(backports-y) $(backports-m)))\n')
> +        f.write('vmlinux-alldirs += $(patsubst %/,%,$(filter %/, $(backports-n) $(backports-)))\n')
> +        f.write('backports-y       := $(patsubst %/, %/built-in.o, $(backports-y))\n')
> +        f.write('KBUILD_VMLINUX_MAIN += $(backports-y)\n')
> +        f.write('endif\n')
> +        f.close()

That could be a template file again that you just copy.

[... I need more time to review, don't have much this morning ...]

johannes

