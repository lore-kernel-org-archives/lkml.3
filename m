Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3GWVor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:44:47 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:65073 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3GWVoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130723151552.GF8497@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
	<20130723151552.GF8497@pd.tnic>
Date: Tue, 23 Jul 2013 23:44:45 +0200
Message-ID: <CAPVoSvSWBmuZKAuQiOq1VS0oFqQSAwr8gUWisXEdfiYMGrZZEw@mail.gmail.com>
Subject: Re: [PATCH]Fix early microcode loading on AMD
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 5:15 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Jul 23, 2013 at 01:58:53PM +0200, Torsten Kaiser wrote:
>> Fixup the early AMD microcode loading.
>>
>> * load_microcode_amd() (and the helper its using) should not have an
>> cpu parameter.
>
> Hmm, I don't think so - we get the cpu handed down from microcode_core
> and besides the early load on 32bit needs to do find_patch(cpu).
>
>> The microcode loading is not depending on the CPU it is
>
> Mostly. There are mixed-stepping boxes which need to differentiate
> between which cpu we're applying the patch for.

I redid the patch in 5 parts, hopefully now better to understand.
Without the other changes the microcode_amd.c-part of patch 5/5 should
make it much more obvious that my change did not result in a different
behavior about which patches get loaded into the microcode cache
'pcache'.

> Btw, your config boots on my F14h box with "nomodeset" on the command
> line because it is missing radeon firmware for my gpu.
>
>> executed and all the loaded patches will end up in a global list for all
>> CPUs anyway.
>> * Return -1 (like Intels apply_microcode) when the loading fails,
>> also do not set the active microcode level on failure.
>
> Yep, this part I want. Please send it as a separate patch.

That is now patch 1/5.
Patch 2/5 is new, I skipped that part originally because I did not
want to make it even bigger...

> So I see a couple of issues in this patch and they should be separated
> into single patches - one patch taking care of one issue and explaining
> what the problem is in the commit message (I know you can do that good
> :)).


I'm still seeing some things in the microcode code that look suspicious:

Why is the X86_64 code updating uci->cpu_sig.rev, but the 32bit
version does not? And I can't see anything that reads that value.

Should apply_microcode_amd() really update uci->mc even before
checking if the microcode is newer?

The X86_32 hunk in save_microcode_in_initrd_amd() now seems obsolete.
load_microcode_amd() is no longer using find_patch() so it doesn't use
ucode_cpu_info anymore. But why is that code using
boot_cpu_data.cpu_index to find the BSP but always then passing 0 as
cpu parameter to load_microcode_amd()? If boot_cpu_data.cpu_index is
ever !=0 that code would fail.

... and collect_cpu_info_amd() also looks very weird. If csig would
not point to uci->cpu_sig then find_patch() will not be happy.
Wouldn't directly passing cpuid_eax(0x00000001) to find_patch() be a
better interface? Then the early microcode loading code would not need
to access ucode_cpu_info at all.

Torsten
