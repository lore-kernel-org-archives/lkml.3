Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3K1Kof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:44:35 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60234 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3K1Koc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:44:32 -0500
Message-ID: <52971E66.9080006@hitachi.com>
Date: Thu, 28 Nov 2013 19:43:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, systemtap@sourceware.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: Re: Re: [PATCH -tip v3 00/23] kprobes: introduce NOKPROBE_SYMBOL()
 and general cleaning of kprobe blacklist
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal> <y0mvbznxi6k.fsf@fche.csb> <20131120153801.GA9743@gmail.com> <20131120173600.GK8993@redhat.com> <528D6C9F.8050809@hitachi.com> <20131121072938.GA16912@gmail.com> <528EC2FF.30301@hitachi.com> <528F4406.3090309@hitachi.com> <20131127133045.GC18422@gmail.com>
In-Reply-To: <20131127133045.GC18422@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/27 22:30), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2013/11/22 11:35), Masami Hiramatsu wrote:
>>> (2013/11/21 16:29), Ingo Molnar wrote:
>>>>
>>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>
>>>>> (2013/11/21 2:36), Frank Ch. Eigler wrote:
>>>>
>>>> [ ... ]
>>>>>> one needs to resort to something like:
>>>>>>
>>>>>> # cat /proc/kallsyms | grep ' [tT] ' | while read addr type symbol; do
>>>>>>    perf probe $symbol
>>>>>> done
>>>>>>
>>>>>> then wait for a few hours for that to finish. Then, or while the loop
>>>>>> is still running, run
>>>>>>
>>>>>> # perf record -e 'probe:*' -aR sleep 1
>>>>>>
>>>>>> to take a kernel down.
>>>>>
>>>>> Um, indeed, current blacklist is not perfect. [...]
>>>>
>>>> Then it needs to be fixed ASAP!
>>>
>>> OK, I see. At least the two patches included this series
>>> should be fixed. :)
>>>
>>> And more, I need to test all symbols and drills down.
>>
>> OK, what I've found was;
>>  - The functions which can be ftraced look good.
>>    (see tracing/available_filter_functions)
>>  - following functions should not be able to be probed.
>>    - memcpy, memset
>>    - native_load_sp0 and some other native functions (need to be clear)
>>    - restore
>>    - trace_graph_return
>>    - trace_hardirqs_off_thunk, trace_hardirqs_on_thunk
>>    - This list still be not perfect. I just enabled/disabled kprobes
>>      one by one. There might be combined bugs (combination of several
>>      kprobes).
>>  - Some of them are hard to specify by NOKPROBE_SYMBOL because they are
>>    defined in assembly file.
>>
>> Anyway, to fix all of them, I think we need file-based blacklist
>> especially for assembler symbols.
> 
> assembler symbols shouldn't be particular hard either, just put them 
> into the noprobes section.

Would you mean .kprobes.text? Hmm, I hope not to use it anymore,
but yeah, bugfix is more important. Agreed.

>> For example, we can get all text symbols by below command;
>>  nm some-file.o | grep -i " t " | cut -f3 -d" "
>> so that we can make a blacklisted-symbol list for the file.
>> I need to look the Kbuild for how I can do that in Makefile.
> 
> I think it's generally better to add explicit annotations to the code.

OK, thus I'll add annotations first.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


