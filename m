Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3JaMXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:23:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22200 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3JaMXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:23:39 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f0a6d000007b1b-6c-52724bc887bf
Message-id: <52724BAC.1080902@samsung.com>
Date: Thu, 31 Oct 2013 14:23:08 +0200
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
In-reply-to: <1383221007.5434.98.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-transfer-encoding: 8bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xq7onvIuCDDZNN7R41/SbxeLyrjls
	Fh96HrFZfFoxidmBxePBoc0sHu/3XWXz+LxJLoA5issmJTUnsyy1SN8ugSvjy+a5TAX7FSsW
	Hz7D0sD4T6qLkZNDQsBE4uDmBYwQtpjEhXvr2boYuTiEBJYySvQ8vMQMkuAVEJT4MfkeC4jN
	LKAuMWneImaIokYmiYZZ11kgnLmMEs2XDjBCdGhJzFn3BqyDRUBV4sOBTWA2m4CexIbmH+wg
	tqhAmMTRpp+sILaIgKbEsdaPjBAbpjNKPLwTBWILC7hJXHm8A2rbEkaJFe09YA2cAu4S69/s
	gmqQlzh45TnYAiGgZd1r17JB/KMocXryOeYJjMKzkHwxC8kXs5C0L2BkXsUomlqaXFCclJ5r
	qFecmFtcmpeul5yfu4kREgFfdjAuPmZ1iFGAg1GJh5dBtzBIiDWxrLgy9xCjBAezkgjvNZ2i
	ICHelMTKqtSi/Pii0pzU4kOMTBycUg2MtX8mGu3nUVfaNqN3asHVtd4nHvCInfAz7DXZ1Lh4
	7lS5nUc27VJLXuj3YbdPrF6y9Mx5qZaSKwsVHFSubG+qFQsrYDhhr9u/RTygQ3XihytrV5n2
	b12z6dhmiYqg24VBy3UkHvVEKB6pN91375cPS0t4E3vnkyJX4WU88h2/BCaXZlaePn9ViaU4
	I9FQi7moOBEA+15HSF4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/13 14:03, Mimi Zohar wrote:
> On Thu, 2013-10-31 at 10:30 +0200, Dmitry Kasatkin wrote:
>> On 30/10/13 20:54, Mimi Zohar wrote:
>>> Require all keys added to the IMA keyring be signed by an
>>> existing trusted key on the system trusted keyring.
>>>
>>> Changelog:
>>> - define stub integrity_init_keyring() function (reported-by Fengguang Wu)
>>> - differentiate between regular and trusted keyring names.
>>> - replace printk with pr_info (D. Kasatkin)
>>>
>>> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
>>> ---
>>>  security/integrity/digsig.c           | 30 +++++++++++++++++++++++++++++-
>>>  security/integrity/ima/Kconfig        |  8 ++++++++
>>>  security/integrity/ima/ima_appraise.c | 11 +++++++++++
>>>  security/integrity/integrity.h        |  7 +++++++
>>>  4 files changed, 55 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
>>> index b4af4eb..77ca965 100644
>>> --- a/security/integrity/digsig.c
>>> +++ b/security/integrity/digsig.c
>>> @@ -13,7 +13,9 @@
>>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>  
>>>  #include <linux/err.h>
>>> +#include <linux/sched.h>
>>>  #include <linux/rbtree.h>
>>> +#include <linux/cred.h>
>>>  #include <linux/key-type.h>
>>>  #include <linux/digsig.h>
>>>  
>>> @@ -21,11 +23,19 @@
>>>  
>>>  static struct key *keyring[INTEGRITY_KEYRING_MAX];
>>>  
>>> +#ifdef CONFIG_IMA_TRUSTED_KEYRING
>>> +static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>>> +	".evm",
>>> +	".module",
>>> +	".ima",
>>> +};
>>> +#else
>>>  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>>>  	"_evm",
>>>  	"_module",
>>>  	"_ima",
>>>  };
>>> +#endif
>> Hello,
>>
>> I am not sure if having 2 different names "_" and "." makes sense.
> The existing keyring implementation permits userspace to create a new
> keyring with the exact same name as a previously defined trusted
> keyring.  For all practical purposes, replacing a trusted keyring with
> an untrusted one.  The existing solution is to prohibit userspace from
> creating a dot prefixed keyring.  
>
> Allowing only signed keys to be added to the IMA keyring breaks the
> existing userspace/kernel ABI, which has existed since linux-3.3.  At
> some point, we could deprecate the non trusted keyring. 
>
>> Setting trusted-only makes sense until we will get support of setting
>> trusted only from user-space using keyctl...
> Agreed, userspace should be permitted to create a trusted keyring, but
> not change an existing keyring to trusted.

Then all keys on that keyring must be signed..
This is not what I was saying...

It is always possible to specify keyring hierarchy and rules what
verifies what.
But may be better not to over-engineer...

It is how it is now.. Will see based on use-cases in the future...

>> David, do you remember our discussion in Edinburgh?
>> Can you provide a way to set keyring as trusted-only from user space..
>>
>> Motivation...
>>
>> In many embedded systems, initramfs is built into the ker​​nel image.
>> Kernel image is signed and obviously initramfs as well..
>> Or initramfs may be signed separately like in my prototype implementation...
>> Note that non-x86 systems - embedded, mobile, etc has no UEFI, MOK.
>> Initial keys cannot be verified. (we should not rely on using kernel
>> modules key)
>> Thus keys on the protected initramfs may not be required to be signed..
> In the builtin initramfs case, the public key is included in the signed
> image.  Where is the key stored that verifies the separately signed
> initramfs?  Is there a signature chain of trust?

In prototype implementation I used kernel module verification
function... module key...

>
> If there is a signature chain of trust and a local-ca signed the
> initramfs, then the local-ca key could be added to the system keyring
> and used to sign keys for the IMA keyring.
>
> thanks,

You need to embed local-ca somehow into the kernel..
Or pass/read and verify it somehow...

- Dmitry

> Mimi
>
>> It must be a way to add "initial keys" from user-space...
>> This is like "setting initial trust"..
>> This kind of functionality also useful for ".system" keyring itself.
>

