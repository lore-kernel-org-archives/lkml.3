Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaEOToq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:44:46 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62682 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbaEOTol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:44:41 -0400
Date: Thu, 15 May 2014 12:44:37 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: roundup_pow_of_two() may not handle 64-bit integers
Message-ID: <20140515194437.GM28907@ld-irv-0074>
References: <20140515022238.GL28907@ld-irv-0074>
 <29314.1400166189@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29314.1400166189@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 04:03:09PM +0100, David Howells wrote:
> Brian Norris <computersforpeace@gmail.com> wrote:
> > I'm looking to use roundup_pow_of_two() (actually, order_base_2())
> > from <linux/log2.h>, but it seems that it only supports 64-bit integers
> > if your toolchain uses a 64-bit 'unsigned long' type. This is strange,
> > considering that ilog2() is explicitly designed for 32-bit or 64-bit
> > compatibility.
> 
> ilog2() was explicitly designed for use with 'unsigned long'.  See the commit
> description (f0d1b0b30d250a07627ad8b9fbbb5c7cc08422e8).  It may work with
> unsigned long long, however...

That's another confusing point; the commit description says 'unsigned
long', but the code shows nothing of that sort, and the comments say
nearly the reverse (mentioning '32-bit and 64-bit', not 'unsigned
long'). The code only referenes ULL constants, and it selects a 32-bit
or 64-bit runtime version based on the type. To me, this demonstrates an
explicit design for "32-bit or 64-bit", regardless of the dimensions of
your 'long'.

So this leaves me with 2 main issues:

(1) Can we make <linux/ilog2.h> have some sense of consistency? If so,
    how?
     - Enforce the 'unsigned long' design (i.e., don't support
       ilog2(u64) when sizeof(unsigned long) == 4)?
     - Make all high-level macros automatically support 32-bit or 64-bit,
       regardless of type?
     - Split out 32-bit vs. 64-bit functions for everything?

    Obviously some of these options are sillier than others.

(2) Powerpc (and maybe some of SH's PCI) code has a potential bug, due
    to using roundup_pow_of_two() on type phys_addr_t, which could
    overflow for LPAE systems with large physical memory ranges. Is this
    a legitimate concern?

Brian
