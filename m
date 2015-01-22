Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbbAVGgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:36:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59894 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbAVGg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:36:27 -0500
Message-ID: <54C09A65.9090809@codeaurora.org>
Date: Thu, 22 Jan 2015 12:06:21 +0530
From: Archit Taneja <architt@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Daniel Ehrenberg <dehrenberg@google.com>
CC: linux-arm-msm@vger.kernel.org, galak@codeaurora.org,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-kernel@vger.kernel.org, agross@codeaurora.org
Subject: Re: [PATCH 2/5] mtd: nand: Add qcom nand controller driver
References: <1421419702-17812-1-git-send-email-architt@codeaurora.org> <1421419702-17812-3-git-send-email-architt@codeaurora.org> <CAAK6Zt0xAY=kD68y1vQP1-AoEHdmyjuzsMTCSQyykPnuwbZLJA@mail.gmail.com>
In-Reply-To: <CAAK6Zt0xAY=kD68y1vQP1-AoEHdmyjuzsMTCSQyykPnuwbZLJA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/21/2015 06:24 AM, Daniel Ehrenberg wrote:
> On Fri, Jan 16, 2015 at 6:48 AM, Archit Taneja <architt@codeaurora.org> wrote:
>> +/*
>> + * the bad block marker is readable only when we read the page with ECC
>> + * disabled. all the read/write commands like NAND_CMD_READOOB, NAND_CMD_READ0
>> + * and NAND_CMD_PAGEPROG are executed in the driver with ECC enabled. therefore,
>> + * the default nand helper functions to detect a bad block or mark a bad block
>> + * can't be used.
>> + */
>> +static int qcom_nandc_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
>> +{
>> +       int page, r, mark, bad = 0;
>> +       struct nand_chip *chip = mtd->priv;
>> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
>> +       int cwperpage = ecc->steps;
>> +       struct qcom_nandc_data *this = chip->priv;
>> +       u32 flash_status;
>> +
>> +       pre_command(this, NAND_CMD_NONE);
>> +
>> +       page = (int)(ofs >> chip->page_shift) & chip->pagemask;
>> +
>> +       /*
>> +        * configure registers for a raw page read, the address is set to the
>> +        * beginning of the last codeword
>> +        */
>> +       this->use_ecc = false;
>> +       set_address(this, this->cw_size * (cwperpage - 1), page);
>> +
>> +       /* we just read one codeword that contains the bad block marker */
>> +       update_rw_regs(this, 1, true);
>> +
>> +       read_cw(this, this->cw_size, 0);
>> +
>> +       r = submit_descs(this);
>> +       if (r) {
>> +               dev_err(this->dev, "error submitting descs\n");
>> +               goto err;
>> +       }
>> +
>> +       flash_status = this->reg_read_buf[0];
>> +
>> +       /*
>> +        * unable to read the marker successfully, is that sufficient to report
>> +        * the block as bad?
>> +        */
>> +       if (flash_status & (FS_OP_ERR | FS_MPU_ERR)) {
>> +               dev_warn(this->dev, "error while reading bad block mark\n");
>> +               goto err;
>> +       }
>> +
>> +       mark = mtd->writesize - (this->cw_size * (cwperpage - 1));
>> +
>> +       if (chip->options & NAND_BUSWIDTH_16)
>> +               bad = this->data_buffer[mark] != 0xff ||
>> +                       this->data_buffer[mark + 1] != 0xff;
>> +
>> +       bad = this->data_buffer[mark] != 0xff;
>> +err:
>> +       free_descs(this);
>> +
>> +       return bad;
>> +}
>> +
>> +static int qcom_nandc_block_markbad(struct mtd_info *mtd, loff_t ofs)
>> +{
>> +       int page, r;
>> +       struct nand_chip *chip = mtd->priv;
>> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
>> +       int cwperpage = ecc->steps;
>> +       struct qcom_nandc_data *this = chip->priv;
>> +       u32 flash_status;
>> +
>> +       pre_command(this, NAND_CMD_NONE);
>> +
>> +       /* fill our internal buffer's oob area with 0's */
>> +       memset(this->data_buffer, 0x00, mtd->writesize + mtd->oobsize);
>> +
>> +       page = (int)(ofs >> chip->page_shift) & chip->pagemask;
>> +
>> +       this->use_ecc = false;
>> +       set_address(this, this->cw_size * (cwperpage - 1), page);
>> +
>> +       /* we just write to one codeword that contains the bad block marker*/
>> +       update_rw_regs(this, 1, false);
>> +
>> +       /*
>> +        * overwrite the last codeword with 0s, this will result in setting
>> +        * the bad block marker to 0 too
>> +        */
>> +       write_cw(this, this->cw_size, 0);
>> +
>> +       r = submit_descs(this);
>> +       if (r) {
>> +               dev_err(this->dev, "error submitting descs\n");
>> +               r = -EIO;
>> +               goto err;
>> +       }
>> +
>> +       flash_status = this->reg_read_buf[0];
>> +
>> +       if (flash_status & (FS_OP_ERR | FS_MPU_ERR))
>> +               r = -EIO;
>> +
>> +err:
>> +       free_descs(this);
>> +
>> +       return r;
>> +}
>
> Looks like this code marks block bad and reads bad block information
> based on information in the OOB area. And in qcom_nandc_init,
> NAND_SKIP_BBTSCAN is set, meaning that this is the code used in
> practice on the chip in the mtd_block_isbad path. Can this driver be
> used with an on-flash OOB table by editing the init function's chip
> flags, or would it need more significant changes to allow that?

The code doesn't exactly read the OOB area. When the ECC HW block is 
enabled, the bad block isn't in either oob or data area! We can access 
it only when ECC is disabled. With ECC disabled, the bad block marker 
lies in the last codeword somewhere in the middle of the user data. For 
the mtd_read_oob()/write_oob() functions, we have the ECC always 
enabled, hence, we never access the bad block marker through them at all.

Creating an on-flash bad block table won't work right now. The reason is 
that the nand_bbt library assumes that it can find the bad block marker 
by reading oob. While creating a bbt in memory, it scans the device for 
bad blocks using the function scan_block_fast(). This would currently 
result in not reading the bad block marker, and therefore break things.

I'm trying to find out if there is a way by which the controller can 
access the bad block marker with ECC HW enabled. If that works, we can 
use the nand_bbt helper as is. For now, I wanted to get the driver 
upstream without the BBT functionality.

Archit
