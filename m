Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbaLEFl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:41:59 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:32873 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaLEFl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:41:57 -0500
MIME-Version: 1.0
In-Reply-To: <1417610126-7957-2-git-send-email-harinik@xilinx.com>
References: <1417610126-7957-1-git-send-email-harinik@xilinx.com>
	<1417610126-7957-2-git-send-email-harinik@xilinx.com>
Date: Fri, 5 Dec 2014 11:11:56 +0530
Message-ID: <CAA7nrtg_G+U2EVxy0joZC+fBGyXS_uOwe1RZ8PyoDv7icu6OBw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] i2c: cadence: Handle > 252 byte transfers
From: rajeev kumar <rajeevkumar.linux@gmail.com>
To: Harini Katakam <harinik@xilinx.com>
Cc: wsa@the-dreams.de, mark.rutland@arm.com, michal.simek@xilinx.com,
        soren.brinkmann@xilinx.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        vishnum@xilinx.com, harinikatakamlinux@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 6:05 PM, Harini Katakam <harinik@xilinx.com> wrote:
> The I2C controller sends a NACK to the slave when transfer size register
> reaches zero, irrespective of the hold bit. So, in order to handle transfers
> greater than 252 bytes, the transfer size register has to be maintained at a
> value >= 1. This patch implements the same.

Why 252 Bytes ?  Is it word allign or what ?

> The interrupt status is cleared at the beginning of the isr instead of
> the end, to avoid missing any interrupts - this is in sync with the new
> transfer handling.
>

No need to write this, actually this is the correct way of handling interrupt.

> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
>
> v2:
> No changes
>
> ---
>  drivers/i2c/busses/i2c-cadence.c |  156 ++++++++++++++++++++------------------
>  1 file changed, 81 insertions(+), 75 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
> index 63f3f03..e54899e 100644
> --- a/drivers/i2c/busses/i2c-cadence.c
> +++ b/drivers/i2c/busses/i2c-cadence.c
> @@ -126,6 +126,7 @@
>   * @suspended:         Flag holding the device's PM status
>   * @send_count:                Number of bytes still expected to send
>   * @recv_count:                Number of bytes still expected to receive
> + * @curr_recv_count:   Number of bytes to be received in current transfer

Please do the alignment properly

>   * @irq:               IRQ number
>   * @input_clk:         Input clock to I2C controller
>   * @i2c_clk:           Maximum I2C clock speed
> @@ -144,6 +145,7 @@ struct cdns_i2c {
>         u8 suspended;
>         unsigned int send_count;
>         unsigned int recv_count;
> +       unsigned int curr_recv_count;

same here..

>         int irq;
>         unsigned long input_clk;
>         unsigned int i2c_clk;
> @@ -180,14 +182,15 @@ static void cdns_i2c_clear_bus_hold(struct cdns_i2c *id)
>   */
>  static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
>  {
> -       unsigned int isr_status, avail_bytes;
> -       unsigned int bytes_to_recv, bytes_to_send;
> +       unsigned int isr_status, avail_bytes, updatetx;
> +       unsigned int bytes_to_send;

why you are mixing tab and space..

>         struct cdns_i2c *id = ptr;
>         /* Signal completion only after everything is updated */
>         int done_flag = 0;
>         irqreturn_t status = IRQ_NONE;
>
>         isr_status = cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
> +       cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
>
>         /* Handling nack and arbitration lost interrupt */
>         if (isr_status & (CDNS_I2C_IXR_NACK | CDNS_I2C_IXR_ARB_LOST)) {
> @@ -195,89 +198,91 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
>                 status = IRQ_HANDLED;
>         }
>
> -       /* Handling Data interrupt */
> -       if ((isr_status & CDNS_I2C_IXR_DATA) &&
> -                       (id->recv_count >= CDNS_I2C_DATA_INTR_DEPTH)) {
> -               /* Always read data interrupt threshold bytes */
> -               bytes_to_recv = CDNS_I2C_DATA_INTR_DEPTH;
> -               id->recv_count -= CDNS_I2C_DATA_INTR_DEPTH;
> -               avail_bytes = cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
> -
> -               /*
> -                * if the tranfer size register value is zero, then
> -                * check for the remaining bytes and update the
> -                * transfer size register.
> -                */
> -               if (!avail_bytes) {
> -                       if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
> -                               cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
> -                                               CDNS_I2C_XFER_SIZE_OFFSET);
> -                       else
> -                               cdns_i2c_writereg(id->recv_count,
> -                                               CDNS_I2C_XFER_SIZE_OFFSET);
> -               }
> +       updatetx = 0;
> +       if (id->recv_count > id->curr_recv_count)
> +               updatetx = 1;
> +
> +       /* When receiving, handle data and transfer complete interrupts */

Breaking statement

> +       if (id->p_recv_buf &&
> +           ((isr_status & CDNS_I2C_IXR_COMP) ||
> +            (isr_status & CDNS_I2C_IXR_DATA))) {
> +               while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) &
> +                      CDNS_I2C_SR_RXDV) {
> +                       if ((id->recv_count < CDNS_I2C_FIFO_DEPTH) &&
> +                           !id->bus_hold_flag)
> +                               cdns_i2c_clear_bus_hold(id);

make it simple. you can use extra variables also.

>
> -               /* Process the data received */
> -               while (bytes_to_recv--)
>                         *(id->p_recv_buf)++ =
>                                 cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
> +                       id->recv_count--;
> +                       id->curr_recv_count--;
>
> -               if (!id->bus_hold_flag &&
> -                               (id->recv_count <= CDNS_I2C_FIFO_DEPTH))
> -                       cdns_i2c_clear_bus_hold(id);
> +                       if (updatetx &&
> +                           (id->curr_recv_count == CDNS_I2C_FIFO_DEPTH + 1))
> +                               break;
> +               }
>
> -               status = IRQ_HANDLED;
> -       }
> +               if (updatetx &&
> +                   (id->curr_recv_count == CDNS_I2C_FIFO_DEPTH + 1)) {
> +                       /* wait while fifo is full */

Not convinced with the implementation . you are waiting in ISR.. You
can move this part in transfer function,

> +                       while (cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET) !=
> +                              (id->curr_recv_count - CDNS_I2C_FIFO_DEPTH))
> +                               ;
>
> -       /* Handling Transfer Complete interrupt */
> -       if (isr_status & CDNS_I2C_IXR_COMP) {
> -               if (!id->p_recv_buf) {
> -                       /*
> -                        * If the device is sending data If there is further
> -                        * data to be sent. Calculate the available space
> -                        * in FIFO and fill the FIFO with that many bytes.
> -                        */
> -                       if (id->send_count) {
> -                               avail_bytes = CDNS_I2C_FIFO_DEPTH -
> -                                   cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
> -                               if (id->send_count > avail_bytes)
> -                                       bytes_to_send = avail_bytes;
> -                               else
> -                                       bytes_to_send = id->send_count;
> -
> -                               while (bytes_to_send--) {
> -                                       cdns_i2c_writereg(
> -                                               (*(id->p_send_buf)++),
> -                                                CDNS_I2C_DATA_OFFSET);
> -                                       id->send_count--;
> -                               }
> +                       if (((int)(id->recv_count) - CDNS_I2C_FIFO_DEPTH) >
> +                           CDNS_I2C_TRANSFER_SIZE) {
> +                               cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
> +                                                 CDNS_I2C_XFER_SIZE_OFFSET);
> +                               id->curr_recv_count = CDNS_I2C_TRANSFER_SIZE +
> +                                                     CDNS_I2C_FIFO_DEPTH;
>                         } else {
> -                               /*
> -                                * Signal the completion of transaction and
> -                                * clear the hold bus bit if there are no
> -                                * further messages to be processed.
> -                                */
> -                               done_flag = 1;
> +                               cdns_i2c_writereg(id->recv_count -
> +                                                 CDNS_I2C_FIFO_DEPTH,
> +                                                 CDNS_I2C_XFER_SIZE_OFFSET);
> +                               id->curr_recv_count = id->recv_count;
>                         }
> -                       if (!id->send_count && !id->bus_hold_flag)
> -                               cdns_i2c_clear_bus_hold(id);
> -               } else {
> +               }
> +
> +               if ((isr_status & CDNS_I2C_IXR_COMP) && !id->recv_count) {
>                         if (!id->bus_hold_flag)
>                                 cdns_i2c_clear_bus_hold(id);
> +                       done_flag = 1;
> +               }
> +
> +               status = IRQ_HANDLED;
> +       }
> +
> +       /* When sending, handle transfer complete interrupt */
> +       if ((isr_status & CDNS_I2C_IXR_COMP) && !id->p_recv_buf) {
> +               /*
> +                * If the device is sending data If there is further
> +                * data to be sent. Calculate the available space
> +                * in FIFO and fill the FIFO with that many bytes.
> +                */
> +               if (id->send_count) {
> +                       avail_bytes = CDNS_I2C_FIFO_DEPTH -
> +                           cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
> +                       if (id->send_count > avail_bytes)
> +                               bytes_to_send = avail_bytes;
> +                       else
> +                               bytes_to_send = id->send_count;
> +
> +                       while (bytes_to_send--) {
> +                               cdns_i2c_writereg(
> +                                       (*(id->p_send_buf)++),
> +                                        CDNS_I2C_DATA_OFFSET);
> +                               id->send_count--;
> +                       }
> +               } else {
>                         /*
> -                        * If the device is receiving data, then signal
> -                        * the completion of transaction and read the data
> -                        * present in the FIFO. Signal the completion of
> -                        * transaction.
> +                        * Signal the completion of transaction and
> +                        * clear the hold bus bit if there are no
> +                        * further messages to be processed.
>                          */
> -                       while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) &
> -                                       CDNS_I2C_SR_RXDV) {
> -                               *(id->p_recv_buf)++ =
> -                                       cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
> -                               id->recv_count--;
> -                       }
>                         done_flag = 1;
>                 }
> +               if (!id->send_count && !id->bus_hold_flag)
> +                       cdns_i2c_clear_bus_hold(id);
>
>                 status = IRQ_HANDLED;
>         }
> @@ -287,8 +292,6 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
>         if (id->err_status)
>                 status = IRQ_HANDLED;
>
> -       cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
> -
>         if (done_flag)
>                 complete(&id->xfer_done);
>
> @@ -314,6 +317,8 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
>         if (id->p_msg->flags & I2C_M_RECV_LEN)
>                 id->recv_count = I2C_SMBUS_BLOCK_MAX + 1;
>
> +       id->curr_recv_count = id->recv_count;
> +
>         /*
>          * Check for the message size against FIFO depth and set the
>          * 'hold bus' bit if it is greater than FIFO depth.
> @@ -333,10 +338,11 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
>          * receive if it is less than transfer size and transfer size if
>          * it is more. Enable the interrupts.
>          */
> -       if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
> +       if (id->recv_count > CDNS_I2C_TRANSFER_SIZE) {
>                 cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
>                                   CDNS_I2C_XFER_SIZE_OFFSET);
> -       else
> +               id->curr_recv_count = CDNS_I2C_TRANSFER_SIZE;
> +       } else
>                 cdns_i2c_writereg(id->recv_count, CDNS_I2C_XFER_SIZE_OFFSET);
>         /* Clear the bus hold flag if bytes to receive is less than FIFO size */
>         if (!id->bus_hold_flag &&
> --
> 1.7.9.5

Overall I think it is required to re-write isr.

~Rajeev

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
