Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaGHIIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:08:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61364 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHIIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:08:32 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ea-53bba6fdeefb
Message-id: <53BBA6B4.7030705@samsung.com>
Date: Tue, 08 Jul 2014 11:07:16 +0300
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
 <53BAC6A6.2010509@samsung.com>
 <1404750875.3029.79.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1404750875.3029.79.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xa7p/l+0ONnh9T9ziy9I6i/v3fjJZ
	vJwxj93i8q45bBYfeh6xWXxaMYnZgc1j56y77B4PDm1m8di94DOTx+dNcgEsUVw2Kak5mWWp
	Rfp2CVwZ306sZyqYKlVx4sdLtgbGftEuRk4OCQETiTXPXzNB2GISF+6tZ+ti5OIQEljKKHH+
	1mJ2CKeRSeL84xlQzixGiTUndgOVcXDwCmhJdL5MBulmEVCVWHb1IguIzSagJ7Gh+Qc7iC0q
	ECFxoO8ZK4jNKyAo8WPyPbAaEQFNiWOtHxlBZjILrGaU2Nf3EKxBWMBD4ubrL8wQy1qZJW49
	6wVLcAq4S7Rs2g/WzSygLjFp3iJmCFteYvOat2C2ENAV3WvXskH8oyhxevI55gmMwrOQLJ+F
	pH0WkvYFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKi48sOxsXHrA4xCnAwKvHwatTu
	DhZiTSwrrsw9xCjBwawkwrthPlCINyWxsiq1KD++qDQntfgQIxMHp1QDo5DUB8bV6hUFR3Jm
	Vy97fEHvUsnzXeUOwqFveb3XshyUL/pzTvVT6Z7Uvt0Z8R3b5qr/0ZkWuCB9i0roVcEupT+6
	hrp8v/wdsr2VT1sbFRietONhSHRXehi0bbLeT36z0isem9+aPOHQevWvtJdHwnOxahDfzrl1
	XJFb82de3uM9f9r/c4+ClViKMxINtZiLihMBORO+gWwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/14 19:34, Mimi Zohar wrote:
> On Mon, 2014-07-07 at 19:11 +0300, Dmitry Kasatkin wrote: 
>> On 07/07/14 18:44, Mimi Zohar wrote:
>>> On Mon, 2014-07-07 at 16:37 +0300, Dmitry Kasatkin wrote: 
>>>> On 07/07/14 14:56, Mimi Zohar wrote:
>>>>> On Fri, 2014-07-04 at 15:05 +0300, Dmitry Kasatkin wrote: 
>>>>>> +/**
>>>>> This is the kernel-doc delimiter.
>>>>>
>>>>>> + * ima_calc_file_hash - calculae file hash
>>>>>> + *
>>>>> Missing kernel-doc argument descriptions.  Refer to
>>>>> Documentation/kernel-doc-nano-HOWTO.txt.
>>> Not defining the arguments results in a kernel-doc warning.  Providing
>>> kernel-doc is nice, but is unnecessary in this case, as it isn't an
>>> exported loadable module, nor an externally visible function to other
>>> kernel files.  Either remove the extra asterisk, making it a regular
>>> comment, or add the arguments.
>>>
>>>> There is no need to explain arguments as they self-evident.
>>>>
>>>>>> + * if ima_ahash_minsize parameter is non-zero, this function uses
>>>>>> + * ahash for hash caclulation. ahash performance varies for different
>>>>>> + * data sizes on different crypto accelerators. shash performance might
>>>>>> + * be better for small file. 'ima.ahash_minsize' module parameter allows
>>>>>> + * to specify the best value for the system.
>>>>>> + *
>>>>>> + * If ahash fails, it fallbacks to shash.
>>>>>> + */
>>>>>> +int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>>>>>> +{
>>>>>> +	loff_t i_size;
>>>>>> +	int rc;
>>>>>> +
>>>>>> +	i_size = i_size_read(file_inode(file));
>>>>>> +
>>>>>> +	if (ima_ahash_minsize && i_size >= ima_ahash_minsize) {
>>>>>> +		rc = ima_calc_file_ahash(file, hash);
>>>>>> +		if (!rc)
>>>>>> +			return 0;
>>>>>> +	}
>>>>>> +
>>>>>> +	return ima_calc_file_shash(file, hash);
>>>>>> +}
>>>>> If the crypto accelerator fails, it falls back to using shash.  Is their
>>>>> any indication that the HW error is intermittent or persistent?  Should
>>>>> ima_ahash_minsize be reset?
>>>> If hw constantly does not work then it is simply broken.
>>> True
>>>
>>>> You want to be protected from "random" failures.
>>>> For me it is not the case either... If it works then it works...
>>> This discussion isn't about your particular HW environment, but a
>>> general question.  For example, suppose we were discussing a laptop with
>>> a HW crypto accelerator.  If the HW crypto broke, I would at least want
>>> to be able to quiesce the system properly.  I'd most likely want to be
>>> able to continue using my laptop with software crypto.
>> Driver probing code will detect that HW is not responding and driver
>> will not be enabled...
>>
>> IMA will not be able to use it...
>>
>> It is the same story as with any other HW and driver in the system.
> Right, but my concern is not about unloading the kernel module, but
> about the IMA module parameters left initialized.  The existing code
> will continue using ahash (software version), even though the kernel
> module was unloaded, not shash.  My question is about the software
> implementations of ahash vs. shash performance.
>
> Mimi

If HW driver will not be available, ahash loads generic driver which is
using shash.
Performance of that will be the same as for using shash directly.

- Dmitry

>

