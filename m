Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaKGKTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:19:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:11832 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaKGKTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:19:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,331,1413270000"; 
   d="scan'208";a="604038531"
Message-ID: <545C9C59.8000802@intel.com>
Date: Fri, 07 Nov 2014 12:18:01 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Chanho Min <chanho.min@lge.com>,
        =?EUC-KR?B?J8Cvx9Gw5ic=?= <hankyung.yu@lge.com>
CC: "'Chris Ball'" <chris@printf.net>,
        "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        "'Seungwon Jeon'" <tgih.jun@samsung.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'HyoJun Im'" <hyojun.im@lge.com>,
        gunho.lee@lge.com
Subject: Re: [PATCH] mmc:core: fix hs400 timing selection
References: <1413946555-1266-1-git-send-email-chanho.min@lge.com> <544F98DD.6040605@intel.com> <00b501cff307$1de03fb0$59a0bf10$@lge.com> <5450B485.5050705@intel.com> <00cb01cff5a4$c746a090$55d3e1b0$@min@lge.com>
In-Reply-To: <00cb01cff5a4$c746a090$55d3e1b0$@min@lge.com>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/14 09:23, Chanho Min wrote:
>>> So change the operating mode and to lower the clock.
>>
>> I meant something different.
>>
>> With your patch I find that __mmc_switch() -> send_status() fails.
>>
>> So I suggest something like this:
>>
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>> index 92247c2..195d48a 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -1045,21 +1045,28 @@ static int mmc_select_hs400(struct mmc_card *card)
>>  	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS,
>>  			   card->ext_csd.generic_cmd6_time,
>> -			   true, true, true);
>> +			   true, false, false);
>> +	if (!err) {
>> +		u32 status;
>> +
>> +		/*
>> +		 * According to JEDEC v5.01 spec (6.6.5), Clock frequency should
>> +		 * be set to a value not greater than 52MHz after the HS_TIMING
>> +		 * field is set to 0x1.
>> +		*/
>> +		mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
>> +		mmc_set_bus_speed(card);
>> +
>> +		err = __mmc_send_status(card, &status, false, 1);
> 
> Why was retry-count changed to 1?
> Is there any reason not to use this?
> +               err = mmc_send_status(card, &status);

Error bits are cleared when read, so if the status command is not
successful then error information may have been lost.  So it does
not make sense to retry.

> 
> 
>> +		if (!err)
>> +			err = mmc_check_switch_status(card->host, status);
>> +	}
>>  	if (err) {
>>  		pr_err("%s: switch to high-speed from hs200 failed, err:%d\n",
>>  			mmc_hostname(host), err);
>>  		return err;
>>  	}
>>
>> -	/*
>> -	 * According to JEDEC v5.01 spec (6.6.5), Clock frequency should
>> -	 * be set to a value not greater than 52MHz after the HS_TIMING
>> -	 * field is set to 0x1.
>> -	 */
>> -	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
>> -	mmc_set_bus_speed(card);
>> -
>>  	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  			 EXT_CSD_BUS_WIDTH,
>>  			 EXT_CSD_DDR_BUS_WIDTH_8,
>> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
>> index 23aa3a3..f917527 100644
>> --- a/drivers/mmc/core/mmc_ops.c
>> +++ b/drivers/mmc/core/mmc_ops.c
>> @@ -23,15 +23,12 @@
>>
>>  #define MMC_OPS_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
>>
>> -static inline int __mmc_send_status(struct mmc_card *card, u32 *status,
>> -				    bool ignore_crc)
>> +int __mmc_send_status(struct mmc_card *card, u32 *status, bool ignore_crc,
>> +		      int retries)
>>  {
>>  	int err;
>>  	struct mmc_command cmd = {0};
>>
>> -	BUG_ON(!card);
>> -	BUG_ON(!card->host);
>> -
>>  	cmd.opcode = MMC_SEND_STATUS;
>>  	if (!mmc_host_is_spi(card->host))
>>  		cmd.arg = card->rca << 16;
>> @@ -39,7 +36,7 @@ static inline int __mmc_send_status(struct mmc_card *card, u32 *status,
>>  	if (ignore_crc)
>>  		cmd.flags &= ~MMC_RSP_CRC;
>>
>> -	err = mmc_wait_for_cmd(card->host, &cmd, MMC_CMD_RETRIES);
>> +	err = mmc_wait_for_cmd(card->host, &cmd, retries);
>>  	if (err)
>>  		return err;
>>
>> @@ -54,7 +51,7 @@ static inline int __mmc_send_status(struct mmc_card *card, u32 *status,
>>
>>  int mmc_send_status(struct mmc_card *card, u32 *status)
>>  {
>> -	return __mmc_send_status(card, status, false);
>> +	return __mmc_send_status(card, status, false, MMC_CMD_RETRIES);
>>  }
>>
>>  static int _mmc_select_card(struct mmc_host *host, struct mmc_card *card)
>> @@ -419,6 +416,21 @@ int mmc_spi_set_crc(struct mmc_host *host, int use_crc)
>>  	return err;
>>  }
>>
>> +int mmc_check_switch_status(struct mmc_host *host, u32 status)
>> +{
>> +	if (mmc_host_is_spi(host)) {
>> +		if (status & R1_SPI_ILLEGAL_COMMAND)
>> +			return -EBADMSG;
>> +	} else {
>> +		if (status & 0xFDFFA000)
>> +			pr_warn("%s: unexpected status %#x after switch\n",
>> +				mmc_hostname(host), status);
>> +		if (status & R1_SWITCH_ERROR)
>> +			return -EBADMSG;
>> +	}
>> +	return 0;
>> +}
>> +
>>  /**
>>   *	__mmc_switch - modify EXT_CSD register
>>   *	@card: the MMC card associated with the data transfer
>> @@ -497,7 +509,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>>  	timeout = jiffies + msecs_to_jiffies(timeout_ms);
>>  	do {
>>  		if (send_status) {
>> -			err = __mmc_send_status(card, &status, ignore_crc);
>> +			err = __mmc_send_status(card, &status, ignore_crc, 1);
>>  			if (err)
>>  				return err;
>>  		}
>> @@ -524,18 +536,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>>  		}
>>  	} while (R1_CURRENT_STATE(status) == R1_STATE_PRG);
>>
>> -	if (mmc_host_is_spi(host)) {
>> -		if (status & R1_SPI_ILLEGAL_COMMAND)
>> -			return -EBADMSG;
>> -	} else {
>> -		if (status & 0xFDFFA000)
>> -			pr_warn("%s: unexpected status %#x after switch\n",
>> -				mmc_hostname(host), status);
>> -		if (status & R1_SWITCH_ERROR)
>> -			return -EBADMSG;
>> -	}
>> -
>> -	return 0;
>> +	return mmc_check_switch_status(host, status);
>>  }
>>  EXPORT_SYMBOL_GPL(__mmc_switch);
>>
>> diff --git a/drivers/mmc/core/mmc_ops.h b/drivers/mmc/core/mmc_ops.h
>> index 6f4b00e..a59319c 100644
>> --- a/drivers/mmc/core/mmc_ops.h
>> +++ b/drivers/mmc/core/mmc_ops.h
>> @@ -20,7 +20,10 @@ int mmc_send_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
>>  int mmc_all_send_cid(struct mmc_host *host, u32 *cid);
>>  int mmc_set_relative_addr(struct mmc_card *card);
>>  int mmc_send_csd(struct mmc_card *card, u32 *csd);
>> +int __mmc_send_status(struct mmc_card *card, u32 *status, bool ignore_crc,
>> +		      int retries);
>>  int mmc_send_status(struct mmc_card *card, u32 *status);
>> +int mmc_check_switch_status(struct mmc_host *host, u32 status);
>>  int mmc_send_cid(struct mmc_host *host, u32 *cid);
>>  int mmc_spi_read_ocr(struct mmc_host *host, int highcap, u32 *ocrp);
>>  int mmc_spi_set_crc(struct mmc_host *host, int use_crc);
> 
> Thanks
> Chanho
> 
> 
> 

