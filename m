Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3IMRCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:02:05 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:53461 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3IMRCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:02:03 -0400
Message-ID: <52334506.9030802@linaro.org>
Date: Fri, 13 Sep 2013 13:01:58 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Re: GPT detection regression in efi.c from commit 27a7c64
References: <20130913145033.GA8502@ohporter.com> <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 12:28 PM, Davidlohr Bueso wrote:
> Cc'ing Linus.
>
> On Fri, 2013-09-13 at 10:50 -0400, Matt Porter wrote:
>> The commit, "27a7c64 partitions/efi: account for pmbr size in lba", that
>> was just merged in 3.12-rc caused a regression on my system with a GPT
>> formatted eMMC device. In 3.11, the GPT partition table was detected
>> fine but now a partition table is not detected.
>>
>> Not being a GPT expert, I did some research and found that the tool used
>> to create the PMBR on my system shares characteristics with what is
>> mentioned in an explanation of Microsoft created PMBRs [1]. In short,
>> the size_in_lba field incorrectly has 0xffffffff even though I have a
>> <2TiB drive (16GiB eMMC).
>
> *sigh*. So Microsoft decided to do its own version of the GPT specs.

Don't sound so surprised. :)

> Up until now, Linux was incorrectly enforcing pMBR checks: not
> recognizing valid labels and vice versa, as with the case you are
> mentioning now. The changes that went in the 3.12 merge window attempt
> to address those concerns, enforcing the correct checks - which is also
> how Linux partitioning tools do it (fdisk, parted).

Understood, and we are fixing our own manufacturing tool that was used 
to prepopulate the eMMC. I definitely prefer to have this correct for my 
case.

>> I get that this is not compliant with UEFI. I bring this up because
>> before this commit the is_pmbr_valid() check was less pedantic. In 3.11
>> a PMBR formatted this way did not fail the check. For my particular
>> case, I simply dded out LBA 1 and whacked the SizeInLBA field to comply
>> with the spec and this patch and I'm back in business. We're updating
>> the tools that we inherited to prepopulate our boards with a GPT to be
>> compliant. However, I wondered if this would be a problem for all the
>> people with Windows-generated GPTs as noted in [1].
>
> I guess this comes down to choosing whether or not we want Linux to be
> more UEFI compliant or not. Should we care if Microsoft decides to go do
> things out of the official spec? I don't know the policy here. The fact
> is that *they* should update their partitioning tools and create valid
> pMBRs. Any way, I'm ok with reverting this commit if deemed necessary.

I can't say first-hand that Windows 7/8 does what is claimed in this 
description as I simply don't have access to any Windows machines here. 
If it's true, I would have to agree with Linus that meeting reality if 
more important than meeting the spec.

Hopefully somebody can confirm that Windows does indeed produce these 
special PMBRs that need to be handled as an exception to the spec.

-Matt

