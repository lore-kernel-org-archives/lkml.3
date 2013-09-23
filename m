Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3IWUVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:21:41 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:56212 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752378Ab3IWUVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:21:40 -0400
X-TM-IMSS-Message-ID: <0a1a2d4b0000ec05@nsa.gov>
Message-ID: <5240A2A3.4040102@tycho.nsa.gov>
Date: Mon, 23 Sep 2013 16:20:51 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to sysfs
 into tpm-sysfs.c
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com> <52408E5D.4020904@tycho.nsa.gov> <20130923193633.GA9194@obsidianresearch.com>
In-Reply-To: <20130923193633.GA9194@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 03:36 PM, Jason Gunthorpe wrote:
> On Mon, Sep 23, 2013 at 02:54:21PM -0400, Daniel De Graaf wrote:
>> On 09/23/2013 02:14 PM, Jason Gunthorpe wrote:
>>> CLASS-sysfs.c is a common idiom for linux subsystems.
>>>
>>> This pulls all the sysfs attribute functions and related code
>>> into tpm-sysfs.c. To support this change some constants are moved
>> >from tpm.c to tpm.h and __tpm_pcr_read is made non-static and is
>>> called tpm_pcr_read_dev.
>>>
>>> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> [...]
>>> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
>>> index 12a4ab2..7892557 100644
>>> +++ b/drivers/char/tpm/xen-tpmfront.c
>> [...]
>>> -static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
>>> -static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
>>> -static DEVICE_ATTR(locality, S_IRUGO | S_IWUSR, tpm_show_locality,
>>> -		tpm_store_locality);
>>
>> This patch drops the "locality" sysfs attribute from xen-tpmfront. Since
>> that attribute is currently only implemented for the xen TPM driver, it
>> is best to leave it there for now (and its show/store functions could
>> also be made static, an oversight I just noticed now). If this attribute
>> is later made available on other TPM drivers, it may need to contain
>> device-specific logic, but such an implementation is well outside the
>> scope of this series.
>
> Okay, I see what you are talking about, the compiler didn't warn
> because of the missing static.
>
> This really is a core functionality. Lots of other drivers support
> locality, but none have dared actually expose the functionality. IHMO,
> it is a mistake to just jam a locality attribute in one driver.
>
> Sorry, I would have said something when the driver was posted if it
> was obvious this was hiding in there :|

That's fine; it wasn't really advertised in the description, and was
mostly added in order to demonstrate the locality security label binding
in Xen's vtpm-stubdom.
  
> It looks like this driver was introduced in the 3.12 merge window, we
> could drop the attribute, and try to merge a core supported locality
> API in 3.13? What do you think?
>
> But, if you say it is needed, it is easy enough to adjust this patch
> series.
>
> Thanks,
> Jason

If it's replaced with an alternative, I don't think the sysfs attribute
will need to remain.  I am not aware of any clients that currently use
this attribute.  The sysfs attribute could remain as the common interface
for changing locality, unless you think an ioctl on /dev/tpm0 or
something else would be preferable (the attribute was just the simplest
way to implement locality switching at the time).

Do you already have an idea on what the core-supported API's interface
would be?  Making the current locality a part of the TPM device state
would suffice for TIS and xen-tpmfront with minimal changes, but I
haven't checked the other drivers.

-- 
Daniel De Graaf
National Security Agency
