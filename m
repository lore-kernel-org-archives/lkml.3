Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3IRAWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:22:47 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37032 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754204Ab3IRAWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:22:46 -0400
Message-ID: <5238F252.5070905@hurleysoftware.com>
Date: Tue, 17 Sep 2013 20:22:42 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
References: <20130913005133.GA32479@localhost> <20130913010936.GA1291@localhost> <5238767D.1080606@hurleysoftware.com> <20130917232214.GA11390@localhost>
In-Reply-To: <20130917232214.GA11390@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 07:22 PM, Fengguang Wu wrote:
> On Tue, Sep 17, 2013 at 11:34:21AM -0400, Peter Hurley wrote:
>> On 09/12/2013 09:09 PM, Fengguang Wu wrote:
>>> On Fri, Sep 13, 2013 at 08:51:33AM +0800, Fengguang Wu wrote:
>>>> Hi Peter,
>>>>
>>>> FYI, we noticed much increased vmap_area_lock contentions since this
>>>> commit:
>>>>
>>>> commit 20bafb3d23d108bc0a896eb8b7c1501f4f649b77
>>>> Author: Peter Hurley <peter@hurleysoftware.com>
>>>> Date:   Sat Jun 15 10:21:19 2013 -0400
>>>>
>>>>      n_tty: Move buffers into n_tty_data
>>>>
>>>>      Reduce pointer reloading and improve locality-of-reference;
>>>>      allocate read_buf and echo_buf within struct n_tty_data.
>>>
>>> Here are some comparison between this commit [o] with its parent commit [*].
>>
>> Hi Fengguang,

Sorry for misspelling your name earlier. Fixed.

>> Can you give the particulars of the aim7 test runs below?
>> I ask because I get _no_ added contention on the vmap_area_lock when I run
>> these tests on a dual-socket xeon.
>>
>> What is the machine configuration(s)?
>> Are you using the aim7 'multitask' test driver or your own custom driver?
>> What is the load configuration (ie., constant, linearly increasing, convergence)?
>> How many loads are you simulating?
>
> The aim7 tests are basically
>
>          (
>                  echo $HOSTNAME
>                  echo $workfile
>
>                  echo 1
>                  echo 2000
>                  echo 2
>                  echo 2000
>                  echo 1
>          ) | ./multitask -t

Thanks for the profile. I ran the aim7 tests with these load parameters (2000!)
and didn't have any significant contention with vmap_area_lock (162).

I had to run a subset of the aim7 tests (just those below) because I don't have
anything fast enough to simulate 2000 loads on the entire workfile.shared testsuite.


>>                         lock_stat.vmap_area_lock.holdtime-total
>> [...]
>>>                 489739.50      +978.5%   5281916.05  lkp-ne04/micro/aim7/shell_rtns_1
>>>                1601675.63      +906.7%  16123642.52  lkp-snb01/micro/aim7/exec_test
>> [...]
>>>                 822461.02     +1585.0%  13858430.62  nhm-white/micro/aim7/exec_test
>>>                   9858.11     +2715.9%    277595.41  nhm-white/micro/aim7/fork_test
>> [...]
>>>                    300.14     +2621.5%      8168.53  nhm-white/micro/aim7/misc_rtns_1
>>>                 345479.21     +1624.5%   5957828.25  nhm-white/micro/aim7/shell_rtns_1
>>
>>
>> None of the tests below execute a code path that leads to get_vmalloc_info().
>> The only in-kernel user of get_vmalloc_info() is a sysfs read of /proc/meminfo,
>> which none of the tests below perform.
>>
>> What is reading /proc/meminfo?
>
> Good point! That may explain it:  I'm running a
>
> loop:
>          cat /proc/meminfo
>          sleep 1
>
> in all the tests.

Yep. That's what's creating the contention -- while the aim7 test is creating
ttys for each and every process (exec_test, shell_rtns_1, ...), the read of
/proc/meminfo is contending with the allocations/frees of 2000 tty ldisc buffers.

Looking over vmalloc.c, the critical section footprint of the vmap_area_lock
could definitely be reduced (even nearly eliminated), but that's a project for
another day :)

Regards,
Peter Hurley


>>>                   lock_stat.vmap_area_lock.contentions.get_vmalloc_info
>>>
>>>      8cb06c983822103da1cf      20bafb3d23d108bc0a89
>>> ------------------------  ------------------------
>>>                   4952.40      +447.0%     27090.40  lkp-ne04/micro/aim7/shell_rtns_1
>>>                  28410.80      +556.2%    186423.00  lkp-snb01/micro/aim7/exec_test
>>>                   8142.00      +615.4%     58247.33  nhm-white/micro/aim7/exec_test
>>>                   1386.00      +762.6%     11955.20  nhm-white/micro/aim7/shell_rtns_1
>>>                  42891.20      +561.5%    283715.93  TOTAL lock_stat.vmap_area_lock.contentions.get_vmalloc_info

