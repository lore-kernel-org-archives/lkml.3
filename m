Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbaE3R0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:26:05 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:36152
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413AbaE3R0C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:26:02 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/6] staging: comedi: addi_apci_1564: cleanup
 v_ADDI_Interrupt()
Thread-Topic: [PATCH 6/6] staging: comedi: addi_apci_1564: cleanup
 v_ADDI_Interrupt()
Thread-Index: AQHPe8HO+UDOSHpGLESrgTAiDXwtOptZWmKw
Date: Fri, 30 May 2014 17:26:00 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E8405F@P3PWEX4MB008.ex4.secureserver.net>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
 <1401425032-22721-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1401425032-22721-1-git-send-email-chase.southwood@gmail.com>
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

On Thursday, May 29, 2014 9:44 PM, Chase Southwood wrote:
> Move the function apci1564_interrupt() from hwdrv_apci1564.c to
> addi_apci_1564.c.  On moving, for now just strip out all of the
> code for interrupts that the driver does not yet support at this
> time.
>
> Rename the variable ui_InterruptStatus_1564 to ctrl, and change the return
> from IRQ_RETVAL(1) to IRQ_HANDLED.
>
> We also check the device is asserting the shared interrupt line and check
> that interrupts have been enabled.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>
> Admittedly, I am not sure if what I have done in the interrupt handler is
> quite sufficient.  Am I missing anything that should be there due to the
> fact that the handler does not yet support all of the types of interrupt
> that the board is capable of issuing (i.e. does the interrupt handler need
> to clear the other interrupts just in case they get triggered, etc?)

This one is a bit of a mess, not your fault, the existing code is pretty ugly.

>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 130 ---------------------
>  drivers/staging/comedi/drivers/addi_apci_1564.c    |  34 +++++-
>  2 files changed, 30 insertions(+), 134 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index 41aa889..ebd763b 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -90,7 +90,6 @@
>  #define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
>  
>  /* Global variables */
> -static unsigned int ui_InterruptStatus_1564;
>  static unsigned int ui_InterruptData, ui_Type;
 
These static globals need to away.

ui_InterruptStatus_1564 is only used in the interrupt handler. It's also not really used
in the existing code. You fixed this in your patch but I'm not sure it deserves mentioning
in the commit other than maybe "remove unnecessary static global foo".

ui_InterruptData is set in apci1564_do_config() but it is never used. That function is also
broke since it does not follow the comedi API.

ui_Type is set in the interrupt handler but you patch strips it out. The variable is then
used in apci1564_do_read() but that function also abuses the comedi API since it is
returning the diagnostic status in the digital output (*insn_read) operation.

Ugh...

You might want to rework this patch to:

1) Move the static globals into the private data.
2) Merge the existing interrupt handler from hwrdv_apci1564.c into the driver.
   You could tidy up the existing code a bit during the move. Hint, the counters
   could be handled with a for () loop.
3) Now "fix" the digital input interrupt handling.

Since you still have the timer subdevice I would leave the timer/counter handling
in the interrupt handler.

For now, hold off and see if Ian has any comments.

I'll try to apply your series and take a better look at this later today.

Regards,
Hartley

