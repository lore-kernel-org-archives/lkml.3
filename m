Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaCaCfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:35:21 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63511 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaCaCfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:35:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140330171957.GF22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396017924-7754-11-git-send-email-jovi.zhangwei@gmail.com>
	<20140330035009.GB22728@two.firstfloor.org>
	<CAGdX0WHK-EhGYHELxr-H_A+w1ZDWWhDpxsvB+=grMgFNpFsZ4g@mail.gmail.com>
	<20140330171957.GF22728@two.firstfloor.org>
Date: Mon, 31 Mar 2014 10:35:18 +0800
Message-ID: <CAGdX0WE2g4ksnuNeWZTzSssVvGaQzYXs6xa+UQUFG73WLAdzxw@mail.gmail.com>
Subject: Re: [PATCH v2 10/29] ktap: add string handling code(kernel/trace/ktap/kp_[str|mempool].[c|h])
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 1:19 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> See test/benchmark/cmp_table.sh, that script compare
>
> Is that a realistic tracing scenario?
>
Yes, it's quite common to use string key in dynamic tracing tool,
for example, See samples/userspace/glibc_func_hist.kp

    var s = {}

    trace probe:/lib64/libc.so.6:* {
        s[probename] += 1
    }

    trace_end {
        print_hist(s)
    }


Result:

Tracing... Hit Ctrl-C to end.
^C
                         value ------------- Distribution ------------- count
                  _IO_sputbackc |@@                                    108344
             __GI__IO_sputbackc |@@                                    107768
             _IO_default_xsputn |                                      46639
        __GI__IO_default_xsputn |                                      46624
                           free |                                      36871
                    __libc_free |                                      36841
                          cfree |                                      36841
                         __free |                                      36811
                        __cfree |                                      36811
               __GI___libc_free |                                      36804
        ____strtoull_l_internal |                                      28670
    __GI_____strtoul_l_internal |                                      28670
   __GI_____strtoull_l_internal |                                      28518
         ____strtoul_l_internal |                                      28518
                      strchrnul |                                      27763
                    __strchrnul |                                      27741
                       _IO_putc |                                      27589
                  __GI__IO_putc |                                      27589
                           putc |                                      27589
                            ... |

Above script output histogram of glibc function call, you will know
which function will be called frequently, a very useful script.

'probename' return probe name string, then insert table as key.
The magic of above script is there have no string copy and string hash
in probe context, because probename string is interned.


>> table operation between ktap with stap, the result is very
>> inspiring, ktap table operation overhead is quite lower than
>> stap, especially when use constant string key.
>
> Ok fair enough.
>
>>
>> But I agree with you partly, because in some cases we don't
>> want/need to interning all string, for example:
>>     trace xxx:yyy {
>>         var str = cast("char *", arg1)
>>         print(str)
>>     }
>>
>> In above case, arg1 is a long kernel string, and no table insert,
>> so definitely no need to interned, so we need to add
>> KTAP_TRAWSTR to represent these values.
>
> Please don't make it more complicated. If there's a good rationale
> for interning it' ok to use always.
>
> It would be better to find ways to simplify things.
>
Definitely, the reason I implement ktap based on lua is the simplicity
and efficiency of lua.

The whole bytecode design and value type is very simple, it could
build a complete safe sandbox for kernel scripting, and easy to
extend to fulfill our need(like multi-key table, aggregation)

Thanks.

Jovi
