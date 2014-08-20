Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaHTSC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:02:58 -0400
Received: from us2.outbound.mailhostbox.com ([162.210.70.53]:58126 "EHLO
	us2.outbound.mailhostbox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbaHTSC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:02:56 -0400
Message-ID: <53F4E2BD.5080205@pek-sem.com>
Date: Wed, 20 Aug 2014 23:32:37 +0530
From: pekon <pekon@pek-sem.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: devicetree@vger.kernel.org, Boris BREZILLON <b.brezillon.dev@gmail.com>,
        kernel@stlinux.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org> <20140703002237.GM3599@ld-irv-0074> <20980858CB6D3A4BAE95CA194937D5E73EAFAFF1@DBDE04.ent.ti.com> <20140805142324.GA10136@lee--X1> <d4ba973a22bd71eaff94be1f479c5334@pek-sem.com> <20140819021248.GR18411@ld-irv-0074>
In-Reply-To: <20140819021248.GR18411@ld-irv-0074>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH-RefID: str=0001.0A020208.53F4E2CD.0252,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-CTCH-Score: 0.000
X-CTCH-Rules: 
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

On Tuesday 19 August 2014 07:42 AM, Brian Norris wrote:
> On Wed, Aug 06, 2014 at 02:32:18AM +0530, pekon@pek-sem.com wrote:
>> On Tuesday 05 August 2014 07:53 PM, Lee Jones wrote:
>>> On Thu, 03 Jul 2014, Gupta, Pekon wrote:
>>>>>> +	/* Load last page of block */
>>>>>> +	offs = (loff_t)block << chip->phys_erase_shift;
>>>>>> +	offs += mtd->erasesize - mtd->writesize;
>>>>>> +	if (bch_read_page(nandi, offs, buf) < 0) {
>>>>
>>>> *Important*: You shouldn't call internal functions directly here..
>>>> Instead use chip->_read() OR mtd-read() that will:
>
> I'm not sure exactly what you're saying in the above line (chip->_read()
> is not a function, and and mtd-read() is syntactically incorrect),
> but...
>
> You most certainly do *not* want to call mtd->_read() directly (or any
> of the callbacks prefixed with underscores). That is one of the main
> purposes of:
>
>      commit 3c3c10bba1e4ccb75b41442e45c1a072f6cded19
>      Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>      Date:   Mon Jan 30 14:58:32 2012 +0200
>
>          mtd: add leading underscore to all mtd functions
>
Makes sense. Thanks for pointing this.

[...]

>
>> I think somewhere in earlier comments, Brian also supported
>> to use high-level function like mtd_read(). Also, nand_bbt.c
>> itself uses 'mtd_read(), mtd_read_oob() and mtd_write_oob()
>> at many places. So I'll let Brain decide here.
>> But having low-level function will add redundant code for
>> re-checking and aligning the addresses boundaries to block
>> and page/sector sizes.
>
> Not all checks are redundant. It's redundant to have the direct
> descendant doing the same checks that the parent does, like:
>
>    mtd_read() (checks boundaries)
>    |_ mtd->_read() (e.g., nand_read())
>
> So nand_read() and nand_do_read_ops() don't need the checking.
>
> But for a BBT implementation, it can help to make sure that its
> page/block/etc. arithmetic fits the right bounds when it ends up
> deciding to scan a block.
>
> Now, it still may be easy to prove that the checks are
> redundant/unnecessary for correctly-written code, but if the layering
> makes sense, then it still may be a better choice to simply use the
> high-level, self-checking API than to try to dig deeper. For instance,
> I'm pretty sure UBI does some checks to make sure it's not reading off
> the end of an MTD, but it still calls mtd_read() because it's The Right
> Thing (TM).
>
> Brian
>
Agree.. re-using mtd_*() API for non-critical paths is justified.


with regards, pekon

------------------------
Powered by BigRock.com

