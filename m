Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab3CMPtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:49:35 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59496 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab3CMPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:49:33 -0400
Message-ID: <1363189770.15011.300.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
From: Matt Fleming <matt.fleming@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Date: Wed, 13 Mar 2013 15:49:30 +0000
In-Reply-To: <20130312211417.GC16558@thinkpad-t410>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
	 <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410>
	 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
	 <513911F9.8050308@zytor.com> <20130311211750.GB8440@thinkpad-t410>
	 <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20130312211417.GC16558@thinkpad-t410>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 16:14 -0500, Seth Forshee wrote:
> From 91df4dd0d1e20f44ea16b3653cffecd507fdb500 Mon Sep 17 00:00:00 2001
> From: Seth Forshee <seth.forshee@canonical.com>
> Date: Wed, 6 Mar 2013 14:25:36 -0600
> Subject: [PATCH] efivars: Add module parameter to allow disabling use as a
>  pstore backend
> 
> We know that with some firmware implementations writing too much data to
> UEFI variables can lead to bricking machines. Recent changes attempt to
> address this issue, but for some it may still be prudent to avoid
> writing large amounts of data until the solution has been proven on a
> wide variety of hardware.
> 
> Crash dumps or other data from pstore can potentially be a large data
> source. Add a pstore_enable parameter to efivars to allow disabling its
> use as a backend for pstore. Also add a config option,
> CONFIG_EFI_VARS_PSTORE, which will specify the default value for this
> parameter. Default this option to Y to maintain the existing behavior.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/firmware/Kconfig   |    9 ++++++
>  drivers/firmware/efivars.c |   66 +++++++++++++++-----------------------------
>  2 files changed, 32 insertions(+), 43 deletions(-)

Thanks for sticking with this Seth. I think this is a nice solution.
I've tossed this patch into my urgent queue and tagged it for stable and
added some Cc's.

I did make one minor adjustment below. Let me know if you disagree.

Peter, are you happy with this version?

> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 9b00072..35f7d16 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -53,6 +53,15 @@ config EFI_VARS
>  	  Subsequent efibootmgr releases may be found at:
>  	  <http://linux.dell.com/efibootmgr>
>  
> +config EFI_VARS_PSTORE
> +	bool "Use efivars as a pstore backend"
> +	depends on EFI_VARS
> +	default y
> +	help
> +	  Say Y here to enable the use of efivars as a storage backend
> +	  for pstore. This setting can be overridden using the
> +	  efivars.pstore_enable parameter.
> +

The depends here should probably include PSTORE, which I think it did on
previous iterations. I can't think of a situation where you'd want to
disable CONFIG_PSTORE but enable CONFIG_EFI_VARS_PSTORE. Also, we don't
need to use CONFIG_EFI_VARS_PSTORE solely for the purpose of setting the
initial value of efivars_pstore_enabled - there's merit in also using it
to leave out the pstore code in efivars.c during compilation.

Granted, this change does mean that your decision at compile time may be
final, and you can't enable the pstore code at runtime if you built your
kernel/efivars module with CONFIG_EFI_VARS_PSTORE=n. Arguably, I think
that's a feature that some people will want, e.g. "Don't allow enabling
the efivars pstore backend at all... no, srsly!".

[...]

> @@ -1309,8 +1312,6 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
>  	.create = efivarfs_create,
>  };
>  
> -static struct pstore_info efi_pstore_info;
> -
>  #ifdef CONFIG_PSTORE

... I've changed this to #ifdef CONFIG_EFI_VARS_PSTORE, since if
CONFIG_EFI_VARS_PSTORE=n there's no point compiling the pstore code.


