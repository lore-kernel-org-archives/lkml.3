Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935717Ab3IEKNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:13:05 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:47911 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935552Ab3IEKNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:13:00 -0400
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
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
        Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20130905085348.GJ28598@console-pimps.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-12-git-send-email-jlee@suse.com>
	 <20130905085348.GJ28598@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Sep 2013 18:13:36 +0800
Message-ID: <1378376016.6193.71.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt, 

First, thanks for your review!

於 四，2013-09-05 於 09:53 +0100，Matt Fleming 提到：
> On Thu, 22 Aug, at 07:01:50PM, Lee, Chun-Yi wrote:
> > +static int efi_status_to_err(efi_status_t status)
> > +{
> > +	int err;
> > +
> > +	switch (status) {
> > +	case EFI_INVALID_PARAMETER:
> > +		err = -EINVAL;
> > +		break;
> > +	case EFI_OUT_OF_RESOURCES:
> > +		err = -ENOSPC;
> > +		break;
> > +	case EFI_DEVICE_ERROR:
> > +		err = -EIO;
> > +		break;
> > +	case EFI_WRITE_PROTECTED:
> > +		err = -EROFS;
> > +		break;
> > +	case EFI_SECURITY_VIOLATION:
> > +		err = -EACCES;
> > +		break;
> > +	case EFI_NOT_FOUND:
> > +		err = -ENODATA;
> > +		break;
> > +	default:
> > +		err = -EINVAL;
> > +	}
> > +
> > +	return err;
> > +}
> 
> Please don't reimplement this. Instead make the existing function
> global.
> 

OK, I will make the function to global.

> [...]
> 
> > +static void *load_wake_key_data(unsigned long *datasize)
> > +{
> > +	u32 attr;
> > +	void *wkey_data;
> > +	efi_status_t status;
> > +
> > +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > +		return ERR_PTR(-EPERM);
> > +
> > +	/* obtain the size */
> > +	*datasize = 0;
> > +	status = efi.get_variable(EFI_S4_WAKE_KEY_NAME, &EFI_HIBERNATE_GUID,
> > +				  NULL, datasize, NULL);
> > +	if (status != EFI_BUFFER_TOO_SMALL) {
> > +		wkey_data = ERR_PTR(efi_status_to_err(status));
> > +		pr_err("PM: Couldn't get wake key data size: 0x%lx\n", status);
> > +		goto error;
> > +	}
> 
> Is it safe to completely bypass the efivars interface and access
> efi.get_variable() directly? I wouldn't have thought so, unless you can
> guarantee that the kernel isn't going to access any of the EFI runtime
> services while you execute this function.
> 

This S4WakeKey is a VOLATILE variable that could not modify by
SetVariable() at runtime. So, it's read only even through efivars. 

Does it what your concern?


Thanks a lot!
Joey Lee

