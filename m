Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3IRAt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:49:58 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59563 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846Ab3IRAt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:49:56 -0400
Message-ID: <5238F8AF.4050309@hurleysoftware.com>
Date: Tue, 17 Sep 2013 20:49:51 -0400
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

[...]

>      8cb06c983822103da1cf      20bafb3d23d108bc0a89
> ------------------------  ------------------------
>                    976.67      +108.3%      2034.67  lkp-a04/micro/netperf/120s-200%-TCP_STREAM
>                   8971.36       +11.4%      9997.05  nhm-white/micro/aim7/exec_test
>                   9948.03       +20.9%     12031.72  TOTAL slabinfo.kmalloc-128.active_objs
>
>      8cb06c983822103da1cf      20bafb3d23d108bc0a89
> ------------------------  ------------------------
>                    976.67      +108.3%      2034.67  lkp-a04/micro/netperf/120s-200%-TCP_STREAM
>                   9127.64       +11.4%     10164.15  nhm-white/micro/aim7/exec_test
>                  10104.31       +20.7%     12198.82  TOTAL slabinfo.kmalloc-128.num_objs

The dramatic increase in 128-byte kmalloc blocks is from vmalloc overhead
with associated with each allocation. On a x86_64, struct vmap_area is 104 bytes,
rounded to 128, allocated with every vmalloc allocation. This is approx 1% overhead
(which seems high to me).

The reason this is still visible after the test completes is the vmap area is
lazily reclaimed (see mm/vmalloc.c:__purge_vmap_area_lazy()).

1% memory overhead coupled with the unwanted vmap_area_lock contention (even though it is
test-induced) -- I might revert this anyway.

Regards,
Peter Hurley
