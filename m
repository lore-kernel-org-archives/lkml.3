Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053Ab3CMRo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:44:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:59972 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096Ab3CMRox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:44:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,838,1355126400"; 
   d="scan'208";a="305704595"
Message-ID: <5140BB13.10806@linux.intel.com>
Date: Wed, 13 Mar 2013 10:44:51 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.9-rc1] Bug in bootup code or debug code?
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp><201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303132224.BEC60922.JStQOFMVFFOHLO@I-love.SAKURA.ne.jp> <3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 08:22 AM, Yu, Fenghua wrote:
>>
>> I found the location of "hardware reset" trigger.
>>
>> It is __pa_symbol(&boot_params) call, for I don't encounter "hardware
>> reset" if
>> I remove the "//" from below debug patch.
>>
>> This bug is not yet fixed as of 3.9.0-rc2-00188-g6c23cbb .
>>
>> --- a/arch/x86/kernel/microcode_intel_early.c
>> +++ b/arch/x86/kernel/microcode_intel_early.c
>> @@ -741,7 +741,9 @@ load_ucode_intel_bsp(void)
>>  #ifdef CONFIG_X86_32
>>         struct boot_params *boot_params_p;
>>
>> +       //while (1);
>>         boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
>> +       while (1);
>>         ramdisk_image = boot_params_p->hdr.ramdisk_image;
>>         ramdisk_size  = boot_params_p->hdr.ramdisk_size;
>>         initrd_start_early = ramdisk_image;
> 
> Tetsuo and Dave,
> 
> That's the place where we suspected to cause the problem.
> 
> My question is: how to access global variable in linear mode in virtualization? __pa_symbol() is not a problem for native.
> 

What kind of virtualization are we talking about here?  We should not be
running this code under any paravirtualized code path -- this is the
hypervisor's job to take care of this.  For HVM, this should just work
the same way.

	-hpa


