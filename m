Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaFYVnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:43:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:34504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbaFYVnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:43:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,548,1400050800"; 
   d="scan'208";a="563476439"
Message-ID: <53AB4271.6040301@intel.com>
Date: Wed, 25 Jun 2014 14:43:13 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-3-git-send-email-qiaowei.ren@intel.com> <53A884B2.5070702@mit.edu> <53A88806.1060908@intel.com> <CALCETrXYZZiZsDiUvvZd0636+qHP9a0sHTN6wt_ZKjvLaeeBzw@mail.gmail.com> <53A88DE4.8050107@intel.com> <CALCETrWBbkFzQR3tz1TphqxiGYycvzrFrKc=ghzMynbem=d7rg@mail.gmail.com> <9E0BE1322F2F2246BD820DA9FC397ADE016AF41C@shsmsx102.ccr.corp.intel.com> <CALCETrX+iS5N8bCUm_O-1E4GPu4oG-SuFJoJjx_+S054K9-6pw@mail.gmail.com> <9E0BE1322F2F2246BD820DA9FC397ADE016B26AB@shsmsx102.ccr.corp.intel.com> <CALCETrWmmVC2qQtL0Js_Y7LvSPdTh5Hpk6c5ZG3Rt8uTJBWoHQ@mail.gmail.com>
In-Reply-To: <CALCETrWmmVC2qQtL0Js_Y7LvSPdTh5Hpk6c5ZG3Rt8uTJBWoHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 02:04 PM, Andy Lutomirski wrote:
> On Tue, Jun 24, 2014 at 6:40 PM, Ren, Qiaowei <qiaowei.ren@intel.com> wrote:
>> Hmm, _install_special_mapping should completely prevent merging, even among MPX vmas.
>>
>> So, could you tell me how to set MPX specific ->name to the vma when it is created? Seems like that I could not find such interface.
> 
> You may need to add one.
> 
> I'd suggest posting a new thread to linux-mm describing what you need
> and asking how to do it.

I shared this with Qiaowei privately, but might as well repeat myself
here in case anyone wants to set me straight.

Most of the interfaces do to set vm_ops do it in file_operations ->mmap
op.  Nobody sets ->vm_ops on anonymous VMAs, so we're in uncharted
territory.

My suggestion: you can either plumb a new API down in to mmap_region()
to get the VMA or set ->vm_ops, or just call find_vma() after
mmap_region() or get_unmapped_area() and set it manually.  Just make
sure you still have mmap_sem held over the whole thing.

I think I prefer just setting ->vm_ops directly, even though it's a wee
bit of a hack to create something just to look it up a moment later.
Oh, well.

