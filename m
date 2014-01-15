Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaAOSsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:48:37 -0500
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:59619
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbaAOSse convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:48:34 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
Thread-Topic: [PATCH v6] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
Thread-Index: AQHPEhp9AlLPgBRqMUKjxhnaYV56m5qGHBhg
Date: Wed, 15 Jan 2014 18:48:32 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817E79800@P3PWEX4MB008.ex4.secureserver.net>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
 <1389808311-4511-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1389808311-4511-1-git-send-email-chase.southwood@yahoo.com>
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

On Wednesday, January 15, 2014 10:52 AM, Chase Southwood wrote:
> This patch for ni_mio_common.c changes out a while loop for a timeout,
> which is preferred.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>
> 2: Changed from simple clean-up to swapping a timeout in for a while loop.
>
> 3: Removed extra counter variable, and added error checking.
>
> 4: No longer using counter variable, using jiffies instead.
>
> 5: udelay for 10u, instead of 1u.
>
> 6: Scrap udelay entirely, in favor of cpu_relax.  Include asm/processor.h
> in order to use cpu_relax.
>
>  drivers/staging/comedi/drivers/ni_mio_common.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index 457b884..fe2f434 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -55,6 +55,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
>  #include <linux/delay.h>
> +#include <asm/processor.h>
>  #include "8255.h"
>  #include "mite.h"
>  #include "comedi_fc.h"
> @@ -687,12 +688,21 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>  {
>  	const struct ni_board_struct *board = comedi_board(dev);
>  	struct ni_private *devpriv = dev->private;
> +	unsigned long timeout;
>  
>  	if (board->reg_type == ni_reg_6143) {
>  		/*  Flush the 6143 data FIFO */
>  		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
>  		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
> -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
> +		/*  Wait for complete */
> +		timeout = jiffies + msec_to_jiffies(500);

Did you build this?

I think you meant to use msecs_to_jiffies().

Regards,
Hartley

