Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaIWJY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:24:28 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49185 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbaIWJY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:24:26 -0400
Message-ID: <1411464267.18580.46.camel@iivanov-dev>
Subject: Re: [PATCH] spi: qup: Fix incorrect block transfers
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 23 Sep 2014 12:24:27 +0300
In-Reply-To: <1411360048-3388-1-git-send-email-agross@codeaurora.org>
References: <1411360048-3388-1-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andy,

On Sun, 2014-09-21 at 23:27 -0500, Andy Gross wrote:
> This patch fixes a number of errors with the QUP block transfer mode.  Errors
> manifested themselves as input underruns, output overruns, and timed out
> transactions.

At what speeds are you seeing those errors?

> 
> The block mode does not require the priming that occurs in FIFO mode.  At the
> moment that the QUP is placed into the RUN state, the QUP may immediately raise
> an interrupt if the request is a write.  Therefore, there is no need to prime
> the pump.
> 
> In addition, the block transfers require that whole blocks of data are
> read/written at a time.  The last block of data that completes a transaction may
> contain less than a full blocks worth of data.

Does this mean that block transfer will start only if the required
bytes from block is written into buffer?

> 
> Each block of data results in an input/output service interrupt accompanied with
> a input/output block flag set.  Additional block reads/writes require clearing
> of the service flag.  It is ok to check for additional blocks of data in the
> ISR, but you have to ack every block you transfer.  Imbalanced acks result in
> early return from complete transactions with pending interrupts that still have
> to be ack'd.  The next transaction can be affected by these interrupts.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  drivers/spi/spi-qup.c |  194 +++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 141 insertions(+), 53 deletions(-)
> 

<snip>

> +static void qup_fill_read_buffer(struct spi_qup *controller,
> +	struct spi_transfer *xfer, u32 data)

Please, could prefix this whit spi_ to be consistent with the
rest of the code.

>  {
>  	u8 *rx_buf = xfer->rx_buf;
> -	u32 word, state;
> -	int idx, shift, w_size;
> -
> -	w_size = controller->w_size;
> -
> -	while (controller->rx_bytes < xfer->len) {
> -
> -		state = readl_relaxed(controller->base + QUP_OPERATIONAL);
> -		if (0 == (state & QUP_OP_IN_FIFO_NOT_EMPTY))
> -			break;
> +	int idx, shift;
> +	int read_len = min_t(int, xfer->len - controller->rx_bytes,
> +				controller->w_size);

You should not need this check here. xfer->len is multiple of controller->w_size
and you always read one word at time.

>  
> -		word = readl_relaxed(controller->base + QUP_INPUT_FIFO);
> -
> -		if (!rx_buf) {
> -			controller->rx_bytes += w_size;
> -			continue;
> -		}
> -
> -		for (idx = 0; idx < w_size; idx++, controller->rx_bytes++) {
> +	if (rx_buf)
> +		for (idx = 0; idx < read_len; idx++) {
>  			/*
>  			 * The data format depends on bytes per SPI word:
>  			 *  4 bytes: 0x12345678
> @@ -229,40 +218,129 @@ static void spi_qup_fifo_read(struct spi_qup *controller,
>  			 *  1 byte : 0x00000012
>  			 */
>  			shift = BITS_PER_BYTE;
> -			shift *= (w_size - idx - 1);
> -			rx_buf[controller->rx_bytes] = word >> shift;
> +			shift *= (controller->w_size - idx - 1);
> +			rx_buf[controller->rx_bytes + idx] = data >> shift;
>  		}
> -	}
> +
> +	controller->rx_bytes += read_len;
>  }
>  
> -static void spi_qup_fifo_write(struct spi_qup *controller,
> -			    struct spi_transfer *xfer)
> +static void qup_prepare_write_data(struct spi_qup *controller,
> +	struct spi_transfer *xfer, u32 *data)
>  {
>  	const u8 *tx_buf = xfer->tx_buf;
> -	u32 word, state, data;
> -	int idx, w_size;
> +	u32 val;
> +	int idx;
> +	int write_len = min_t(int, xfer->len - controller->tx_bytes,
> +				controller->w_size);
>  

Same here.

> -	w_size = controller->w_size;
> +	*data = 0;
>  
> -	while (controller->tx_bytes < xfer->len) {
> +	if (tx_buf)
> +		for (idx = 0; idx < write_len; idx++) {
> +			val = tx_buf[controller->tx_bytes + idx];
> +			*data |= val << (BITS_PER_BYTE * (3 - idx));
> +		}
>  
> -		state = readl_relaxed(controller->base + QUP_OPERATIONAL);
> -		if (state & QUP_OP_OUT_FIFO_FULL)
> -			break;
> +	controller->tx_bytes += write_len;
> +}
>  
> -		word = 0;
> -		for (idx = 0; idx < w_size; idx++, controller->tx_bytes++) {
> +static void spi_qup_service_block(struct spi_qup *controller,
> +	struct spi_transfer *xfer, bool is_read)
> +{

Please, could you split this function to read and write, so we can use:

spi_qup_fifo_read() and spi_qup_fifo_write() in FIFO modes and 
spi_qup_block_read() and spi_qup_block_write() for BLOCK mode.

> +	u32 data, words_per_blk, num_words, ack_flag, op_flag;
> +	int i;
> +
> +	if (is_read) {
> +		op_flag = QUP_OP_IN_BLOCK_READ_REQ;
> +		ack_flag = QUP_OP_IN_SERVICE_FLAG;
> +		num_words = DIV_ROUND_UP(xfer->len - controller->rx_bytes,
> +					controller->w_size);

Same here and below.

> +		words_per_blk = controller->in_blk_sz >> 2;
> +	} else {
> +		op_flag = QUP_OP_OUT_BLOCK_WRITE_REQ;
> +		ack_flag = QUP_OP_OUT_SERVICE_FLAG;
> +		num_words = DIV_ROUND_UP(xfer->len - controller->tx_bytes,
> +					controller->w_size);
> +		words_per_blk = controller->out_blk_sz >> 2;
> +	}

Thank you.
Ivan


