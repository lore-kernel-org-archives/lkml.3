Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaHEVN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:13:26 -0400
Received: from us2.outbound.mailhostbox.com ([162.210.70.54]:35133 "EHLO
	us2.outbound.mailhostbox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611AbaHEVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:13:24 -0400
X-Greylist: delayed 660 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2014 17:13:24 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Aug 2014 02:32:18 +0530
From: pekon@pek-sem.com
To: Lee Jones <lee.jones@linaro.org>
Cc: <devicetree@vger.kernel.org>, Boris BREZILLON <b.brezillon.dev@gmail.com>,
        <kernel@stlinux.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mtd: nand: =?UTF-8?Q?stm=5Fnand=5Fbch=3A=20add=20new?=
 =?UTF-8?Q?=20driver?=
In-Reply-To: <20140805142324.GA10136@lee--X1>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20980858CB6D3A4BAE95CA194937D5E73EAFAFF1@DBDE04.ent.ti.com>
 <20140805142324.GA10136@lee--X1>
Message-ID: <d4ba973a22bd71eaff94be1f479c5334@pek-sem.com>
User-Agent: Webmail Services/0.4
X-CTCH-RefID: wb
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-CTCH-Score: 0.000
X-CTCH-Rules: WHITE_FROM_RCVD
X-CTCH-Flags: 0
X-CTCH-ScoreCust: 0.000
X-CTCH-SenderID: pekon@pek-sem.com
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalRecipients: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-BlueWhiteFlag: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday 05 August 2014 07:53 PM, Lee Jones wrote:
> On Thu, 03 Jul 2014, Gupta, Pekon wrote:
>>> From: Brian Norris [mailto:computersforpeace@gmail.com]
>>> On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:
[...]
>>>> +static void bch_wait_seq(struct nandi_controller *nandi)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	ret = wait_for_completion_timeout(&nandi->seq_completed, HZ/2);
>>
>> Are you sure you want to use same timeout value for all operations
>> like ERASE, READ, WRITE ? because
>> (1) There is wide variance between:
>> - BLOCK_ERASE:  max(tBER) = 10ms) for MT29F4G08 Micron NAND
>> - PAGE_ERASE: max(tPROG) = 600usec for same Micron part.
>>
>> (2) The value of HZ varies across kernel versions and hardware 
>> platforms.
>>
>> I suggest you pass the timeout value in call to bch_wait_seq().
>> And this timeout value should be like 2x of typical value of which 
>> you found
>> during ONFI parsing, or from DT
>
> How do you obtain these timings?  I don't see tBER or tPROG being 
> used
> anywhere in MTD.
>

These are not from NAND framework, these are terms used in data-sheet.
However, you can read all signal timing from ONFI page while probing.
But, as Brian suggested that timeout is a erroneous and rare condition
anyway, so these relaxed timeout values are acceptable. So you may
ignore my previous comment.


> [...]
>
>>>> +{
>>>> +	uint8_t *b = data;
>>>> +	int zeros = 0;
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < page_size; i++) {
>>>> +		zeros += hweight8(~*b++);
>> Are you sure you want to use hweight8 ?
>> hweight32 or something should give better performance, plz check.
>> because this piece of code (check_xx_bitflips) sometimes becomes
>> bottle neck for READ path.
>
> I'm not sure, no.  If I change it, how will I know if it's still 
> doing
> the correct thing or otherwise?
>
hweight/hweight16/hweight32 are all macros of same family
just operating on different data-widths, so you may continue
for now. But once the driver is merged, you might like to
re-analyze performance gain (especially on MLC NAND) when
using hweight32() instead of hweight8().


> [...]
>
>>>> +	/* Load last page of block */
>>>> +	offs = (loff_t)block << chip->phys_erase_shift;
>>>> +	offs += mtd->erasesize - mtd->writesize;
>>>> +	if (bch_read_page(nandi, offs, buf) < 0) {
>>
>> *Important*: You shouldn't call internal functions directly here..
>> Instead use chip->_read() OR mtd-read() that will:
>> - keep this code independent of ECC modes added in your driver in 
>> future.
>> - implicitly handle updating mtd->ecc_stat (like ecc_failed, 
>> bits_corrected).
>> - implicitly take care of address alignments checks and offset 
>> calculations.
>>
>> <Same applies to other places where you have directly used 
>> bch_read_page())
>
> Yourself and Brian seem to disagree on this point.  Which is correct?
>
>>>> +	/* Is block already considered bad? (will also catch invalid 
>>>> offsets) */
>>>> +	ret = mtd_block_isbad(mtd, offs);
>>>
>>> You're violating some of the layering here; the low-level driver
>>> probably shouldn't be calling the high-level mtd_*() APIs. On a 
>>> similar
>>> note, I'm not 100% confident that the nand_base/nand_bbt separation 
>>> is
>>> written cleanly enough for easy maintenance of your nand_base + ST 
>>> BBT
>>> code in parallel. I might need a second look at that, and I think
>>> modularizing your BBT code to a separate file could help ease this 
>>> a
>>> little.
>
> ... here is the converse argument.
>
I think somewhere in earlier comments, Brian also supported
to use high-level function like mtd_read(). Also, nand_bbt.c
itself uses 'mtd_read(), mtd_read_oob() and mtd_write_oob()
at many places. So I'll let Brain decide here.
But having low-level function will add redundant code for
re-checking and aligning the addresses boundaries to block
and page/sector sizes.

Brian ??


with regards, pekon


------------------------
Powered by BigRock.com

