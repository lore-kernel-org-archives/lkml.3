Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaGGQMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:12:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25381 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaGGQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:12:34 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-74-53bac6eefc04
Message-id: <53BAC6A6.2010509@samsung.com>
Date: Mon, 07 Jul 2014 19:11:18 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH v3 1/3] ima: use ahash API for file hash calculation
References: <cover.1404475462.git.d.kasatkin@samsung.com>
 <dc5977267c662c98f02cd637dd44c42be850916f.1404475462.git.d.kasatkin@samsung.com>
 <1404734207.3029.22.camel@dhcp-9-2-203-236.watson.ibm.com>
 <53BAA281.7040903@samsung.com>
 <1404747894.3029.58.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1404747894.3029.58.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xy7rvju0KNtjzR9fiy9I6i/v3fjJZ
	vJwxj93i8q45bBYfeh6xWXxaMYnZgc1j56y77B4PDm1m8di94DOTx+dNcgEsUVw2Kak5mWWp
	Rfp2CVwZt9omMxd0ildcbn7E1sC4S6iLkZNDQsBE4vbiq8wQtpjEhXvr2UBsIYGljBLTDxp2
	MXIB2Y1MEj+ffWeDcGYxSrw5fosVpIpXQEtiQ89ldhCbRUBV4u+MRkYQm01AT2JD8w+wuKhA
	hMSBvmdQ9YISPybfYwGxRQQ0JY61fmQEGcossJpRYl/fQ7AGYQEPiZuvvzBDbFvOJPFgx0uw
	+zgF3CUa519iArGZBdQlJs1bxAxhy0tsXvOWGeJuVYnutWvZIP5RlDg9+RzzBEbhWUiWz0LS
	PgtJ+wJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIdHxdQfj0mNWhxgFOBiVeHhv7N8Z
	LMSaWFZcmXuIUYKDWUmEd8XyXcFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGN2aNrJyV5a4TBAT
	K/1pcPVz0xb/Z+fXZbXvffLWQ5klLulz6pOZLNlqSUcPFM4ymdcRvt158mrXmcYrLOPk2Nzv
	F6/x1OrpXnEi2ce6ue9qoJ0Yk+uakKkBJXtYt+UGO1+L5fzePT3x3qRN882eMHoKBC1bVZFx
	iz876YzBR9+Nd2XOFV8JV2Ipzkg01GIuKk4EAPqMBuRsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/14 18:44, Mimi Zohar wrote:
> On Mon, 2014-07-07 at 16:37 +0300, Dmitry Kasatkin wrote: 
>> On 07/07/14 14:56, Mimi Zohar wrote:
>>> On Fri, 2014-07-04 at 15:05 +0300, Dmitry Kasatkin wrote: 
>>>> +/**
>>> This is the kernel-doc delimiter.
>>>
>>>> + * ima_calc_file_hash - calculae file hash
>>>> + *
>>> Missing kernel-doc argument descriptions.  Refer to
>>> Documentation/kernel-doc-nano-HOWTO.txt.
> Not defining the arguments results in a kernel-doc warning.  Providing
> kernel-doc is nice, but is unnecessary in this case, as it isn't an
> exported loadable module, nor an externally visible function to other
> kernel files.  Either remove the extra asterisk, making it a regular
> comment, or add the arguments.
>
>> There is no need to explain arguments as they self-evident.
>>
>>>> + * if ima_ahash_minsize parameter is non-zero, this function uses
>>>> + * ahash for hash caclulation. ahash performance varies for different
>>>> + * data sizes on different crypto accelerators. shash performance might
>>>> + * be better for small file. 'ima.ahash_minsize' module parameter allows
>>>> + * to specify the best value for the system.
>>>> + *
>>>> + * If ahash fails, it fallbacks to shash.
>>>> + */
>>>> +int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>>>> +{
>>>> +	loff_t i_size;
>>>> +	int rc;
>>>> +
>>>> +	i_size = i_size_read(file_inode(file));
>>>> +
>>>> +	if (ima_ahash_minsize && i_size >= ima_ahash_minsize) {
>>>> +		rc = ima_calc_file_ahash(file, hash);
>>>> +		if (!rc)
>>>> +			return 0;
>>>> +	}
>>>> +
>>>> +	return ima_calc_file_shash(file, hash);
>>>> +}
>>> If the crypto accelerator fails, it falls back to using shash.  Is their
>>> any indication that the HW error is intermittent or persistent?  Should
>>> ima_ahash_minsize be reset?
>> If hw constantly does not work then it is simply broken.
> True
>
>> You want to be protected from "random" failures.
>> For me it is not the case either... If it works then it works...
> This discussion isn't about your particular HW environment, but a
> general question.  For example, suppose we were discussing a laptop with
> a HW crypto accelerator.  If the HW crypto broke, I would at least want
> to be able to quiesce the system properly.  I'd most likely want to be
> able to continue using my laptop with software crypto.

Driver probing code will detect that HW is not responding and driver
will not be enabled...

IMA will not be able to use it...

It is the same story as with any other HW and driver in the system.

>>> If the crypto accelerator, built as a kernel module, is removed,
>>> ima_ahash_minsize would still be set.  It would continue to use ahash.
>>> Is this the correct behavior? Or should ima_ahash_minsize be reset?
>>>
>> It cannot be removed, because it is used and module usage counter
>> protects from removing...
> Ok
>
> Mimi
>
>

