Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3LPLd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:33:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51151 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab3LPLd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:33:27 -0500
Date: Mon, 16 Dec 2013 12:33:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 10/14] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131216113324.GB4922@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-11-git-send-email-dyoung@redhat.com>
 <20131213160150.GE32329@pd.tnic>
 <20131216020010.GC3754@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131216020010.GC3754@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 10:00:10AM +0800, Dave Young wrote:
> > > -	print_efi_memmap();
> > > +	if (efi_setup) {
> > > +		int s;
> > > +		struct efi_setup_data *data;
> > > +
> > > +		s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
> > > +		data = early_memremap(efi_setup, s);
> > > +		if (!data)
> > > +			return;
> > > +		print_efi_memmap(data->map, nr_efi_runtime_map,
> > > +				 sizeof(data->map[0]));
> > > +		early_memunmap(data, s);
> > 
> > Well, if you call print_efi_memmap() in parse_efi_setup() you can save
> > yourself that map/unmaping no?
> 
> In parse_efi_setup, I need map twice as well:

Well, your v6 has a something completely different:

void __init parse_efi_setup(u64 phys_addr)
{
        efi_setup = phys_addr;
}

There's no mapping at all anymore. So please redo your reply against v6.

> Another where what I print in this patch is same position what
> non-kexec kernel does, it looks better that print them only if earlier
> init is ok.

-ENOPARSE.

All I'm saying is, if you're going to memremap/memunmap efi_setup,
then do it once in efi_setup_init() as you do already and call
print_efi_memmap from there - no need to do work twice for no reason.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
