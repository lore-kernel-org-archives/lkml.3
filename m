Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaCTIZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:25:12 -0400
Received: from relmlor4.renesas.com ([210.160.252.174]:11704 "EHLO
	relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751129AbaCTIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:25:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,693,1389711600"; 
   d="scan'";a="155897429"
Message-ID: <532AA5D6.6000402@renesas.com>
Date: Thu, 20 Mar 2014 17:24:54 +0900
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uio: Fix memory size check with vma in uio_mmap_physical()
References: <1394587461-8574-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com> <20140317232645.GA11450@kroah.com>
In-Reply-To: <20140317232645.GA11450@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [211.11.155.148]
X-ClientProxiedBy: SINPR04CA008.apcprd04.prod.outlook.com (10.242.48.38) To
 HKNPR06MB084.apcprd06.prod.outlook.com (10.242.102.153)
X-Forefront-PRVS: 01565FED4C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6049001)(428001)(51704005)(199002)(189002)(479174003)(24454002)(54356001)(53806001)(42186004)(51856001)(46102001)(81342001)(76482001)(77096001)(94316002)(74706001)(81816001)(81686001)(94946001)(50466002)(87976001)(64126003)(81542001)(54316002)(95416001)(74662001)(77982001)(59766001)(74502001)(65806001)(80022001)(86362001)(97186001)(65956001)(19580405001)(83322001)(47776003)(20776003)(19580395003)(63696002)(80316001)(31966008)(66066001)(74876001)(93516002)(76796001)(97336001)(80976001)(59896001)(36756003)(79102001)(74366001)(83506001)(90146001)(56816005)(92566001)(92726001)(33656001)(83072002)(85852003)(23676002)(56776001)(85306002)(50986001)(47976001)(47736001)(4396001)(49866001)(69226001);DIR:OUT;SFP:1101;SCL:1;SRVR:HKNPR06MB084;H:[10.161.41.224];FPR:BEEED217.EFE2DC29.ACF4A947.82EAD2F1.2028D;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/18 8:26), Greg KH wrote:
> On Wed, Mar 12, 2014 at 10:24:21AM +0900, Nobuhiro Iwamatsu wrote:
>> Register for the device are mapped in uio_mmap_physical().
>> In this case, it might not be the same as the size of VMA always.
>
> Why wouldn't this be the case?

size contained in the "mem-> size" is the size of the actual always.
However, in this case, "if (vma-> vm_end - vma-> vm_start> mem-> size)" is an error by always.
This is because the address contained in the vma is because it is always aligned by PAGE_SIZE.

>
>> This uses PAGE_ALIGN to memory size, fix the check of the memory size
>> to be mapped.
>>
>> Signed-off-by: Nobuhiro Iwamatsu<nobuhiro.iwamatsu.yj@renesas.com>
>> ---
>>   drivers/uio/uio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>> index a673e5b..e371f5a 100644
>> --- a/drivers/uio/uio.c
>> +++ b/drivers/uio/uio.c
>> @@ -655,7 +655,7 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
>>
>>   	if (mem->addr&  ~PAGE_MASK)
>>   		return -ENODEV;
>> -	if (vma->vm_end - vma->vm_start>  mem->size)
>> +	if (vma->vm_end - vma->vm_start>  PAGE_ALIGN(mem->size))
>
> You just increased the size for the check, that seems wrong.  Why
> wouldn't mem->size be correct here?
>
> What hardware is failing for this with a valid size and end/start
> addresses?

For example, when I have the following settings in in platform device setup,
the size of the mem->size will be 344.

static struct resource vpu_resources[] = {
	[0] = {
		.name	= "VPU",
		.start	= 0xfe900000,
		.end	= 0xfe900157,
		.flags	= IORESOURCE_MEM,
	},
};

And vma->vm_start was set 0xB6F9F000, vma->start was set B6FA0000.
Therefore, this is "if (vma-> vm_end - vma-> vm_start> mem-> size)" will result in an error.
Am I wrong how to use UIO?

>
> thanks,
>
> greg k-h

Best regards,
   Nobuhiro
