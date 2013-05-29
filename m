Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967033Ab3E2VNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:13:42 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39843 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758817Ab3E2VNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:13:34 -0400
Message-ID: <51A66F79.7070007@linux.vnet.ibm.com>
Date: Wed, 29 May 2013 16:13:29 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/pseries: Force 32 bit MSIs when tearing down
References: <20130527162027.GA18182@dhcp-26-207.brq.redhat.com> <1369691531.3557.36.camel@pasglop>
In-Reply-To: <1369691531.3557.36.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052921-7182-0000-0000-000006FF97D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 04:52 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2013-05-27 at 18:20 +0200, Alexander Gordeev wrote:
>> This fix just adds a missed call to a new PAPR function
>> which should have been done with commit e61133d ("powerpc/
>> pseries: Force 32 bit MSIs for devices that require it")
> 
> Arguably, PAPR should allow to disable MSIs using either interface,
> we shouldn't have to know whether the MSI was a forced-32-bit one to be
> able to disable it.
> 
> Brian, can you check with Colleen ?

That is correct, and is the exact path we went down when I tested the code
that is currently upstream. I don't think this patch should be needed.

Thanks,

Brian


> 
> Cheers,
> Ben.
> 
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> ---
>>  arch/powerpc/platforms/pseries/msi.c |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
>> index 40c7db3..2b80a68 100644
>> --- a/arch/powerpc/platforms/pseries/msi.c
>> +++ b/arch/powerpc/platforms/pseries/msi.c
>> @@ -90,6 +90,7 @@ static int rtas_change_msi(struct pci_dn *pdn, u32 func, u32 num_irqs)
>>  static void rtas_disable_msi(struct pci_dev *pdev)
>>  {
>>  	struct pci_dn *pdn;
>> +	int rc;
>>  
>>  	pdn = get_pdn(pdev);
>>  	if (!pdn)
>> @@ -98,7 +99,12 @@ static void rtas_disable_msi(struct pci_dev *pdev)
>>  	/*
>>  	 * disabling MSI with the explicit interface also disables MSI-X
>>  	 */
>> -	if (rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, 0) != 0) {
>> +	if (pdn->force_32bit_msi)
>> +		rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, 0);
>> +	else
>> +		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, 0);
>> +
>> +	if ((rc != 0) && !pdn->force_32bit_msi) {
>>  		/* 
>>  		 * may have failed because explicit interface is not
>>  		 * present
>> -- 
>> 1.7.7.6
>>
>>
> 
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


