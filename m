Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3GRMmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:42:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:59011 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab3GRMmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,692,1367996400"; 
   d="scan'208";a="367316900"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH v3] x86, tboot: iomem fixes
Thread-Topic: [PATCH v3] x86, tboot: iomem fixes
Thread-Index: AQHOg4+GjeUz8TeQAkemboXWVaGEjZlpub2AgACf0QA=
Date: Thu, 18 Jul 2013 12:42:00 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE013C8C77@SHSMSX102.ccr.corp.intel.com>
References: <1374134874-8161-1-git-send-email-qiaowei.ren@intel.com>
 <20130718104223.GD23558@gmail.com>
In-Reply-To: <20130718104223.GD23558@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-07-18, Ingo Molnar wrote:
> 
> * Qiaowei Ren <qiaowei.ren@intel.com> wrote:
> 
>> Current code doesn't use specific interface to access I/O space.
>> So some potential bugs can be caused. We can fix this by using
>> specific API.
> 
> This is still very vague.
> 
>> 
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> ---
>>  arch/x86/kernel/tboot.c |   21 ++++++++++++---------
>>  1 file changed, 12 insertions(+), 9 deletions(-)
>> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c index
>> 3ff42d2..afe8cf8 100644
>> --- a/arch/x86/kernel/tboot.c
>> +++ b/arch/x86/kernel/tboot.c
>> @@ -466,9 +466,12 @@ struct sinit_mle_data {
>>  	u32               vtd_dmars_off;
>>  } __packed;
>> +#define SINIT_MLE_DATA_VTD_DMAR_OFF	140
>> +
>>  struct acpi_table_header *tboot_get_dmar_table(struct
>> acpi_table_header *dmar_tbl)  {
>> -	void *heap_base, *heap_ptr, *config;
>> +	void __iomem *heap_base, *heap_ptr, *config;
>> +	u32 dmar_tbl_off;
>> 
>>  	if (!tboot_enabled())
>>  		return dmar_tbl;
>> @@ -485,25 +488,25 @@ struct acpi_table_header
> *tboot_get_dmar_table(struct acpi_table_header *dmar_tb
>>  		return NULL;
>>  
>>  	/* now map TXT heap */
>> -	heap_base = ioremap(*(u64 *)(config + TXTCR_HEAP_BASE),
>> -			    *(u64 *)(config + TXTCR_HEAP_SIZE));
>> +	heap_base = ioremap(readl(config + TXTCR_HEAP_BASE),
>> +			    readl(config + TXTCR_HEAP_SIZE));
>>  	iounmap(config);
>>  	if (!heap_base)
>>  		return NULL;
>>  
>>  	/* walk heap to SinitMleData */
>>  	/* skip BiosData */
>> -	heap_ptr = heap_base + *(u64 *)heap_base;
>> +	heap_ptr = heap_base + readq(heap_base);
>>  	/* skip OsMleData */
>> -	heap_ptr += *(u64 *)heap_ptr;
>> +	heap_ptr += readq(heap_ptr);
>>  	/* skip OsSinitData */
>> -	heap_ptr += *(u64 *)heap_ptr;
>> +	heap_ptr += readq(heap_ptr);
>>  	/* now points to SinitMleDataSize; set to SinitMleData */
>>  	heap_ptr += sizeof(u64);
>>  	/* get addr of DMAR table */
>> -	dmar_tbl = (struct acpi_table_header *)(heap_ptr +
>> -		   ((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
>> -		   sizeof(u64));
>> +	dmar_tbl_off = readl(heap_ptr + SINIT_MLE_DATA_VTD_DMAR_OFF);
>> +	memcpy_fromio(dmar_tbl, heap_ptr + dmar_tbl_off - sizeof(u64),
>> +			sizeof(struct acpi_table_header));
> 
> That memcpy (or an equivalent of it) was not in the code before, AFAICS.
> 
> How can this be an 'interface fix'? It adds in new code...
> 
Sorry, current code only need to get addr of DMAR table, so memcpy_fromio may be removed, even though this will also work.
So "memcpy_fromio" line will be changed to 
	dmar_tbl = (struct acpi_table_header *)(heap_ptr + dmar_tbl_off + - sizeof(u64));
If so, no new interface will be added, and the changelog at the beginning of this patch is engouch?

Thanks,
Qiaowei

