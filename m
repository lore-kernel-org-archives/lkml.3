Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3LBOwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:52:53 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56309 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3LBOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:52:51 -0500
Message-ID: <529C9EC0.70607@gmail.com>
Date: Mon, 02 Dec 2013 07:52:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/2] perf probe: Improve error message when function not
 found
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <529C21C5.3030007@hitachi.com>
In-Reply-To: <529C21C5.3030007@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/1/13, 10:59 PM, Masami Hiramatsu wrote:
> (2013/12/02 9:07), David Ahern wrote:
>> When requesting a function from a userspace library the error message to
>> the user is less than helpful. e.g.,
>>
>>      perf probe -x /lib64/libpthread-2.14.90.so -a 'lock_full=__pthread_mutex_lock_full'
>>      no symbols found in /lib64/libpthread-2.14.90.so, maybe install a debug package?
>>      Failed to load map.
>>         Error: Failed to add events. (-22)
>>
>> In this cae the symbol really does exist but is a local symbol which is
>> filtered:
>>
>>      nm /lib64/libpthread-2.14.90.so | grep __pthread_mutex_lock_full
>>      0000000000005700 t __pthread_mutex_lock_full
>>
>> With this patch:
>>      perf probe -x /lib64/libpthread-2.14.90.so -a 'lock_full=__pthread_mutex_lock_full'
>>
>>      no symbols found in /lib64/libpthread-2.14.90.so, maybe install a debug package?
>>      Failed to find function in /lib64/libpthread-2.14.90.so. Perhaps it is a local variable?
> 
> Hmm, indeed current message is too less information, but your message looks
> wired. I think just showing "Failed to find requested symbol in %s" is enough. :)

I disagree. perf-probe filters non-global variables:

    if (sym->binding == STB_GLOBAL &&
        strfilter__compare(available_func_filter, sym->name))
        return 0;

That needs to be explicitly stated in the error message -- only global
symbols may be given.

Between the 2 original error messages I wasted 2 hours strace'ing perf
looking at files -- including all the debuginfo variants -- that perf
opens. nm/objdump and every other tool sees the symbols yet perf throws
out bizarre error messages -- "no symbols found in ..." and "Failed to
load map". Let's fix those messages with something meaningful.

David
