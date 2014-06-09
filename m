Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbaFINGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:06:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41708 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbaFINGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:06:05 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-f0-5395b13a60ca
Message-id: <5395B125.8010503@samsung.com>
Date: Mon, 09 Jun 2014 16:05:41 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v5 4/4] KEYS: define an owner trusted keyring
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1401818318-15780-5-git-send-email-zohar@linux.vnet.ibm.com>
 <5395A4F9.1020205@samsung.com>
 <1402318294.7064.19.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1402318294.7064.19.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7pWG6cGG7w4xWvxruk3i8WBd09Y
	LGbveshicXnXHDaLDz2P2Cw+rZjE7MDmMe3EMhaPB4c2s3i833eVzePzJrkAligum5TUnMyy
	1CJ9uwSujJ477xgLNgtVLJ63gLWBcQ9fFyMnh4SAicTLQ08ZIWwxiQv31rN1MXJxCAksZZT4
	ercdymlkkjjVuIkJpEpIYBajxOe5qiA2r4CWxLcTp9hBbBYBVYneu/fAbDYBPYkNzT+AbA4O
	UYEIiccXhCDKBSV+TL7HAmKLCGhKHGv9yAgyn1ngNqPEy4OH2UDqhQVcJZoPhkCsesoo0b3R
	AsTmFHCXWLnnATOIzSygLjFp3iIoW15i85q3zBD1qhLda9eyQTyjKHF68jnmCYzCs5CsnoWk
	fRaS9gWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQiLj6w7GpcesDjEKcDAq8fAmME0N
	FmJNLCuuzD3EKMHBrCTC27EeKMSbklhZlVqUH19UmpNafIiRiYNTqoFx/yvxrCmimToZszb6
	3Fvw+9kxLbdYmaoP5Vmby3/rOlX/cOFePJ1lbqbuyQmhkxZMaXZv3j7ZpP25Ravkn3L/I4UZ
	iWrbmy5lerjsNrun8TYyadPHle2nJ/l+m/9xVc/Xu0t0V1tqCon5yp9gED7VstraWZVRfP2j
	A72rayJvy/2vDogSEDFSYinOSDTUYi4qTgQAxkl7iWoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/14 15:51, Mimi Zohar wrote:
> On Mon, 2014-06-09 at 15:13 +0300, Dmitry Kasatkin wrote: 
>> On 03/06/14 20:58, Mimi Zohar wrote:
>>> Instead of allowing public keys, with certificates signed by any
>>> key on the system trusted keyring, to be added to a trusted
>>> keyring, this patch further restricts the certificates to those
>>> signed by a particular key on the system keyring.
>>>
>>> When the UEFI secure boot keys are added to the system keyring, the
>>> platform owner will be able to load their key in one of the UEFI DBs
>>> (eg. Machine Owner Key(MOK) list) and select their key, without
>>> having to rebuild the kernel.
>>>
>>> This patch defines an owner trusted keyring, a new boot command
>>> line option 'keys_ownerid=', and defines a new function
>>> get_system_or_owner_trusted_keyring().
>> Hello,
>>
>> The functionality of this entire patch can be replaced by only ~2 lines
>> of code in x509_request_asymmetric_key()
>>
>> if (keys_ownerid || strcmp(keys_ownerid, id))
>>      return -EPERM;
>>
>> Right?
> Are you suggesting only add the one matching key to the system keyring?

No. I am not suggesting this.

All built in keys are allocated with KEY_ALLOC_TRUSTED flag and
prep.trusted is set to "true".

So  the following statement has no effect.

#ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
        ret = x509_validate_trust(cert, system_trusted_keyring);
        if (!ret)
            prep->trusted = 1;
#endif

Keys which come from user-space will check for

if (keys_ownerid && strcmp(keys_ownerid, id))
     return -EPERM;


So 2 lines patch works fine..

- Dmitry

> The original patch compared the builtin key being loaded onto the system
> keyring and, if it matched the requested key, also added the key to the
> owner keyring.  This version waits for all the builtin keys to be loaded
> onto the system keyring, and in the future the UEFI DB keys, before
> adding the matched key to the owner keyring.  In this version, the keys
> are already on the system keyring.  So no, your two lines would not
> work.
>
> Mimi
>



>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

