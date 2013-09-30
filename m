Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3I3Vo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:44:56 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:38734 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab3I3Voz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130930200313.GT13318@ZenIV.linux.org.uk>
References: <1379353350-11320-1-git-send-email-adityakali@google.com>
 <20130917024040.GH13318@ZenIV.linux.org.uk> <523B5AEA.1070808@google.com>
 <CAGr1F2E1Xo7Y_xb-UXt6WCyhi0Hq+ygovuAp8pAHkwTkKOV-FA@mail.gmail.com>
 <5249BF43.705@google.com> <20130930200313.GT13318@ZenIV.linux.org.uk>
From: Aditya Kali <adityakali@google.com>
Date: Mon, 30 Sep 2013 14:44:33 -0700
Message-ID: <CAGr1F2HF0sXD5Ejq3HN9YAtpeLqYJkZc=79+B=2XErj_Z_kufA@mail.gmail.com>
Subject: Re: [RFC] vfs: avoid sb->s_umount lock while changing bind-mount flags
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatol Pomazau <anatol@google.com>, "Theodore Ts'o" <tytso@mit.edu>,
        tj@kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 1:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Sep 30, 2013 at 11:13:23AM -0700, Aditya Kali wrote:
>> +Ted Ts'o, Tejun Heo, Jens Axboe
>>
>>
>> On 09/30/2013 10:54 AM, Aditya Kali wrote:
>> >Hi Al and other fs-developers,
>> >
>> >Please let me know what you think about this patch.
>
> Don't top-post, please...  What prevents a race between MS_BIND remounts
> and plain ones?  Used to be serialized on ->s_umount, but...

The rational here is that MS_BIND remounts need to act on the bind
mount-point only (struct vfsmount *) and not on the underlying
superblock (struct super_block *). So, intuitively, it should not be
necessary to take a superblock level lock for the MS_BIND case. As for
the modification of mnt_flags on vfsmount, there is already
vfsmount_lock taken in both MS_BIND and non-MS_BIND case to prevent
the race.

Following is the example that demonstrates the problem that I am
trying to address with this patch:

(1) /dev/sda is mounted at /mnt/sda
(2) /mnt/sda/users/user1 is bind mounted at /home/user1/ ;
/mnt/sda/users/user2 is bind mounted at /home/user2/
(3) user1 is doing buffered writes in /home/user1/logs/
(4) admin tries to make /home/user2/bin/ read-only using a bind-mounts:
    $ mount --bind /home/user2/bin/ /home/user2/bin/    # this is fast
    $ mount --bind -o remount,ro /home/user2/bin/    # this blocks
behind any writeback happening on sda (because of sb->s_umount write
lock)

Please advise.

Thanks,
-- 
Aditya
