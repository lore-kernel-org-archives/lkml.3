Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3EWSwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:52:50 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40252 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3EWSwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:52:49 -0400
Date: Thu, 23 May 2013 20:52:41 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v2 1/3] kdump: Introduce ELF header in new memory
 feature
Message-ID: <20130523205241.4b9e4fde@holzheu>
In-Reply-To: <20130523174127.GA12290@redhat.com>
References: <1369245517-16204-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1369245517-16204-2-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130523174127.GA12290@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052318-3548-0000-0000-0000057AAFD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

Thanks for your reply. I will integrate your feedback into the v3 patch
set and will make the following changes:

- Get rid of ELFCORE_ADDR_NEWMEM (sorry for that:)
- Make read_from_crash_header() only read from kernel
- Move read_from_crash_header() to weak function
  arch_read_from_crash_header()
- Implement read_from_crash_header() strong function for s390
- Set elfcorehdr_addr to address of new ELF header

Best Regards,
Michael

On Thu, 23 May 2013 13:41:27 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, May 22, 2013 at 07:58:35PM +0200, Michael Holzheu wrote:
> > or s390 we create the ELF core header in the 2nd kernel
> > with a small trick. We relocate the addresses in the ELF header in
> > a way that for the /proc/vmcore code it seems to be in the 1st
> > kernel (old) memory and the read_from_oldmem() returns the correct
> > data. This allows the /proc/vmcore code to use the ELF header in the
> > 2nd kernel.
> > 
> > This patch now exchanges the old mechanism with the new and much
> > cleaner function call override feature that now offcially allows to
> > create the ELF core header in the 2nd kernel.
> > 
> > To use the new feature the following has to be done by the
> > architecture backend code:
> > 
> >  * Set elfcorehdr_addr to ELFCORE_ADDR_NEWMEM
> >    -> is_kdump_kernel() will return true
> 
> setting elfcorehdr_addr to ELFCORE_ADDR_NEWMEM looks really odd to me.
> There is no need for arch independent code to know whether crash
> headers are in new memory or not. Our old assumption was that
> everything is in old memory. Now that is broken because of s390. So
> arch should be able to override read_from_crash_header() call and
> read headers from new memory. If need be s390 can maintain another
> variable for this state to figure out where headers are.
> 
> Also arch should be able to  set elfcorehdr_addr to virtual address
> of ELF header. is_kdump_kernel() does not care whether address stored
> in elfcorehdr_addr is physical or virtual.
> 
> IOW, generic code would not care whether headers are in new memory
> or old memory. All the operations on header will be abstracted with
> the help of helper functions.
> 
> Can we please get rid of this NEWMEM stuff.
> 
> 
> >  * Override arch_get_crash_header() to return the address of the ELF
> >    header in new memory.
> >  * Override arch_free_crash_header() to free the memory of the ELF
> >    header in new memory.
> > 
> > Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > ---
> >  fs/proc/vmcore.c           | 80
> > +++++++++++++++++++++++++++++++++++-----------
> > include/linux/crash_dump.h |  3 ++ 2 files changed, 65
> > insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> > index 6ba32f8..d97ed31 100644
> > --- a/fs/proc/vmcore.c
> > +++ b/fs/proc/vmcore.c
> > @@ -123,6 +123,47 @@ static ssize_t read_from_oldmem(char *buf,
> > size_t count, return read;
> >  }
> >  
> > +/*
> > + * Read from the current (new) kernel memory
> > + */
> > +static ssize_t read_from_newmem(char *buf, size_t count, u64
> > *ppos, int userbuf) +{
> > +	if (userbuf) {
> > +		if (copy_to_user(buf, (void *)*ppos, count))
> > +			return -EFAULT;
> > +	} else {
> > +		memcpy(buf, (void *)*ppos, count);
> > +	}
> > +	*ppos += count;
> > +	return count;
> > +}
> > +
> 
> Why do we need read_from_newmem? I thought arch code will override
> read_from_crash_header() and write a variant of read_from_newmem()
> internally. I think could still be an helper function in vmcore.c if
> there are many arch keeping headers in new memory so that we don't
> have same code across multiple arches. But s390 seems to be the only
> expcetion at this point of time.
> 
> > +/*
> > + * Provide access to the header
> > + */
> > +static ssize_t read_from_crash_header(char *buf, size_t count, u64
> > *ppos,
> > +				      int userbuf)
> > +{
> > +	if (elfcorehdr_addr == ELFCORE_ADDR_NEWMEM)
> > +		return read_from_newmem(buf, count, ppos, userbuf);
> > +	else
> > +		return read_from_oldmem(buf, count, ppos, userbuf);
> > +}
> > +
> 
> I thought read_from_crash_header() will simply be
> 
> read_from_crash_header() {
> 	return read_from_oldmem()
> }
> 
> And arch code will override it to read the headers from new memory.
> That way generic code does not have to know whether headers are in
> old memory or in new memory or somewhere else.
> 
> Also current usage of read_from_crash_header() seems to be that we are
> not copying header data to user space buffer directly. Generic code
> will process headers and copy them in kernel memory and it will be
> copied to user space from there if need be.
> 
> So for time being I think it should be just fine to assume that
> read_from_crash_header() is copying data to kernel memory only.
> 
> Thanks
> Vivek
> 

