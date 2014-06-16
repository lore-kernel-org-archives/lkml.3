Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbaFPSqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:46:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32336 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbaFPSqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:46:13 -0400
Date: Mon, 16 Jun 2014 20:45:27 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        tglx@linutronix.de
Subject: Re: [PATCH v5 4/7] xen: Put EFI machinery in place
Message-ID: <20140616184527.GH3463@olila.local.net-space.pl>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-5-git-send-email-daniel.kiper@oracle.com>
 <alpine.DEB.2.02.1406161245490.13771@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406161245490.13771@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 12:55:35PM +0100, Stefano Stabellini wrote:
> On Fri, 13 Jun 2014, Daniel Kiper wrote:
> > This patch enables EFI usage under Xen dom0. Standard EFI Linux
> > Kernel infrastructure cannot be used because it requires direct
> > access to EFI data and code. However, in dom0 case it is not possible
> > because above mentioned EFI stuff is fully owned and controlled
> > by Xen hypervisor. In this case all calls from dom0 to EFI must
> > be requested via special hypercall which in turn executes relevant
> > EFI code in behalf of dom0.
> >
> > When dom0 kernel boots it checks for EFI availability on a machine.
> > If it is detected then artificial EFI system table is filled.
> > Native EFI callas are replaced by functions which mimics them
> > by calling relevant hypercall. Later pointer to EFI system table
> > is passed to standard EFI machinery and it continues EFI subsystem
> > initialization taking into account that there is no direct access
> > to EFI boot services, runtime, tables, structures, etc. After that
> > system runs as usual.
> >
> > This patch is based on Jan Beulich and Tang Liang work.
> >
> > v5 - suggestions/fixes:
> >    - improve macro usage readability
> >      (suggested by Andrew Cooper and David Vrabel),
> >    - conditions cleanup
> >      (suggested by David Vrabel),
> >    - use -fshort-wchar option
> >      (suggested by Jan Beulich),
> >    - Kconfig rule cleanup
> >      (suggested by Jan Beulich),
> >    - forward port fixes from SUSE kernel
> >      (suggested by Jan Beulich),
> >    - improve commit message
> >      (suggested by David Vrabel).
> >
> > v4 - suggestions/fixes:
> >    - "just populate an efi_system_table_t object"
> >      (suggested by Matt Fleming).
> >
> > Signed-off-by: Jan Beulich <jbeulich@suse.com>
> > Signed-off-by: Tang Liang <liang.tang@oracle.com>
> > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
>
> Sorry for commenting on your patches so late in the review cycle.

No problem.

[...]

> > +efi_system_table_t __init *xen_efi_probe(void)
> > +{
> > +	struct xen_platform_op op = {
> > +		.cmd = XENPF_firmware_info,
> > +		.u.firmware_info = {
> > +			.type = XEN_FW_EFI_INFO,
> > +			.index = XEN_FW_EFI_CONFIG_TABLE
> > +		}
> > +	};
> > +	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
> > +
> > +	if (!xen_initial_domain() || HYPERVISOR_dom0_op(&op) < 0)
> > +		return NULL;
> > +
> > +	/* Here we know that Xen runs on EFI platform. */
> > +
> > +	efi = efi_xen;
> > +
> > +	op.cmd = XENPF_firmware_info;
> > +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> > +	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
> > +	info->vendor.bufsz = sizeof(vendor);
> > +	set_xen_guest_handle(info->vendor.name, vendor);
> > +
> > +	if (HYPERVISOR_dom0_op(&op) == 0) {
> > +		efi_systab_xen.fw_vendor = __pa_symbol(vendor);
> > +		efi_systab_xen.fw_revision = info->vendor.revision;
> > +	} else
> > +		efi_systab_xen.fw_vendor = __pa_symbol(L"UNKNOWN");
> > +
> > +	op.cmd = XENPF_firmware_info;
> > +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> > +	op.u.firmware_info.index = XEN_FW_EFI_VERSION;
> > +
> > +	if (HYPERVISOR_dom0_op(&op) == 0)
> > +		efi_systab_xen.hdr.revision = info->version;
> > +
> > +	op.cmd = XENPF_firmware_info;
> > +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> > +	op.u.firmware_info.index = XEN_FW_EFI_RT_VERSION;
> > +
> > +	if (HYPERVISOR_dom0_op(&op) == 0)
> > +		efi.runtime_version = info->version;
> > +
> > +	op.cmd = XENPF_firmware_info;
> > +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> > +	op.u.firmware_info.index = XEN_FW_EFI_CONFIG_TABLE;
> > +
> > +	if (HYPERVISOR_dom0_op(&op) < 0)
> > +		BUG();
>
> Is it really worth of a BUG()? Can't we just print a warning and return
> NULL? We could still boot without EFI support.

Earlier the same hypercall function succeeded so if here it failed
it means that something is really broken. However, I will try remove
this call and get all data from earlier one. This way we avoid this
BUG() call.

Daniel
