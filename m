Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3F1IQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:16:08 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:51414 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3F1IP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:15:59 -0400
Date: Fri, 28 Jun 2013 10:15:52 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 1/5] vmcore: Introduce ELF header in new memory
 feature
Message-ID: <20130628101552.68aab404@holzheu>
In-Reply-To: <20130627202334.GL4899@redhat.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130614185401.GL12023@redhat.com>
	<20130621161703.751b5f23@holzheu>
	<20130627193202.GK4899@redhat.com>
	<20130627202334.GL4899@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062808-0342-0000-0000-00000570FAB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 16:23:34 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Jun 27, 2013 at 03:32:02PM -0400, Vivek Goyal wrote:
> > On Fri, Jun 21, 2013 at 04:17:03PM +0200, Michael Holzheu wrote:
> > > On Fri, 14 Jun 2013 14:54:02 -0400
> > > Vivek Goyal <vgoyal@redhat.com> wrote:

[snip]

> Thinking more about it, I think let us cleanup with this little ugly
> bit too so that future changes become easy.
> 
> Current convention is that elfcorehdr_addr and elfcorehdr_size are
> already set by arch code by the time vmcore.c starts reading it. Can't
> s390 allocate elf headers in early boot code and elfcorehdr_addr? Then
> we don't have to call elfcorehdr_alloc().
> 
> And once we are done with reading headers, we can call elfcorehdr_free()
> and s390 could free memory and set elfcorehdr_addr to ELFCORE_ADDR_ERR
> and elfcorehdr_size=0. That would signify that one can not try to read
> elf headers now and it must have been freed.
> 
> is_kdump_kernel() will continue to work as elfcorehdr_addr is
> ELFCORE_ADDR_ERR. And that will mean that either elfcorehdr were not
> readable/usable to begin with or they have been freed now.

Hello Vivek,

We would like to keep the alloc/free symmetry as you have suggested in a
previous mail. This also has the advantage that we do not have to rely
on the ordering of init calls.

Wouldn't it be sufficient to just set elfcorehdr_addr to ELFCORE_ADDR_ERR
after elfcorehdr_free() and remove the comment?

So the code would look like the following:

static int __init vmcore_init(void)
{
        int rc = 0;

        /* Allow architectures to allocate ELF header in 2nd kernel */
        rc = elfcorehdr_alloc(&elfcorehdr_addr, &elfcorehdr_size);
        if (rc)
                return rc;
        /*
         * If elfcorehdr= has been passed in cmdline or created in 2nd kernel,
         * then capture the dump.
         */
        if (!(is_vmcore_usable()))
                return rc;
        rc = parse_crash_elf_headers();
        if (rc) {
                pr_warn("Kdump: vmcore not initialized\n");
                return rc;
        }
        elfcorehdr_free(elfcorehdr_addr);
	elfcorehdr_addr = ELFCORE_ADDR_ERR;

        proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
        if (proc_vmcore)
                proc_vmcore->size = vmcore_size;
        return 0;
}

This looks clean for me.

What do you think?

Best Regards,
Michael

