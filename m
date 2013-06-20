Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422801Ab3FTUOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:14:12 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50731 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422787Ab3FTUOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:14:10 -0400
Message-ID: <51C36288.4050405@linux.vnet.ibm.com>
Date: Fri, 21 Jun 2013 01:44:00 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
References: <20130619175438.2852.93449.stgit@localhost.localdomain> <20130620073943.GE32694@pd.tnic> <51C3531D.3000600@linux.vnet.ibm.com> <20130620192928.GD19877@pd.tnic>
In-Reply-To: <20130620192928.GD19877@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062020-5564-0000-0000-0000087372F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 12:59 AM, Borislav Petkov wrote:
> On Fri, Jun 21, 2013 at 12:38:13AM +0530, Naveen N. Rao wrote:
>> We need this bitfield to prevent enabling CMCI in future
>> cmci_discover() invocations. See usage in cmci_discover() further
>> below.
>
> So?!
>
> 	/* Skip banks in firmware first mode */
> 	if (!test_bit(i, __get_cpu_var(mce_poll_banks))
> 		continue;

This won't work across cpu offline/online, right? We will end up _not_ 
enabling CMCI on certain banks where we should have.

>
> ...
>
>>> Yeah, let's call it ...disable_poll_bank because we're disabling polling
>>> for those banks. And yes, we poll for errors for which no MCE exception
>>> is generated and those happen to be corrected but still...
>>
>> We actually also disable CMCI here. So, in essence, we are disabling
>> these banks for all sorts of direct corrected error reporting. I
>> thought of naming this disable_ce_on_bank() or disable_ce_bank(),
>> but felt that the mce_ prefix would be good to have. If that isn't
>> necessary, I can rename this to disable_ce_on_bank() which sounds
>> more accurate to me. Is that ok?
>
> No, mce_disable_bank() removes the respective bank from the polling
> bitfield and cmci_disable_bank() actually disables CMCI which is
> Intel-only. So leave it at mce_disable_bank and that should be fine.

Ok. I will rename this to mce_disable_bank() from mce_disable_ce_bank().

Another thing: for hest_parse_cmc(), does the below look good?

         cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
         if (!cmc->enabled)
                 return 0;

#define ACPI_HEST_PARSING_DONE 1
         /*
          * We expect HEST to provide a list of MC banks that
          * report errors in firmware first mode.
          */
         if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) || 
!cmc->num_hardware_banks)
                 return ACPI_HEST_PARSING_DONE;

The return value doesn't really matter since we don't check it, but 
returning an error looked like the wrong thing to do as well.


Thanks,
Naveen

