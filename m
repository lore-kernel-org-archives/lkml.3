Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaFDOSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:18:48 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60072 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaFDOSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:18:47 -0400
Message-ID: <538F2AC2.1060904@kernel.dk>
Date: Wed, 04 Jun 2014 08:18:42 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: blk-mq: bitmap tag: performance degradation?
References: <20140604103544.GA11350@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140604103544.GA11350@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 04:35, Alexander Gordeev wrote:
> Hi Jens, et al
>
> With new bitmap tags I am observing performance degradation on 'null_blk'
> device with 512 queue depth. This is 'fio' config used:
>
> [global]
> bs=4k
> size=16g
>
> [nullb]
> filename=/dev/nullb0
> direct=1
> rw=randread
> numjobs=8
>
>
> I tried machines with 16 and 48 CPUs and it seems the more
> CPUs we have the worse the result. Here is 48 CPUs one:
>
> 3.15.0-rc4+
>
>     READ: io=131072MB, aggrb=3128.7MB/s, minb=400391KB/s, maxb=407204KB/s,
> mint=41201msec, maxt=41902msec
>
>     548,549,235,428 cycles:k
>       3,759,335,303 L1-dcache-load-misses
>         419,021,008 cache-misses:k
>
>        39.659121371 seconds time elapsed
>
> 3.15.0-rc1.for-3.16-blk-mq-tagging+
>
>     READ: io=131072MB, aggrb=1951.8MB/s, minb=249824KB/s, maxb=255851KB/s,
> mint=65574msec, maxt=67156msec
>
>   1,063,669,976,651 cycles:k
>       4,572,746,591 L1-dcache-load-misses
>       1,127,037,813 cache-misses:k
>
>        69.446112553 seconds time elapsed

A null_blk test is the absolute best case for percpu_ida, since there 
are enough tags and everything is localized. The above test is more 
useful for testing blk-mq than any real world application of the tagging.

I've done considerable testing on both 2 and 4 socket (32 and 64 CPUs) 
and bitmap tagging is better in a much wider range of applications. This 
includes even high tag depth devices like nvme, and more normal ranges 
like mtip32xx and scsi-mq setups.

-- 
Jens Axboe

