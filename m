Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3LCJZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:25:40 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56912 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3LCJYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:24:44 -0500
Message-ID: <529DA355.9090408@hitachi.com>
Date: Tue, 03 Dec 2013 18:24:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, namhyung@kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/2] perf probe: Allow user to specify address within
 executable
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <1385942827-11637-2-git-send-email-dsahern@gmail.com> <529C259D.8010901@hitachi.com> <529C9DDF.1080401@gmail.com> <529CC97A.6000807@gmail.com>
In-Reply-To: <529CC97A.6000807@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/03 2:55), David Ahern wrote:
> On 12/2/13, 7:49 AM, David Ahern wrote:
>> On 12/1/13, 11:15 PM, Masami Hiramatsu wrote:
>>> (2013/12/02 9:07), David Ahern wrote:
>>>> Allow user to specify an address within an executable. This is useful, for
>>>> example, in probing local functions. If the function name begins with 0x
>>>> then try to convert the supplied name to an address. If succuessful then
>>>> treat the function name as the address within the executable to be probed.
>>>
>>> Hmm, IMHO, this kind of functionality is only good for debugging.
>>
>> Why? perf-probe takes the function name, looks up the address in the
>> executable, adds an offset and then pushes that address to the kernel.
>> Why can't I have an option to jump straight to the desired address?
>>
>> A few use cases that come to mind:
>>
>> 1. Allows manual creation of return probes in kernels which do not have
>> that support.
>>
>> 2. probing static functions
> 
> D'oh. That is supposed to be local functions, not static functions.
> Right now perf-probe does not allow probes in local functions of an
> executable. Giving a specific address provides a mean to do that.

No, perf probe for kprobe support to probing on local functions even
if it is inlined. The problem currently you encountered is that
perf probe uprobe support is incomplete. It should be enhanced to
support dwarf(debuginfo) to find the functions(even lines) from it.

I don't want to make perf-probe just a wrapper of the ftrace dynamic
event interface, because it doesn't add any "value" for users.
Current uprobe support state is not sufficient for me.

>>> In that case, you should use uprobe_events interface directly.
>>
>> How do I do that within the context of perf?

No way, but here, you can save this script as perf-uprobe and
can use it for that purpose. :)
---
#!/bin/sh
BIN=$1
FUNC=$2
ADDR=`nm $BIN | grep " $FUNC\$" | cut -f1 -d" "`
echo p $BIN:0x$ADDR > /sys/kernel/debug/tracing/uprobe_events
---

>>> I recommend you to try enabing dwarf support in user space.
>>> Perf probe is a user-friendly interface of dynamic events.
>>
>> I do have dwarf support enabled in perf. Are you referring to other
>> components of userspace (like system libraries)?

Ah, right. Unfortunately, perf probe for uprobes does not support
dwarf for user space yet. This should be enabled for completing
the perf probe work...

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


