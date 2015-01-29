Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbbA2GTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:19:13 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbbA2GTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:19:10 -0500
Date: Wed, 28 Jan 2015 22:19:07 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi: Add a check for TOS_NOT_SUPPORTED in the
 sci_open function
Message-ID: <20150129061907.GC115032@vmdeb7>
References: <1421633832-28490-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421633832-28490-1-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 07:17:12PM -0700, Azael Avalos wrote:
> This was "toshiba_acpi: Change sci_open function return value"
> 
> Some Toshiba laptops have "poorly implemented" SCI calls on their
> BIOSes and are not checking for sci_{open, close} calls, therefore,
> the sci_open function is failing and making some of the supported
> features unavailable (kbd backlight, touchpad, illumination, etc.).
> 
> This patch checks wheter we receive TOS_NOT_SUPPORTED and returns

                   ^ whether

(checkpatch.pl would catch this)

Since I'm late in review, this one's on me ;-)

> 1, making the supported features work on such laptops.
> 
> In the case that some laptops really do not support the SCI, all the
> SCI dependent functions check for TOS_NOT_SUPPORTED, and thus, not
> registering support for the queried feature.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>

Queued for 3.20.

> ---
> Darren,
> 
> Hopefully this new patch eases some of the concerns of the previous
> patch, and this time I added a comment block explaining a bit, but of
> course, let me know if there is something else that needs change.
> 
> Cheers
> Azael
> 
>  drivers/platform/x86/toshiba_acpi.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index fc34a71..899ead6b 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -389,6 +389,19 @@ static int sci_open(struct toshiba_acpi_dev *dev)
>  	} else if (out[0] == TOS_ALREADY_OPEN) {
>  		pr_info("Toshiba SCI already opened\n");
>  		return 1;
> +	} else if (out[0] == TOS_NOT_SUPPORTED) {
> +		/* Some BIOSes do not have the SCI open/close functions
> +		 * implemented and return 0x8000 (Not Supported), failing to
> +		 * register some supported features.
> +		 *
> +		 * Simply return 1 if we hit those affected laptops to make the
> +		 * supported features work.
> +		 *
> +		 * In the case that some laptops really do not support the SCI,
> +		 * all the SCI dependent functions check for TOS_NOT_SUPPORTED,
> +		 * and thus, not registering support for the queried feature.
> +		 */

This is great by the way, when things are just weird/broken, this is when we
need really clear comments.

> +		return 1;
>  	} else if (out[0] == TOS_NOT_PRESENT) {
>  		pr_info("Toshiba SCI is not present\n");
>  	}

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
