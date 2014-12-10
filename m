Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaLJKmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:42:06 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:33027 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaLJKmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:42:04 -0500
Date: Wed, 10 Dec 2014 16:11:24 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Subject: Re: [RFC PATCH 2/8] perf probe powerpc: Fix symbol fixup issues due
 to ELF type
Message-ID: <20141210104124.GB16045@naverao1-tp.in.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <0412a00009a22762f92c208964df6f842796464e.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <1418205050.9279.5.camel@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418205050.9279.5.camel@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121010-0005-0000-0000-000002B94E99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/10 08:50PM, Michael Ellerman wrote:
> On Tue, 2014-12-09 at 23:04 +0530, Naveen N. Rao wrote:
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
> 
> OK, but why is that happening? And why does checking for ET_DYN fix it?

The section header indicates 0x10000 as the offset:

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .text             PROGBITS         c000000000000000  00010000
       0000000000806678  0000000000000000  AX       0     0     256

This is used during fixup and perf only expects this to be needed for
ET_EXEC, though we use ET_DYN on ppc64.

> > Fix by checking for ELF type ET_DYN used by ppc64 kernels.
> 
> We sometimes produce ET_DYN kernels, but only if CONFIG_RELOCATABLE=y.

Ok.

- Naveen

