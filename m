Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3FTVWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:22:37 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:47199 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab3FTVWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:22:36 -0400
Message-ID: <51C37291.40303@linux.vnet.ibm.com>
Date: Fri, 21 Jun 2013 02:52:25 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
References: <20130619175438.2852.93449.stgit@localhost.localdomain> <20130620073943.GE32694@pd.tnic> <51C3531D.3000600@linux.vnet.ibm.com> <20130620192928.GD19877@pd.tnic> <51C36288.4050405@linux.vnet.ibm.com> <20130620205726.GA20863@pd.tnic>
In-Reply-To: <20130620205726.GA20863@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062021-2000-0000-0000-00000C936DF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 02:27 AM, Borislav Petkov wrote:
> On Fri, Jun 21, 2013 at 01:44:00AM +0530, Naveen N. Rao wrote:
>> This won't work across cpu offline/online, right? We will end up
>> _not_ enabling CMCI on certain banks where we should have.
>
> Huh, don't understand. cmci_discover runs on each CPU. After you've run
> hest_parse_cmc early during boot and cleared the mce_poll_banks bits,
> nothing will set them again so CPU hotplug doesn't matter...

Exactly, but mce_poll_banks also doesn't have bits set for banks on 
which CMCI is enabled.

Let's say we have a cpu with 2 banks (not shared), none of which work in 
FF mode. Both these banks support CMCI, so mce_poll_banks won't have 
these bits set.

On cpu offline, we call cmci_clear() which disables CMCI on these two 
banks before offlining it.  When this cpu is brought online again, we 
call cmci_discover() which sees that mce_poll_banks doesn't have these 
two banks enabled and will skip enabling CMCI thinking these are in FF.

Right?

>
>> Another thing: for hest_parse_cmc(), does the below look good?
>>
>>          cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
>>          if (!cmc->enabled)
>>                  return 0;
>>
>> #define ACPI_HEST_PARSING_DONE 1
>>          /*
>>           * We expect HEST to provide a list of MC banks that
>>           * report errors in firmware first mode.
>>           */
>>          if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) ||
>> !cmc->num_hardware_banks)
>>                  return ACPI_HEST_PARSING_DONE;
>>
>> The return value doesn't really matter since we don't check it, but
>> returning an error looked like the wrong thing to do as well.
>
> I'd add a comment above the "return 1" statement to explain why I'm
> doing this. It is much more verbose even than a well-named macro :)

Okay :)

Thanks,
Naveen

