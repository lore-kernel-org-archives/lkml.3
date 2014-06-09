Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaFIH5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:57:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32878 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaFIH5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:57:01 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-ec-539568cbc612
Message-id: <539568B6.2070603@samsung.com>
Date: Mon, 09 Jun 2014 10:56:38 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v5 1/4] KEYS: special dot prefixed keyring name bug fix
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1401818318-15780-2-git-send-email-zohar@linux.vnet.ibm.com>
 <CACE9dm909SGRBOybkh8z8jNiGPc_ksKHzsMuvNB+ro9furQ_tQ@mail.gmail.com>
 <1402092031.11626.35.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1402092031.11626.35.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xy7qnM6YGG2ztYbJ41/SbxeLL0jqL
	A++esFjM3vWQxeLyrjlsFh96HrFZfFoxidmB3WPnrLvsHtNOLGPxeHBoM4vH+31X2Tw+b5IL
	YI3isklJzcksSy3St0vgytjwpJep4J9QRdOPZ2wNjFd4uxg5OCQETCSutrt1MXICmWISF+6t
	ZwOxhQSWMkrc+iXWxcgFZDcySRye+oYRwpnFKDFr0WlmkCpeAS2JjQvms4PYLAKqEuuWH2UB
	sdkE9CQ2NP9gB1kgKhAh8fiCEES5oMSPyffASkSAwof2nGIBmckscJtR4uXBw2CbhQX8JXqm
	rYS6oodJoqlVH8TmFPCQmPr4HSOIzSygLjFp3iJmCFteYvOat8wQ9aoS3WvXskF8oyhxevI5
	5gmMwrOQ7J6FpH0WkvYFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJi5esOxqXHrA4x
	CnAwKvHwJjBNDRZiTSwrrsw9xCjBwawkwludChTiTUmsrEotyo8vKs1JLT7EyMTBKdXA2OC7
	OvGQmtP3hevbA3ZmhR3d69ZyN2aW9emzc7neGIdv9d9SGl4mc7Y4m/md4aVDmxtbmJ980VhS
	LnVacbrr+pjYeTNm3PuTv/xDJG+Ei2T19M3rVpgf6TJvbNbL3/wpZbtwsOPGwOSLZvMbxS9X
	OEuLzC/Ywi0cf1xkOTe7iJGrYvjJSzxLlViKMxINtZiLihMBdZRcGHMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/14 01:00, Mimi Zohar wrote:
> On Sat, 2014-06-07 at 00:48 +0300, Dmitry Kasatkin wrote: 
>> On 3 June 2014 20:58, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>> Dot prefixed keyring names are supposed to be reserved for the
>>> kernel, but add_key() calls key_get_type_from_user(), which
>>> incorrectly verifies the 'type' field, not the 'description' field.
>>> This patch verifies the 'description' field isn't dot prefixed,
>>> when creating a new keyring, and removes the dot prefix test in
>>> key_get_type_from_user().
>>>
>>> Changelog v5:
>>> - Only prevent userspace from creating a dot prefixed keyring, not
>>>   regular keys  - Dmitry
>>>
>>> Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>>> Cc: David Howells <dhowells@redhat.com>
>>> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>>> ---
>>>  security/keys/keyctl.c | 6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
>>> index cd5bd0c..62a9952 100644
>>> --- a/security/keys/keyctl.c
>>> +++ b/security/keys/keyctl.c
>>> @@ -37,8 +37,6 @@ static int key_get_type_from_user(char *type,
>>>                 return ret;
>>>         if (ret == 0 || ret >= len)
>>>                 return -EINVAL;
>>> -       if (type[0] == '.')
>>> -               return -EPERM;
>>>         type[len - 1] = '\0';
>>>         return 0;
>>>  }
>>> @@ -86,6 +84,10 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
>>>                 if (!*description) {
>>>                         kfree(description);
>>>                         description = NULL;
>>> +               } else if ((description[0] == '.') &&
>>> +                          (strncmp(type, "keyring", 7) == 0)) {
>>> +                               ret = -EPERM;
>>> +                               goto error2;
>>>                 }
>>>         }
>> I think it does not another problem...
>> It is not only prevent creating new keyring with ".abc" name but also
>> prevent adding new key...
>>
>> this is wrong...
> Seems to prevent creating a dot prefixed keyring, but permits creating a
> dot prefixed key.  Do you have an example?

I think by mistake I was checking old patch in the thread because I have
not noticed strncmp(type, "keyring", 7).
This patch definitely should do the job.

- Dmitry


> thanks,
>
> Mimi
>
> Mimi
>
>
>

