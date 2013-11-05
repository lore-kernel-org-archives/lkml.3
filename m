Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3KEG7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:59:11 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34321 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3KEG7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:59:08 -0500
Message-ID: <5278973A.1010705@hitachi.com>
Date: Tue, 05 Nov 2013 15:59:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VXdlIEtsZQ==?= =?UTF-8?B?aW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on func_ptr_is_kernel_text
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal> <20131101112537.14657.88496.stgit@kbuild-fedora.novalocal> <20131104210053.76c37210@gandalf.local.home> <20131105060901.GA29936@gmail.com>
In-Reply-To: <20131105060901.GA29936@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/05 15:09), Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Fri, 01 Nov 2013 11:25:37 +0000
>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>
>>> Prohibit probing on func_ptr_is_kernel_text().
>>> Since the func_ptr_is_kernel_text() is called from
>>> notifier_call_chain() which is called from int3 handler,
>>> probing it may cause double int3 fault and kernel will
>>> reboot.
>>>
>>> This happenes when the kernel built with CONFIG_DEBUG_NOTIFIERS=y.
>>>
>>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
>>> Cc: Borislav Petkov <bp@suse.de>
>>> Cc: Ingo Molnar <mingo@kernel.org>
>>> ---
>>>  kernel/extable.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/extable.c b/kernel/extable.c
>>> index 832cb28..022fb25 100644
>>> --- a/kernel/extable.c
>>> +++ b/kernel/extable.c
>>> @@ -129,7 +129,7 @@ int kernel_text_address(unsigned long addr)
>>>   * pointer is part of the kernel text, we need to do some
>>>   * special dereferencing first.
>>>   */
>>> -int func_ptr_is_kernel_text(void *ptr)
>>> +int nokprobe func_ptr_is_kernel_text(void *ptr)
>>>  {
>>>  	unsigned long addr;
>>>  	addr = (unsigned long) dereference_function_descriptor(ptr);
>>>
>>
>> One thing I worry about the "nokprobe" annotation, is that it moves the 
>> location of the function out of local. This function no exists in the 
>> section with its users. Same with the debug functions in the other 
>> patch.
> 
> Well, it's a bit like noinline, that changes the position of the function 
> as well. So it's not true that 'noxyz' attributes don't affect function 
> placement - they often don't, but some do.
> 
> The more important aspect is that 'noprobe' makes it really, really 
> apparent what the tag is about, at first sight.
> 
> _How_ the 'non probing' is achived is an implementational detail when 
> kprobes are enabled: right now it puts a function into a separate section, 
> but we could just a much build a list of function names and check against 
> it at probe insertion time.

Actually, kprobes already has it -- kprobes_blacklist. Currently
the list is manually maintained in kprobes.c separated from the
function definition. I hope to build the list when the kernel
build time if possible... Would you have any idea to classify
some annotated(but no side-effect) functions?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


