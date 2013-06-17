Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3FQWpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:45:15 -0400
Received: from smtp103.biz.mail.sg3.yahoo.com ([106.10.167.246]:27933 "HELO
	smtp103.biz.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751043Ab3FQWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:45:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2013 18:45:12 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UH3K1rIVM1nL2v4FQqHh97VckDeZ3_57qfU7AlSaDo4DMtJ
 v7EOcyiinefYPDC8e7N5bL5Fmux3Nybew_6pbNAH.6idBkvMxHXLp8sXbr_T
 CGsxp0Pi9pKO_wfyyYPSowg8xfnWYjnLvwgtvTewUO9nVYg2t1dudvccz6Yh
 mCtQuMSjunaB_7k0Ok7sOGr1zAaMbkNKEosN54Hqb54KpwUsOGyn78863H3u
 rYPzLrHSuvEnQyxtDvhorghH_0AWV1fwuj7B6Yy1LtC5KBXudA2JxPfEllpq
 bkjUefjOmjuh9vkeqISvotOiW6yggQQjLJRH4vhXvmU0dOnw7xtuaH1mSH3x
 1VqDJ4UucB.RXXzCVvAFuzKuYdczB._73ZFoI2Epk_LVDmURRN20HiQBm6.0
 M4stMCRXZmgNcUQ0EWlqguzeruwbOpIcEkL6mbsj6nBtf5ogOKNjw7ygZxDb
 NRswC4CUrxYbExDGbu_Uq
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [10.10.10.249] (casey@115.23.168.190 with plain)
        by smtp103.biz.mail.sg3.yahoo.com with SMTP; 17 Jun 2013 22:38:30 +0000 UTC
Message-ID: <51BF8FE3.1060909@schaufler-ca.com>
Date: Mon, 17 Jun 2013 15:38:27 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC 1/5] security: smack: avoid kmalloc allocations while loading
 a rule string
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com> <1371137352-31273-2-git-send-email-t.stanislaws@samsung.com> <51BCC159.6090001@schaufler-ca.com> <51BEF1D5.4050101@samsung.com>
In-Reply-To: <51BEF1D5.4050101@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/2013 4:24 AM, Tomasz Stanislawski wrote:
> Hi Casey,
> Thank you for the review.
> Please refer to the comments below.
>
> On 06/15/2013 09:32 PM, Casey Schaufler wrote:
>> On 6/13/2013 8:29 AM, Tomasz Stanislawski wrote:
>>> The maximal length for a rule line for long format is introduced as
>>> SMK_LOAD2LEN. This allows a buffer for a rule string to be allocated
>>> on a stack instead of a heap (aka kmalloc cache).
>>>
>>> Limiting the length of a rule line helps to avoid allocations of a very long
>>> contiguous buffer from a heap if user calls write() for a very long chunk.
>>> Such an allocation often causes a lot swapper/writeback havoc and it is very
>>> likely to fails.
>>>
>>> Moreover, stack allocation is slightly faster than from kmalloc.
>>>
>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Please see the explanation below.
>>
>> Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
>>
>>> ---
>>>  security/smack/smackfs.c |   15 ++++++---------
>>>  1 file changed, 6 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
>>> index 53a08b8..9a3cd0d 100644
>>> --- a/security/smack/smackfs.c
>>> +++ b/security/smack/smackfs.c
>>> @@ -137,6 +137,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
>>>   * SMK_ACCESS: Maximum possible combination of access permissions
>>>   * SMK_ACCESSLEN: Maximum length for a rule access field
>>>   * SMK_LOADLEN: Smack rule length
>>> + * SMK_LOAD2LEN: Smack maximal long rule length excluding \0
>>>   */
>>>  #define SMK_OACCESS	"rwxa"
>>>  #define SMK_ACCESS	"rwxat"
>>> @@ -144,6 +145,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
>>>  #define SMK_ACCESSLEN	(sizeof(SMK_ACCESS) - 1)
>>>  #define SMK_OLOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_OACCESSLEN)
>>>  #define SMK_LOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
>>> +#define SMK_LOAD2LEN	(2 * SMK_LONGLABEL + SMK_ACCESSLEN + 2)
>>>  
>>>  /*
>>>   * Stricly for CIPSO level manipulation.
>>> @@ -447,8 +449,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>>>  {
>>>  	struct smack_known *skp;
>>>  	struct smack_parsed_rule *rule;
>>> -	char *data;
>>> -	int datalen;
>>> +	char data[SMK_LOAD2LEN + 1];
>> That puts over 512 bytes on the stack. The reason that the code
>> uses a temporary allocation is that 512 bytes to considerably
>> beyond what is considered reasonable to put on the kernel stack.
>> As reasonable as this approach is in user space code, it is not
>> appropriate in the kernel.
>>
> OK. I see the problem now. Usually the kernel stack is limited to 8KiB (2 pages).
> I agree that 512-byte allocation is not a good idea.
> Anyway, I still think that a length of a rule should be limited.
> This will protect from kmalloc() fro too long buffers.
> What is your opinion?

I agree that range checking is good. I am toying with how to
allow multiple rules per write. If we go that route the number
will likely be more like 4k than 512.

>
>>>  	int rc = -EINVAL;
>>>  	int load = 0;
>>>  
>>> @@ -465,13 +466,10 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>>>  		 */
>>>  		if (count != SMK_OLOADLEN && count != SMK_LOADLEN)
>>>  			return -EINVAL;
>>> -		datalen = SMK_LOADLEN;
>>> -	} else
>>> -		datalen = count + 1;
>>> +	}
>>>  
>>> -	data = kzalloc(datalen, GFP_KERNEL);
>>> -	if (data == NULL)
>>> -		return -ENOMEM;
>>> +	if (count > SMK_LOAD2LEN)
>>> +		count = SMK_LOAD2LEN;
>>>  
>>>  	if (copy_from_user(data, buf, count) != 0) {
>>>  		rc = -EFAULT;
>>> @@ -522,7 +520,6 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>>>  out_free_rule:
>>>  	kfree(rule);
>>>  out:
>>> -	kfree(data);
>>>  	return rc;
>>>  }
>>>  
>>
>

