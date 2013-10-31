Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3JaNSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:18:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52732 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3JaNSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:18:33 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7ef66d00000795a-bd-527258a79ed6
Message-id: <5272588B.2050509@samsung.com>
Date: Thu, 31 Oct 2013 15:18:03 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ima: define '_ima' as a builtin 'trusted' keyring
References: <1383159291.5434.18.camel@dhcp-9-2-203-236.watson.ibm.com>
 <5272153D.4080801@samsung.com>
 <1383221007.5434.98.camel@dhcp-9-2-203-236.watson.ibm.com>
 <52724BAC.1080902@samsung.com>
 <1383223387.5434.111.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1383223387.5434.111.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-transfer-encoding: 8bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xq7rLI4qCDLZtYrN41/SbxeLyrjls
	Fh96HrFZfFoxidmBxePBoc0sHu/3XWXz+LxJLoA5issmJTUnsyy1SN8ugStj58cuxoLlahWv
	5hk0MHbLdzFyckgImEhcPHKEEcIWk7hwbz1bFyMXh5DAUkaJ9v+bmEASvAKCEj8m32MBsZkF
	1CUmzVvEDFHUyCRxeOYNKGcuo0TfrVVsEB1aEsuvXWEHsVkEVCVOd75mBrHZBPQkNjT/AIuL
	CoRJHG36yQpiiwhoShxr/cgIsWE6o8TDO1EgtrCAm8SVxzugFjQzSTRs2A22gFPAQ+LqtyVM
	EA3yEgevPAc7TwhoWffatWwQ/yhKnJ58jnkCo/AsJF/MQvLFLCTtCxiZVzGKppYmFxQnpeca
	6RUn5haX5qXrJefnbmKEhP/XHYxLj1kdYhTgYFTi4WXQLQwSYk0sK67MPcQowcGsJMK7Kawo
	SIg3JbGyKrUoP76oNCe1+BAjEwenVAPjvPy9Ob1eyr8z7F9fDZxorr3Q6G+QX/a2ewGCzk82
	HvJW5mGu5dv8QD36qMWE5czbNq7YrzAx8vDKk/5dp/M3az4X9beN/mYoMD/JV/LFg3B176rE
	/S+EQoPDr4Tft3Q9OuOgqyvT9/fVIg9/1/leVD6aJrE48+S2ZxMeR3/mT+911ZCrklmlxFKc
	kWioxVxUnAgA+E3gA10CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/13 14:43, Mimi Zohar wrote:
> On Thu, 2013-10-31 at 14:23 +0200, Dmitry Kasatkin wrote:
>> On 31/10/13 14:03, Mimi Zohar wrote:
>>> On Thu, 2013-10-31 at 10:30 +0200, Dmitry Kasatkin wrote:
>>>> On 30/10/13 20:54, Mimi Zohar wrote:
>>>>> Require all keys added to the IMA keyring be signed by an
>>>>> existing trusted key on the system trusted keyring.
>>>>>
>>>>> Changelog:
>>>>> - define stub integrity_init_keyring() function (reported-by Fengguang Wu)
>>>>> - differentiate between regular and trusted keyring names.
>>>>> - replace printk with pr_info (D. Kasatkin)
>>>>>
>>>>> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
>>>>> ---
>>>>>  security/integrity/digsig.c           | 30 +++++++++++++++++++++++++++++-
>>>>>  security/integrity/ima/Kconfig        |  8 ++++++++
>>>>>  security/integrity/ima/ima_appraise.c | 11 +++++++++++
>>>>>  security/integrity/integrity.h        |  7 +++++++
>>>>>  4 files changed, 55 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
>>>>> index b4af4eb..77ca965 100644
>>>>> --- a/security/integrity/digsig.c
>>>>> +++ b/security/integrity/digsig.c
>>>>> @@ -13,7 +13,9 @@
>>>>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>>>  
>>>>>  #include <linux/err.h>
>>>>> +#include <linux/sched.h>
>>>>>  #include <linux/rbtree.h>
>>>>> +#include <linux/cred.h>
>>>>>  #include <linux/key-type.h>
>>>>>  #include <linux/digsig.h>
>>>>>  
>>>>> @@ -21,11 +23,19 @@
>>>>>  
>>>>>  static struct key *keyring[INTEGRITY_KEYRING_MAX];
>>>>>  
>>>>> +#ifdef CONFIG_IMA_TRUSTED_KEYRING
>>>>> +static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>>>>> +	".evm",
>>>>> +	".module",
>>>>> +	".ima",
>>>>> +};
>>>>> +#else
>>>>>  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>>>>>  	"_evm",
>>>>>  	"_module",
>>>>>  	"_ima",
>>>>>  };
>>>>> +#endif
>>>> Hello,
>>>>
>>>> I am not sure if having 2 different names "_" and "." makes sense.
>>> The existing keyring implementation permits userspace to create a new
>>> keyring with the exact same name as a previously defined trusted
>>> keyring.  For all practical purposes, replacing a trusted keyring with
>>> an untrusted one.  The existing solution is to prohibit userspace from
>>> creating a dot prefixed keyring.  
>>>
>>> Allowing only signed keys to be added to the IMA keyring breaks the
>>> existing userspace/kernel ABI, which has existed since linux-3.3.  At
>>> some point, we could deprecate the non trusted keyring. 
>>>
>>>> Setting trusted-only makes sense until we will get support of setting
>>>> trusted only from user-space using keyctl...
>>> Agreed, userspace should be permitted to create a trusted keyring, but
>>> not change an existing keyring to trusted.
>> Then all keys on that keyring must be signed..
>> This is not what I was saying...
>>
>> It is always possible to specify keyring hierarchy and rules what
>> verifies what.
>> But may be better not to over-engineer...
>>
>> It is how it is now.. Will see based on use-cases in the future...
> Right, keys can be loaded onto the existing keyring; and the keyring can
> be locked in the initramfs.  Moving forward, a trusted keyring implies a
> HW based certificate chain of trust.
>
>>>> David, do you remember our discussion in Edinburgh?
>>>> Can you provide a way to set keyring as trusted-only from user space..
>>>>
>>>> Motivation...
>>>>
>>>> In many embedded systems, initramfs is built into the ker​​nel image.
>>>> Kernel image is signed and obviously initramfs as well..
>>>> Or initramfs may be signed separately like in my prototype implementation...
>>>> Note that non-x86 systems - embedded, mobile, etc has no UEFI, MOK.
>>>> Initial keys cannot be verified. (we should not rely on using kernel
>>>> modules key)
>>>> Thus keys on the protected initramfs may not be required to be signed..
>>> In the builtin initramfs case, the public key is included in the signed
>>> image.  Where is the key stored that verifies the separately signed
>>> initramfs?  Is there a signature chain of trust?
>> In prototype implementation I used kernel module verification
>> function... module key...
> This implies that you rebuilt the kernel. :)  In that case, add your
> local-ca public key to the root build tree.  All .x509 suffixed files
> are included in the image and loaded on the system keyring.
>

No.. Key stays on the filesystem... It is re-generated if it is missing...

- Dmitry

>>> If there is a signature chain of trust and a local-ca signed the
>>> initramfs, then the local-ca key could be added to the system keyring
>>> and used to sign keys for the IMA keyring.
>>>
>>> thanks,
>> You need to embed local-ca somehow into the kernel..
>> Or pass/read and verify it somehow...
> Exactly.
>
> Mimi
>
>

