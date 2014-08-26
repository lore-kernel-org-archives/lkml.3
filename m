Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaHZWRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:17:00 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47940 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbaHZWQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:16:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<53FD01D0.8020203@zytor.com>
	<CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
Date: Wed, 27 Aug 2014 01:16:57 +0300
Message-ID: <CAPWNY8WG3E7oZdZDdYsrnGM5pG4kWAKkEq0Eh5Hc_uXJ_8zD5g@mail.gmail.com>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 1:05 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Aug 26, 2014 at 2:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 08/26/2014 02:45 PM, Yinghai Lu wrote:
>>> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
>>> loaded above 4G"), the kernel freezes at the earliest possible moment
>>> when trying to boot via UEFI on Asus laptop.
>>>
>>> There are buggy EFI implementations: with EFI run time, kernel need
>>> to load file with 512bytes alignment when buffer is above 4G.
>>>
>>
>> This makes absolutely zero sense.  Please explain what the actual
>> problem is here.
>
> The firmware has bug and can use buffer above 4G to read files.
> and if the file size is 512 bytes alignment, then reading could go through.
>
> From Mantas:
> --
> On Wed, Aug 20, 2014 at 12:05 PM, Mantas Mikulėnas <grawity@gmail.com> wrote:
>>
>> I experimented with some things (like setting chunk size to a few kB
>> to see if it hangs earlier or only at the very end; etc.), and finally
>> found out that it stops freezing if I pad the initrd file to a
>> multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
>> bytes will not.
>>
>> ...In other words, seems like it cannot read chunks that aren't
>> multiples of 512 into a location above 4 GB. Or something like that..

Note that I'm mostly clueless about how EFI works (my "debugging" is
mostly just 'efi_printk()'s to see where it hangs), so take my
description with a grain of salt...

In particular, I just realized yesterday that I don't know whether
it's referring to physical or virtual addresses in the initrd load
code -- and the laptop only has 4 GB of memory, so the kernel
shouldn't be using larger physical addresses in the first place.
(Virtual ones, on the other hand, /would/ mean a weird bug like
described above.)

-- 
Mantas Mikulėnas <grawity@gmail.com>
