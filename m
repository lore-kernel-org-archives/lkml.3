Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794Ab3DBG1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:27:32 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:36805 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759535Ab3DBG1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:27:31 -0400
Message-ID: <1364884045.3301.18.camel@slavad-ubuntu>
Subject: Re: mkfs.f2fs gets stuck with "blk_update_request: bio idx 0 >=
 vcnt 0" on 3.8
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 02 Apr 2013 10:27:25 +0400
In-Reply-To: <5159EC3D.2020501@gmail.com>
References: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
	 <254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
	 <5159EC3D.2020501@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.126.90 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 00:21 +0400, Max Filippov wrote:

[snip]
> > 
> > Could you share "cat /proc/partitions" and "strace mkfs.f2fs /dev/mmcblk0p3" outputs? I think that these outputs can be very useful for issue analysis.
> > 
> > By the way, can you reproduce the issue on another SD-card? Do you reproduce the issue only under pandaboard?
> 
> Yes, I can reproduce it on three SD cards of different vendors and different sizes.
> Unfortunately ATM I don't have any other board to try it on.
> 
> # cat /proc/partitions
> major minor  #blocks  name
> 
>  179        0    7782400 mmcblk0
>  179        1      40131 mmcblk0p1
>  179        2      32130 mmcblk0p2
>  179        3    5685248 mmcblk0p3
> 


As I see, you have several partition on your SD-card. How did it
prepared?

> strace output is the following:
> 
[snip]
> write(1, "Info: sector size = 512\n", 24) = 24
> write(1, "Info: total sectors = 11370496 ("..., 45) = 45
> write(1, "Info: zone aligned segment0 blka"..., 41) = 41
> fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(179, 3), ...}) = 0
> ioctl(3, BLKDISCARD

As I understand, the BLKDISCARD ioctl (to pre-discard all blocks on an
ssd, or a thinly-provisioned storage device) is a visible reason of the
issue. Unfortunately, as I see, mkfs.f2fs doesn't support option to
format partition without blocks discard step.

So, I think that it needs to investigate issue in the direction of
BLKDISCARD code on the kernel side. It makes sense to debug
f2fs_trim_device() method of mkfs.f2fs utility too. But I can't see
anything strange in this function at a glance.

With the best regards,
Vyacheslav Dubeyko.

> 
> 


