Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaFYBlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:41:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:13776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaFYBlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:41:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,541,1400050800"; 
   d="scan'208";a="533659820"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: RE: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
Thread-Topic: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
Thread-Index: AQHPitp0g7xixZVNTkiLN9tFeBCqMZt+nJAAgAAD+ACAAADtgIAABhEAgAAKEgCAARYTkIAArB+AgACg/iA=
Date: Wed, 25 Jun 2014 01:40:48 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE016B26AB@shsmsx102.ccr.corp.intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-3-git-send-email-qiaowei.ren@intel.com>
 <53A884B2.5070702@mit.edu> <53A88806.1060908@intel.com>
 <CALCETrXYZZiZsDiUvvZd0636+qHP9a0sHTN6wt_ZKjvLaeeBzw@mail.gmail.com>
 <53A88DE4.8050107@intel.com>
 <CALCETrWBbkFzQR3tz1TphqxiGYycvzrFrKc=ghzMynbem=d7rg@mail.gmail.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE016AF41C@shsmsx102.ccr.corp.intel.com>
 <CALCETrX+iS5N8bCUm_O-1E4GPu4oG-SuFJoJjx_+S054K9-6pw@mail.gmail.com>
In-Reply-To: <CALCETrX+iS5N8bCUm_O-1E4GPu4oG-SuFJoJjx_+S054K9-6pw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5P1fQ3H002998

On 2014-06-25, Andy Lutomirski wrote:
> On Mon, Jun 23, 2014 at 10:53 PM, Ren, Qiaowei <qiaowei.ren@intel.com>
> wrote:
>> On 2014-06-24, Andy Lutomirski wrote:
>>>> On 06/23/2014 01:06 PM, Andy Lutomirski wrote:
>>>>> Can the new vm_operation "name" be use for this?  The magic
>>>>> "always written to core dumps" feature might need to be reconsidered.
>>>> 
>>>> One thing I'd like to avoid is an MPX vma getting merged with a
>>>> non-MPX vma.  I don't see any code to prevent two VMAs with
>>>> different vm_ops->names from getting merged.  That seems like a
>>>> bit of a design oversight for ->name.  Right?
>>> 
>>> AFAIK there are no ->name users that don't also set ->close, for
>>> exactly that reason.  I'd be okay with adding a check for ->name, too.
>>> 
>>> Hmm.  If MPX vmas had a real struct file attached, this would all
>>> come for free. Maybe vmas with non-default vm_ops and file != NULL
>>> should never be mergeable?
>>> 
>>>> 
>>>> Thinking out loud a bit... There are also some more complicated
>>>> but more performant cleanup mechanisms that I'd like to go after in the future.
>>>> Given a page, we might want to figure out if it is an MPX page or not.
>>>> I wonder if we'll ever collide with some other user of vm_ops->name.
>>>> It looks fairly narrowly used at the moment, but would this keep
>>>> us from putting these pages on, say, a tmpfs mount?  Doesn't look
>>>> that way at the moment.
>>> 
>>> You could always check the vm_ops pointer to see if it's MPX.
>>> 
>>> One feature I've wanted: a way to have special per-process vmas that
>>> can be easily found.  For example, I want to be able to efficiently
>>> find out where the vdso and vvar vmas are.  I don't think this is
>>> currently supported.
>>> 
>> Andy, if you add a check for ->name to avoid the MPX vmas merged
>> with
> non-MPX vmas, I guess the work flow should be as follow (use
> _install_special_mapping to get a new vma):
>> 
>> unsigned long mpx_mmap(unsigned long len) {
>>     ......
>>     static struct vm_special_mapping mpx_mapping = {
>>         .name = "[mpx]",
>>         .pages = no_pages,
>>     };
>>     
>>     ....... vma = _install_special_mapping(mm, addr, len, vm_flags,
>>     &mpx_mapping); ......
>> }
>> 
>> Then, we could check the ->name to see if the VMA is MPX specific. Right?
> 
> Does this actually create a vma backed with real memory?  Doesn't this
> need to go through anon_vma or something?  _install_special_mapping
> completely prevents merging.
> 
Hmm, _install_special_mapping should completely prevent merging, even among MPX vmas.

So, could you tell me how to set MPX specific ->name to the vma when it is created? Seems like that I could not find such interface.

Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
