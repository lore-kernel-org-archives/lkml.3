Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859Ab3K1J3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:29:15 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:48081 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3K1J3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:29:09 -0500
Date: Thu, 28 Nov 2013 09:29:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, angus.clark@st.com,
        linus.walleij@linaro.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 00/23] mtd: st_spi_fsm: Add new device
Message-ID: <20131128092904.GZ3296@lee--X1>
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
 <20131127040723.GZ9468@ld-irv-0074.broadcom.com>
 <20131127115226.GC3296@lee--X1>
 <5296B9C5.3060704@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5296B9C5.3060704@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >However, as we send entire 'message sequences' to the FSM Controller
> >as opposed to merely OPCODEs we would have to extract the OPCODE from
> >flash->command[0] and call our own functions to craft the correct
> >'message sequence' for the task. For this reason we rejected the idea
> >and went with a stand-alone driver.
> >
> could you send me the datasheet of your spi nor controller?
> I can change my code if it really not good enough.

Unfortunately not, it's ST company confidential.

> we can store the opcode to a field, such as spi_nor_write_op.

The OPCODE isn't the issue here.

> >The framework which Huang is proposing suffers from the same issues.
> >Only providing read(), write(), read_reg() and write_reg() doesn't
> >work for our use-case, as we'd have to decode the flash->command[0] and
> >invoke our own internal routines as before.
> >
> >The only framework with would work for us would consist almost all
> >of the important functions such as; read(), write(), erase(),
> >wait_busy(), read_jedec(), read_status_reg(), write_status_reg(),
> >read_control_reg(), write_control_reg(), etc. However, this approach
> read_jedec() can be replaced by read_reg(0x9f);
> 
> read_status() can be replaced by read_reg(0x5);
> 
> ....
> 
> write_control_reg() can be replaced by write_reg(xx).
> 
> Please correct me if i am wrong.
>
> IMHO, the current four hooks for spi-nor{} can do all the things.
> 
>      read/write/read_reg/write_reg.

I _fully_ understand your implementation, but it just won't work for
our controller. Or it would, but it would mean writing _more_ code to
bend it into your framework, not less. Let me try to explain in
another way by implementing what you're suggesting. For your JEDEC
example above, we would have to implement [1] which to my mind
completely defeats the purpose.

Most controllers just take an OPCODE and pass it on to the controller
and have done with it. The issue that you're attempting to rectify is
that the m25p80 expects every controller to be an SPI controller
registered to the SPI framework, but as we both know that's not always
practical as the SPI framework doesn't allow all configuration
information to be passed back to the controller driver. Our issue is
not the same. We are required to send entire 'message sequences', to
the controller rather than just opcodes. The JEDEC message sequence
can be seen below. Bear in mind that this is also one of the more
simple message sequences. Some of them even vary depending on which
chip is present.

[1]:

static struct stfsm_seq stfsm_seq_read_jedec = {
	.data_size = TRANSFER_SIZE(8),
	.seq_opc[0] = (SEQ_OPC_PADS_1 |
		       SEQ_OPC_CYCLES(8) |
		       SEQ_OPC_OPCODE(FLASH_CMD_RDID)),
	.seq = {
		STFSM_INST_CMD1,
		STFSM_INST_DATA_READ,
		STFSM_INST_STOP,
	},
	.seq_cfg = (SEQ_CFG_PADS_1 |
		    SEQ_CFG_READNOTWRITE |
		    SEQ_CFG_CSDEASSERT |
		    SEQ_CFG_STARTSEQ),
};

static inline int stfsm_is_idle(struct stfsm *fsm)
{
	return readl(fsm->base + SPI_FAST_SEQ_STA) & 0x10;
}

static inline uint32_t stfsm_fifo_available(struct stfsm *fsm)
{
	return (readl(fsm->base + SPI_FAST_SEQ_STA) >> 5) & 0x7f;
}

static inline void stfsm_load_seq(struct stfsm *fsm,
				  const struct stfsm_seq *seq)
{
	void __iomem *dst = fsm->base + SPI_FAST_SEQ_TRANSFER_SIZE;
	const uint32_t *src = (const uint32_t *)seq;
	int words = STFSM_SEQ_SIZE / sizeof(uint32_t);

	while (words--) {
		writel(*src, dst);
		src++;
		dst += 4;
	}
}

static void stfsm_wait_seq(struct stfsm *fsm)
{
	unsigned long timeo = jiffies + HZ;

	while (time_before(jiffies, timeo)) {
		if (stfsm_is_idle(fsm))
			return;

		cond_resched();
	}
}

static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
			    const uint32_t size)
{
	uint32_t remaining = size >> 2;
	uint32_t avail;
	uint32_t words;

	while (remaining) {
		for (;;) {
			avail = stfsm_fifo_available(fsm);
			if (avail)
				break;
			udelay(1);
		}
		words = min(avail, remaining);
		remaining -= words;

		readsl(fsm->base + SPI_FAST_SEQ_DATA_REG, buf, words);
		buf += words;
	}
}

static void stfsm_read_jedec(struct stfsm *fsm, u8 *jedec)
{
	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
	uint32_t tmp[2];

	stfsm_load_seq(fsm, seq);

	stfsm_read_fifo(fsm, tmp, 8);

	memcpy(jedec, tmp, 5);

	stfsm_wait_seq(fsm);
}

static int stfsm_read_reg(struct spi_nor *flash, u8 opcode, u8 *buf, int len)
{
	struct stfsm *fsm = dev_get_drvdata(flash->mtd->dev.parent);
	
	switch (opcode) {
	case OPCODE_RDID :
		stfsm_read_jedec(fsm, buf);
		break;

	case OPCODE_A :
		stfsm_do_a();
		break;

	/******** SNIP ********/

	case OPCODE_Z :
		stfsm_do_z();
		break;

	case default :
		return -EINVAL;
	}
}

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
