Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaGYSXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:23:12 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:36705
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbaGYSXL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:23:11 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] staging: comedi: amplc_dio200_common: prevent extra
 free_irq()
Thread-Topic: [PATCH 1/3] staging: comedi: amplc_dio200_common: prevent
 extra free_irq()
Thread-Index: AQHPqCrr8EkYQfITLUWKJ+HRxzaKZ5uxGTdA
Date: Fri, 25 Jul 2014 18:23:10 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F1E378@P3PWEX4MB008.ex4.secureserver.net>
References: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
 <1406308029-15712-2-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1406308029-15712-2-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 25, 2014 10:07 AM, Ian Abbott wrote:
> `dio200_detach()` in "amplc_dio200.c" calls
> `amplc_dio200_common_detach()` in "amplc_dio200_common.c", followed by
> `comedi_legacy_detach()` in "../drivers.c".  Both of those functions
> call `free_irq()` if `dev->irq` is non-zero.  The second call produces a
> warning message because the handler has already been freed.  Prevent
> that by setting `dev->irq = 0` in `amplc_dio200_common_detach()`.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/drivers/amplc_dio200_common.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/amplc_dio200_common.c b/drivers/staging/comedi/drivers/amplc_dio200_common.c
> index 78700e8..3592e58 100644
> --- a/drivers/staging/comedi/drivers/amplc_dio200_common.c
> +++ b/drivers/staging/comedi/drivers/amplc_dio200_common.c
> @@ -1202,8 +1202,10 @@ void amplc_dio200_common_detach(struct comedi_device *dev)
>  
>  	if (!thisboard || !devpriv)
>  		return;
> -	if (dev->irq)
> +	if (dev->irq) {
>  		free_irq(dev->irq, dev);
> +		dev->irq = 0;
> +	}
>  }
>  EXPORT_SYMBOL_GPL(amplc_dio200_common_detach);
 
Ian,

I have already gave a Reviewed-by signoff for this series.

After looking over the code I think a cleaner solution would be to:

1) Use comedi_legacy_detach() directly for the (*detach) in the
   legacy ISA driver.
2) Move the code from amplc_dio200_common_detach() into the
   (*detach) function for the PCI driver.
3) Remove the exported function amplc_dio200_common_detach().

Regards,
Hartley

