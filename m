Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaBZTAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:00:45 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:58492 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaBZTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:00:44 -0500
MIME-Version: 1.0
In-Reply-To: <5306BD8D.3030606@intel.com>
References: <1392230186-16130-1-git-send-email-qiaowei.ren@intel.com>
 <1392230186-16130-3-git-send-email-qiaowei.ren@intel.com> <52FBD74F.7050203@mit.edu>
 <5306BD8D.3030606@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Feb 2014 11:00:21 -0800
Message-ID: <CALCETrU4-ew7qNn5TWx=Y0Vizzvf+vPoS8DmQbT=wRQs4_yHsg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] x86, mpx: hook #BR exception handler to allocate
 bound tables
To: Ren Qiaowei <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 6:44 PM, Ren Qiaowei <qiaowei.ren@intel.com> wrote:
> On 02/13/2014 04:19 AM, Andy Lutomirski wrote:
>>
>> On 02/12/2014 10:36 AM, Qiaowei Ren wrote:
>>>
>>> An access to an invalid bound directory entry will cause a #BR
>>> exception. This patch hook #BR exception handler to allocate
>>> one bound table and bind it with that buond directory entry.
>>>
>>> This will avoid the need of forwarding the #BR exception
>>> to the user space when bound directory has invalid entry.
>>>
>>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>>> ---
>>> +void do_mpx_bt_fault(struct xsave_struct *xsave_buf)
>>> +{
>>> +       unsigned long status;
>>> +       unsigned long bd_entry, bd_base;
>>> +       unsigned long bd_size = 1UL << (MPX_L1_BITS+MPX_L1_SHIFT);
>>> +
>>> +       bd_base = xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ADDR_MASK;
>>> +       status = xsave_buf->bndcsr.status_reg;
>>> +
>>> +       bd_entry = status & MPX_BNDSTA_ADDR_MASK;
>>> +       if ((bd_entry >= bd_base) && (bd_entry < bd_base + bd_size))
>>> +               allocate_bt(bd_entry);
>>> +}
>>
>>
>> This still just loops on failure, right?
>>
> Seems like that SIGBUS should be raised if the allocation fail.
>
>         if (!do_mpx_bt_fault(xsave_buf))
>                 force_sig(SIGBUS, tsk);

I wonder if this should go through the force_sig_info path.

--Andy

>
> Thanks,
> Qiaowei
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
