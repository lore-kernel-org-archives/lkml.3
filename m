Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3KVVFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:05:33 -0500
Received: from mail-ph.de-nserver.de ([85.158.179.214]:43219 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3KVVFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:05:31 -0500
X-Fcrdns: No
Message-ID: <528FC722.7010703@profihost.ag>
Date: Fri, 22 Nov 2013 22:05:38 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Chinmay V S <cvs268@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
References: <528CA73B.9070604@profihost.ag> <20131120125446.GA6284@infradead.org> <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com> <528CC36A.7080003@profihost.ag> <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com> <20131120153703.GA23160@thunk.org> <20131120155507.GA5380@fieldses.org> <CAK-9PRCQ6qWvzpdvK8BswpS+TfgM7NeoRaVdChFHhyDjwtUGTw@mail.gmail.com> <20131120175807.GC5380@fieldses.org> <CAK-9PRDNxHAX70cN88kRt03FkYbDB_x1cFQQYmVzqiCX=aZD6w@mail.gmail.com> <20131121101101.GA18404@infradead.org> <528FB828.5000301@profihost.ag> <528FC09E.5090004@redhat.com>
In-Reply-To: <528FC09E.5090004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ric,

Am 22.11.2013 21:37, schrieb Ric Wheeler:
> On 11/22/2013 03:01 PM, Stefan Priebe wrote:
>> Hi Christoph,
>> Am 21.11.2013 11:11, schrieb Christoph Hellwig:
>>>>
>>>> 2. Some drives may implement CMD_FLUSH to return immediately i.e. no
>>>> guarantee the data is actually on disk.
>>>
>>> In which case they aren't spec complicant.  While I've seen countless
>>> data integrity bugs on lower end ATA SSDs I've not seen one that simpliy
>>> ingnores flush.  If you'd want to cheat that bluntly you'd be better
>>> of just claiming to not have a writeback cache.
>>>
>>> You solve your performance problem by completely disabling any chance
>>> of having data integrity guarantees, and do so in a way that is not
>>> detectable for applications or users.
>>>
>>> If you have a workload with lots of small synchronous writes disabling
>>> the writeback cache on the disk does indeed often help, especially with
>>> the non-queueable FLUSH on all but the most recent ATA devices.
>>
>> But this isn't correct for drives with capicitors like Crucial m500,
>> Intel DC S3500, DC S3700 isn't it? Shouldn't the linux kernel has an
>> option to disable this for drives like these?
>> /sys/block/sdX/device/ignore_flush
>
> If you know 100% for sure that your drive has a non-volatile write
> cache, you can run the file system without the flushing by mounting "-o
> nobarrier".  With most devices, this is not needed since they tend to
> simply ignore the flushes if they know they are power failure safe.

Thanks - but i have raw block devices the data goes to .

> Block level, we did something similar for users who are not running
> through a file system for SCSI devices - James added support to echo
> "temporary" into the sd's device's cache_type field:
>
> See:
>
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=2ee3e26c673e75c05ef8b914f54fadee3d7b9c88

So i have to switch to write through but i'm still using the wb cache of 
the device?

echo temporary write through > /sys/class/scsi_disk/<disk>/cache_type

Thanks!

Stefan
