Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbbA0D4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:56:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53809 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbbA0D4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:56:15 -0500
Message-ID: <54C70C59.4090407@codeaurora.org>
Date: Tue, 27 Jan 2015 09:26:09 +0530
From: Archit Taneja <architt@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: Daniel Ehrenberg <dehrenberg@google.com>, linux-arm-msm@vger.kernel.org,
        agross@codeaurora.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        galak@codeaurora.org
Subject: Re: [PATCH 2/5] mtd: nand: Add qcom nand controller driver
References: <1421419702-17812-1-git-send-email-architt@codeaurora.org> <1421419702-17812-3-git-send-email-architt@codeaurora.org> <CAAK6Zt0xAY=kD68y1vQP1-AoEHdmyjuzsMTCSQyykPnuwbZLJA@mail.gmail.com> <54C09A65.9090809@codeaurora.org> <CAJiQ=7B+2xp_XPA6_nieG30+dQUSxQeLGN=xBX0e3zQqgiPqNA@mail.gmail.com>
In-Reply-To: <CAJiQ=7B+2xp_XPA6_nieG30+dQUSxQeLGN=xBX0e3zQqgiPqNA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/27/2015 02:35 AM, Kevin Cernekee wrote:
> On Wed, Jan 21, 2015 at 10:36 PM, Archit Taneja <architt@codeaurora.org> wrote:
>> On 01/21/2015 06:24 AM, Daniel Ehrenberg wrote:
>>> On Fri, Jan 16, 2015 at 6:48 AM, Archit Taneja <architt@codeaurora.org>
>>> wrote:
>>>>
>>>> +/*
>>>> + * the bad block marker is readable only when we read the page with ECC
>>>> + * disabled. all the read/write commands like NAND_CMD_READOOB,
>>>> NAND_CMD_READ0
>>>> + * and NAND_CMD_PAGEPROG are executed in the driver with ECC enabled.
>>>> therefore,
>>>> + * the default nand helper functions to detect a bad block or mark a bad
>>>> block
>>>> + * can't be used.
>>>> + */
>>>> +static int qcom_nandc_block_bad(struct mtd_info *mtd, loff_t ofs, int
>>>> getchip)
>>>> +{
>>>> +       int page, r, mark, bad = 0;
>>>> +       struct nand_chip *chip = mtd->priv;
>>>> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
>>>> +       int cwperpage = ecc->steps;
>>>> +       struct qcom_nandc_data *this = chip->priv;
>>>> +       u32 flash_status;
>>>> +
>>>> +       pre_command(this, NAND_CMD_NONE);
>>>> +
>>>> +       page = (int)(ofs >> chip->page_shift) & chip->pagemask;
>>>> +
>>>> +       /*
>>>> +        * configure registers for a raw page read, the address is set to
>>>> the
>>>> +        * beginning of the last codeword
>>>> +        */
>>>> +       this->use_ecc = false;
>>>> +       set_address(this, this->cw_size * (cwperpage - 1), page);
>>>> +
>>>> +       /* we just read one codeword that contains the bad block marker
>>>> */
>>>> +       update_rw_regs(this, 1, true);
>>>> +
>>>> +       read_cw(this, this->cw_size, 0);
>>>> +
>>>> +       r = submit_descs(this);
>>>> +       if (r) {
>>>> +               dev_err(this->dev, "error submitting descs\n");
>>>> +               goto err;
>>>> +       }
>>>> +
>>>> +       flash_status = this->reg_read_buf[0];
>>>> +
>>>> +       /*
>>>> +        * unable to read the marker successfully, is that sufficient to
>>>> report
>>>> +        * the block as bad?
>>>> +        */
>>>> +       if (flash_status & (FS_OP_ERR | FS_MPU_ERR)) {
>>>> +               dev_warn(this->dev, "error while reading bad block
>>>> mark\n");
>>>> +               goto err;
>>>> +       }
>>>> +
>>>> +       mark = mtd->writesize - (this->cw_size * (cwperpage - 1));
>>>> +
>>>> +       if (chip->options & NAND_BUSWIDTH_16)
>>>> +               bad = this->data_buffer[mark] != 0xff ||
>>>> +                       this->data_buffer[mark + 1] != 0xff;
>>>> +
>>>> +       bad = this->data_buffer[mark] != 0xff;
>>>> +err:
>>>> +       free_descs(this);
>>>> +
>>>> +       return bad;
>>>> +}
>>>> +
>>>> +static int qcom_nandc_block_markbad(struct mtd_info *mtd, loff_t ofs)
>>>> +{
>>>> +       int page, r;
>>>> +       struct nand_chip *chip = mtd->priv;
>>>> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
>>>> +       int cwperpage = ecc->steps;
>>>> +       struct qcom_nandc_data *this = chip->priv;
>>>> +       u32 flash_status;
>>>> +
>>>> +       pre_command(this, NAND_CMD_NONE);
>>>> +
>>>> +       /* fill our internal buffer's oob area with 0's */
>>>> +       memset(this->data_buffer, 0x00, mtd->writesize + mtd->oobsize);
>>>> +
>>>> +       page = (int)(ofs >> chip->page_shift) & chip->pagemask;
>>>> +
>>>> +       this->use_ecc = false;
>>>> +       set_address(this, this->cw_size * (cwperpage - 1), page);
>>>> +
>>>> +       /* we just write to one codeword that contains the bad block
>>>> marker*/
>>>> +       update_rw_regs(this, 1, false);
>>>> +
>>>> +       /*
>>>> +        * overwrite the last codeword with 0s, this will result in
>>>> setting
>>>> +        * the bad block marker to 0 too
>>>> +        */
>>>> +       write_cw(this, this->cw_size, 0);
>>>> +
>>>> +       r = submit_descs(this);
>>>> +       if (r) {
>>>> +               dev_err(this->dev, "error submitting descs\n");
>>>> +               r = -EIO;
>>>> +               goto err;
>>>> +       }
>>>> +
>>>> +       flash_status = this->reg_read_buf[0];
>>>> +
>>>> +       if (flash_status & (FS_OP_ERR | FS_MPU_ERR))
>>>> +               r = -EIO;
>>>> +
>>>> +err:
>>>> +       free_descs(this);
>>>> +
>>>> +       return r;
>>>> +}
>
> Would it be possible to refactor this code so that it implements
> generic read_oob_raw() and write_oob_raw() callbacks, which can
> read/write arbitrary uncorrected OOB bytes instead of just the BBI?
> Or is the controller limited in which OOB bytes can be directly
> accessed?

When accessing the page with ECC disabled, there doesn't seem to be any 
limitation.

We have 528/32 bytes per codeword, and we can access all of it in raw mode.

>
> One advantage of implementing the generic raw read/write callbacks is
> that the MTD subsystem already has logic to handle old NAND chips with
> different BBI positions, bitflips in the BBI, and other corner cases.
>
>>> Looks like this code marks block bad and reads bad block information
>>> based on information in the OOB area. And in qcom_nandc_init,
>>> NAND_SKIP_BBTSCAN is set, meaning that this is the code used in
>>> practice on the chip in the mtd_block_isbad path. Can this driver be
>>> used with an on-flash OOB table by editing the init function's chip
>>> flags, or would it need more significant changes to allow that?
>>
>>
>> The code doesn't exactly read the OOB area. When the ECC HW block is
>> enabled, the bad block isn't in either oob or data area! We can access it
>> only when ECC is disabled. With ECC disabled, the bad block marker lies in
>> the last codeword somewhere in the middle of the user data. For the
>> mtd_read_oob()/write_oob() functions, we have the ECC always enabled, hence,
>> we never access the bad block marker through them at all.
>>
>> Creating an on-flash bad block table won't work right now. The reason is
>> that the nand_bbt library assumes that it can find the bad block marker by
>> reading oob. While creating a bbt in memory, it scans the device for bad
>> blocks using the function scan_block_fast(). This would currently result in
>> not reading the bad block marker, and therefore break things.
>>
>> I'm trying to find out if there is a way by which the controller can access
>> the bad block marker with ECC HW enabled. If that works, we can use the
>> nand_bbt helper as is. For now, I wanted to get the driver upstream without
>> the BBT functionality.
>
> So, back in commit a7e68834fc2739 ("mtd: nand: use ECC, if present,
> when scanning OOB"), the BBT code was changed to use MTD_OPS_PLACE_OOB
> instead of MTD_OPS_RAW, because some controllers offer the ability to
> provide corrected OOB data and we wanted to use it if possible.  The
> changelog notes that many existing drivers still disabled ECC when
> reading OOB in MTD_OPS_PLACE_OOB mode.
>
> Now it sounds like the qcom_nandc controller can either provide access
> to some corrected OOB bytes (not including the BBI) when
> MTD_OPS_PLACE_OOB is used, or all (?) uncorrected OOB bytes (including
> the BBI) when MTD_OPS_RAW is used.

That's right.

>
> Two possible options are:
>
> 1) qcom_nandc should just disable ECC when performing OOB reads/writes
> in MTD_OPS_PLACE_OOB mode

What prevented me from doing this was how the 
chip->ecc.read_page/write_page funcs are defined. They take
the param called oob_required.

If oob_required is set, we would need to read/write page contents with 
ECC disabled too. Or, perform 2 rounds of acceses. One for the page 
contents with ECC enabled, and other for oob with ECC disabled.

I don't know how often oob_required is set by the mtd subsystem, if it's 
a path that is never exercised, we could try this option.

>
> 2) MTD should be made aware of whether the controller can access the
> BBI in MTD_OPS_PLACE_OOB mode, and fall back to MTD_OPS_RAW mode if
> the hardware cannot do so

That sounds like a good option. A NAND chip option mentioning this 
capability could be helpful here.

Thanks,
Archit

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
