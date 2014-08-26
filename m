Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbaHZWFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:05:53 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52952 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaHZWFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:05:51 -0400
MIME-Version: 1.0
In-Reply-To: <53FD01D0.8020203@zytor.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<53FD01D0.8020203@zytor.com>
Date: Tue, 26 Aug 2014 15:05:50 -0700
X-Google-Sender-Auth: 9pcT_N6NCLpjC5xpvTl94zEoiEw
Message-ID: <CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 2:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/26/2014 02:45 PM, Yinghai Lu wrote:
>> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
>> loaded above 4G"), the kernel freezes at the earliest possible moment
>> when trying to boot via UEFI on Asus laptop.
>>
>> There are buggy EFI implementations: with EFI run time, kernel need
>> to load file with 512bytes alignment when buffer is above 4G.
>>
>
> This makes absolutely zero sense.  Please explain what the actual
> problem is here.

The firmware has bug and can use buffer above 4G to read files.
and if the file size is 512 bytes alignment, then reading could go through.

>From Mantas:
--
On Wed, Aug 20, 2014 at 12:05 PM, Mantas Mikulėnas <grawity@gmail.com> wrote:
>
> I experimented with some things (like setting chunk size to a few kB
> to see if it hangs earlier or only at the very end; etc.), and finally
> found out that it stops freezing if I pad the initrd file to a
> multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
> bytes will not.
>
> ...In other words, seems like it cannot read chunks that aren't
> multiples of 512 into a location above 4 GB. Or something like that..


>From Matt:
---
> OK, we're out of options here. Yinghai, we're going to have to revert
> your patch, 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G")
>
> We could conceivably add a boot parameter option to attempt loading
> inirds above 4G, but we can't turn the feature on by default because of
> all these buggy EFI implementations - things must work out of the box.
