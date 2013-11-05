Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3KEBpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:45:18 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53160 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3KEBpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:45:16 -0500
Message-ID: <52784DA8.1050100@hitachi.com>
Date: Tue, 05 Nov 2013 10:45:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        x86@kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH -tip v2 1/3] kprobes: Introduce nokprobe annotation
 for non-probe-able functions
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal> <20131101112532.14657.34462.stgit@kbuild-fedora.novalocal> <20131101095510.6b43aef5@gandalf.local.home>
In-Reply-To: <20131101095510.6b43aef5@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/01 22:55), Steven Rostedt wrote:
> On Fri, 01 Nov 2013 11:25:32 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Instead of __kprobes annotation, introduce 'nokprobe' new annotation
>> to annotate that the function is not probed by kprobes.
>>
>> Previously the '__kprobes' is used just for avoiding probes on
>> kprobes-related functions which will be used from kprobes. However
>> nowadays we use it for prohibiting probing the functions implicitly
>> invoked from kprobes int3 handler, since that causes infinit-loop
>> lockup or sudden reboot. In this case, the annotated functions are
>> not limited in the kprobes-related functions, and __kprobes looks
>> very confusing. (Moreover, actually, most of control-side kprobes
>> functions like as register_kprobes() are safely probed by kprobes)
>>
>> Thus, we decide to introduce 'nokprobe' new annotation. We leave
>> "__kprobes" just for compatibility but it should be replaced or
>> removed eventually.
>>
>> New commits must use 'nokprobe' for this purpose.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> ---
>>  include/linux/compiler.h |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
>> index 92669cd..173c64e 100644
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -353,8 +353,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>>  
>>  /* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
>>  #ifdef CONFIG_KPROBES
>> -# define __kprobes	__attribute__((__section__(".kprobes.text")))
>> +# define nokprobe	__attribute__((__section__(".kprobes.text")))
> 
> I wonder if we should have both a __kprobes and nokprobe annotation,
> such that we have:
> 
> # define __kprobes	__attribute__((__section__(".kprobes.text")))
> # define nokprobe	__attribute__((__section__(".nokprobes.text")))
> 
> Then use __kprobes for the actual kprobes code, and nokprobe for all
> the places that must not be traced by kprobes.

No, actually, we don't need __kprobes anymore. That has started
historically by misunderstanding the problem. kprobes is using
the .kprobes.text only for blacklisting the non probe-able functions.
Thus, eventually it should be renamed .nokprobe.text, not be added.

> It just seems strange to me grouping kprobes code with non kprobes code.

Yeah, so I'd like to cleanup all the __kprobes finally (and classify which
is not needed).

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


