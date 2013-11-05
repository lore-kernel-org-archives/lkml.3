Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3KEDPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:15:12 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58331 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3KEDPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:15:10 -0500
Message-ID: <527862B9.2060300@hitachi.com>
Date: Tue, 05 Nov 2013 12:15:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VXdlIEtsZQ==?= =?UTF-8?B?aW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on func_ptr_is_kernel_text
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal> <20131101112537.14657.88496.stgit@kbuild-fedora.novalocal> <20131104210053.76c37210@gandalf.local.home>
In-Reply-To: <20131104210053.76c37210@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/05 11:00), Steven Rostedt wrote:
> On Fri, 01 Nov 2013 11:25:37 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Prohibit probing on func_ptr_is_kernel_text().
>> Since the func_ptr_is_kernel_text() is called from
>> notifier_call_chain() which is called from int3 handler,
>> probing it may cause double int3 fault and kernel will
>> reboot.
>>
>> This happenes when the kernel built with CONFIG_DEBUG_NOTIFIERS=y.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> ---
>>  kernel/extable.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/extable.c b/kernel/extable.c
>> index 832cb28..022fb25 100644
>> --- a/kernel/extable.c
>> +++ b/kernel/extable.c
>> @@ -129,7 +129,7 @@ int kernel_text_address(unsigned long addr)
>>   * pointer is part of the kernel text, we need to do some
>>   * special dereferencing first.
>>   */
>> -int func_ptr_is_kernel_text(void *ptr)
>> +int nokprobe func_ptr_is_kernel_text(void *ptr)
>>  {
>>  	unsigned long addr;
>>  	addr = (unsigned long) dereference_function_descriptor(ptr);
>>
> 
> One thing I worry about the "nokprobe" annotation, is that it moves the
> location of the function out of local. This function no exists in
> the section with its users. Same with the debug functions in the
> other patch.
> 
> Now these may be a slow path where we really don't care, but if the
> nokprobe expands this can cause issues.
> 
> The "nokprobe" works differently than "notrace" as "notrace" is just an
> attribute that tells gcc not to add mcount to it. The "nokprobe"
> actually moves the function into a different section.

Well, in that case, I can put it in the opt-out type blacklist(kprobe_blacklist). :)
Hmm, I think if I can list nokprobe functions up at build time, we can almost
remove the .kprobes.text (Note that some of entry functions in asm still require it.)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


