Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaENWkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:40:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaENWkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:40:37 -0400
Message-ID: <5373F0D6.4090600@redhat.com>
Date: Wed, 14 May 2014 17:40:22 -0500
From: Eric Sandeen <esandeen@redhat.com>
Reply-To: sandeen@redhat.com
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
CC: Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing filesystems
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com> <1400018683-5565-2-git-send-email-mguzik@redhat.com> <20140514111449.GB5824@quack.suse.cz> <20140514112619.GA10637@mguzik.redhat.com> <20140514113945.GC5824@quack.suse.cz> <20140514220052.GD5421@dastard> <20140514223745.GF5421@dastard>
In-Reply-To: <20140514223745.GF5421@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/14, 5:37 PM, Dave Chinner wrote:
> On Thu, May 15, 2014 at 08:00:52AM +1000, Dave Chinner wrote:
>> On Wed, May 14, 2014 at 01:39:45PM +0200, Jan Kara wrote:
>>> On Wed 14-05-14 13:26:21, Mateusz Guzik wrote:
>>>> On Wed, May 14, 2014 at 01:14:49PM +0200, Jan Kara wrote:
>>>>> On Wed 14-05-14 00:04:43, Mateusz Guzik wrote:
>>>>>> This helps hang troubleshooting efforts when only dmesg is available.
>>>>>>
>>>>>> While here remove code duplication with MS_RDONLY case and fix a
>>>>>> whitespace nit.
>>>>>   I'm somewhat undecided here I have to say. On one hand I don't like
>>>>> printing to kernel log when everything is fine and kernel is operating
>>>>> normally. On the other hand I've seen quite a few cases where people have
>>>>> shot themselves in the foot with filesystem freezing so having some trace
>>>>> of this in the log doesn't seem like a completely bad thing either. What do
>>>>> other people think?
>>>>>
>>>>
>>>> I would like to note that the kernel already prints messages when e.g.
>>>> filesystems get mounted.
>>>   Yeah, that's a fair point.
>>
>> But filesystems choose to output that info, not the VFS. When you do
>> a remount,ro there is no output in syslog, because filesystems don't
>> need to dump any output - the state change is reflected in
>> /proc/self/mounts. IMO frozen should state should be communicated
>> the same way so that it is silent when it just works, and the state
>> can easily be determined when something goes wrong.
> 
> Say, like this:
> 
> $ grep /mnt/test /proc/mounts
> /dev/vda /mnt/test xfs rw,relatime,attr2,inode64,noquota 0 0
> $ sudo xfs_freeze -f /mnt/test
> $ grep /mnt/test /proc/mounts
> /dev/vda /mnt/test xfs rw,frozen,relatime,attr2,inode64,noquota 0 0
> $ sudo xfs_freeze -u /mnt/test
> $ grep /mnt/test /proc/mounts
> /dev/vda /mnt/test xfs rw,relatime,attr2,inode64,noquota 0 0
> $

I'm not totally convinced that including a non-mount option in what
has always (?) been a list of mount options is a great idea.

(Granted, some options there are defaults, and weren't actually specified
as a mount option, but if they had been, they'd have been accepted).

Maybe add a "mount -o remount,frozen" handler ?  ;)

-Eric
