Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3BVX1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:27:44 -0500
Received: from hibox-130.abo.fi ([130.232.216.130]:35436 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139Ab3BVX1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:27:42 -0500
Message-ID: <5127FEEA.60207@hibox.fi>
Date: Sat, 23 Feb 2013 01:27:38 +0200
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <20121107161730.GB23654@quack.suse.cz> <509C4339.2090506@hibox.fi> <509D014B.2080709@hibox.fi> <20121113135159.GA18651@quack.suse.cz> <50A592BA.8050709@hibox.fi> <20121121233021.GA8730@quack.suse.cz> <50B4E6F2.6010000@hibox.fi> <20121205153216.GF5706@quack.suse.cz> <51248C5F.4040606@hibox.fi> <5124B613.6040400@hibox.fi> <20130222205144.GA30600@quack.suse.cz>
In-Reply-To: <20130222205144.GA30600@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.02.2013 22:51, Jan Kara wrote:
> On Wed 20-02-13 13:40:03, Marcus Sundman wrote:
>> On 20.02.2013 10:42, Marcus Sundman wrote:
>>> On 05.12.2012 17:32, Jan Kara wrote:
>>>>    I see. Maybe you could have something like
>>>> while true; do echo w >/proc/sysrq-trigger; sleep 10; done
>>>>    running in the background?
>>> Sure, but I suspect it'll take until the worst is over before it
>>> manages to load and execute that "echo w".
>> Here is a big run of sysrq-triggering, all while I was uncompressing
>> a big rar file causing the whole system to be utterly unusable.
>> NB: Even with realtime I/O-priority the sysrq couldn't be triggered
>> between 12:41:54 and 12:42:49, as you can see from the dmesg-3.txt
>> file.
>>
>> $ sudo ionice -c 1 su
>> # ionice
>> realtime: prio 4
>> # while true; do sleep 10; echo w >/proc/sysrq-trigger; done
>> ^C
>> # tail -n +1700 /var/log/syslog >dmesg-3.txt
>>
>> http://sundman.iki.fi/dmesg-3.txt
>    Thanks for the traces. I was looking at them and we seem to be always
> waiting for IO. There don't seem to be that much CPU load either.
>
> I'm actually starting to suspect the SSD in your laptop.

I've suspected the driver, because I don't remember it being slow in 
windows before I wiped it and installed ubuntu on it. (I didn't do very 
much with it in windows, though. I just downloaded the ubuntu image, but 
AFAICR it had no problem saving the image at the speed of my internet 
connection (which is normally around 6 MiB/s), but nowadays I have to 
strype my downloads to less than 1 MiB/s for it to not lock up so much.)

> The svctm field
> from iostat output shows it takes 1 second on average to complete an IO
> request. That is awfully slow given one request has ~180 KB of data on
> average. Ah, one more idea - can you post your /proc/mounts please?

Sure:
> $ cat /proc/mounts
> rootfs / rootfs rw 0 0
> sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> udev /dev devtmpfs rw,relatime,size=1964816k,nr_inodes=491204,mode=755 0 0
> devpts /dev/pts devpts 
> rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
> tmpfs /run tmpfs rw,nosuid,relatime,size=789652k,mode=755 0 0
> /dev/disk/by-uuid/5bfa7a58-2d35-4758-954e-4deafb09b892 / ext4 
> rw,noatime,discard,errors=remount-ro 0 0
> none /sys/fs/fuse/connections fusectl rw,relatime 0 0
> none /sys/kernel/debug debugfs rw,relatime 0 0
> none /sys/kernel/security securityfs rw,relatime 0 0
> none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
> none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
> none /run/user tmpfs 
> rw,nosuid,nodev,noexec,relatime,size=102400k,mode=755 0 0
> /dev/sda6 /home ext4 rw,noatime,discard 0 0
> binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc 
> rw,nosuid,nodev,noexec,relatime 0 0
> gvfsd-fuse /run/user/marcus/gvfs fuse.gvfsd-fuse 
> rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0

Both / and /home are on the same SSD and suffer from the same problem. 
(I think the swap does as well, but I have my swappiness set very low to 
minimize swapping.)

Regards,
Marcus

