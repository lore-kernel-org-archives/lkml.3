Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750804AbaKBEDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 00:03:55 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59862 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaKBEDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 00:03:53 -0400
MIME-Version: 1.0
In-Reply-To: <20141101175129.GC4462@pd.tnic>
References: <1414856696-8094-1-git-send-email-stevenhoneyman@gmail.com>
	<20141101171909.GA5034@pd.tnic>
	<CABz95_BFew81JGAf=oP=6m9yPMi1_JmvfjKgX2CxFmha52A54w@mail.gmail.com>
	<20141101175129.GC4462@pd.tnic>
Date: Sun, 2 Nov 2014 04:03:52 +0000
Message-ID: <CABz95_CYGw1sBro2GtehyczYCEBs-SrSzkgF64ibJsdDvQ24VA@mail.gmail.com>
Subject: Re: [PATCH] x86, cpu: trivial printk formatting fixes
From: Steven Honeyman <stevenhoneyman@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Kosina <trivial@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 November 2014 17:51, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Nov 01, 2014 at 05:38:18PM +0000, Steven Honeyman wrote:
>> On 1 November 2014 17:19, Borislav Petkov <bp@alien8.de> wrote:
>> > On Sat, Nov 01, 2014 at 03:44:56PM +0000, Steven Honeyman wrote:
>> >> A 2 line printk makes dmesg output messy, because the second line does not get a timestamp.
>> >> For example:
>> >>
>> >> [    0.012863] CPU0: Thermal monitoring enabled (TM1)
>> >> [    0.012869] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
>> >> Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
>> >> [    0.012958] Freeing SMP alternatives memory: 28K (ffffffff81d86000 - ffffffff81d8d000)
>> >> [    0.014961] dmar: Host address width 39
>> >
>> > It looks just fine here, albeit with repeated timestamp:
>> >
>> > $ dmesg | grep -E "[id]TLB"
>> > [    0.269607] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
>> > [    0.269607] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
>>
>> That's strange! Is it the same for the other one? I just double
>
> dmesg | grep ENERGY
> [    0.061976] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.061976] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
>
>> checked on the slight chance I had an alias causing problems etc, but
>> that wasn't the case:
>>
>> $ 'dmesg'|'grep' ENERGY
>> [    0.010557] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
>> ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
>> $ dmesg --version && grep --version
>> dmesg from util-linux 2.25.2
>> grep (GNU grep) 2.20
>
> $ dmesg --version && grep --version
> dmesg from util-linux 2.20.1
> grep (GNU grep) 2.20
>
> I've upgraged util-linux (for dmesg) on the other box:
>
> $ dmesg --version && grep --version
> dmesg from util-linux 2.25.1
> grep (GNU grep) 2.18
>
> and now I get:
>
> dmesg | grep -E "[id]TLB"
> [    0.269607] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
> Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
>
> So I'd say it looks like a regression in dmesg itself.

Hmm - the difference is to do with the source of the kernel ring
buffer. The old output format be obtained using the latest dmesg by
adding "-S", which uses syslog(2) rather than /dev/kmsg.
(added in commit 7af230601ab)

The klogctl version interprets the \n and adds the timestamp
afterwards, but /dev/kmsg changes the '\n' to "\x0a" resulting in:
4,355,10557,-;ENERGY_PERF_BIAS: Set to 'normal', was
'performance'\x0aENERGY_P...

It looks as though it's just a matter of opinion/preference whether
control characters are printed (rfc5424)
