Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3LQGf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:35:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab3LQGfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:35:24 -0500
Date: Tue, 17 Dec 2013 14:34:36 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 10/14] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131217063436.GF6751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-11-git-send-email-dyoung@redhat.com>
 <20131213160150.GE32329@pd.tnic>
 <20131216020010.GC3754@dhcp-16-126.nay.redhat.com>
 <20131216113324.GB4922@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216113324.GB4922@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/13 at 12:33pm, Borislav Petkov wrote:
> On Mon, Dec 16, 2013 at 10:00:10AM +0800, Dave Young wrote:
> > > > -	print_efi_memmap();
> > > > +	if (efi_setup) {
> > > > +		int s;
> > > > +		struct efi_setup_data *data;
> > > > +
> > > > +		s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
> > > > +		data = early_memremap(efi_setup, s);
> > > > +		if (!data)
> > > > +			return;
> > > > +		print_efi_memmap(data->map, nr_efi_runtime_map,
> > > > +				 sizeof(data->map[0]));
> > > > +		early_memunmap(data, s);
> > > 
> > > Well, if you call print_efi_memmap() in parse_efi_setup() you can save
> > > yourself that map/unmaping no?
> > 
> > In parse_efi_setup, I need map twice as well:
> 
> Well, your v6 has a something completely different:
> 
> void __init parse_efi_setup(u64 phys_addr)
> {
>         efi_setup = phys_addr;
> }
> 
> There's no mapping at all anymore. So please redo your reply against v6.

They are moved to efi.c efi_setup_init(), I'm not sure if I expained clear
enough, in current code parse_efi_setup only accept one argument phys_addr
so I will mapping it with sizeof(struct setup_data) to get the payload size
then get the nr_efi_runtime_map. This is a simplification from the old 
implementation.

Based on current implementation, yes, I can add back another argument data_len
to avoid the 1st mapping thus I can print efi memmap as you said.

In this way I need export another extern for the data_len though.

> 
> > Another where what I print in this patch is same position what
> > non-kexec kernel does, it looks better that print them only if earlier
> > init is ok.
> 
> -ENOPARSE.

What do you mean about NOPARSE, do you want another function name like
save_efi_setup()?

> 
> All I'm saying is, if you're going to memremap/memunmap efi_setup,
> then do it once in efi_setup_init() as you do already and call
> print_efi_memmap from there - no need to do work twice for no reason.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
