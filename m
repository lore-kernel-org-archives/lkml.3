Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3LLEN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 23:13:28 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48810 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LLENZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 23:13:25 -0500
Message-ID: <52A937DE.408@hitachi.com>
Date: Thu, 12 Dec 2013 13:13:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [PATCH -tip v5.1 12/18] ftrace/kprobes: Use NOKPROBE_SYMBOL
 macro in ftrace
References: <20131209120450.4da43296@gandalf.local.home> <20131210095714.8225.57495.stgit@kbuild-fedora.novalocal> <20131211203435.43531ca5@gandalf.local.home>
In-Reply-To: <20131211203435.43531ca5@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/12 10:34), Steven Rostedt wrote:
> On Tue, 10 Dec 2013 09:57:14 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>> --- a/kernel/trace/trace_kprobe.c
>> +++ b/kernel/trace/trace_kprobe.c
>> @@ -51,45 +51,45 @@ struct event_file_link {
>>  	(sizeof(struct probe_arg) * (n)))
>>  
>>  
>> -static __kprobes bool trace_probe_is_return(struct trace_probe *tp)
>> +static __always_inline bool trace_probe_is_return(struct trace_probe *tp)
> 
> I wonder if we should have a comment somewhere explaining why we are
> using __always_inline.  Maybe we should add a new annotation:
> 
> #define kprobes_inline   __always_inline
> 
> ?
> 
> The above would be self documenting, and we can also include a comment
> with the define that states why it is there. Otherwise 10 years from
> now, someone is going to see these and say "WTF!" and remove them.

Hm, agreed, and I think nokprobe_inline is better since it is
similar to NOKPROBE_SYMBOL(). :)

[...]
>> @@ -755,8 +755,8 @@ static const struct file_operations kprobe_profile_ops = {
>>  };
>>  
>>  /* Sum up total data length for dynamic arraies (strings) */
>> -static __kprobes int __get_data_size(struct trace_probe *tp,
>> -				     struct pt_regs *regs)
>> +static __always_inline
>> +int __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
> 
> This function is used 4 times within the file and is not that small. I
> think it's a bit too big for an inline, and qualifies for a normal
> function with a NOKPROBE_SYMBOL() attached. 

OK, I'll do so.

>> @@ -771,9 +771,9 @@ static __kprobes int __get_data_size(struct trace_probe *tp,
>>  }
>>  
>>  /* Store the value of each argument */
>> -static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
>> -				       struct pt_regs *regs,
>> -				       u8 *data, int maxlen)
>> +static __always_inline
>> +void store_trace_args(int ent_size, struct trace_probe *tp,
>> +		      struct pt_regs *regs, u8 *data, int maxlen)
> 
> Same here (even more so!)

OK.

>>  {
>>  	int i;
>>  	u32 end = tp->size;
>> @@ -803,7 +803,7 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
>>  }
>>  
>>  /* Kprobe handler */
>> -static __kprobes void
>> +static __always_inline void
>>  __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
>>  		    struct ftrace_event_file *ftrace_file)
> 
> OK, this one is big, but it's only used once.

Right, at least in my build binary, it is inlined.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


