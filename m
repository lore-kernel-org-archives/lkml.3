Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3IQPe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:34:27 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35930 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752888Ab3IQPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:34:25 -0400
Message-ID: <5238767D.1080606@hurleysoftware.com>
Date: Tue, 17 Sep 2013 11:34:21 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
References: <20130913005133.GA32479@localhost> <20130913010936.GA1291@localhost>
In-Reply-To: <20130913010936.GA1291@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 09:09 PM, Fengguang Wu wrote:
> On Fri, Sep 13, 2013 at 08:51:33AM +0800, Fengguang Wu wrote:
>> Hi Peter,
>>
>> FYI, we noticed much increased vmap_area_lock contentions since this
>> commit:
>>
>> commit 20bafb3d23d108bc0a896eb8b7c1501f4f649b77
>> Author: Peter Hurley <peter@hurleysoftware.com>
>> Date:   Sat Jun 15 10:21:19 2013 -0400
>>
>>      n_tty: Move buffers into n_tty_data
>>
>>      Reduce pointer reloading and improve locality-of-reference;
>>      allocate read_buf and echo_buf within struct n_tty_data.
>
> Here are some comparison between this commit [o] with its parent commit [*].

Hi Fenguang,

Can you give the particulars of the aim7 test runs below?
I ask because I get _no_ added contention on the vmap_area_lock when I run
these tests on a dual-socket xeon.

What is the machine configuration(s)?
Are you using the aim7 'multitask' test driver or your own custom driver?
What is the load configuration (ie., constant, linearly increasing, convergence)?
How many loads are you simulating?

                        lock_stat.vmap_area_lock.holdtime-total
[...]
>                 489739.50      +978.5%   5281916.05  lkp-ne04/micro/aim7/shell_rtns_1
>                1601675.63      +906.7%  16123642.52  lkp-snb01/micro/aim7/exec_test
[...]
>                 822461.02     +1585.0%  13858430.62  nhm-white/micro/aim7/exec_test
>                   9858.11     +2715.9%    277595.41  nhm-white/micro/aim7/fork_test
[...]
>                    300.14     +2621.5%      8168.53  nhm-white/micro/aim7/misc_rtns_1
>                 345479.21     +1624.5%   5957828.25  nhm-white/micro/aim7/shell_rtns_1


None of the tests below execute a code path that leads to get_vmalloc_info().
The only in-kernel user of get_vmalloc_info() is a sysfs read of /proc/meminfo,
which none of the tests below perform.

What is reading /proc/meminfo?

Regards,
Peter Hurley

>                   lock_stat.vmap_area_lock.contentions.get_vmalloc_info
>
>      8cb06c983822103da1cf      20bafb3d23d108bc0a89
> ------------------------  ------------------------
>                   4952.40      +447.0%     27090.40  lkp-ne04/micro/aim7/shell_rtns_1
>                  28410.80      +556.2%    186423.00  lkp-snb01/micro/aim7/exec_test
>                   8142.00      +615.4%     58247.33  nhm-white/micro/aim7/exec_test
>                   1386.00      +762.6%     11955.20  nhm-white/micro/aim7/shell_rtns_1
>                  42891.20      +561.5%    283715.93  TOTAL lock_stat.vmap_area_lock.contentions.get_vmalloc_info

