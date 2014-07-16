Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaGPH5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:57:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24233 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaGPH5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:57:37 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-47-53c6306e29cc
Message-id: <53C63016.6050805@samsung.com>
Date: Wed, 16 Jul 2014 10:56:06 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-ima-devel@lists.sourceforge.net
Subject: Re: [Linux-ima-devel] [PATCH v1 1/3] ima: provide flag to identify new
 empty files
References: <cover.1405078844.git.d.kasatkin@samsung.com>
 <ac60392e0118902ce9b308fdae09d633da1682af.1405078844.git.d.kasatkin@samsung.com>
 <1405432827.21720.20.camel@dhcp-9-2-203-236.watson.ibm.com>
 <1405462329.2124.12.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1405462329.2124.12.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xa7p5BseCDSZcZLHYs/cki8XLGfPY
	LS7vmsNm8aHnEZvF+b/HWS0+rZjE7MDm8eDQZhaP3Qs+M3l83iTnsenJW6YAligum5TUnMyy
	1CJ9uwSujEfzb7MWHJSrWPb4GXMDY79kFyMnh4SAicScaXfZIWwxiQv31rN1MXJxCAksZZTY
	MuEKlNPIJHHpZC8zhDOLUeLjor0sIC28AloST949ZwOxWQRUJWb87gIbxSagJ7Gh+QeYLSoQ
	IXGg7xkrRL2gxI/J98B6RQQ0JY61fmQEsZkFVjFKLGoOArGFBWIljnSehtrcziQx+es0sGZO
	AXeJKzu2sUI0qEtMmreIGcKWl9i85i2YLQR0RPfatWwQ/yhKnJ58jnkCo/AsJLtnIWmfhaR9
	ASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQ+Piyg3HxMatDjAIcjEo8vAyzjwYLsSaW
	FVfmHmKU4GBWEuEVYTkWLMSbklhZlVqUH19UmpNafIiRiYNTqoHROr8qf+Lhotrv8rbxj5s2
	5Ps+TgnsEWcq1EurPHxCJeZqkAtfsu2mKxtfrZ5leSVoZcw2c167K3t4ulL6a844R/5b+MOo
	bK1u9FzRa/kpAY3qdVsX3EmcXPhtBUf1rkchmYEetzVvtl9Ki83tPfaz9Ub8Wt6GBQt+Lj1e
	KBVdsGDhkxgG/xNKLMUZiYZazEXFiQAKOl6ebQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/14 01:12, Mimi Zohar wrote:
> On Tue, 2014-07-15 at 10:00 -0400, Mimi Zohar wrote: 
>> On Fri, 2014-07-11 at 14:46 +0300, Dmitry Kasatkin wrote: 
>>> Newly created empty files do not get initial security.ima
>>> value because iversion does not change. It can be checked from
>>> the shell as:
>>>
>>>   $ (exec >foo)
>>>   $ getfattr -h -e hex -d -m security foo
> This is a change in behavior.  Please include the commit number that
> introduced this change in the patch description.

This commit might caused this.
dff6efc326a4d5f305797d4a6bba14f374fdd633 fs: fix iversion handling

- Dmitry

> Mimi
>
>>> This patch defines IMA_NEW_FILE flag which is set when IMA detects that new
>>> file is created. It is checked upon ima_file_free hook to set initial
>>> security.ima value.
>> Other than rebasing on top of #next, this patch set looks good.
>>
>> thanks,
>>
>> Mimi
>>
>>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>>> ---
>>>  security/integrity/ima/ima_appraise.c |  7 +++++--
>>>  security/integrity/ima/ima_main.c     | 12 +++++++-----
>>>  security/integrity/integrity.h        |  1 +
>>>  3 files changed, 13 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
>>> index 9dd18b5..3a4beb3 100644
>>> --- a/security/integrity/ima/ima_appraise.c
>>> +++ b/security/integrity/ima/ima_appraise.c
>>> @@ -194,8 +194,11 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>>>  			goto out;
>>>
>>>  		cause = "missing-hash";
>>> -		status =
>>> -		    (inode->i_size == 0) ? INTEGRITY_PASS : INTEGRITY_NOLABEL;
>>> +		status = INTEGRITY_NOLABEL;
>>> +		if (inode->i_size == 0) {
>>> +			iint->flags |= IMA_NEW_FILE;
>>> +			status = INTEGRITY_PASS;
>>> +		}
>>>  		goto out;
>>>  	}
>>>
>>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>>> index e51e0d5..5a870e7 100644
>>> --- a/security/integrity/ima/ima_main.c
>>> +++ b/security/integrity/ima/ima_main.c
>>> @@ -124,11 +124,13 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
>>>  		return;
>>>
>>>  	mutex_lock(&iint->mutex);
>>> -	if (atomic_read(&inode->i_writecount) == 1 &&
>>> -	    iint->version != inode->i_version) {
>>> -		iint->flags &= ~IMA_DONE_MASK;
>>> -		if (iint->flags & IMA_APPRAISE)
>>> -			ima_update_xattr(iint, file);
>>> +	if (atomic_read(&inode->i_writecount) == 1) {
>>> +		if ((iint->version != inode->i_version) ||
>>> +		    (iint->flags & IMA_NEW_FILE)) {
>>> +			iint->flags &= ~(IMA_DONE_MASK | IMA_NEW_FILE);
>>> +			if (iint->flags & IMA_APPRAISE)
>>> +				ima_update_xattr(iint, file);
>>> +		}
>>>  	}
>>>  	mutex_unlock(&iint->mutex);
>>>  }
>>> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
>>> index 92c1083..7656d47 100644
>>> --- a/security/integrity/integrity.h
>>> +++ b/security/integrity/integrity.h
>>> @@ -30,6 +30,7 @@
>>>  #define IMA_ACTION_FLAGS	0xff000000
>>>  #define IMA_DIGSIG_REQUIRED	0x01000000
>>>  #define IMA_PERMIT_DIRECTIO	0x02000000
>>> +#define IMA_NEW_FILE		0x04000000
>>>
>>>  #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
>>>  				 IMA_APPRAISE_SUBMASK)
>>
>>
>> ------------------------------------------------------------------------------
>> Want fast and easy access to all the code in your enterprise? Index and
>> search up to 200,000 lines of code with a free copy of Black Duck
>> Code Sight - the same software that powers the world's largest code
>> search on Ohloh, the Black Duck Open Hub! Try it now.
>> http://p.sf.net/sfu/bds
>> _______________________________________________
>> Linux-ima-devel mailing list
>> Linux-ima-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/linux-ima-devel
>>
>
>

