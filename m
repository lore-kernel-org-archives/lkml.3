Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3JVQcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:32:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28358 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3JVQce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:32:34 -0400
Date: Tue, 22 Oct 2013 12:31:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
        Ian Campbell <ian.campbell@citrix.com>, keir@xen.org,
        david.woodhouse@intel.com, stefano.stabellini@eu.citrix.com,
        Daniel Kiper <daniel.kiper@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Jan Beulich <JBeulich@suse.com>,
        ross.philipson@citrix.com, boris.ostrovsky@oracle.com,
        richard.l.maliszewski@intel.com
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022163155.GC19189@phenom.dumpdata.com>
References: <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <20131022140947.GA17829@phenom.dumpdata.com>
 <1382451868.18283.21.camel@hastur.hellion.org.uk>
 <20131022145140.GA18679@phenom.dumpdata.com>
 <52669C2C.90509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52669C2C.90509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 05:39:24PM +0200, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> On 22.10.2013 16:51, Konrad Rzeszutek Wilk wrote:
> > If you use 'linux' module, it will call ExitBootService.
> > If you use 'multiboot' module, it will call ExitBootService too.
> > 
> > So if you don't want to the module to call 'grub_efi_finish_boot_services'
> > you need to use 'linuxefi' :-)
> That's a very limited logic. Commands can be modified and protocols can
> be extended.
> There was only one e-mail explaining the needs and I answered with
> proposing possible solutions yet the 2 e-mails in question were
> completely ignored.

This was before my time - so I am not exactly sure what was discussed.
You wouldn't by any chance have any URLs handy?

> What's the need behind not calling ExitBootService? This is a point
> which was never really explained to me. EFI specification specifically
> tells to call ExitBootService.

This commit points to it being a problem with the spec and hardware
implementations not being in sync:

commit 916f676f8dc016103f983c7ec54c18ecdbb6e349
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed May 25 09:53:13 2011 -0400

    x86, efi: Retain boot service code until after switching to virtual mode
    
    UEFI stands for "Unified Extensible Firmware Interface", where "Firmware"
    is an ancient African word meaning "Why do something right when you can
    do it so wrong that children will weep and brave adults will cower before
    you", and "UEI" is Celtic for "We missed DOS so we burned it into your
    ROMs". The UEFI specification provides for runtime services (ie, another
    way for the operating system to be forced to depend on the firmware) and
    we rely on these for certain trivial tasks such as setting up the
    bootloader. But some hardware fails to work if we attempt to use these
    runtime services from physical mode, and so we have to switch into virtual
    mode. So far so dreadful.
    
    The specification makes it clear that the operating system is free to do
    whatever it wants with boot services code after ExitBootServices() has been
    called. SetVirtualAddressMap() can't be called until ExitBootServices() has
    been. So, obviously, a whole bunch of EFI implementations call into boot
    services code when we do that. Since we've been charmingly naive and
    trusted that the specification may be somehow relevant to the real world,
    we've already stuffed a picture of a penguin or something in that address
    space. And just to make things more entertaining, we've also marked it
    non-executable.
    
    This patch allocates the boot services regions during EFI init and makes
    sure that they're executable. Then, after SetVirtualAddressMap(), it
    discards them and everyone lives happily ever after. Except for the ones
    who have to work on EFI, who live sad lives haunted by the knowledge that
    someone's eventually going to write yet another firmware specification.
    
    [ hpa: adding this to urgent with a stable tag since it fixes currently-broken
      hardware.  However, I do not know what the dependencies are and so I do
      not know which -stable versions this may be a candidate for. ]
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Link: http://lkml.kernel.org/r/1306331593-28715-1-git-send-email-mjg@redhat.com


> 


