Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3ILTMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:12:20 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:37647 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3ILTMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:12:19 -0400
Date: Thu, 12 Sep 2013 16:12:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912191213.GB11400@ghostprotocols.net>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912184341.GA11400@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 12, 2013 at 03:43:41PM -0300, Arnaldo Carvalho de Melo escreveu:
> But if I do it as a normal user and then try installing as root... it
> behaves like you described, duh :-\
> 
> Because of this:
> 
>     * new build flags or prefix
> 
> Will check...

This is the cause:


### Detect prefix changes
TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)

$(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
        @FLAGS='$(TRACK_CFLAGS)'; \
            if test x"$$FLAGS" != x"`cat $(OUTPUT)PERF-CFLAGS 2>/dev/null`" ; then \
                echo 1>&2 "    * new build flags or prefix"; \
                echo "$$FLAGS" >$(OUTPUT)PERF-CFLAGS; \
            fi

That "prefix" thing, i.e.:

             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)


As user it is:

/home/acme/bin:libexec/perf-core:share/perf-core/templates:/home/acme

while as root it becomes:

/root/bin:libexec/perf-core:share/perf-core/templates:/root

And that causes the whole thing to be rebuilt when going from 'make' as normal
user to 'make install' as root.

All the other things in that TRACK_CFLAGS part is equal.

We probably got all this from the 'git' makefile, checking how it is done
there these days...

- Arnaldo
