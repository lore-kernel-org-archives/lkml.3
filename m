Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaLASO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:14:56 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33707 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaLASOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:14:54 -0500
Date: Mon, 1 Dec 2014 10:14:49 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Zhou Wang <wangzhou.bry@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mtd: hisilicon: add a new NAND controller driver
 for hisilicon hip04 Soc
Message-ID: <20141201181449.GG21347@ld-irv-0074>
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com>
 <1415105221-7732-2-git-send-email-wangzhou.bry@gmail.com>
 <20141130093529.GH3608@norris-Latitude-E6410>
 <547C685A.3090804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547C685A.3090804@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:08:42PM +0800, Zhou Wang wrote:
> On 2014年11月30日 17:35, Brian Norris wrote:
> >On Tue, Nov 04, 2014 at 08:47:00PM +0800, Zhou Wang wrote:
> >>Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
[...]
> >>+static void hisi_nfc_dma_transfer(struct hinfc_host *host, int todev)
> >>+{
> >>+	struct mtd_info	*mtd = &host->mtd;
> >>+	struct nand_chip *chip = mtd->priv;
> >>+	unsigned long val;
> >>+	int ret;
> >>+
> >>+	hinfc_write(host, host->dma_buffer, HINFC504_DMA_ADDR_DATA);
> >>+	hinfc_write(host, host->dma_oob, HINFC504_DMA_ADDR_OOB);
> >>+
> >>+	if (chip->ecc.mode == NAND_ECC_NONE) {
> >>+		hinfc_write(host, ((mtd->oobsize & HINFC504_DMA_LEN_OOB_MASK)
> >>+			<< HINFC504_DMA_LEN_OOB_SHIFT), HINFC504_DMA_LEN);
> >>+
> >>+		hinfc_write(host, HINFC504_DMA_PARA_DATA_RW_EN
> >>+			| HINFC504_DMA_PARA_OOB_RW_EN, HINFC504_DMA_PARA);
> >>+	} else {
> >>+		hinfc_write(host, HINFC504_DMA_PARA_DATA_RW_EN
> >>+		| HINFC504_DMA_PARA_OOB_RW_EN | HINFC504_DMA_PARA_DATA_EDC_EN
> >>+		| HINFC504_DMA_PARA_OOB_EDC_EN | HINFC504_DMA_PARA_DATA_ECC_EN
> >>+		| HINFC504_DMA_PARA_OOB_ECC_EN, HINFC504_DMA_PARA);
> >>+	}
> >>+
> >>+	val = (HINFC504_DMA_CTRL_DMA_START | HINFC504_DMA_CTRL_BURST4_EN
> >>+		| HINFC504_DMA_CTRL_BURST8_EN | HINFC504_DMA_CTRL_BURST16_EN
> >>+		| HINFC504_DMA_CTRL_DATA_AREA_EN | HINFC504_DMA_CTRL_OOB_AREA_EN
> >>+		| ((host->addr_cycle == 4 ? 1 : 0)
> >>+			<< HINFC504_DMA_CTRL_ADDR_NUM_SHIFT)
> >>+		| ((host->chipselect & HINFC504_DMA_CTRL_CS_MASK)
> >>+			<< HINFC504_DMA_CTRL_CS_SHIFT));
> >>+
> >>+	if (todev)
> >>+		val |= HINFC504_DMA_CTRL_WE;
> >>+
> >>+	hinfc_write(host, val, HINFC504_DMA_CTRL);
> >>+
> >>+	init_completion(&host->cmd_complete);
> >
> >You need to run init_completion() *before* you kick off your I/O.
> >Otherwise, your interrupt handler is racing with this function.
> >
> 
> Do you mean that it needs put init_completion() before hinfc_write()?
> If not so, interrupt handler maybe execute before init_completion()
> which will cause something wrong.

Yes.

	init_completion(&host->cmd_complete);

should come sometime before

	hinfc_write(host, val, HINFC504_DMA_CTRL);

> >>+	ret = wait_for_completion_timeout(&host->cmd_complete,
> >>+			HINFC504_NFC_DMA_TIMEOUT);

[...]

> >>+static void set_addr(struct mtd_info *mtd, int column, int page_addr)
> >>+{
> >>+	struct nand_chip *chip = mtd->priv;
> >>+	struct hinfc_host *host = chip->priv;
> >>+
> >>+	host->addr_cycle    = 0;
> >>+	host->addr_value[0] = 0;
> >>+	host->addr_value[1] = 0;
> >>+
> >>+	/* Serially input address */
> >>+	if (column != -1) {
> >>+		/* Adjust columns for 16 bit buswidth */
> >>+		if (chip->options & NAND_BUSWIDTH_16)
> >>+			column >>= 1;
> >
> >It doesn't look like you're supporting ONFI parameter pages yet, but you
> >might consider checking for !nand_opcode_8bits(opcode) before adjusting the
> >address. We had to fix some other drivers for this recently.
> >
> 
> sorry, could you give me more clue about this?  Do you mean that we
> should first make sure it is not 8 bits bus width?

Look for use of nand_opcode_8bits() in nand_base.c.

I'm suggesting that you don't necessarily want to "adjust the column"
for all commands; there are some opcodes that take their address only on
the lower x8 bits, even if the flash has an x16 buswidth.

> >>+
> >>+		host->addr_value[0] = column & 0xffff;
> >>+		host->addr_cycle    = 2;
> >>+	}

[...]

> >>+	switch (mtd->writesize) {
> >>+	case 2048:
> >>+		flag |= (0x001 << HINFC504_CON_PAGEISZE_SHIFT);
> >>+	/* add more pagesize support
> >>+	 * default pagesize has been set in hisi_nfc_host_init
> >>+	 */
> >
> >Does this mean you can't handle any other page size? You might want to
> >put the words 'TODO' or 'FIXME' in the comment, and you might want to
> >print an error and exit if you see some other value for mtd->writesize.
> >
> 
> Yes, this NAND controller can handle not only 2048 page size. But
> the NAND controller on hip04-d01 board which I used to test this
> driver connects with a NAND flash chip which is just 2048 page size.
> So here I
> just listed 'case 2048', Maybe I need indicate this by 'TODO:...'?

Not just a TODO; make sure to also error out, so that users don't get
unexplained failures if they find themselves with a non-2KB page size
NAND.

Brian
