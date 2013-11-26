Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3KZRsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:48:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47746 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3KZRsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:48:16 -0500
Date: Tue, 26 Nov 2013 17:48:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Chang Liu <cl91tp@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, Jility <jility09@gmail.com>,
        Florian Otti <f.otti@gmx.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] PCI: add a quirk for keeping Bus Master bit on shutdown
Message-ID: <20131126174806.GA14789@srcf.ucam.org>
References: <1384285203-642-1-git-send-email-cl91tp@gmail.com>
 <CAErSpo5E4584zgTt4ySPSEFhtwdHDOyrrowirp=SmtmJjDyHgg@mail.gmail.com>
 <5294CF1A.6080707@oracle.com>
 <CAErSpo6eAbVDfc8PFPP4b4HLzAjkFe23pJytu-TZq-V8-pfQMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6eAbVDfc8PFPP4b4HLzAjkFe23pJytu-TZq-V8-pfQMA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:35:26AM -0700, Bjorn Helgaas wrote:
> On Tue, Nov 26, 2013 at 9:40 AM, Khalid Aziz <khalid.aziz@oracle.com> wrote:
> > Disabling Bus Master bit is effectively a brute force and not an elegant way
> > to stop unwanted DMA. It can have side effects as Alan and others pointed
> > out in the original discussion, and we are now seeing one with Lynx Point on
> > Acer.
> 
> I'm getting more queasy all the time about disabling Bus Master.  I
> don't think RHEL does it, and that's probably where most kexec use is.
>  So I doubt we really have much experience with it yet.

Does Windows disable the BM bit on shutdown? If not, it's likely that 
there are platforms where the SMM code assumes it's still enabled. We 
also know that there are devices that hang if BM is disabled while their 
DMA engines are still running.

Unless we verify that Windows does this, I think there's no way we can 
guarantee that firmware won't make assumptions about the state of PCI. 
The easiest compromise would probably be to set a flag that disables 
busmastering purely when we're performing a kexec.

> > Eric had pointed out in original discussion -
> > <http://marc.info/?l=linux-pci&m=133901193430829&w=2> that this code change
> > moves failure from a random point in the kexec'd kernel to a predictable
> > point on shutdown path where it becomes lot easier to debug than a random
> > memory overwrite.
> 
> That is probably true in some cases, but not this one.  I have no idea
> how to debug this poweroff hang.  Poweroff is a path *everybody* uses,
> so it's much more important to have that work reliably than it is to
> have kexec work.

If it's hanging after we've performed the io writes that trap us into 
SMM, there's no meaningful way for us to debug it. We're violating 
assumptions that the firmware is making, and the only way to fix that is 
to cease violating those assumptions.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
