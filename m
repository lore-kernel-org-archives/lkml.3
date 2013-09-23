Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3IWAXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 20:23:32 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:44682 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3IWAXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 20:23:30 -0400
Date: Sun, 22 Sep 2013 18:23:28 -0600
From: Linn Crosetto <linn@hp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] x86: EFI stub support for large memory maps
Message-ID: <20130923002328.GC24764@oranje.fc.hp.com>
References: <1377291771-21302-1-git-send-email-linn@hp.com>
 <1378487056-9857-1-git-send-email-linn@hp.com>
 <20130917201452.GI3409@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917201452.GI3409@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 09:14:52PM +0100, Matt Fleming wrote:
> > +static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
> > +				  u32 *e820ext_size)
> > +{
> > +	efi_status_t status;
> > +	unsigned long size;
> > +
> > +	size = sizeof(struct setup_data) +
> > +		sizeof(struct e820entry) * nr_desc;
> > +
> > +	if (*e820ext && size <= *e820ext_size)
> > +		return EFI_SUCCESS; /* Already allocated */
> 
> Do we actually need this check? I thought the 'prev_nr_desc' below
> ensures we only allocate 'e820ext' if we need more memory.

I am okay with removing the check. There is another bug in exit_boot, when
jumping to get_map the call to get the memory map is passed the previous map
size instead of the size of the allocated buffer. I'll make the changes and
resend.

> 
> [...]
> 
> > @@ -1016,6 +1157,19 @@ get_map:
> >  	if (status != EFI_SUCCESS)
> >  		goto free_mem_map;
> >  
> > +	prev_nr_desc = nr_desc;
> > +	nr_desc = size / desc_size;
> > +	if (nr_desc > prev_nr_desc &&
> > +	    nr_desc > ARRAY_SIZE(boot_params->e820_map)) {
> > +		u32 nr_e820ext = nr_desc - ARRAY_SIZE(boot_params->e820_map);
> > +
> > +		status = alloc_e820ext(nr_e820ext, &e820ext, &e820ext_size);
> > +		if (status != EFI_SUCCESS)
> > +			goto free_mem_map;
> > +
> > +		goto get_map; /* Allocated memory, get map again */
> > +	}
> > +
