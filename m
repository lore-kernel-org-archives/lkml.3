Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaE1N53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:57:29 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:49349 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaE1N51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:57:27 -0400
Message-ID: <5385EB42.1060604@linaro.org>
Date: Wed, 28 May 2014 14:57:22 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH v3 13/13] mmc: mmci: Add Qcom specific pio_read function.
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org> <1400849589-7626-1-git-send-email-srinivas.kandagatla@linaro.org> <537FD9A7.3010100@codeaurora.org>
In-Reply-To: <537FD9A7.3010100@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Stephen for late reply,
Some reason this mail was filtered in other folders.

On 24/05/14 00:28, Stephen Boyd wrote:
> On 05/23/14 05:53, srinivas.kandagatla@linaro.org wrote:
>> @@ -1022,6 +1025,40 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
>>   	}
>>   }
>>
>> +static int mmci_qcom_pio_read(struct mmci_host *host, char *buffer,
>> +			unsigned int remain)
>> +{
>> +	u32 *ptr = (u32 *) buffer;
>> +	unsigned int count = 0;
>> +	unsigned int words, bytes;
>> +	unsigned int fsize = host->variant->fifosize;
>> +
>> +	words = remain >> 2;
>> +	bytes = remain % 4;
>> +	/* read full words followed by leftover bytes */
>> +	if (words) {
>> +		while (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
>> +			*ptr = readl(host->base + MMCIFIFO + (count % fsize));
>
> This doesn't look endianness agnostic. Shouldn't we use ioread32_rep()
> to read this fifo?
Is'nt readl endianess aware?

we can not use ioread32_rep because as we can not reliably know how many 
words we should read? FIFOCNT would have helped but its not advised to 
be use as per the datasheet.



Thanks,
srini
>
>> +			ptr++;
>> +			count += 4;
>> +			words--;
>> +			if (!words)
>> +				break;
>> +		}
>> +	}
>> +
>> +	if (unlikely(bytes)) {
>> +		unsigned char buf[4];
>> +		if (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
>> +			*buf = readl(host->base + MMCIFIFO + (count % fsize));
>> +			memcpy(ptr, buf, bytes);
>> +			count += bytes;
>> +		}
>> +	}
>> +
>> +	return count;
>> +}
>> +
>>   static int mmci_pio_read(struct mmci_host *host, char *buffer, unsigned int remain)
>>   {
>>   	void __iomem *base = host->base;
>>
>
