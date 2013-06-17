Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3FQLYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:24:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36945 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab3FQLYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:24:09 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-21-51bef1d7ce0c
Message-id: <51BEF1D5.4050101@samsung.com>
Date: Mon, 17 Jun 2013 13:24:05 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/5] security: smack: avoid kmalloc allocations while loading
 a rule string
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
 <1371137352-31273-2-git-send-email-t.stanislaws@samsung.com>
 <51BCC159.6090001@schaufler-ca.com>
In-reply-to: <51BCC159.6090001@schaufler-ca.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7rXP+4LNDhz18zi3rZfbBZnm96w
	W1zeNYfN4kPPIzaLtUfuslu8nbSC2YHNo2/LKkaPo/sXsXl83iQXwBzFZZOSmpNZllqkb5fA
	lTFpRlbBP+mKtyuvszcwzhLrYuTkkBAwkdi7uJUJwhaTuHBvPVsXIxeHkMBSRom9396yQzif
	GSVadpwBq+IV0JJ43XePDcRmEVCVmLDgBAuIzQY06diSz4xdjBwcogIREk2nyyDKBSV+TL4H
	ViIioCOxb89zsJnMApMZJb6f7QObKSwQL/H9/TGozWsZJdp37mIGSXAKGEjM2ToRzGYG6t7f
	Oo0NwpaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh
	gfx1B+PSY1aHGAU4GJV4eDdU7wsUYk0sK67MPcQowcGsJMIbOxEoxJuSWFmVWpQfX1Sak1p8
	iJGJg1OqgXHZ8/ufpxn2yP3c/nZr5OTvd18k3TMufCr/5pc5i6VvvO373F9Tnwa2C4kcSN99
	u8y6u3eHPaNM5q8O34Nr9UNe80xnChVa4PdO6ZfRpDhFrehTkisM9kyXOnFys8mHnKzjkgZL
	T/Nrp7UaybZkxr+vT/3c31qdLVfKXRjtafZAo/GvfgmvuxJLcUaioRZzUXEiALGFHmdCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,
Thank you for the review.
Please refer to the comments below.

On 06/15/2013 09:32 PM, Casey Schaufler wrote:
> On 6/13/2013 8:29 AM, Tomasz Stanislawski wrote:
>> The maximal length for a rule line for long format is introduced as
>> SMK_LOAD2LEN. This allows a buffer for a rule string to be allocated
>> on a stack instead of a heap (aka kmalloc cache).
>>
>> Limiting the length of a rule line helps to avoid allocations of a very long
>> contiguous buffer from a heap if user calls write() for a very long chunk.
>> Such an allocation often causes a lot swapper/writeback havoc and it is very
>> likely to fails.
>>
>> Moreover, stack allocation is slightly faster than from kmalloc.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> 
> Please see the explanation below.
> 
> Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
> 
>> ---
>>  security/smack/smackfs.c |   15 ++++++---------
>>  1 file changed, 6 insertions(+), 9 deletions(-)
>>
>> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
>> index 53a08b8..9a3cd0d 100644
>> --- a/security/smack/smackfs.c
>> +++ b/security/smack/smackfs.c
>> @@ -137,6 +137,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
>>   * SMK_ACCESS: Maximum possible combination of access permissions
>>   * SMK_ACCESSLEN: Maximum length for a rule access field
>>   * SMK_LOADLEN: Smack rule length
>> + * SMK_LOAD2LEN: Smack maximal long rule length excluding \0
>>   */
>>  #define SMK_OACCESS	"rwxa"
>>  #define SMK_ACCESS	"rwxat"
>> @@ -144,6 +145,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
>>  #define SMK_ACCESSLEN	(sizeof(SMK_ACCESS) - 1)
>>  #define SMK_OLOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_OACCESSLEN)
>>  #define SMK_LOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
>> +#define SMK_LOAD2LEN	(2 * SMK_LONGLABEL + SMK_ACCESSLEN + 2)
>>  
>>  /*
>>   * Stricly for CIPSO level manipulation.
>> @@ -447,8 +449,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>>  {
>>  	struct smack_known *skp;
>>  	struct smack_parsed_rule *rule;
>> -	char *data;
>> -	int datalen;
>> +	char data[SMK_LOAD2LEN + 1];
> 
> That puts over 512 bytes on the stack. The reason that the code
> uses a temporary allocation is that 512 bytes to considerably
> beyond what is considered reasonable to put on the kernel stack.
> As reasonable as this approach is in user space code, it is not
> appropriate in the kernel.
> 

OK. I see the problem now. Usually the kernel stack is limited to 8KiB (2 pages).
I agree that 512-byte allocation is not a good idea.
Anyway, I still think that a length of a rule should be limited.
This will protect from kmalloc() fro too long buffers.
What is your opinion?

>>  	int rc = -EINVAL;
>>  	int load = 0;
>>  
>> @@ -465,13 +466,10 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>>  		 */
>>  		if (count != SMK_OLOADLEN && count != SMK_LOADLEN)
>>  			return -EINVAL;
>> -		datalen = SMK_LOADLEN;
>> -	} else
>> -		datalen = count + 1;
>> +	}
>>  
>> -	data = kzalloc(datalen, GFP_KERNEL);
>> -	if (data == NULL)
>> -		return -ENOMEM;
>> +	if (count > SMK_LOAD2LEN)
>> +		count = SMK_LOAD2LEN;
>>  
>>  	if (copy_from_user(data, buf, count) != 0) {
>>  		rc = -EFAULT;
>> @@ -522,7 +520,6 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>>  out_free_rule:
>>  	kfree(rule);
>>  out:
>> -	kfree(data);
>>  	return rc;
>>  }
>>  
> 
> 

