Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaIVIpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:45:22 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45041 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaIVIpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:45:21 -0400
Message-ID: <1411375517.6908.10.camel@nebuchadnezzar>
Subject: Re: [PATCH v3] checkkconfigsymbols.sh: reimplementation in python
From: Valentin Rothberg <valentinrothberg@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stefan.hengelein@fau.de,
        Valentin Rothberg <valentinrothberg@gmail.com>
Date: Mon, 22 Sep 2014 10:45:17 +0200
In-Reply-To: <1411374249.11208.15.camel@x220>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
	 <1411329197-15102-1-git-send-email-valentinrothberg@gmail.com>
	 <1411334939.6049.30.camel@x41> <1411371813.3460.34.camel@nebuchadnezzar>
	 <1411374249.11208.15.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lun., 2014-09-22 at 10:24 +0200, Paul Bolle wrote:
> Hi Valentin,
> 
> On Mon, 2014-09-22 at 09:43 +0200, Valentin Rothberg wrote:
> > On dim., 2014-09-21 at 23:28 +0200, Paul Bolle wrote:
> > > Valentin Rothberg schreef op zo 21-09-2014 om 21:53 [+0200]:
> > > > Furthermore, it generates false positives (4 of 526 in v3.17-rc1).
> > > 
> > > Curiosity: what are those four false positives?
> > 
> > 1) /arch/cris/kernel/module.c: 	ETRAX_KMALLOCED_MODULES (defined in
> > arch/cris/Kconfig)
> 
> This probably because
>     symb_bare=`echo $symb | sed -e 's/_MODULE//'`
> 
> in the shell script you removed should read (something untested like):
>     symb_bare=`echo $symb | sed -e 's/_MODULE$//'`
> 
> > 2) ./lib/Makefile: TEST_MODULE (defined in lib/Kconfig.debug)
> 
> TEST_MODULE is an awkward name for a Kconfig symbol. My local script has
> it special cased.

I plan to rename this feature in a future patch, since imho it violates
the _MODULE suffix for kernel modules.

> 
> > 3,4) ./include/linux/module.h, ./kernel/module.c: DEBUG_SET_MODULE_RONX
> > (defined in arch/{s390,arm,x86}/Kconfig.debug)
> 
> See above.
> 
> > > > This patch replaces the shell script with an implementation in Python,
> > > > which:
> > > >     (a) detects the same bugs, but does not report false positives
> > > 
> > > Depends a bit on the definition of false positives. Ie, the hit for
> > >     ./arch/sh/kernel/head_64.S:	CACHE_
> > > 
> > > is caused by
> > >      #error preprocessor flag CONFIG_CACHE_... not recognized!
> > > 
> > > Should that line, and similar lines, be changed?
> > 
> > I consider a false positive to actually be defined in Kconfig. The
> > feature in your example does not really apply to the naming convention
> > of Kconfig features ("..."), so that our regex does not match it.
> 
> But your python script does report it, doesn't it?

It does. Regexes are hell :) I will check that and fix it in the next
version of this patch.

> 
> > However, the regex matches "CONFIG_X86_". I shall change the regex to
> > not accept strings ending with "_", so that such cases are not reported.
> 
> > > > +# REGEX EXPRESSIONS
> > > > +OPERATORS = r"&|\(|\)|\||\!"
> > > > +FEATURE = r"\w*[A-Z]{1}\w*"
> > > > +FEATURE_DEF = r"^\s*(menu){,1}config\s+" + FEATURE + r"\s*"
> > > > +EXPR = r"(" + OPERATORS + r"|\s|" + FEATURE + r")*"
> > > > +STMT = r"^\s*(if|select|depends\s+on)\s+" + EXPR
> > > 
> > >                           "depends on" with multiple spaces?
> > > > +
> > > > +# REGEX OBJECTS
> > > > +REGEX_FILE_KCONFIG = re.compile(r"Kconfig[\.\w+\-]*$")
> > > > +REGEX_FILE_SOURCE = re.compile(r"\.[cSh]$")
> 
> New observation: this causes the script to skip text files, shell
> scripts, etc, doesn't it? 

Yes. Do you prefer to cover such files? I just grepped CONFIG_ in
Documentation and think that covering such could improve the quality
there too. I will put this into the next version of the patch.

> > > > +REGEX_FILE_MAKE = re.compile(r"Makefile|Kbuild[\.\w+]*$")
> > > > +REGEX_FEATURE = re.compile(r"(" + FEATURE + r")")
> > > > +REGEX_FEATURE_DEF = re.compile(FEATURE_DEF)
> > > > +REGEX_CPP_FEATURE = re.compile(r"\W+CONFIG_(" + FEATURE + r")[.]*")
> > > 
> > > There are a few uses of "-DCONFIG_[...]" in Makefiles. This will miss
> > > those, won't it? That's not bad, per se, but a comment why you're
> > > skipping those might be nice. Or are those caught too, somewhere else?
> > 
> > I was not aware of such uses, thanks. It seems important to cover them
> > too. Does this prefix has a certain purpose?
> 
> It is, in short, a way to define preprocessor macros from the GCC
> command line (see info gcc).
> 
> > > > +REGEX_KCONFIG_EXPR = re.compile(EXPR)
> > > > +REGEX_KCONFIG_STMT = re.compile(STMT)
> > > > +REGEX_KCONFIG_HELP = re.compile(r"^[\s|-]*help[\s|-]*")
> > > 
> > > Won't "^\s\+(---help---|help)$" do? Might help catch creative variants
> > > of the help statement (we had a few in the past).
> > 
> > Yes, your regex is more robust. Thanks!
> 
> But it seems I should not have escaped the plus. Please check.

Thank you,
 Valentin

> 
> 
> Paul Bolle
> 


