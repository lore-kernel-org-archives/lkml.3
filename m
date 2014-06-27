Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaF0A1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 20:27:05 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:50205 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF0A1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 20:27:03 -0400
MIME-Version: 1.0
In-Reply-To: <53ACB8A7.9050002@intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-3-git-send-email-qiaowei.ren@intel.com> <53A884B2.5070702@mit.edu>
 <53A88806.1060908@intel.com> <CALCETrXYZZiZsDiUvvZd0636+qHP9a0sHTN6wt_ZKjvLaeeBzw@mail.gmail.com>
 <53A88DE4.8050107@intel.com> <CALCETrWBbkFzQR3tz1TphqxiGYycvzrFrKc=ghzMynbem=d7rg@mail.gmail.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE016AF41C@shsmsx102.ccr.corp.intel.com>
 <CALCETrX+iS5N8bCUm_O-1E4GPu4oG-SuFJoJjx_+S054K9-6pw@mail.gmail.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE016B26AB@shsmsx102.ccr.corp.intel.com>
 <CALCETrWmmVC2qQtL0Js_Y7LvSPdTh5Hpk6c5ZG3Rt8uTJBWoHQ@mail.gmail.com>
 <CALCETrUD3L5Ta_v+NqgUrTk7Ok3zE=CRg0rqeKthOj2OORCLKQ@mail.gmail.com>
 <53AB42E1.4090102@intel.com> <CALCETrVTTh9yuXH0hfcOpytyBd25K6thPfqqUBQtnOqx90ZRqw@mail.gmail.com>
 <53ACA5B3.3010702@intel.com> <CALCETrVceOhRunCg1b9Q3VL10Kcb+uA-HFUURnq5f2S63_jACg@mail.gmail.com>
 <53ACB8A7.9050002@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 26 Jun 2014 17:26:40 -0700
Message-ID: <CALCETrVR9QB3QvA2x_JjAXCFoqMw4B+byFTPDC3gQMUC1C-2NA@mail.gmail.com>
Subject: Re: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Ren, Qiaowei" <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 5:19 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 06/26/2014 04:15 PM, Andy Lutomirski wrote:
>> So here's my mental image of how I might do this if I were doing it
>> entirely in userspace: I'd create a file or memfd for the bound tables
>> and another for the bound directory.  These files would be *huge*: the
>> bound directory file would be 2GB and the bounds table file would be
>> 2^48 bytes or whatever it is.  (Maybe even bigger?)
>>
>> Then I'd just map pieces of those files wherever they'd need to be,
>> and I'd make the mappings sparse.  I suspect that you don't actually
>> want a vma for each piece of bound table that gets mapped -- the space
>> of vmas could end up incredibly sparse.  So I'd at least map (in the
>> vma sense, not the pte sense) and entire bound table at a time.  And
>> I'd probably just map the bound directory in one big piece.
>>
>> Then I'd populate it in the fault handler.
>>
>> This is almost what the code is doing, I think, modulo the files.
>>
>> This has one killer problem: these mappings need to be private (cowed
>> on fork).  So memfd is no good.
>
> This essentially uses the page cache's radix tree as a parallel data
> structure in order to keep a vaddr->mpx_vma map.  That's not a bad idea,
> but it is a parallel data structure that does not handle copy-on-write
> very well.
>
> I'm pretty sure we need the semantics that anonymous memory provides.
>
>> There's got to be an easyish way to
>> modify the mm code to allow anonymous maps with vm_ops.  Maybe a new
>> mmap_region parameter or something?  Maybe even a special anon_vma,
>> but I don't really understand how those work.
>
> Yeah, we very well might end up having to go down that path.
>
>> Also, egads: what happens when a bound table entry is associated with
>> a MAP_SHARED page?
>
> Bounds table entries are for pointers.  Do we keep pointers inside of
> MAP_SHARED-mapped things? :)

Sure, if it's MAP_SHARED | MAP_ANONYMOUS.  For example:

struct thing {
  struct thing *next;
};

struct thing *storage = mmap(..., MAP_SHARED | MAP_ANONYMOUS, ...);
storage[0].next = &storage[1];
fork();

I'm not suggesting that this needs to *work* in the first incarnation of this :)

--Andy
