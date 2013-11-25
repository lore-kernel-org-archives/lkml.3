Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab3KYQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:16:27 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55122 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab3KYQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:16:22 -0500
Date: Mon, 25 Nov 2013 17:15:00 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, mjg59@srcf.ucam.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        greg@kroah.com, hpa@zytor.com
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
Message-ID: <20131125171500.418125a7@holzheu>
In-Reply-To: <20131125153620.GA23094@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
	<8761rl73s7.fsf@xmission.com>
	<20131122015518.GA31921@redhat.com>
	<87txf4y304.fsf@xmission.com>
	<20131125110428.4bae2fe7@holzheu>
	<20131125153620.GA23094@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112516-1948-0000-0000-00000701B730
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013 10:36:20 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Nov 25, 2013 at 11:04:28AM +0100, Michael Holzheu wrote:
> > On Fri, 22 Nov 2013 05:34:03 -0800
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> > 
> > > Vivek Goyal <vgoyal@redhat.com> writes:
> > 
> > > >> There is also a huge missing piece of this in that your purgatory is not
> > > >> checking a hash of the loaded image before jumping too it.  Without that
> > > >> this is a huge regression at least for the kexec on panic case.  We
> > > >> absolutely need to check that the kernel sitting around in memory has
> > > >> not been corrupted before we let it run very far.
> > > >
> > > > Agreed. This should not be hard. It is just a matter of calcualting
> > > > digest of segments. I will store it in kimge and verify digest again
> > > > before passing control to control page. Will fix it in next version.
> > > 
> > > Nak.  The verification needs to happen in purgatory. 
> > > 
> > > The verification needs to happen in code whose runtime environment is
> > > does not depend on random parts of the kernel.  Anything else is a
> > > regression in maintainability and reliability.
> > 
> > Hello Vivek,
> > 
> > Just to be sure that you have not forgotten the following s390 detail:
> > 
> > On s390 we first call purgatory with parameter "0" for doing the
> > checksum test. If this fails, we can have as backup solution our
> > traditional stand-alone dump. In case tha checksum test was ok,
> > we call purgatory a second time with parameter "1" which then
> > starts kdump.
> > 
> > Could you please ensure that this mechanism also works after
> > your rework.
> 
> Hi Michael,
> 
> All that logic in in arch dependent portion of s390? If yes, I am not
> touching any arch dependent part of s390 yet and only doing implementation
> of x86.

Yes, part of s390 architecture code (kernel and kexec purgatory).

kernel:
-------
arch/s390/kernel/machine_kexec.c:
 kdump_csum_valid() -> rc = start_kdump(0);
 __do_machine_kdump() -> start_kdump(1)

kexec tools:
------------
purgatory/arch/s390/setup-s390.S
  cghi %r2,0
  je verify_checksums

> Generic changes should be usable by s390 and you should be able to do
> same thing there. Though we are still detating whether segment checksum
> verification logic should be part of purgatory or core kernel.

Yes, that was my concern. If you move the purgatory checksum logic to
the kernel we probably have to consider our s390 checksum test.

Thanks!
Michael

