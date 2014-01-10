Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaAJHM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:12:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaAJHMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:12:53 -0500
Date: Fri, 10 Jan 2014 15:11:24 +0800
From: Baoquan <bhe@redhat.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com, linux-acpi@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, dyoung@redhat.com
Subject: Re: kdump failed because of hotplug memory adding in kdump kernel
Message-ID: <20140110071124.GA6464@dhcp-16-105.nay.redhat.com>
References: <8500545.JVNPnKcyD1@vostro.rjw.lan>
 <1389226308.1792.39.camel@misato.fc.hp.com>
 <20140109145035.GB25897@redhat.com>
 <1389283439.1792.66.camel@misato.fc.hp.com>
 <20140109162427.GF25897@redhat.com>
 <1389288265.1792.108.camel@misato.fc.hp.com>
 <20140109182310.GG25897@redhat.com>
 <1389292470.1792.109.camel@misato.fc.hp.com>
 <20140109212705.GC12111@redhat.com>
 <1389304583.1792.139.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389304583.1792.139.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/14 at 02:56pm, Toshi Kani wrote:
> On Thu, 2014-01-09 at 16:27 -0500, Vivek Goyal wrote:
> > On Thu, Jan 09, 2014 at 11:34:30AM -0700, Toshi Kani wrote:
> > > On Thu, 2014-01-09 at 13:23 -0500, Vivek Goyal wrote:
> > > > On Thu, Jan 09, 2014 at 10:24:25AM -0700, Toshi Kani wrote:
> > > > 
> > > > [..]
> > > > > > I think creating a new command line option is simpler as compared to
> > > > > > creating a new flag in bootparam which in turn disables memory hotplug.
> > > > > > More users can use that option. For example, if for some reason hotplug
> > > > > > code is crashing, one can just disable it on command line as work around
> > > > > > and move on.
> > > > > 
> > > > > I do not have a strong opinion about having such option.  However, I
> > > > > think it is more user friendly to keep the exactmap option works alone
> > > > > on any platforms.
> > > > 
> > > > I think we should create internally a variable which will disable memory
> > > > hotplug. And set that variable based on memmap=exactmap, mem=X and also
> > > > provide a way to disable memory hotplug directly using command line
> > > > option.
> > > > 
> > > > Current kexec-tools can use memmap=exactmap and be happy. I am writing
> > > > a new kexec syscall and will not be using memmap=exactmap and would need
> > > > to use that command line option to disable memory hotplug behavior.
> > > 
> > > Sounds good to me.
> > 
> > Nobody responded to my other question, so I would ask it again.
> > 
> > Assume we have disabled hotplug memory in second kernel. First kernel
> > saw hotplug memory and assume crash kernel reserved region came from
> > there. We will pass this memory in bootparams to second kernel and it
> > will show up in E820 map. It should still be accessible in second kernel,
> > is that right?
> 
> Yes.
> 
> > Or there is some dependency on ACPI doing some magic before this memory
> > range is available in second kernel?
> 
> No.  The 1st kernel reserves the crash kernel region, which cannot be
> hot-deleted.  So, this region continues to be accessible by the 2nd
> kernel without any operation.

Now what I understand is if a several memsection is reserved for
crashkernel, then in 2nd kernel, they are just like normal memory. In ns
object tree, they are not treated as hotplug memory.

Otherwise, any hotplug memory which is not reserved for 2nd kernel can
be parsed and need be added as hotplug memory, and add them into movable
zone.

Am I right?

The other question, e820 reserve is done earlier than acpi
initialization, because acpi_early_init() invocation is very late in
start_kernel(). Does that means at the very beginning all memorys are in
e820, later when acpi_early_init is called, hotplug memory is detected,
they will be moved to different place or need be marked with a specific
flag?



> 
> I am more curious to know how makedumpfile decides what memory ranges to
> dump.  The 1st kernel may have performed memory hot-add / delete
> operations before a crash, so it needs to know the valid physical
> address range at the time of crash, and may not rely on the E820 map
> from BIOS (which is stale).  Am I right to assume that makedumpfile gets
> it from the page tables of the 1st kernel?

makedumpfile just do the dump, what memory ranges to dump is decided in
1st kernel by kexec-tools. In 1st kernel, if kexec-tools executed, it
will find all System Ram memorys which exclude the reserved regions for
kdump kernel, then build a logical elf file, each load segment is one of
these System Ram memory regions, its addr and length is written into the
program header.

Then makedumpfile just read this elf file, and read all of them and
dump.

If after kexec-tools execution and before crash, a hotplug memory is
removed, udev will check this and trigger a kdump restart, kexec-tools
is executed again, System Ram region information are stored. The logical
file header will be passed to 2nd kernel.


> 
> Thanks,
> -Toshi
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
