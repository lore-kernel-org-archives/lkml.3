Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3F0UYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:24:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab3F0UYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:24:05 -0400
Date: Thu, 27 Jun 2013 16:23:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 1/5] vmcore: Introduce ELF header in new memory feature
Message-ID: <20130627202334.GL4899@redhat.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
 <20130614185401.GL12023@redhat.com>
 <20130621161703.751b5f23@holzheu>
 <20130627193202.GK4899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627193202.GK4899@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 03:32:02PM -0400, Vivek Goyal wrote:
> On Fri, Jun 21, 2013 at 04:17:03PM +0200, Michael Holzheu wrote:
> > On Fri, 14 Jun 2013 14:54:02 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Fri, Jun 07, 2013 at 06:55:57PM +0200, Michael Holzheu wrote:
> > > 
> > > [..]
> > > > @@ -935,10 +967,17 @@ static int __init vmcore_init(void)
> > > >  {
> > > >  	int rc = 0;
> > > >  
> > > > -	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
> > > > -	if (!(is_vmcore_usable()))
> > > > -		return rc;
> > > > +	/*
> > > > +	 * If elfcorehdr= has not been passed in cmdline, try to get the
> > > > +	 * header from 2nd kernel, then capture the dump.
> > > > +	 */
> > > > +	if (!(is_vmcore_usable())) {
> > > > +		rc = elfcorehdr_alloc();
> > > > +		if (rc)
> > > > +			return rc;
> > > > +	}
> > > 
> > > Hi Michael,
> > > 
> > > Patch description says that elfcorehdr_alloc() returns the addr and 
> > > size of elf headers. But that does not seem to be the case here. Has
> > > it been modified in later patches.
> > 
> > Sorry, that is a relict of one of my previous experiments where I tried
> > to implement elfcorehdr_addr() similar to the way as you suggest it now.
> > Because elfcorehdr_addr is a global variable, I decided to not pass
> > it in the functions. But of course I can change that again if you prefer
> > that.
> >  
> > > Also will it be better if we call elfcorehdr_alloc() always and then
> > > check for is_vmcore_usable().
> > > 
> > > Something like.
> > > 
> > > elfcorehdr_addr = elfcorehdr_alloc()
> > > if (elfcorehdr_addr < )
> > > 	return elfcorehdr_addr
> > > 
> > > if (!(is_vmcore_usable()))
> > > 	return error
> > 
> > Ok, but then I think elfcorehdr_alloc() should also return
> > the elfcorehdr_size.
> > 
> > So what about the following patch:
> 
> This patch looks good to me. There are little ugly pieces w.r.t not
> setting elfcorehdr_addr null after calling free() as there are other
> pieces depdendent on elfcorehdr_addr. I think sometime later we can
> have a separate variable to track track whether this is kdump kernel
> and remove dependency on elfcorehdr_addr being set.

Hi Michael,

Thinking more about it, I think let us cleanup with this little ugly
bit too so that future changes become easy.

Current convention is that elfcorehdr_addr and elfcorehdr_size are
already set by arch code by the time vmcore.c starts reading it. Can't
s390 allocate elf headers in early boot code and elfcorehdr_addr? Then
we don't have to call elfcorehdr_alloc().

And once we are done with reading headers, we can call elfcorehdr_free()
and s390 could free memory and set elfcorehdr_addr to ELFCORE_ADDR_ERR
and elfcorehdr_size=0. That would signify that one can not try to read
elf headers now and it must have been freed.

is_kdump_kernel() will continue to work as elfcorehdr_addr is
ELFCORE_ADDR_ERR. And that will mean that either elfcorehdr were not
readable/usable to begin with or they have been freed now.

Thanks
Vivek
