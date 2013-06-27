Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3F0UKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:10:52 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42690 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754345Ab3F0UKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:10:50 -0400
Date: Thu, 27 Jun 2013 15:10:47 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v5 1/5] vmcore: Introduce ELF header in new memory
	feature
Message-ID: <20130627201047.GB28477@sgi.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com> <1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com> <20130614185401.GL12023@redhat.com> <20130621161703.751b5f23@holzheu> <20130627193202.GK4899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627193202.GK4899@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
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
> 
> 
> So I am fine with this patch.

I would like to endorse this whole vmcore series.  It greatly speeds the
writing of a system dump.

In my recent tests these patches cut 16% to 58% off the time to create a
dump, depending on the size of the system.
On an idle 117G memory, for example, the patches reduced the time from 4.8
minutes to 2.0 minutes.  (the savings are less pronounced on a bigger
system)

-Cliff

> 
> Vivek
> 
> > ---
> >  fs/proc/vmcore.c           |   65 +++++++++++++++++++++++++++++++++++++--------
> >  include/linux/crash_dump.h |    6 ++++
> >  2 files changed, 60 insertions(+), 11 deletions(-)
> > 
> > --- a/fs/proc/vmcore.c
> > +++ b/fs/proc/vmcore.c
> > @@ -123,6 +123,36 @@ static ssize_t read_from_oldmem(char *bu
> >  	return read;
> >  }
> >  
> > +/*
> > + * Architectures may override this function to allocate ELF header in 2nd kernel
> > + */
> > +int __weak elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size)
> > +{
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Architectures may override this function to free header
> > + */
> > +void __weak elfcorehdr_free(unsigned long long addr)
> > +{}
> > +
> > +/*
> > + * Architectures may override this function to read from ELF header
> > + */
> > +ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos)
> > +{
> > +	return read_from_oldmem(buf, count, ppos, 0);
> > +}
> > +
> > +/*
> > + * Architectures may override this function to read from notes sections
> > + */
> > +ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
> > +{
> > +	return read_from_oldmem(buf, count, ppos, 0);
> > +}
> > +
> >  /* Read from the ELF header and then the crash dump. On error, negative value is
> >   * returned otherwise number of bytes read are returned.
> >   */
> > @@ -322,7 +352,7 @@ static int __init update_note_header_siz
> >  		notes_section = kmalloc(max_sz, GFP_KERNEL);
> >  		if (!notes_section)
> >  			return -ENOMEM;
> > -		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
> > +		rc = elfcorehdr_read_notes(notes_section, max_sz, &offset);
> >  		if (rc < 0) {
> >  			kfree(notes_section);
> >  			return rc;
> > @@ -409,7 +439,8 @@ static int __init copy_notes_elf64(const
> >  		if (phdr_ptr->p_type != PT_NOTE)
> >  			continue;
> >  		offset = phdr_ptr->p_offset;
> > -		rc = read_from_oldmem(notes_buf, phdr_ptr->p_memsz, &offset, 0);
> > +		rc = elfcorehdr_read_notes(notes_buf, phdr_ptr->p_memsz,
> > +					   &offset);
> >  		if (rc < 0)
> >  			return rc;
> >  		notes_buf += phdr_ptr->p_memsz;
> > @@ -510,7 +541,7 @@ static int __init update_note_header_siz
> >  		notes_section = kmalloc(max_sz, GFP_KERNEL);
> >  		if (!notes_section)
> >  			return -ENOMEM;
> > -		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
> > +		rc = elfcorehdr_read_notes(notes_section, max_sz, &offset);
> >  		if (rc < 0) {
> >  			kfree(notes_section);
> >  			return rc;
> > @@ -597,7 +628,8 @@ static int __init copy_notes_elf32(const
> >  		if (phdr_ptr->p_type != PT_NOTE)
> >  			continue;
> >  		offset = phdr_ptr->p_offset;
> > -		rc = read_from_oldmem(notes_buf, phdr_ptr->p_memsz, &offset, 0);
> > +		rc = elfcorehdr_read_notes(notes_buf, phdr_ptr->p_memsz,
> > +					   &offset);
> >  		if (rc < 0)
> >  			return rc;
> >  		notes_buf += phdr_ptr->p_memsz;
> > @@ -793,7 +825,7 @@ static int __init parse_crash_elf64_head
> >  	addr = elfcorehdr_addr;
> >  
> >  	/* Read Elf header */
> > -	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf64_Ehdr), &addr, 0);
> > +	rc = elfcorehdr_read((char *)&ehdr, sizeof(Elf64_Ehdr), &addr);
> >  	if (rc < 0)
> >  		return rc;
> >  
> > @@ -820,7 +852,7 @@ static int __init parse_crash_elf64_head
> >  	if (!elfcorebuf)
> >  		return -ENOMEM;
> >  	addr = elfcorehdr_addr;
> > -	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
> > +	rc = elfcorehdr_read(elfcorebuf, elfcorebuf_sz_orig, &addr);
> >  	if (rc < 0)
> >  		goto fail;
> >  
> > @@ -849,7 +881,7 @@ static int __init parse_crash_elf32_head
> >  	addr = elfcorehdr_addr;
> >  
> >  	/* Read Elf header */
> > -	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf32_Ehdr), &addr, 0);
> > +	rc = elfcorehdr_read((char *)&ehdr, sizeof(Elf32_Ehdr), &addr);
> >  	if (rc < 0)
> >  		return rc;
> >  
> > @@ -875,7 +907,7 @@ static int __init parse_crash_elf32_head
> >  	if (!elfcorebuf)
> >  		return -ENOMEM;
> >  	addr = elfcorehdr_addr;
> > -	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
> > +	rc = elfcorehdr_read(elfcorebuf, elfcorebuf_sz_orig, &addr);
> >  	if (rc < 0)
> >  		goto fail;
> >  
> > @@ -902,7 +934,7 @@ static int __init parse_crash_elf_header
> >  	int rc=0;
> >  
> >  	addr = elfcorehdr_addr;
> > -	rc = read_from_oldmem(e_ident, EI_NIDENT, &addr, 0);
> > +	rc = elfcorehdr_read(e_ident, EI_NIDENT, &addr);
> >  	if (rc < 0)
> >  		return rc;
> >  	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
> > @@ -935,7 +967,14 @@ static int __init vmcore_init(void)
> >  {
> >  	int rc = 0;
> >  
> > -	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
> > +	/* Allow architectures to allocate ELF header in 2nd kernel */
> > +	rc = elfcorehdr_alloc(&elfcorehdr_addr, &elfcorehdr_size);
> > +	if (rc)
> > +		return rc;
> > +	/*
> > +	 * If elfcorehdr= has been passed in cmdline or created in 2nd kernel,
> > +	 * then capture the dump.
> > +	 */
> >  	if (!(is_vmcore_usable()))
> >  		return rc;
> >  	rc = parse_crash_elf_headers();
> > @@ -943,7 +982,11 @@ static int __init vmcore_init(void)
> >  		pr_warn("Kdump: vmcore not initialized\n");
> >  		return rc;
> >  	}
> > -
> > +	elfcorehdr_free(elfcorehdr_addr);
> > +	/*
> > +	 * elfcorehdr_addr must not be set to NULL here to keep
> > +	 * is_kdump_kernel() working.
> > +	 */
> >  	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
> >  	if (proc_vmcore)
> >  		proc_vmcore->size = vmcore_size;
> > --- a/include/linux/crash_dump.h
> > +++ b/include/linux/crash_dump.h
> > @@ -12,6 +12,12 @@
> >  extern unsigned long long elfcorehdr_addr;
> >  extern unsigned long long elfcorehdr_size;
> >  
> > +extern int __weak elfcorehdr_alloc(unsigned long long *addr,
> > +				   unsigned long long *size);
> > +extern void __weak elfcorehdr_free(unsigned long long addr);
> > +extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
> > +extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
> > +
> >  extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
> >  						unsigned long, int);
> >  
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
