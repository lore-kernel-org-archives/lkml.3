Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256AbaDIToM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:44:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50993 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaDIToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:44:08 -0400
Date: Wed, 9 Apr 2014 22:43:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "jkc@redhat.com" <jkc@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unisys: staging: Check for s-Par firmware before
 initializing s-Par modules
Message-ID: <20140409194350.GE26890@mwanda>
References: <C97001BC43954D438ACB059713BA5CDF92040F0F09@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C97001BC43954D438ACB059713BA5CDF92040F0F09@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has a million checkpatch.pl warnings...  We were so nice to
you on merging this driver directly into staging without commenting on
the style but YOU"RE IN THE ARMY NOW!!!  Please, fix all the checkpatch
warnings and resend.  :P

> diff --git a/drivers/staging/unisys/include/timskmodutils.h b/drivers/staging/unisys/include/timskmodutils.h
> index 2d81d46..cc439d3 100644
> --- a/drivers/staging/unisys/include/timskmodutils.h
> +++ b/drivers/staging/unisys/include/timskmodutils.h
> @@ -1,6 +1,6 @@
>  /* timskmodutils.h
>   *
> - * Copyright � 2010 - 2013 UNISYS CORPORATION
> + * Copyright © 2010 - 2013 UNISYS CORPORATION
>   * All rights reserved.
>   *

Send these typo fixes as a separate patch.

> @@ -2276,6 +2276,11 @@
>  static int __init
>  uislib_mod_init(void)
>  {
> +	/* check for s-Par support */
> +	if( !is_spar_system() ) {
> +		printk( "s-Par not detected.\n" );
> +		return -EPERM;

EPERM isn't the right return code.  Probably use ENODEV;  By the way,
I'm confused why we have this check in so many places.  Can't we just
check at module_init() or probe() or something?  (I didn't try find the
answer to this question because I am a bad human being and lazy).

> @@ -2681,18 +2681,13 @@
>  	struct proc_dir_entry *toolaction_file;
>  	struct proc_dir_entry *bootToTool_file;
>  
> -	LOGINF("chipset driver version %s loaded", VERSION);
> -	/* process module options */
> -	POSTCODE_LINUX_2(DRIVER_ENTRY_PC, POSTCODE_SEVERITY_INFO);
> +	/* check for s-Par support */
> +	if( !is_spar_system() ) {
> +		printk( "s-Par not detected.\n" );
> +		return -EPERM;
> +	}
>  
> -	LOGINF("option - testvnic=%d", visorchipset_testvnic);
> -	LOGINF("option - testvnicclient=%d", visorchipset_testvnicclient);
> -	LOGINF("option - testmsg=%d", visorchipset_testmsg);
> -	LOGINF("option - testteardown=%d", visorchipset_testteardown);
> -	LOGINF("option - major=%d", visorchipset_major);
> -	LOGINF("option - serverregwait=%d", visorchipset_serverregwait);
> -	LOGINF("option - clientregwait=%d", visorchipset_clientregwait);
> -	LOGINF("option - holdchipsetready=%d", visorchipset_holdchipsetready);
> +	POSTCODE_LINUX_2(DRIVER_ENTRY_PC, POSTCODE_SEVERITY_INFO);

Separate patch.

> +/* the s-Par firmware uses the virtualization hardware in the CPU to split up
> + * processors into partitions. The hypervisor ID can be found in the CPUID
> + * hypervisor feature leaf, encoded as a string "UnisysSpar64" across the
> + * returned ebx/ecx/edx registers.
> + */
> +int is_spar_system() {
> +	unsigned int eax, ebx, ecx, edx;
> +
> +	cpuid( 0x00000001, &eax, &ebx, &ecx, &edx ); /* check for virtual processor */
> +	if( !(ecx & 0x80000000) ) return 0;
> +	cpuid( 0x40000000, &eax, &ebx, &ecx, &edx ); /* check for s-Par id */
> +	return (ebx == 0x73696e55) && (ecx == 0x70537379)
> +			&& (edx == 0x34367261);
> +}

Here is how to write this in kernel style:

int is_spar_system(void)
{
	unsigned int eax, ebx, ecx, edx;

	/* check for virtual processor */
	cpuid(0x00000001, &eax, &ebx, &ecx, &edx);
	if (!(ecx & 0x80000000))
		return 0;

	/* check for s-Par id */
	cpuid(0x40000000, &eax, &ebx, &ecx, &edx);
	return (ebx == 0x73696e55) && (ecx == 0x70537379) &&
	       (edx == 0x34367261);
}

Basically, any variation from that is going to make someone complain
about something...  The void has to be there in the declaration.  The
curly brace has to be on a line by itself.  The comment has to be moved
to the line before so it doesn't go over 80 characters.  The return has
to be on a line by itself.  I put a blank line between the virt and the
spar checks, but that blank is optional.  I moved the commen up a line
but that was a preference choice and reviewers are not allowed to
complain about matters of preference like that.  The "&&" has to be at
the end of the line instead of the start of the line.  The white space
on the last line is:
[tab][space][space][space][space][space][space][space](edx ==

Honestly, kernel coding is like that.  Those are all rules.
Checkpatch.pl will help you with most of them.  Good luck.  :)

regards,
dan carpenter

