Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3ILPI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:08:29 -0400
Received: from hibox-130.abo.fi ([130.232.216.130]:58213 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab3ILPI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:08:27 -0400
Message-ID: <5231D8DD.5010703@hibox.fi>
Date: Thu, 12 Sep 2013 18:08:13 +0300
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <5124B613.6040400@hibox.fi> <20130222205144.GA30600@quack.suse.cz> <5127FEEA.60207@hibox.fi> <20130224001222.GB5551@dastard> <20130224012052.GC1196@thunk.org> <512D01E0.7010009@hibox.fi> <20130226231703.GA22674@quack.suse.cz> <5231BA3C.2090704@hibox.fi> <20130912131051.GA14664@quack.suse.cz> <5231C5FF.3060504@hibox.fi> <20130912143941.GB14664@quack.suse.cz>
In-Reply-To: <20130912143941.GB14664@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.09.2013 17:39, Jan Kara wrote:
> On Thu 12-09-13 16:47:43, Marcus Sundman wrote:
>> On 12.09.2013 16:10, Jan Kara wrote:
>>>    So now you run without 'discard' mount option, right? My guess then would
>>> be that the FTL layer on your SSD is just crappy and as the erase blocks
>>> get more fragmented as the filesystem is used it cannot keep up. But it's
>>> easy to put blame on someone else :)
>>>
>>> You can check whether this is a problem of Linux or your SSD by writing a
>>> large file (few GB or more) like 'dd if=/dev/zero of=testfile bs=1M
>>> count=4096 oflag=direct'. What is the throughput? If it is bad, check output
>>> of 'filefrag -v testfile'. If the extents are reasonably large (1 MB and
>>> more), then the problem is in your SSD firmware. Not much we can do about
>>> it in that case...
>>>
>>> If it really is SSD's firmware, maybe you could try f2fs or similar flash
>>> oriented filesystem which should put lower load on the disk's FTL.
>> ----8<---------------------------
>> $ grep LABEL /etc/fstab
>> LABEL=system    /        ext4    errors=remount-ro,nobarrier,noatime 0 1
>> LABEL=home    /home        ext4    defaults,nobarrier,noatime 0    2
>> $ df -h|grep home
>> /dev/sda3       104G   98G  5.1G  96% /home
>> $ sync && time dd if=/dev/zero of=testfile bs=1M count=2048
>> oflag=direct && time sync
>> 2048+0 records in
>> 2048+0 records out
>> 2147483648 bytes (2.1 GB) copied, 404.571 s, 5.3 MB/s
>>
>> real    6m44.575s
>> user    0m0.000s
>> sys    0m1.300s
>>
>> real    0m0.111s
>> user    0m0.000s
>> sys    0m0.004s
>> $ filefrag -v testfile
>> Filesystem type is: ef53
>> File size of testfile is 2147483648 (524288 blocks, blocksize 4096)
>>   ext logical physical expected length flags
>>     0       0 21339392             512
>>   [... http://sundman.iki.fi/extents.txt ...]
>>   282  523520  1618176  1568000    768 eof
>> testfile: 282 extents found
>> $
>> ----8<---------------------------
>>
>> Many extents are around 400 blocks(?) -- is this good or bad? (This
>> partition has a fragmentation score of 0 according to e4defrag.)
>    The free space is somewhat fragmented but given how full the fs is this
> is understandable. The extents are large enough that the drive shouldn't
> have problems processing them better than at 5 MB/s (standard rotating disk
> would achieve much better throughput with this layout I believe). So my
> conclusion is that really FTL on your drive sucks (or possibly the drive
> doesn't have enough "hidden" additional space to ease the load on FTL when
> the disk gets full).
>
> And with this full filesystem fstrim isn't going to help you because we can
> trim only free blocks and there aren't that many of those. Sorry.

OK, but why does it become worse over time?
And can I somehow "reset" whatever it is that is making it worse so that 
it becomes good again? That way I could spend maybe 1 hour once every 
few months to get it back to top speed.
Any other ideas how I could make this (very expensive and fairly new 
ZenBook) laptop usable?
Also, why doesn't this happen with USB memory sticks?

And many thanks for all your help with this issue! And thanks also to 
Sprouse and Ts'o!


Best regards,
Marcus

