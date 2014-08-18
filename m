Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaHRFcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 01:32:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaHRFcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 01:32:05 -0400
Message-ID: <53F18FCE.7060005@suse.com>
Date: Mon, 18 Aug 2014 07:31:58 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Widawsky <benjamin.widawsky@intel.com>
Subject: Re: [Intel-gfx] Usage of _PAGE_PCD et al in i915 driver
References: <53E4B338.3040904@suse.com> <CAKMK7uEqfLudZbj1ArKJVXET69d+g+SA3=GtXQ0zXi+FeudAag@mail.gmail.com> <20140813080705.31a0901a@jbarnes-desktop> <53EC331F.3000508@suse.com> <20140815102157.GR4193@intel.com>
In-Reply-To: <20140815102157.GR4193@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 12:21 PM, Ville Syrjälä wrote:
> On Thu, Aug 14, 2014 at 05:55:11AM +0200, Juergen Gross wrote:
>> On 08/13/2014 05:07 PM, Jesse Barnes wrote:
>>> On Fri, 8 Aug 2014 15:14:15 +0200
>>> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>>
>>>> Adding relevant mailing lists.
>>>>
>>>> On Fri, Aug 8, 2014 at 1:23 PM, Juergen Gross <jgross@suse.com> wrote:
>>>>> I'm just about to create a patch for full PAT support in the Linux
>>>>> kernel, including Xen. For this purpose I introduce a translation
>>>>> between cache modes and pte bits.
>>>>>
>>>>> Scanning the kernel sources for usage of the cache mode bits in the
>>>>> pte I discovered  drivers/gpu/drm/i915/i915_gem_gtt.h is using
>>>>> _PAGE_PCD, _PAGE_PWT and _PAGE_PAT. I think those defines are used
>>>>> to create ptes not for usage by the main processor, but for the
>>>>> graphics processor. Is this true? In this case I'd suggest to define
>>>>> i915-specific macros instead of using the x86 ones.
>>>>
>>>> Yeah, those are gpu specific PAT tables, but the hw engineers
>>>> specifically designed this to match, and we've tried to follow the cpu
>>>> side to match it. Especially in the future that will be somewhat
>>>> important, since we want to fully share the entire address space
>>>> between cpu and gpu on the next platform. Jesse is working on that.
>>>
>>> Right, we have an x86 compatible MMU in the GPU itself, so re-using the
>>> defines makes sense.  I suppose with your work you'll move them and
>>> make them a bit more opaque?  If so, we'll still want a way to get at
>>> them directly, or access your mapping functions for generating PTE bits
>>> for the GPU MMU.
>>
>> Using the mapping functions I'm introducing should work, if the MMU has
>> an x86 compatible MSR_IA32_CR_PAT which is configured the same way as
>> on the x86 processor (be aware that Xen is using another MSR_IA32_CR_PAT
>> setting as the Linux kernel).
>
> We have a PAT that is structured the same way as the x86 PAT. But the
> contents of the PAT entries are obviously specific to the GPU so it's
> not identical. But the pcd/pwt/pat bits index the PAT in exactly the
> same way as on x86.
>
> See bdw_setup_private_ppat() and chv_setup_private_ppat() for how we
> set up the PAT.
>

So you are using the PAT bit in the ptes, but the semantic for the GPU
will be different as for the x86 processor, because the GPU PAT is set
up differently from the x86 one.

In case you are sharing ptes between GPU and x86 processor in future,
this might lead to problems when the x86 processor will use ptes with
the PAT bit set.


Juergen
