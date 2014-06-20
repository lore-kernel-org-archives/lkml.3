Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaFTOho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:37:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46094 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaFTOhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:37:42 -0400
Date: Fri, 20 Jun 2014 16:36:51 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
Message-ID: <20140620143651.GE28489@olila.local.net-space.pl>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
 <20140618135229.GH24049@console-pimps.org>
 <20140618164835.GD28489@olila.local.net-space.pl>
 <20140619144112.GT24049@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619144112.GT24049@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 03:41:12PM +0100, Matt Fleming wrote:
> On Wed, 18 Jun, at 06:48:35PM, Daniel Kiper wrote:
> > >
> > > Why don't you want to export efi.fw_vendor, etc? Rationale please.
> >
> > I am exporting real addresses (machine addresses) of things which
> > I am able to get. Stuff which was created artificially and lives
> > in dom0 address space or does not exist are not exported.
>
> So, wouldn't it be easier to just leave those fields as
> EFI_INVALID_TABLE_ADDR? If they're not usable why fill out an address?

It looks that EFI_PARAVIRT check is needed for efi.fw_vendor only.
Probably I prepared this chunk of code before filling
efi_systab_xen.runtime with EFI_INVALID_TABLE_ADDR. efi.fw_vendor
contains pointer to vendor name which lives in dom0 memory and it
is a copy of name living in EFI memory data. So, this pointer is useless
for potential user of /sys/firmware/efi/fw_vendor. efi.fw_vendor is
used in init code only. Hence, I was thinking once about wiping this
pointer with EFI_INVALID_TABLE_ADDR. However, it requires some changes
in arch/x86/platform/efi/efi.c (wipe it if EFI_PARAVIRT is set) and
it is a hack for me. I prefer to live with current solution.

> > Hmmm... I do not know what is wrong with this minimal shuffling. We are
> > playing here with internal stuff which is not visible outside of any
> > given kernel. Additionally, as I saw in a few places arch bits are
> > defined in following way:
> >
> > #define ARCH_1 10
> >
> > #define A_ARCH_CONST ARCH_1
> > #define B_ARCH_CONST (ARCH_1 + 1)
> > #define C_ARCH_CONST (ARCH_1 + 2)
> > ...
> >
> > So I think addition is more natural here than subtraction.
>
> No, because we hit the same problem if we need more non-arch bits after
> bit 9, it moves the problem, it doesn't fix it. Though admittedly, using

10 is just an example. It could be an arbitrary value. However, you
are right. This just moves the problem.

> this level of indirection (going through ARCH_1) instead of using
> constants does reduce the problem.
>
> Yes, these bits are internal, and yes the shuffling is minimal, but we
> can do better.

As always, it is a place for an improvement. However, I am not sure
it is worth fighting with that so hard.

> I'm not suggesting you need to modify your patch. I'm really just
> thinking out loud. I'll take care of fixing this up later.

OK. Thanks.

Daniel
