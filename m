Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaAQQkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:40:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40063 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaAQQkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:40:14 -0500
Message-ID: <52D95CEA.809@profitbricks.com>
Date: Fri, 17 Jan 2014 17:40:10 +0100
From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: Why is (2 < 2) true? Is it a gcc bug?
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com> <D9FFE20C522965449E182ACE73889AEB1A6A352E@IRSMSX105.ger.corp.intel.com>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A6A352E@IRSMSX105.ger.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.01.2014 14:55, Dorau, Lukasz wrote:
> On Friday, January 17, 2014 2:37 PM Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
>>
>> Hi
>>
>> My story is very simply...
>> I applied the following patch:
>>
>> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
>> --- a/drivers/scsi/isci/init.c
>> +++ b/drivers/scsi/isci/init.c
>> @@ -698,8 +698,11 @@ static int isci_pci_probe(struct pci_dev *pdev, const struct
>> pci_device_id *id)
>>  	if (err)
>>  		goto err_host_alloc;
>>
>> -	for_each_isci_host(i, isci_host, pdev)
>> +	for_each_isci_host(i, isci_host, pdev) {
>> +		pr_err("(%d < %d) == %d\n",\
>> +		       i, SCI_MAX_CONTROLLERS, (i < SCI_MAX_CONTROLLERS));
>>  		scsi_scan_host(to_shost(isci_host));
>> +	}
>>
>>  	return 0;
>>
>> --
>> 1.8.3.1
>>
>> Then I issued the command 'modprobe isci' on platform with two SCU controllers
>> (Patsburg D or T chipset)
>> and received the following, very strange, output:
>>
>> (0 < 2) == 1
>> (1 < 2) == 1
>> (2 < 2) == 1
>>
>> Can anyone explain why (2 < 2) is true? Is it a gcc bug?
>>
>> (The kernel was compiled using gcc version 4.8.2.)
>>
> 
> Some additional information:
> 
> The loop 'for' in macro ' for_each_isci_host ' defined as (drivers/scsi/isci/host.h:313):
> 
> #define for_each_isci_host(id, ihost, pdev) \
>         for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
>              id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
>              ihost = to_pci_info(pdev)->hosts[++id])
> 
> should be executed only for i = 0 and 1, because:
> ARRAY_SIZE(to_pci_info(pdev)->hosts) = SCI_MAX_CONTROLLERS = 2
> 
> but it was executed also for i=2 regardless the above loop's end condition. 

to_pci_info() can return NULL in dev_get_drvdata(). The use of
ARRAY_SIZE() is inappropriate.

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
__must_be_array(arr))

#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))

#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))

I would say that this was supposed to trigger a build error but it
didn't and added 1 to the loop end condition.

Can you test putting SCI_MAX_CONTROLLERS to the loop end condition, please?

Cheers,
Sebastian
