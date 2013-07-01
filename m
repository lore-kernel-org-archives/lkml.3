Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3GASaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:30:11 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:47223 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab3GASaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:30:07 -0400
Date: Mon, 1 Jul 2013 20:29:59 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 1/5] vmcore: Introduce ELF header in new memory
 feature
Message-ID: <20130701202959.178a1697@holzheu>
In-Reply-To: <20130701173727.GD9840@redhat.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130614185401.GL12023@redhat.com>
	<20130621161703.751b5f23@holzheu>
	<20130627193202.GK4899@redhat.com>
	<20130627202334.GL4899@redhat.com>
	<20130628101552.68aab404@holzheu>
	<20130701173727.GD9840@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070118-0342-0000-0000-00000576CACF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013 13:37:27 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Jun 28, 2013 at 10:15:52AM +0200, Michael Holzheu wrote:
> > On Thu, 27 Jun 2013 16:23:34 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Thu, Jun 27, 2013 at 03:32:02PM -0400, Vivek Goyal wrote:
> > > > On Fri, Jun 21, 2013 at 04:17:03PM +0200, Michael Holzheu wrote:
> > > > > On Fri, 14 Jun 2013 14:54:02 -0400
> > > > > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > [snip]
> > 
> > > Thinking more about it, I think let us cleanup with this little ugly
> > > bit too so that future changes become easy.
> > > 
> > > Current convention is that elfcorehdr_addr and elfcorehdr_size are
> > > already set by arch code by the time vmcore.c starts reading it. Can't
> > > s390 allocate elf headers in early boot code and elfcorehdr_addr? Then
> > > we don't have to call elfcorehdr_alloc().
> > > 
> > > And once we are done with reading headers, we can call elfcorehdr_free()
> > > and s390 could free memory and set elfcorehdr_addr to ELFCORE_ADDR_ERR
> > > and elfcorehdr_size=0. That would signify that one can not try to read
> > > elf headers now and it must have been freed.
> > > 
> > > is_kdump_kernel() will continue to work as elfcorehdr_addr is
> > > ELFCORE_ADDR_ERR. And that will mean that either elfcorehdr were not
> > > readable/usable to begin with or they have been freed now.
> > 
> > Hello Vivek,
> > 
> > We would like to keep the alloc/free symmetry as you have suggested in a
> > previous mail. This also has the advantage that we do not have to rely
> > on the ordering of init calls.
> > 
> > Wouldn't it be sufficient to just set elfcorehdr_addr to ELFCORE_ADDR_ERR
> > after elfcorehdr_free() and remove the comment?
> > 
> 
> Hi Michael,
> 
> This has only one problem and that is what's the initialization semantics
> of elfcorehdr_addr. 
> 
> So far we expected it to be initialized very early in boot process and
> once this is set, any component in the system could figure out if it
> is kdump kernel (is_kdump_kernel()) and do kdump specific things.
> 
> But if we move initialization of this variable little late, then it
> might be a problem for early users of is_kdump_kernel(). Though right
> now I don't see drivers making use of it and only arch specific early
> boot up code seems to have it.
> 
> So either we can stick to existing semantics of initializing headers
> early or we could create a separate variable for is_kdump_kernel() which
> is set in early boot and then one can delay initialization of
> elfcorehdr_addr() in vmcore_init().

The later makes much sense to me. This would also make the s390 code
easier to read since we then could exchange some early kdump checks
with the official is_kdump() function.

Perhaps we can do that as an additional patch after we are ready with
this patch series.

> 
> Given the fact that I don't see any users of is_kdump_kernel() in arch
> independent directory, and I am assuming that you will tackle all early
> users of is_kdump_kernel() in s390, I will be fine even with your patch
> below.

Ok great, so I will send you the current patch set version 6 with all the
discussed changes.

Thanks!
Michael

