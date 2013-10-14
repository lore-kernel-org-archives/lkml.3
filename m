Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3JNNE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:04:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39280 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583Ab3JNNE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:04:56 -0400
Date: Mon, 14 Oct 2013 14:04:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Message-ID: <20131014130451.GA10834@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008164551.GB16793@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Oct, at 06:45:51PM, Borislav Petkov wrote:
> @@ -141,34 +151,75 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
>  			return -EFAULT;
>  
>  		convert_from_guid(&vendor, &vendor_guid);
> -		status = efi.get_variable(pgetvariable->VariableName, &vendor,
> -					&attr, &datasize, pgetvariable->Data);
> +
> +		vardata = kmalloc(datasize, GFP_KERNEL);
> +		if (!vardata)
> +			return -ENOMEM;
> +
> +		namelen = ucs2_strsize(pgetvariable->VariableName, 1024);
> +
> +		varname = kmalloc(namelen, GFP_KERNEL);
> +		if (!varname)
> +			return -ENOMEM;
> +
> +		if (copy_from_user(varname, pgetvariable->VariableName, namelen))
> +			return -EFAULT;
> +

		varname = kmalloc(namelen + 1, GFP_KERNEL);
		varname[namelen] = 0;

Note that ucs2_strsize() doesn't count the terminating NUL.

-- 
Matt Fleming, Intel Open Source Technology Center
