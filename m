Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3CFRwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:52:03 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56436 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab3CFRwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:52:00 -0500
Message-ID: <5137822F.2030501@linux.vnet.ibm.com>
Date: Wed, 06 Mar 2013 09:51:43 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: bp@alien8.de, hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp> <51367104.5050200@linux.vnet.ibm.com>	<20130305224432.GD27022@pd.tnic> <201303062358.EFG90616.HLtSQFJFOMVOFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201303062358.EFG90616.HLtSQFJFOMVOFO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030617-9360-0000-0000-00001132D80F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 06:58 AM, Tetsuo Handa wrote:
> Borislav Petkov wrote:
>> Ok, before we continue guessing stuff, Tetsuo, can you please explain
>> how exactly you're triggering this. More specifically, we need .config,
>> hypervisor version, I'm assuming kernel is 3.9-rc1, Linux is guest/host
>> etc, etc.
> 
> I'm using CentOS 6.3 x86_32 guest running on VMware Workstation 6.5.5 for
> Windows XP x86_32 host and VMware Player 4.0.5 for Windows 7 x86_64 host.
> 
> Kernel version is 3.9-rc1 x86_32. This bug can be triggered only when the
> guest has little RAM such that /proc/meminfo reports that HighTotal == 0.
> Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc1-acpi .
> 
> I don't know why but changing kernel config to CONFIG_ACPI=n
> ( http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc1-noacpi ) solves this bug.
> Well, should I run bisection on ACPI code?

I was able to reproduce and got some better debugging out of this:

[    0.193170] __cpa_process_fault(c1673e90, e4afa000, 1)
[    0.208752] max_pfn_mapped: 150528
[    0.218886] PAGE_OFFSET: c0000000
[    0.228597] PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)): e4c00000
[    0.247837] slow_virt_to_phys(e4afa000): 0

The pte looks to actually _be_ empty:

[   44.038145] slow_virt_to_phys() pte: 0000000000000000 level: 1

Not sure what's going on in the end, but it does appear this is another
win for the new BUG_ON().  There really does look to be a real bug here.

BTW, the BUG_ON() is proving to be woefully inadequate.  We need some
better diagnostic messages out of there, and probably a nice dump of the
pagetable walk too.

