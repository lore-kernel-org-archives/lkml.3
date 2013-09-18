Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3IROF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:05:57 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53932 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3IROFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:05:55 -0400
Date: Wed, 18 Sep 2013 07:05:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modpost: Fix secondary errors seen if a single module
 build fails
Message-ID: <20130918140549.GA15490@roeck-us.net>
References: <1379219942-31545-1-git-send-email-linux@roeck-us.net>
 <52384C72.4040403@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52384C72.4040403@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 02:34:58PM +0200, Michal Marek wrote:
> Dne 15.9.2013 06:39, Guenter Roeck napsal(a):
> > Commit ea4054a23 (modpost: handle huge numbers of modules) added
> > support for building a large number of modules.
> > 
> > Unfortunately, the commit changed the semantics of the makefile: Instead of
> > passing only existing object files to modpost, make now passes all expected
> > object files. If make was started with option -i, this results in a modpost
> > error if a single file failed to build.
> > 
> > Example with the current btrfs build falure on m68k:
> > 
> > fs/btrfs/btrfs.o: No such file or directory
> > make[1]: [__modpost] Error 1 (ignored)
> > 
> > This error is followed by lots of errors such as:
> > 
> > m68k-linux-gcc: error: arch/m68k/emu/nfcon.mod.c: No such file or directory
> > m68k-linux-gcc: fatal error: no input files
> > compilation terminated.
> > make[1]: [arch/m68k/emu/nfcon.mod.o] Error 1 (ignored)
> > 
> > This doesn't matter much for normal builds, but it is annoying for builds
> > started with "make -i" due to the large number of secondary errors.
> > Those errors unnececessarily clog any error log and make it difficult
> > to find the real errors in the build.
> > 
> > Fix the problem by only passing existing object files to modpost.
> > 
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  scripts/Makefile.modpost |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> > index 8dcdca2..387c806 100644
> > --- a/scripts/Makefile.modpost
> > +++ b/scripts/Makefile.modpost
> > @@ -81,7 +81,8 @@ modpost = scripts/mod/modpost                    \
> >  
> >  # We can go over command line length here, so be careful.
> >  quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
> > -      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | $(modpost) -s -T -
> > +      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | \
> > +	while read a; do [ -f $$a ] && echo $$a; done | $(modpost) -s -T -
> 
> Can you do this filtering only if make -i is used ('i' is present in
> $(MAKEFLAGS)), to not hide potential buildsystem bugs? Regarding shell
> loop vs. ls, maybe the cleanest way would be to add an option to modpost
> to ignore missing files.
> 
To follow up on this - are you at the Linux Plumbers conference ?
If yes maybe we can meet briefly and discuss how to proceed.
I'd volunteer to create a patch to add the above functionality if
people think it is valuable, but I would like to keep it as
separate patch.

Thanks,
Guenter
