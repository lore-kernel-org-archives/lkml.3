Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbaDIQrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:47:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:41401 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898AbaDIQrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:47:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,827,1389772800"; 
   d="scan'208";a="510245988"
Message-ID: <534578FB.8010807@intel.com>
Date: Thu, 10 Apr 2014 00:44:43 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Alessandro Rubini <rubini@gnudd.com>
CC: gregkh@linuxfoundation.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [FMC] BUG: scheduling while atomic: swapper/1/0x10000002
References: <5344BF60.5050300@intel.com> <20140409050843.GA18949@mail.gnudd.com> <20140409052816.GA29432@localhost>
In-Reply-To: <20140409052816.GA29432@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 01:28 PM, Fengguang Wu wrote:
> On Wed, Apr 09, 2014 at 07:08:43AM +0200, Alessandro Rubini wrote:
>> Hello.
>> Thank you for the report.
>>
>> I'm at a conference and I fear I won't be able to test myself in the
>> next days, but I think this is already fixed (it is part of
>> the "misc_register" call path, so it's the same problem).
>>
>> The fix is commit v3.11-rc2-11-g783c2fb
>>
>>    783c2fb FMC: fix locking in sample chardev driver
>>
>> This commit, however, is not part of v3.11 and I think this is why you
>> are finding the problem in the v3.10..v3.11 interval.
> 
> Alessandro, you are right. There are no more "scheduling while 
> atomic" bugs in v3.12 and v3.13.
> 
> Our bisect log shows
> 
> git bisect  bad 38dbfb59d1175ef458d006556061adeaa8751b72  # 10:03      0-    345  Linus 3.14-rc1
> 
> However that happen to be caused by an independent "scheduling while
> atomic" bug:

Alessandro, Fengguang & I confirmed that this below dmesg is also caused by over locking in fc_probe(). Not a new introduced bug.

> 
> [   20.038125] Fixing recursive fault but reboot is needed!
> [   20.038125] BUG: scheduling while atomic: kworker/0:1H/77/0x00000005
> [   20.038125] INFO: lockdep is turned off.
> [   20.038125] irq event stamp: 758
> [   20.038125] hardirqs last  enabled at (757): [<c1c31683>] _raw_spin_unlock_irq+0x22/0x30
> [   20.038125] hardirqs last disabled at (758): [<c1c31523>] _raw_spin_lock_irq+0x14/0x73
> [   20.038125] softirqs last  enabled at (302): [<c1032d4d>] __do_softirq+0x186/0x1d2
> [   20.038125] softirqs last disabled at (295): [<c1002f99>] do_softirq_own_stack+0x2f/0x35
> [   20.038125] CPU: 0 PID: 77 Comm: kworker/0:1H Tainted: G      D W    3.14.0-rc1 #1
> [   20.038125] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   20.038125]  c0420610 c0420610 c0449a38 c1c1f562 c0449a54 c1c1b59c c1f91661 c0420938
> [   20.038125]  0000004d 00000005 c0420610 c0449acc c1c2e4e2 c105fff8 01449a7c 000004af
> [   20.038125]  c0420610 0000002c 00000001 c0449a7c c0420610 c0449ab4 c106001c 00000000
> [   20.038125] Call Trace:
> [   20.038125]  [<c1c1f562>] dump_stack+0x16/0x18
> [   20.038125]  [<c1c1b59c>] __schedule_bug+0x5d/0x6f
> [   20.038125]  [<c1c2e4e2>] __schedule+0x45/0x55f
> [   20.038125]  [<c105fff8>] ? vprintk_emit+0x367/0x3a4
> [   20.038125]  [<c106001c>] ? vprintk_emit+0x38b/0x3a4
> [   20.038125]  [<c105876b>] ? trace_hardirqs_off+0xb/0xd
> [   20.038125]  [<c1c1c185>] ? printk+0x38/0x3a
> [   20.038125]  [<c1c2ea59>] schedule+0x5d/0x5f
> [   20.038125]  [<c10314b8>] do_exit+0xcc/0x75d
> [   20.038125]  [<c1060e7b>] ? kmsg_dump+0x184/0x191
> [   20.038125]  [<c1060d13>] ? kmsg_dump+0x1c/0x191
> [   20.038125]  [<c1003d54>] oops_end+0x7e/0x83
> [   20.038125]  [<c1c1ae82>] no_context+0x1ba/0x1c2
> [   20.038125]  [<c1c1afc1>] __bad_area_nosemaphore+0x137/0x13f
> [   20.038125]  [<c1c1a82d>] ? pte_offset_kernel+0x13/0x2a
> [   20.038125]  [<c1c1aa5f>] ? spurious_fault+0x75/0xd5
> [   20.038125]  [<c1c1afdb>] bad_area_nosemaphore+0x12/0x14
> 
> Thanks,
> Fengguang
> 
