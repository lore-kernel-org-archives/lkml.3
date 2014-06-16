Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaFPXyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:54:37 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:50414 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaFPXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:54:34 -0400
Date: Mon, 16 Jun 2014 16:54:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Nazarewicz <mina86@mina86.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include: kernel.h: rewrite min3, max3 and clamp using
 min and max
In-Reply-To: <20140616163525.46933b64320e220a6d806bb4@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1406161652490.21018@chino.kir.corp.google.com>
References: <1402952842-12886-1-git-send-email-mina86@mina86.com> <20140616161804.bb06ed842f59371c031d1252@linux-foundation.org> <alpine.DEB.2.02.1406161621530.21018@chino.kir.corp.google.com> <20140616163525.46933b64320e220a6d806bb4@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Andrew Morton wrote:

> On Mon, 16 Jun 2014 16:25:15 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> > On Mon, 16 Jun 2014, Andrew Morton wrote:
> > 
> > > > It appears that gcc is better at optimising a double call to min
> > > > and max rather than open coded min3 and max3.  This can be observed
> > > > here:
> > > > 
> > > > ...
> > > >
> > > > Furthermore, after ___make allmodconfig && make bzImage modules___ this is the
> > > > comparison of image and modules sizes:
> > > > 
> > > >     # Without this patch applied
> > > >     $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
> > > >     350715800
> > > > 
> > > >     # With this patch applied
> > > >     $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
> > > >     349856528
> > > 
> > > We saved nearly a megabyte by optimising min3(), max3() and clamp()? 
> > > 
> > > I'm counting a grand total of 182 callsites for those macros.  So the
> > > saving is 4700 bytes per invokation?  I don't believe it...
> > > 
> > 
> > I was checking just the instances of min3() in mm/ and gcc ends up 
> > inlining transfer_objects() in mm/slab.c as a result of this change and 
> > increases its text size:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >   28369	  21559	      4	  49932	   c30c	slab.o.before
> >   28399	  21559	      4	  49962	   c32a	slab.o.after
> 
> Maybe that's a good thing in disguise: gcc said "hey this thing is now
> small enough to inline it".
> 

On linux-next, allyesconfig has a 0.0001% savings as a result of the 
patch, but I'd be worried about the extra temp variable it allocates on 
the stack that is evident in the mm/slab.c disassembly unless all cases 
can be audited to show that we're not potentially deep.

   text	   data	    bss	    dec	    hex	filename
108573045	23488016	51580928	183641989	af22785	vmlinux.before
108572908	23488016	51580928	183641852	af226fc	vmlinux.after
