Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaIDAt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 20:49:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaIDAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 20:49:57 -0400
Date: Wed, 3 Sep 2014 17:49:47 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] eeepc-laptop: remove possible use of uninitialized value
Message-ID: <20140904004947.GA17138@vmdeb7>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 12:53:25AM +0200, Frans Klaver wrote:
> In store_sys_acpi, if count equals zero, or parse_arg()s sscanf call
> fails, 'value' remains possibly uninitialized. In that case 'value'
> shouldn't be used to produce the store_sys_acpi()s return value.
> 
> Only test the return value of set_acpi() if we can actually call it.
> Return rv otherwise.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
>  drivers/platform/x86/eeepc-laptop.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index bd533c2..41f12ba 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -279,10 +279,10 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
>  	int rv, value;
>  
>  	rv = parse_arg(buf, count, &value);
> -	if (rv > 0)
> -		value = set_acpi(eeepc, cm, value);

That was rather horrible wasn't it? :-)

> -	if (value < 0)
> -		return -EIO;
> +	if (rv > 0) {
> +		if (set_acpi(eeepc, cm, value) < 0)
> +			return -EIO;

Is there a compelling reason not to propogate the return code of set_acpi?
(ENODEV specifically). I see -EIO in Documentation/filesystems/sysfs.txt, but
it's used by default if the show() pointer is NULL (for example), but otherwise
propogates the error.

Specifically it states:

- show() or store() can always return errors. If a bad value comes
  through, be sure to return an error.

Greg, does this need to be -EIO? or is returning someting like ENODEV preferable
if it more accurately reflects the error?

-- 
Darren Hart
Intel Open Source Technology Center
