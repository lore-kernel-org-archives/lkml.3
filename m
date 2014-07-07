Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaGGLDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:03:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaGGLDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:03:41 -0400
Message-ID: <53BA7E8B.6090603@suse.cz>
Date: Mon, 07 Jul 2014 13:03:39 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Do not run modules_install and install in paralel
References: <CALCETrWSX1nVqyfe0Ee2rUvpHosTRyW8GSJfr52UCpT566-eWA@mail.gmail.com> <1402652395-28779-1-git-send-email-mmarek@suse.cz> <539AC82B.4070505@suse.cz> <CALCETrVbq3kQtq0jOsE0fBAkrSB=UxbB2P9F9iVd1896wO+f-g@mail.gmail.com> <53B72780.4000302@suse.cz> <CALCETrWRo9B=q04dqGZZS0ojXaRxdA4kQ6UQWSaeq-Z6yD=7oQ@mail.gmail.com>
In-Reply-To: <CALCETrWRo9B=q04dqGZZS0ojXaRxdA4kQ6UQWSaeq-Z6yD=7oQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-05 01:45, Andy Lutomirski wrote:
> On Fri, Jul 4, 2014 at 3:15 PM, Michal Marek <mmarek@suse.cz> wrote:
>> Dne 13.6.2014 19:29, Andy Lutomirski napsal(a):
>>> On Fri, Jun 13, 2014 at 2:45 AM, Michal Marek <mmarek@suse.cz> wrote:
>>>> Dne 13.6.2014 11:39, Michal Marek napsal(a):
>>>>> Based on a x86-only patch by Andy Lutomirski <luto@amacapital.net>
>>>>>
>>>>> With modular kernels, 'make install' is going to need the installed
>>>>> modules at some point to generate the initramfs.
>>>>>
>>>>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>>>>> ---
>>>>>  Makefile | 6 ++++++
>>>>>  1 file changed, 6 insertions(+)
>>>>>
>>>>> diff --git a/Makefile b/Makefile
>>>>> index 7680d7c..7e5e483 100644
>>>>> --- a/Makefile
>>>>> +++ b/Makefile
>>>>> @@ -503,6 +503,12 @@ ifeq ($(KBUILD_EXTMOD),)
>>>>>                  endif
>>>>>          endif
>>>>>  endif
>>>>> +# install and module_install need also be processed one by one
>>>>> +ifneq ($(filter install,$(MAKECMDGOALS)),)
>>>>> +        ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
>>>>> +             mixed-targets := 1
>>>>> +        endif
>>>>> +endif
>>>>
>>>> Note that this version does not enforce the ordering, it just avoids the
>>>> interleaved execution. It can be added if desired.
>>>
>>> Hmm.  This will fix 'make modules_install install' but will not fix
>>> 'make install modules_install'.  I don't know how many people would
>>> type the latter.
>>
>> Resuming a thread from last month -- As I said, it does not enforce the
>> ordering. So it's not as bullet-proof as your patch, but it works on all
>> architectures. I'm thinking about adding the patch to kbuild.git for
>> 3.17. But if you want to fix the ordering as well, feel free to change
>> the __build_one_by_one rule to do this.
> 
> Sounds good to me.
> 
> Where's __build_one_by_one?

A few lines below in the main Makefile:

   513  ifeq ($(mixed-targets),1)
   514  #
======================================================================
=====
   515  # We're called with mixed targets (*config and build targets).
   516  # Handle them one by one.
   517
   518  PHONY += $(MAKECMDGOALS) __build_one_by_one
   519
   520  $(filter-out __build_one_by_one, $(MAKECMDGOALS)):
__build_one_by_one
   521          @:
   522
   523  __build_one_by_one:
   524          $(Q)set -e; \
   525          for i in $(MAKECMDGOALS); do \
   526                  $(MAKE) -f $(srctree)/Makefile $$i; \
   527          done

Michal
