Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3EJBCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:02:14 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47579 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3EJBCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:02:12 -0400
Message-ID: <518C46F0.6060507@huawei.com>
Date: Fri, 10 May 2013 09:01:36 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
CC: Libo Chen <libo.chen@huawei.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>
Subject: Re: [PATCH v2 1/2] i2c: i2c-bfin-twi: don`t free peripheral before
 it init successful
References: <1368088044-20408-1-git-send-email-libo.chen@huawei.com> <1368088044-20408-2-git-send-email-libo.chen@huawei.com> <B168F8A49F4BCF4C84FD23DA5F6363EEAD57@NWD2MBX7.ad.analog.com>
In-Reply-To: <B168F8A49F4BCF4C84FD23DA5F6363EEAD57@NWD2MBX7.ad.analog.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/9 16:33, Zhang, Sonic wrote:
> Hi Libo,
> 
>> -----Original Message-----
>> From: Libo Chen [mailto:libo.chen@huawei.com]
>> Sent: Thursday, May 09, 2013 4:27 PM
>> To: Zhang, Sonic; wsa@the-dreams.de
>> Cc: uclinux-dist-devel@blackfin.uclinux.org; linux-kernel@vger.kernel.org; linux-
>> i2c@vger.kernel.org; lizefan@huawei.com; Libo Chen
>> Subject: [PATCH v2 1/2] i2c: i2c-bfin-twi: don`t free peripheral before it init
>> successful
>>
>> down out_error_no_irq. When platform_get_irq fail, no need to free peripheral
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>> drivers/i2c/busses/i2c-bfin-twi.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
>> index 05080c4..6617645 100644
>> --- a/drivers/i2c/busses/i2c-bfin-twi.c
>> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
>> @@ -709,9 +709,9 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>> out_error_add_adapter:
>>       free_irq(iface->irq, iface);
>> out_error_req_irq:
>> -out_error_no_irq:
>>       peripheral_free_list((unsigned short *)pdev->dev.platform_data);
>> out_error_pin_mux:
>> +out_error_no_irq:
>>       iounmap(iface->regs_base);
>> out_error_ioremap:
>> out_error_get_res:
>> --
> 
> Sorry, but you didn't exchange as I suggested.
> Should be
> 

Hi Sonic,

Look at peripheral_request_list()
{
	u16 cnt;
	int ret;

	for (cnt = 0; per[cnt] != 0; cnt++) {

		ret = peripheral_request(per[cnt], label);

		if (ret < 0) {
			for ( ; cnt > 0; cnt--)
				peripheral_free(per[cnt - 1]);

			return ret;
		}
	}

	return 0;
}


When peripheral_request fail, it had called peripheral_free().
So there is no reason to call peripheral_free_list again.

Did I miss something else?


>> out_error_req_irq:
>> -out_error_no_irq:
>> +out_error_pin_mux:
>>       peripheral_free_list((unsigned short *)pdev->dev.platform_data);
>> -out_error_pin_mux:
>> +out_error_no_irq:
> 
> 
> Regards,
> 
> Sonic
> 
> 
> 


