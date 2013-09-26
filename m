Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3IZLeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:34:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45658 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755712Ab3IZLeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:34:07 -0400
Date: Thu, 26 Sep 2013 12:34:00 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Linn Crosetto <linn@hp.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] x86: EFI stub support for large memory maps
Message-ID: <20130926113400.GM21381@console-pimps.org>
References: <1378487056-9857-1-git-send-email-linn@hp.com>
 <1379901548-70954-1-git-send-email-linn@hp.com>
 <20130925125840.GK21381@console-pimps.org>
 <20130925224541.GT13098@oranje.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925224541.GT13098@oranje.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep, at 04:45:41PM, Linn Crosetto wrote:
> On Wed, Sep 25, 2013 at 01:58:40PM +0100, Matt Fleming wrote:
> > On Sun, 22 Sep, at 07:59:08PM, Linn Crosetto wrote:
> > > This patch fixes a problem with EFI memory maps larger than 128 entries
> > > when booting using the EFI stub, which results in overflowing e820_map
> > > in boot_params and an eventual halt when checking the map size in
> > > sanitize_e820_map().
> > > 
> > > If the number of map entries is greater than what can fit in e820_map,
> > > add the extra entries to the setup_data list using type SETUP_E820_EXT.
> > > These extra entries are then picked up when the setup_data list is
> > > parsed in parse_e820_ext().
> > > 
> > > Signed-off-by: Linn Crosetto <linn@hp.com>
> > > ---
> > > Changes from v2:
> > >  * Removed unnecessary optimization in alloc_e820ext() (Matt Fleming)
> > >  * Fixed a bug where an incorrect buffer size may be passed to
> > >    get_memory_map when jumping to get_map
> > > 
> > >  arch/x86/boot/compressed/eboot.c | 239 +++++++++++++++++++++++++++------------
> > >  1 file changed, 167 insertions(+), 72 deletions(-)
> > 
> > Thanks Linn. I applied this to the 'next' branch at,
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> > 
> > but it required a bit of massaging to apply on top of the changes
> > already there. Could you confirm that my changes are OK? I've included
> > the modified commit below.
> 
> I have tested the 'next' branch on a system with a large number of entries in
> the memory map and the merge appears to be functionally correct. 
 
Excellent, thank you for verifying.

> With the change in commit ae8e9060, I noticed the memory map is no longer placed
> in memory allocated with low_alloc(). I have not looked into what effect it
> could have, if any.
 
Correct. I haven't run into any problems on my test machines.

> > +	/* Historic? */
> > +	boot_params->alt_mem_k = 32 * 1024;
> > +
> > +	status = setup_e820(boot_params, e820ext, e820ext_size);
> >  
> >  	return EFI_SUCCESS;
> 
> I might add the following to your merge for semantic reasons:
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 04b228d..a7677ba 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -730,6 +730,8 @@ get_map:
>         boot_params->alt_mem_k = 32 * 1024;
>  
>         status = setup_e820(boot_params, e820ext, e820ext_size);
> +       if (status != EFI_SUCCESS)
> +               return status;
>  
>         return EFI_SUCCESS;

Aha, nice catch! Though if setup_e820() fails we should be jumping to
the 'free_mem_map' label so we don't leak the memory map, like so,

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 04b228d..602950b 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -730,8 +730,8 @@ get_map:
 	boot_params->alt_mem_k = 32 * 1024;
 
 	status = setup_e820(boot_params, e820ext, e820ext_size);
-
-	return EFI_SUCCESS;
+	if (status == EFI_SUCCESS)
+		return status;
 
 free_mem_map:
 	efi_call_phys1(sys_table->boottime->free_pool, mem_map);


I've fixed this up and pushed out a new patch.

-- 
Matt Fleming, Intel Open Source Technology Center
