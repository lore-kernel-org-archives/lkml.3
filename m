Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaESNoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:44:07 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:54098 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaESNoB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:2>);
	Mon, 19 May 2014 09:44:01 -0400
X-Greylist: delayed 791 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2014 09:44:01 EDT
Message-Id: <537A26BB0200007800013AAE@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 19 May 2014 14:43:55 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <david.vrabel@citrix.com>, <ian.campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <matt.fleming@intel.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, <eshelton@pobox.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH v4 3/5] xen: Put EFI machinery in place
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.05.14 at 22:41, <daniel.kiper@oracle.com> wrote:
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -240,4 +240,7 @@ config XEN_MCE_LOG
>  config XEN_HAVE_PVMMU
>         bool
>  
> +config XEN_EFI
> +	def_bool X86_64 && EFI

Constructs like this are bogus - they needlessly add a line to .config
when the expression evaluates to false.

config XEN_EFI
	def_bool y
	depends on X86_64 && EFI

is what avoids this.

> +static efi_status_t xen_efi_get_variable(efi_char16_t *name,
> +					 efi_guid_t *vendor,
> +					 u32 *attr,
> +					 unsigned long *data_size,
> +					 void *data)
> +{
> +	int err;
> +	DECLARE_CALL(get_variable);
> +
> +	set_xen_guest_handle(call.u.get_variable.name, name);
> +	BUILD_BUG_ON(sizeof(*vendor) !=
> +		     sizeof(call.u.get_variable.vendor_guid));
> +	memcpy(&call.u.get_variable.vendor_guid, vendor, sizeof(*vendor));
> +	call.u.get_variable.size = *data_size;
> +	set_xen_guest_handle(call.u.get_variable.data, data);
> +	err = HYPERVISOR_dom0_op(&op);
> +	if (err)
> +		return EFI_UNSUPPORTED;
> +
> +	*data_size = call.u.get_variable.size;
> +	*attr = call.misc; /* misc in struction is U32 variable*/

Iirc attr is an optional output, i.e. can be NULL, which hence needs
to be checked for here. I remember that this was broken in the
original EFI patch in our trees, so perhaps it would be good for you
to re-check against recent sources of ours for eventual other bug
fixes.

> +static efi_status_t xen_efi_query_variable_info(u32 attr,
> +						u64 *storage_space,
> +						u64 *remaining_space,
> +						u64 *max_variable_size)
> +{
> +	int err;
> +	DECLARE_CALL(query_variable_info);
> +
> +	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
> +		return EFI_UNSUPPORTED;
> +

Here's a similar case - there is

	call.u.query_variable_info.attr = attr;

missing.

> +static efi_char16_t vendor[100] __initdata;
> +static const efi_char16_t unknown[] __initconst =
> +			{'U', 'N', 'K', 'N', 'O', 'W', 'N', '\0'};

If you enforced -fshort-wchar for the file's compilation, this could be
written in a more legible manner (and probably you wouldn't need a
named variable at all).

Jan

