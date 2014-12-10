Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaLJJgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:36:08 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45181 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaLJJgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:36:05 -0500
Date: Wed, 10 Dec 2014 15:05:10 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, ananth@in.ibm.com
Subject: Re: [RFC PATCH 2/8] perf probe powerpc: Fix symbol fixup issues due
 to ELF type
Message-ID: <20141210093510.GG5318@naverao1-tp.in.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <0412a00009a22762f92c208964df6f842796464e.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <20141209210717.GA8788@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209210717.GA8788@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121009-0025-0000-0000-000000B30B2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/09 06:07PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 09, 2014 at 11:04:00PM +0530, Naveen N. Rao escreveu:
> > If using the symbol table, symbol addresses are not being fixed up
> > properly, resulting in probes being placed at wrong addresses:
> > 
> >   # perf probe do_fork
> >   Added new event:
> >     probe:do_fork        (on do_fork)
> > 
> >   You can now use it in all perf tools, such as:
> > 
> > 	  perf record -e probe:do_fork -aR sleep 1
> > 
> >   # cat /sys/kernel/debug/tracing/kprobe_events
> >   p:probe/do_fork _text+635952
> >   # printf "%x" 635952
> >   9b430
> >   # grep do_fork /boot/System.map
> >   c0000000000ab430 T .do_fork
> > 
> > Fix by checking for ELF type ET_DYN used by ppc64 kernels.
> 
> Are you sure this doesn't need to be enclosed in ifdef PPC64?

I felt this change is architecture-independent, though I'm actually not 
sure if there are other architectures using ET_DYN for their kernel. I 
can restrict this to ppc64 if you think that would be better.

- Naveen

> 
> - Arnaldo
> 
> > Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> > ---
> >  tools/perf/util/symbol-elf.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> > index 1e23a5b..67e4392 100644
> > --- a/tools/perf/util/symbol-elf.c
> > +++ b/tools/perf/util/symbol-elf.c
> > @@ -629,7 +629,8 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
> >  						     NULL) != NULL);
> >  	} else {
> >  		ss->adjust_symbols = ehdr.e_type == ET_EXEC ||
> > -				     ehdr.e_type == ET_REL;
> > +				     ehdr.e_type == ET_REL ||
> > +				     ehdr.e_type == ET_DYN;
> >  	}
> >  
> >  	ss->name   = strdup(name);
> > -- 
> > 2.1.3
> 

