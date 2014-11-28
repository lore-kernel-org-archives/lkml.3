Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaK1KIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:08:40 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:59044 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaK1KI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:08:27 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sASA6YUA027905, This message is accepted by code: ctloc85258
From: =?gb2312?B?vrTI8Q==?= <micky_ching@realsil.com.cn>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "chris@printf.net" <chris@printf.net>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?gb2312?B?zfXsvw==?= <wei_wang@realsil.com.cn>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/2] mfd: rtsx: add func to split u32 into register
Thread-Topic: [PATCH 1/2] mfd: rtsx: add func to split u32 into register
Thread-Index: AQHQCe14eJjs+qSYFEq1JMJqIBseQJx0EkkAgAE2P4A=
Date: Fri, 28 Nov 2014 09:54:07 +0000
Message-ID: <5478463F.9030101@realsil.com.cn>
References: <cover.1417056337.git.micky_ching@realsil.com.cn>
 <51dde5250305623c420e78fa555800ef8fef0a09.1417056337.git.micky_ching@realsil.com.cn>
 <20141127152342.GA4860@mwanda>
In-Reply-To: <20141127152342.GA4860@mwanda>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="gb2312"
Content-ID: <A3BD4FDE1930DE44B85B16E7A2BA8615@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sASA8xRX030236

Let's take an example,

cmd.arg = ((ocr & 0xFF8000) != 0) << 8 | test_pattern;

using "TP" name test_pattern for simplication ,
when we call: rtsx_pci_write_be32(pcr, SD_CMD1, cmd->arg);
we should make sure TP write to SD_CMD4.

If on "be" platform, then cpu_to_be32() do nothing,
and TP is write to SD_CMD1, in this case, it is wrong.

BR,
micky.
On 11/27/2014 11:23 PM, Dan Carpenter wrote:
> On Thu, Nov 27, 2014 at 10:53:58AM +0800, micky_ching@realsil.com.cn wrote:
>> +static inline void rtsx_pci_write_be32(struct rtsx_pcr *pcr, u16 reg, u32 val)
>> +{
>> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, val >> 24);
>> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, val >> 16);
>> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, val >> 8);
>> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val);
> This assumes the cpu is little endian.  First convert to big endian
> using cpu_to_be32() and then write it out.
>
> 	__be32 be_val = cpu_to_be32()
>
> 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, be_val);
> 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, be_val >> 8);
> 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, be_val >> 16);
> 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, be_val >> 24);
>
> (Written hurredly in my mail client.  May be wrong).
>
>> +}
>> +
>> +static inline void rtsx_pci_write_le32(struct rtsx_pcr *pcr, u16 reg, u32 val)
>> +{
>> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, val);
>> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, val >> 8);
>> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, val >> 16);
>> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val >> 24);
>> +}
> We don't have a user for rtsx_pci_write_le32() so don't add it.
>
> regards,
> dan carpenter
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
