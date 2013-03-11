Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3CKJnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:43:11 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:46316 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3CKJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:43:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jingbai Ma <jingbai.ma@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, mingo@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, hpa@zytor.com, yinghai@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
	<20130307152108.GC2790@redhat.com> <87k3piri3e.fsf@xmission.com>
	<20130308155216.GB8219@redhat.com> <513D9338.20402@hp.com>
Date: Mon, 11 Mar 2013 02:42:48 -0700
In-Reply-To: <513D9338.20402@hp.com> (Jingbai Ma's message of "Mon, 11 Mar
	2013 16:18:00 +0800")
Message-ID: <87wqtenug7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/4Y0TPMQdaaS2i7SVrEfGxb1s4mSu7wpQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jingbai Ma <jingbai.ma@hp.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel to speedup kernel dump process
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingbai Ma <jingbai.ma@hp.com> writes:

> On 03/08/2013 11:52 PM, Vivek Goyal wrote:
>> On Thu, Mar 07, 2013 at 01:54:45PM -0800, Eric W. Biederman wrote:
>>> Vivek Goyal<vgoyal@redhat.com>  writes:
>>>
>>>> On Thu, Mar 07, 2013 at 10:58:18PM +0800, Jingbai Ma wrote:
>>>>> This patch intend to speedup the memory pages scanning process in
>>>>> selective dump mode.
>>>>>
>>>>> Test result (On HP ProLiant DL980 G7 with 1TB RAM, makedumpfile
>>>>> v1.5.3):
>>>>>
>>>>> 						Total scan Time
>>>>> Original kernel
>>>>> 	+ makedumpfile v1.5.3 cyclic mode	1958.05 seconds
>>>>> Original kernel
>>>>> 	+ makedumpfile v1.5.3 non-cyclic mode	1151.50 seconds
>>>>> Patched kernel
>>>>> 	+ patched makedumpfile v1.5.3		17.50 seconds
>>>>>
>>>>> Traditionally, to reduce the size of dump file, dumper scans all memory
>>>>> pages to exclude the unnecessary memory pages after capture kernel
>>>>> booted, and scan it in userspace code (makedumpfile).
>>>>
>>>> I think this is not a good idea. It has several issues.
>>>
>>> Actually it does not appear to be doing any work in the first kernel.
>>
>> Looks like patch3 in series is doing that.
>>
>>                          machine_crash_shutdown(&fixed_regs);
>> +                       generate_crash_dump_bitmap();
>>                          machine_kexec(kexec_crash_image);
>>
>> So this bitmap seems to be being set just before transitioning into
>> second kernel.
>>
>> I am sure you would not like this extra code in this path. :-)
>
> I was thought this function code is pretty simple, could be called
> here safely.
> If it's not proper for here, how about before the function
> machine_crash_shutdown(&fixed_regs)?
> Furthermore, could you explain the real risks to execute more codes here?

The kernel is known bad.  What is bad is unclear.
Executing any extra code is a bad idea.

The history here is that before kexec-on-panic there were lots of dump
routines that did all of the crashdump logic in the kernel before they
shutdown.  They all worked beautifully during development, and on
developers test machines and were absolutely worthless in real world
situations.

A piece of code that walks all of the page tables is most definitely
opening itself up to all kinds of failure situations I can't even
imagine.

The only way that it would be ok to do this would be to maintain the
bitmap in real time with the existing page table maintenance code,
and that would only be ok if it did not add a performance penalty.

Every once in a great while there is a new cpu architecture feature
we need to deal with, but otherwise the only thing that is ok to
do on that code path is to reduce it until it much more closely
resembles the glorified jump instruction that it really is.

Speaking of have you given this code any coverage testing with lkdtm?

Eric

