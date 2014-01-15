Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaAOISK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:18:10 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42534 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAOISI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:18:08 -0500
Message-ID: <52D64439.5040800@hitachi.com>
Date: Wed, 15 Jan 2014 17:18:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 3/8] x86: add generic function to modify more calls
 using int3 framework
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz> <1386690140-19941-4-git-send-email-pmladek@suse.cz> <20140114193338.4375f205@gandalf.local.home>
In-Reply-To: <20140114193338.4375f205@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/15 9:33), Steven Rostedt wrote:
> On Tue, 10 Dec 2013 16:42:15 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
>> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
>> index 586747f5f41d..82ffe7e1529c 100644
>> --- a/arch/x86/include/asm/alternative.h
>> +++ b/arch/x86/include/asm/alternative.h
>> @@ -232,4 +232,40 @@ extern int text_poke_bp(void *addr, const void *opcode, size_t len,
>>  extern void text_poke_bp_or_die(void *addr, const void *opcode, size_t len,
>>  				void *handler);
> 
> Small nit. If you can, place comments on the same line as the
> structure field.
>   
>> +struct text_poke_bp_iter {
>> +	/* information used to start iteration from the beginning */
>> +	void *init;
>> +	/* length of the patched instruction */
>> +	size_t len;
>> +	/* details about failure if any */
>> +	int fail_count;
>> +	void *fail_addr;
> 
> The above should have the comments on the same line as the field.
> Something like this:
> 
> 	void		*init;	/* information used to start
> 	iteration from the beginning */
> 
> The comments for the function pointers below are fine.
> 
>> +	/* iteration over entries */
>> +	void *(*start)(void *init);
>> +	void *(*next)(void *prev);
>> +	/* callback to get patched address */
>> +	void *(*get_addr)(void *cur);
>> +	/*
>> +	 * Callbacks to get the patched code. They could return NULL if no
>> +	 * patching is needed; This is useful for example in ftrace.
>> +	 */
>> +	const void *(*get_opcode)(void *cur);
>> +	const void *(*get_old_opcode)(void *cur);
>> +	/*
>> +	 * Optional function that is called when the patching of the given
>> +	 * has finished. It might be NULL if no postprocess is needed.
>> +	 */
>> +	int (*finish)(void *cur);
>> +	/*
>> +	 * Helper function for int3 handler. It decides whether the given IP
>> +	 * is being patched or not.
>> +	 *
>> +	 * Try to implement it as fast as possible. It affects performance
>> +	 * of the system when the patching is in progress.
>> +	 */
>> +	void *(*is_handled)(const unsigned long ip);
>> +};
>> +
>> +extern int text_poke_bp_list(struct text_poke_bp_iter *iter);
>> +
>>  #endif /* _ASM_X86_ALTERNATIVE_H */
>> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
>> index 6436beec7b0c..8e57ac03a0e8 100644
>> --- a/arch/x86/kernel/alternative.c
>> +++ b/arch/x86/kernel/alternative.c
>> @@ -7,6 +7,7 @@
>>  #include <linux/stringify.h>
>>  #include <linux/kprobes.h>
>>  #include <linux/mm.h>
>> +#include <linux/uaccess.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/memory.h>
>>  #include <linux/stop_machine.h>
>> @@ -610,8 +611,11 @@ static void run_sync(void)
>>  		on_each_cpu(do_sync_core, NULL, 1);
>>  }
>>  
>> +static char bp_int3;
> 
> bp_int3 is not going to be anything but 0xcc. Let's change that to:
> 
> static char bp_int3 = 0xcc;
> 
> And remove the other initializations.

just a comment.
If it is always 0xcc, it should be a const variable.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


