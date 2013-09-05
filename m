Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578Ab3IEIyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:54:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37151 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762639Ab3IEIxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:53:55 -0400
Date: Thu, 5 Sep 2013 09:53:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Message-ID: <20130905085348.GJ28598@console-pimps.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-12-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377169317-5959-12-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug, at 07:01:50PM, Lee, Chun-Yi wrote:
> +static int efi_status_to_err(efi_status_t status)
> +{
> +	int err;
> +
> +	switch (status) {
> +	case EFI_INVALID_PARAMETER:
> +		err = -EINVAL;
> +		break;
> +	case EFI_OUT_OF_RESOURCES:
> +		err = -ENOSPC;
> +		break;
> +	case EFI_DEVICE_ERROR:
> +		err = -EIO;
> +		break;
> +	case EFI_WRITE_PROTECTED:
> +		err = -EROFS;
> +		break;
> +	case EFI_SECURITY_VIOLATION:
> +		err = -EACCES;
> +		break;
> +	case EFI_NOT_FOUND:
> +		err = -ENODATA;
> +		break;
> +	default:
> +		err = -EINVAL;
> +	}
> +
> +	return err;
> +}

Please don't reimplement this. Instead make the existing function
global.

[...]

> +static void *load_wake_key_data(unsigned long *datasize)
> +{
> +	u32 attr;
> +	void *wkey_data;
> +	efi_status_t status;
> +
> +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> +		return ERR_PTR(-EPERM);
> +
> +	/* obtain the size */
> +	*datasize = 0;
> +	status = efi.get_variable(EFI_S4_WAKE_KEY_NAME, &EFI_HIBERNATE_GUID,
> +				  NULL, datasize, NULL);
> +	if (status != EFI_BUFFER_TOO_SMALL) {
> +		wkey_data = ERR_PTR(efi_status_to_err(status));
> +		pr_err("PM: Couldn't get wake key data size: 0x%lx\n", status);
> +		goto error;
> +	}

Is it safe to completely bypass the efivars interface and access
efi.get_variable() directly? I wouldn't have thought so, unless you can
guarantee that the kernel isn't going to access any of the EFI runtime
services while you execute this function.

-- 
Matt Fleming, Intel Open Source Technology Center
