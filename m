Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3CKUjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:39:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38114 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3CKUjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:39:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
References: <20130311144853.GB8482@redhat.com>
	<20130311150256.GC8482@redhat.com>
	<CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
	<20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com>
	<CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
	<513E28B8.3000502@zytor.com>
	<CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
	<20130311192021.GF12107@redhat.com> <513E36CB.5040908@zytor.com>
	<20130311201245.GC14738@redhat.com> <513E3C44.9030402@zytor.com>
Date: Mon, 11 Mar 2013 13:38:53 -0700
In-Reply-To: <513E3C44.9030402@zytor.com> (H. Peter Anvin's message of "Mon,
	11 Mar 2013 13:19:16 -0700")
Message-ID: <87hakhk6xu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19X/CpTMBPaAyQKX1flie8P/vtN3azzjVg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 03/11/2013 01:12 PM, Vivek Goyal wrote:
>>>
>>> Quite frankly the whole design seems to be held together with chewing
>>> gum.  At the core, the problem is a tight coupling between kexec-tools
>>> version, kexec-tools options, and kernel command line options that have
>>> to be combined in very ugly ways.  Part of the reason is that the kernel
>>> isn't actually given the information it needs to do the job required.
>>>
>>> As far as "if a user wants to load"... why on Earth should that be the
>>> default?  How could that *not* be an exceptional case?
>> 
>> Because it breaks existing user cases. We had this limitation so far
>> that bzImage has to be loaded in first 896MB. And for 32bit bzImage
>> entry, I think that is still true?
>> 
>> So how can kernel assume that user is always loading a 64bit bzImage
>> and reserve memory accordingly.
>> 
>> Also in the past we did not have relocatable kernel and memory had to
>> be reserved at the address new kernel is built. Thankfully that is
>> no more the case.
>> 
>
> The problem with this argument here is that we are spiraling down the
> drain of increasing user-visible complexity in order to not break
> existing but exotic use cases.  We need to stop and reverse this trend.
>  I want to make a few observations on this:

> 1. Running with an archaic kexec-tools should be considered an anomaly.
>  If necessary, we could introduce a kernel option to let the kernel know
> which kexec-tools version the user will use.

Sure.  Running with the last release of kexec-tools before new changes
were made is not at all unreasonable, as updating both tools in sync is
a practical problem.

Having thought about this a little more with no changes and reserving
memory high we can run with any memory location we want as the syntax
crashkernel=AMOUNT@LOC is still supported.

A distro may not be able to automate that but shrug, a distro can
upgrade to the latest and greatest version of the tools assuming
those tools can support loading high.

> 2. As long as memory is available, there is always the option to shift
> memory around to accommodate the crashkernel.  That probably should have
> been done all along.

Arguable.  The core strategy is to reserve memory at the beginning of
time so we have memory that we know has never been used for DMA, so
there is a very strong chance that memory will never be the target of
a DMA operation.  The expectation is that we do the shifting around at
boot time.

I doubt we have a mechanism in place that can actually shift around
memory in the quantities some people are after, after a system boots.

Now quite frankly I think there are some very silly things going on.
Why does makedumpfile need to allocate and create a huge bitmap of
which pages to dump?

Last I was playing with this I had my amount of reserved memory down to
32MiB or was it 8MiB.  It was very small and for the small system I was
on it worked fine.

I totally makes sense to figure out how to load a kernel high.  I am not
convinced kexec on panic is the best use of that ability.  I would argue
that it might be better to figure out how to use a small memory
foot-print and try to keep that foot-print from growing.

Eric
