Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaGDGwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:52:49 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45692 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGDGwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:52:47 -0400
Message-ID: <53B64F3C.6080502@linaro.org>
Date: Fri, 04 Jul 2014 08:52:44 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org
Subject: Re: [PATCH v4 2/3] acpi, apei, ghes: Make NMI error notification
 to be GHES architecture extension.
References: <1403610095-5354-1-git-send-email-tomasz.nowicki@linaro.org> <1403610095-5354-3-git-send-email-tomasz.nowicki@linaro.org> <20140702121645.GF1318@pd.tnic>
In-Reply-To: <20140702121645.GF1318@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.07.2014 14:16, Borislav Petkov wrote:
> On Tue, Jun 24, 2014 at 01:41:34PM +0200, Tomasz Nowicki wrote:
>> Currently APEI depends on x86 architecture. It is because of NMI hardware
>> error notification of GHES which is currently supported by x86 only.
>> However, many other APEI features can be still used perfectly by other
>> architectures.
>>
>> This commit adds two symbols:
>> 1. HAVE_ACPI_APEI for those archs which support APEI.
>> 2. HAVE_ACPI_APEI_NMI which is used for NMI code isolation in ghes.c
>>     file. NMI related data and functions are grouped so they can be wrapped
>>     inside one #ifdef section. Appropriate function stubs are provided for
>>     !NMI case.
>>
>> Note there is no functional changes for x86 due to hard selected
>> HAVE_ACPI_APEI and HAVE_ACPI_APEI_NMI symbols.
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   arch/x86/Kconfig          |    2 +
>>   drivers/acpi/apei/Kconfig |    8 ++-
>>   drivers/acpi/apei/ghes.c  |  149 +++++++++++++++++++++++++++++----------------
>>   include/linux/nmi.h       |    4 ++
>>   4 files changed, 110 insertions(+), 53 deletions(-)
>>
>
> ...
>
>> @@ -894,11 +892,71 @@ static unsigned long ghes_esource_prealloc_size(
>>   	return prealloc_size;
>>   }
>>
>> +static void ghes_estatus_pool_shrink(unsigned long len)
>> +{
>> +	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
>> +}
>> +
>> +static void ghes_nmi_add(struct ghes *ghes)
>> +{
>> +	unsigned long len;
>> +
>> +	len = ghes_esource_prealloc_size(ghes->generic);
>> +	ghes_estatus_pool_expand(len);
>> +	mutex_lock(&ghes_list_mutex);
>> +	if (list_empty(&ghes_nmi))
>> +		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes");
>> +	list_add_rcu(&ghes->list, &ghes_nmi);
>> +	mutex_unlock(&ghes_list_mutex);
>> +}
>> +
>> +static void ghes_nmi_remove(struct ghes *ghes)
>> +{
>> +	unsigned long len;
>> +
>> +	mutex_lock(&ghes_list_mutex);
>> +	list_del_rcu(&ghes->list);
>> +	if (list_empty(&ghes_nmi))
>> +		unregister_nmi_handler(NMI_LOCAL, "ghes");
>> +	mutex_unlock(&ghes_list_mutex);
>> +	/*
>> +	 * To synchronize with NMI handler, ghes can only be
>> +	 * freed after NMI handler finishes.
>> +	 */
>> +	synchronize_rcu();
>> +	len = ghes_esource_prealloc_size(ghes->generic);
>> +	ghes_estatus_pool_shrink(len);
>> +}
>> +
>> +static void ghes_nmi_init_cxt(void)
>> +{
>> +	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
>> +}
>> +#else
>
> Markers please to know to which CONFIG_ symbol this #else refers to:
>
> #else /* CONFIG_HAVE_ACPI_APEI_NMI */
>
>> +static inline void ghes_nmi_add(struct ghes *ghes)
>> +{
>> +	pr_err(GHES_PFX "ID: %d, trying to add NMI notification which is not supported!\n",
>> +	       ghes->generic->header.source_id);
>> +	BUG();
>> +}
>> +
>> +static inline void ghes_nmi_remove(struct ghes *ghes)
>> +{
>> +	pr_err(GHES_PFX "ID: %d, trying to remove NMI notification which is not supported!\n",
>> +	       ghes->generic->header.source_id);
>> +	BUG();
>> +}
>> +
>> +static inline void ghes_nmi_init_cxt(void)
>> +{
>> +}
>> +#endif
>
> Ditto.
>

Right, I will fix that and thanks for all you acks.

BTW, who else should I asked for review to move upstream process one 
step further?

Regards,
Tomasz
