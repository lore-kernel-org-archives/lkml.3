Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3GAQ4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:56:33 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53437 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3GAQ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:56:32 -0400
MIME-Version: 1.0
In-Reply-To: <51D1AFC8.80803@linux.intel.com>
References: <20130630040514.GA20587@www.outflux.net>
	<51D18B16.1000402@linux.intel.com>
	<CAGXu5jJw==6ypJVa3YQu27xBidfbgg4tO6AkJia34CwHF=OOfg@mail.gmail.com>
	<51D1AFC8.80803@linux.intel.com>
Date: Mon, 1 Jul 2013 09:56:21 -0700
X-Google-Sender-Auth: _s6qDkewXZVOk0RgfhehOHDQkUQ
Message-ID: <CAGXu5j+JSehao2LnoWxzL8QHxZ2QcsoPtiF=+Cwe6KBnSrkKwA@mail.gmail.com>
Subject: Re: [PATCH] x86, kernel: make dump_pagetables a tristate
From: Kees Cook <keescook@chromium.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 9:35 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 7/1/2013 8:55 AM, Kees Cook wrote:
>>
>> On Mon, Jul 1, 2013 at 6:58 AM, Arjan van de Ven <arjan@linux.intel.com>
>> wrote:
>>>
>>> On 6/29/2013 9:05 PM, Kees Cook wrote:
>>>>
>>>>
>>>> Being able to examine page tables is handy, so make this a module that
>>>> can be loaded as needed.
>>>
>>>
>>> I personally don't think this is a good idea due to the various
>>> security/etc implications of this feature... should really just
>>> be off for non-debug kernels, not "off unless you load the module"
>>
>>
>> I struggled with this too, but I couldn't come up with any reason that
>> made sense. If a system is running without modules_disabled, this code
>> is still loadable:
>>
>> https://www.outflux.net/blog/archives/2011/04/27/non-executable-kernel-memory-progress/
>>
>> The root user just needs to look at /proc/kallsyms before passing an
>> argument. So having it NOT a tristate doesn't actually change anything
>> except make it awkward to get it done.
>>
>> If a system is running with verified modules, then just not
>> signing/including ptdump makes it unavailable. And running with
>> modules_disabled, obviously, blocks it.
>>
>>>> +#ifdef CONFIG_X86_64
>>>> +EXPORT_SYMBOL_GPL(init_level4_pgt);
>>>> +#else
>>>> +EXPORT_SYMBOL_GPL(swapper_pg_dir);
>>>> +#endif
>>>
>>>
>>> like these really have no business in any module
>>
>>
>> Well, that's why I took me 2 years to send this patch. Those symbols
>> shouldn't be used outside of page table debugging, so it didn't really
>> seem upstreamable. However, now that I need to do regular examination
>> of the page tables, I wanted to do it without the hacky thing above. I
>> want to do at will on our test images (we use the same kernel for
>> production and test, but production images leave out the test modules,
>> etc).
>
>
> the code is small...
> how about making it a command line option to enable?
>
> rather than making something like this a module

Hmm. The Chrome OS build infrastructure frowns on making cmdline
changes between production and testing images. I could probably do it
this way, but it'd be more of a pain to maintain than just carrying
the hack patch.

Since there's no actual loss to system security by making this a
module, how about we allow it to be a tristate and continue to
recommend it being "n" by default?

As far as the export goes, could ptdump read cr3 instead of needing a
symbol export?

-Kees

--
Kees Cook
Chrome OS Security
