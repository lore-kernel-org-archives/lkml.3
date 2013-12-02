Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3LBRzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:55:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52229 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3LBRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:55:09 -0500
Message-ID: <529CC97A.6000807@gmail.com>
Date: Mon, 02 Dec 2013 10:55:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, namhyung@kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/2] perf probe: Allow user to specify address within
 executable
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <1385942827-11637-2-git-send-email-dsahern@gmail.com> <529C259D.8010901@hitachi.com> <529C9DDF.1080401@gmail.com>
In-Reply-To: <529C9DDF.1080401@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 7:49 AM, David Ahern wrote:
> On 12/1/13, 11:15 PM, Masami Hiramatsu wrote:
>> (2013/12/02 9:07), David Ahern wrote:
>>> Allow user to specify an address within an executable. This is useful, for
>>> example, in probing local functions. If the function name begins with 0x
>>> then try to convert the supplied name to an address. If succuessful then
>>> treat the function name as the address within the executable to be probed.
>>
>> Hmm, IMHO, this kind of functionality is only good for debugging.
> 
> Why? perf-probe takes the function name, looks up the address in the
> executable, adds an offset and then pushes that address to the kernel.
> Why can't I have an option to jump straight to the desired address?
> 
> A few use cases that come to mind:
> 
> 1. Allows manual creation of return probes in kernels which do not have
> that support.
> 
> 2. probing static functions

D'oh. That is supposed to be local functions, not static functions.
Right now perf-probe does not allow probes in local functions of an
executable. Giving a specific address provides a mean to do that.

> 
> 3. probing versioned addresses in libc -- something the current syntax
> does not allow because '@' is used as a field separator:
> 
> $ nm /lib64/libc-2.14.90.so | grep pthread_cond_timedwait
> 00000000000fe6c0 t __pthread_cond_timedwait
> 000000000012d920 t __pthread_cond_timedwait_2_0
> 00000000000fe6c0 T pthread_cond_timedwait@@GLIBC_2.3.2
> 000000000012d920 T pthread_cond_timedwait@GLIBC_2.2.5
> 
> $ perf probe -x /lib64/libc-2.14.90.so -a
> 'cond_timewait=pthread_cond_timedwait'
> no symbols found in /lib64/libc-2.14.90.so, maybe install a debug package?
> Failed to load map.
>    Error: Failed to add events. (-22)
> 
> $ perf probe -x /lib64/libc-2.14.90.so -a
> 'cond_timewait=pthread_cond_timedwait@@GLIBC_2.3.2'
> Semantic error :SRC@SRC is not allowed.
> 
> 
> 4. A workaround for any other shortcomings in the interface that require
> patches to fix and backports to be done. backports which take time if
> even possible.
> 
>> In that case, you should use uprobe_events interface directly.
> 
> How do I do that within the context of perf?
> 
>>
>> I recommend you to try enabing dwarf support in user space.
>> Perf probe is a user-friendly interface of dynamic events.
> 
> I do have dwarf support enabled in perf. Are you referring to other
> components of userspace (like system libraries)?
> 
> David
> 

