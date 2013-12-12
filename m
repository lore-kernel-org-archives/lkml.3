Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab3LLG0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:26:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab3LLG0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:26:05 -0500
Date: Thu, 12 Dec 2013 14:25:06 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 09/14] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131212062506.GH3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-10-git-send-email-dyoung@redhat.com>
 <20131211222057.GB8863@pd.tnic>
 <20131212030619.GG3751@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212030619.GG3751@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > + */
> > > +static int __init map_regions_fixed(void)
> > > +{
> > > +	int i, s, ret = 0;
> > > +	u64 end, systab;
> > > +	unsigned long size;
> > > +	efi_memory_desc_t *md;
> > > +	struct efi_setup_data *data;
> > > +
> > > +	s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
> > > +	data = early_memremap(efi_setup, s);
> > > +	if (!data) {
> > > +		ret = -ENOMEM;
> > > +		goto out;
> > > +	}
> > 
> > newline.
> 
> Will remove

misread the comment, there's no new line here. Looks like you want a
new blank line here, ok..

> 
> > 
> > > +	for (i = 0, md = data->map; i < nr_efi_runtime_map; i++, md++) {
> > > +		efi_map_region_fixed(md); /* FIXME: add error handling */
> > > +		size = md->num_pages << PAGE_SHIFT;
> > > +		end = md->phys_addr + size;
> > > +
> > > +		systab = (u64) (unsigned long) efi_phys.systab;
> > > +		if (md->phys_addr <= systab && systab < end) {
> > > +			systab += md->virt_addr - md->phys_addr;
> > > +			efi.systab = (efi_system_table_t *)(unsigned long)systab;
> > > +		}
> > > +		ret = save_runtime_map(md, i);
> > 
