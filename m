Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422836Ab3FUHrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:47:06 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53708 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3FUHrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:47:04 -0400
Message-ID: <51C404EA.10906@linux.vnet.ibm.com>
Date: Fri, 21 Jun 2013 13:16:50 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
References: <20130619175438.2852.93449.stgit@localhost.localdomain> <20130620073943.GE32694@pd.tnic> <51C3531D.3000600@linux.vnet.ibm.com> <20130620192928.GD19877@pd.tnic> <51C36288.4050405@linux.vnet.ibm.com> <20130620205726.GA20863@pd.tnic> <51C37291.40303@linux.vnet.ibm.com> <20130621073419.GC22006@pd.tnic>
In-Reply-To: <20130621073419.GC22006@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062107-8878-0000-0000-000007A07CA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 01:04 PM, Borislav Petkov wrote:
> On Fri, Jun 21, 2013 at 02:52:25AM +0530, Naveen N. Rao wrote:
>> Exactly, but mce_poll_banks also doesn't have bits set for banks on
>> which CMCI is enabled.
>>
>> Let's say we have a cpu with 2 banks (not shared), none of which work
>> in FF mode. Both these banks support CMCI, so mce_poll_banks won't
>> have these bits set.
>>
>> On cpu offline, we call cmci_clear() which disables CMCI on these two
>> banks before offlining it. When this cpu is brought online again, we
>> call cmci_discover() which sees that mce_poll_banks doesn't have these
>> two banks enabled and will skip enabling CMCI thinking these are in
>> FF.
>
> Hmm, mce_intel has yet another bitfield - mce_banks_owned. (Btw, this is
> why I have a problem with adding yet another bitfield).
>
> The way I understand it is, if a bit is set in the owned bitfield, those
> banks belong to CMCI and are not polled.
>
> Now, can we use both mce_banks_owned and mce_poll_banks? If a bit in
> both bifields is cleared, the corresponding bank is not polled *and* is
> not owned by CMCI => it is in FF mode.
>
> Makes sense?
>

Yes, but I'm afraid this won't work either - mce_banks_owned is cleared 
during cpu offline. This is necessary since a cmci rediscover is 
triggered on cpu offline, so that if this bank is shared across cores, a 
different cpu can claim ownership of this bank.

The difference between the new bitfield and the existing bitfields is 
that the new one is not per-cpu. This is a global list of banks across 
cpus that we do not want enabled.


Thanks,
Naveen

