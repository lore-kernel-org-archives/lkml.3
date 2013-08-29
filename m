Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3H2DoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 23:44:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46124 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3H2DoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 23:44:06 -0400
Message-ID: <521EC382.5070406@hitachi.com>
Date: Thu, 29 Aug 2013 12:44:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [guv v2 08/31] tracing: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com> <00000140bc5f00c2-8e9ffffa-de46-4329-aef3-317c258828bd-000000@email.amazonses.com> <20130828154804.20f4dde6@gandalf.local.home>
In-Reply-To: <20130828154804.20f4dde6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/29 4:48), Steven Rostedt wrote:
> On Mon, 26 Aug 2013 20:44:37 +0000
> Christoph Lameter <cl@linux.com> wrote:
> 
>> __get_cpu_var() is used for multiple purposes in the kernel source. One of them is
>> address calculation via the form &__get_cpu_var(x). This calculates the address for
>> the instance of the percpu variable of the current processor based on an offset.
>>
>> Others usage cases are for storing and retrieving data from the current processors percpu area.
>> __get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.
>>
>> __get_cpu_var() is defined as :
>>
>>
>> #define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
>>
>>
>>
>> __get_cpu_var() always only does a address determination. However, store and retrieve operations
>> could use a segment prefix (or global register on other platforms) to avoid the address calculation.
>>
>> this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
>> optimized assembly code to read and write per cpu variables.
>>
>>
>> This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()
>> or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
>> and less registers are used when code is generated.
>>
>> At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.
>>
>> The patchset includes passes over all arches as well. Once these operations are used throughout then
>> specialized macros can be defined in non -x86 arches as well in order to optimize per cpu access by
>> f.e. using a global register that may be set to the per cpu base.
> 
> You should limit the width of the change log to 76 characters.
> 
> I fixed it for now.
> 
>>
>>
>>
>>
>> Transformations done to __get_cpu_var()
>>
>>
>> 1. Determine the address of the percpu instance of the current processor.
>>
>> 	DEFINE_PER_CPU(int, y);
>> 	int *x = &__get_cpu_var(y);
>>
>>     Converts to
>>
>> 	int *x = this_cpu_ptr(&y);
>>
>>
>> 2. Same as #1 but this time an array structure is involved.
>>
>> 	DEFINE_PER_CPU(int, y[20]);
>> 	int *x = __get_cpu_var(y);
>>
>>     Converts to
>>
>> 	int *x = this_cpu_ptr(y);
>>
>>
>> 3. Retrieve the content of the current processors instance of a per cpu variable.
>>
>> 	DEFINE_PER_CPU(int, u);
>> 	int x = __get_cpu_var(y)
>>
>>    Converts to
>>
>> 	int x = __this_cpu_read(y);
>>
>>
>> 4. Retrieve the content of a percpu struct
>>
>> 	DEFINE_PER_CPU(struct mystruct, y);
>> 	struct mystruct x = __get_cpu_var(y);
>>
>>    Converts to
>>
>> 	memcpy(this_cpu_ptr(&y), x, sizeof(x));
>>
>>
>> 5. Assignment to a per cpu variable
>>
>> 	DEFINE_PER_CPU(int, y)
>> 	__get_cpu_var(y) = x;
>>
>>    Converts to
>>
>> 	this_cpu_write(y, x);
>>
>>
>> 6. Increment/Decrement etc of a per cpu variable
>>
>> 	DEFINE_PER_CPU(int, y);
>> 	__get_cpu_var(y)++
>>
>>    Converts to
>>
>> 	this_cpu_inc(y)
>>
>>
>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>
>> Index: linux/include/linux/kprobes.h
>> ===================================================================
>> --- linux.orig/include/linux/kprobes.h	2013-08-26 14:25:53.000000000 -0500
>> +++ linux/include/linux/kprobes.h	2013-08-26 14:26:29.460993659 -0500
>> @@ -329,7 +329,7 @@ static inline void reset_current_kprobe(
>>  
>>  static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
>>  {
>> -	return (&__get_cpu_var(kprobe_ctlblk));
>> +	return this_cpu_ptr(&kprobe_ctlblk);
>>  }
> 
> Masami,
> 
> Can you give me an Acked-by: for this.
> 

Thanks for pinging me ;)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


