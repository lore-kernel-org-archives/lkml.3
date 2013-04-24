Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3DXOy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:54:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab3DXOyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:54:54 -0400
Date: Wed, 24 Apr 2013 10:54:49 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: Check EFI revision in setup_efi_vars
Message-ID: <20130424145449.GC15272@hansolo.jdub.homelinux.org>
References: <20130424143738.GB15272@hansolo.jdub.homelinux.org>
 <5177EFCE.80104@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5177EFCE.80104@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 03:44:30PM +0100, Matt Fleming wrote:
> On 24/04/13 15:37, Josh Boyer wrote:
> > We need to check the runtime sys_table for the EFI version the firmware
> > specifies instead of just checking for a NULL QueryVariableInfo.  Older
> > implementations of EFI don't have QueryVariableInfo but the runtime is
> > a smaller structure, so the pointer to it may be pointing off into garbage.
> > 
> > This is apparently the case with several Apple firmwares that support EFI
> > 1.10, and the current check causes them to no longer boot.  Fix based on
> > a suggestion from Matthew Garrett.
> > 
> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> > ---
> >  arch/x86/boot/compressed/eboot.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> > index 8615f75..b46efbf 100644
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -258,7 +258,9 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
> >  	u64 store_size, remaining_size, var_size;
> >  	efi_status_t status;
> >  
> > -	if (!sys_table->runtime->query_variable_info)
> > +	if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
> > +		return EFI_UNSUPPORTED;
> > +	else if(!sys_table->runtime->query_variable_info)
> >  		return EFI_UNSUPPORTED;
> >  
> >  	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
> > 
> 
> Thanks Josh, that looks correct.
> 
> It's a small point, but does the check against NULL actually make sense?
> I don't think we ever check other system table pointers against NULL.

That I'm not sure of.  I was going off of the assumption that Matthew
put it there because someone's EFI 2.0 implementation was crappy and
didn't actually implement it.  So I left that check in place for now.

josh
