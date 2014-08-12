Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaHLHUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:20:44 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42627 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHLHUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:20:43 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7C7KEwc032260, This message is accepted by code: ctloc85258
Message-ID: <53E9BFF0.5030506@realtek.com>
Date: Tue, 12 Aug 2014 15:19:12 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <driverdev-devel@linuxdriverproject.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mmc: rtsx: fix incorrect last byte in R2 response
References: <1407745936-18513-1-git-send-email-rogerable@realtek.com> <20140811130254.GP4856@mwanda>
In-Reply-To: <20140811130254.GP4856@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/11/2014 09:02 PM, Dan Carpenter wrote:
> On Mon, Aug 11, 2014 at 04:32:16PM +0800, rogerable@realtek.com wrote:
>> From: Roger Tseng <rogerable@realtek.com>
>>
>> Current code erroneously fill the last byte of R2 response with an undefined
>> value. In addition, it is impossible to obtain the real values since the
>> controller actually 'offloads' the last byte(CRC7, end bit) while receiving R2
>> response. This could cause mmc stack to obtain inconsistent CID from the same
>> card after resume and misidentify it as a different card.
>>
>> Fix by assigning a dummy value 0x01 to the last byte of R2 response.
>>
>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>> ---
>>   drivers/mmc/host/rtsx_pci_sdmmc.c |    1 +
>>   drivers/mmc/host/rtsx_usb_sdmmc.c |    1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
>> index dfde4a2..54849d8 100644
>> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
>> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
>> @@ -412,6 +412,7 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
>>   	}
>>
>>   	if (rsp_type == SD_RSP_TYPE_R2) {
>> +		ptr[16] = 1;
>
> Avoid magic numbers like 16 and 0x1.
>
> This is subtle enough that it deserves a comment.
>
> 		ptr[stat_idx] = 0x1 /* 0x1 chosen randomly */
>
The 0x1 consists of 7-bit dummy zero CRC and stop bit 1, described in SD 
card. Anyway, I'll give a comment to this in the next version.
>>   		for (i = 0; i < 4; i++) {
>>   			cmd->resp[i] = get_unaligned_be32(ptr + 1 + i * 4);
>>   			dev_dbg(sdmmc_dev(host), "cmd->resp[%d] = 0x%08x\n",
>
> There are a lot of magic numbers in this function.  We could get rid
> of this i < 4 loop but doing:
>
> 		memcpy(cmd->resp, ptr + 1, resp_len);
>
> Currently we don't use resp_len and the resp_len = 5 assignment is off
> by one...  It should be resp_len = 4.  This function is quite ugly.

I can remove the unused rsp_len in this function. But I'm afraid the 
loop is still required. The destination cmd->resp is cpu-endian, but the 
raw response from SD card in the buffer (pointed by ptr) is big-endian.

> regards,
> dan carpenter
>
>
> ------Please consider the environment before printing this e-mail.
> .
>

Best regards,
Roger Tseng
