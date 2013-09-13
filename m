Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3IMUir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:38:47 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24115 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3IMUip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:38:45 -0400
Date: Fri, 13 Sep 2013 14:38:12 -0600
From: jerry.hoemann@hp.com
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Fish <afish@apple.com>, edk2-devel@lists.sourceforge.net,
        Laszlo Ersek <lersek@redhat.com>, linux-efi@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Brian Richardson <brian.richardson@intel.com>,
        Colin Ian King <colin.king@canonical.com>,
        Randy Wright <rwright@hp.com>, Linn Crosetto <linn.crosetto@hp.com>,
        terry.lee@hp.com, samer.el-haj-mahmoud@hp.com, randy.pawell@hp.com,
        chrisp@hp.com, linda.knippers@hp.com, dong.wei@hp.com
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130913203812.GA312@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
 <20130808101730.GJ2515@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808101730.GJ2515@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:17:30AM +0100, Matt Fleming wrote:
> > Is it possible to have a switch to turn off the not required behavior
> > (hiding EFI implementation bugs) so that bad platforms could be
> > detected? This would be a good thing to try on platforms at the
> > upcoming UEFI Plugfest hosted by the Linux Foundation and the UEFI
> > Forum, so the bad behavior can be detected and the vendors can fix the
> > issue. 
> 
> We don't tend to provide switches for the kernel to turn off workarounds
> because users run the risk of inadvertently stopping their machines from
> booting correctly. Also, because the major distributions will always
> enable the workarounds, the kernel would need to be built manually to
> see any kind of informative error message.
> 

...

> 
> > PS Also maybe it would be possible to key this work around behavior on
> > the EFI/UEFI version. So for example no work-around after UEFI v2.3.1?
> 
> That would really depend on who has seen this bug and on which
> platforms. Is there a particular reason that mapping the boot services
> regions as-is would cause problems?
> 

Matt,

We have hit an issue on our new platform in development related to the
call of efi_reserve_boot_services() from setup_arch().

The reservation can interfere with allocation of the crash kernel.

In pre 3.9(?) kernels,  the crash kernel is required to be allocated from
physically contiguous memory below 896 MB.

Our new platforms are large in both the amount of memory and the amount
of IO. This requires large crash kernels for kdump to work.  This is even
after the work done for makedumpfile v 1.5 to allow it to work with a
smaller foot print.


One of the problems is that drivers will allocate memory as boot code and/or
data in the region < 896 that effectively fragments this memory.
With the reservation, we can't reuse the memory when needed for the
crash kernels.   If we remove the reservation and allow the kernel
to reuse the memory,  we the reservation of the crash kernel succeeds.

This is definitely a problem for distros that are pre 3.9.  Probably less
so for top of tree, but i haven't been focused there.

So we are definitely interested in finding a mechanism to not
do this reservation on platforms that don't have the issues described
earlier in this thread.

thanks,

Jerry

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

