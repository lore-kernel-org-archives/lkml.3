Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaCFQCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:02:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47271 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaCFQCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:02:08 -0500
Message-ID: <53189BF8.1010308@oracle.com>
Date: Thu, 06 Mar 2014 11:02:00 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
References: <52B23CEA.7090405@oracle.com> <52CD762B.7020600@oracle.com> <53123D81.6080003@oracle.com> <20140303214040.GA15265@quack.suse.cz> <53166920.709@oracle.com> <20140305124536.GA32371@quack.suse.cz>
In-Reply-To: <20140305124536.GA32371@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 07:45 AM, Jan Kara wrote:
> On Tue 04-03-14 19:00:32, Sasha Levin wrote:
>> On 03/03/2014 04:40 PM, Jan Kara wrote:
>>> On Sat 01-03-14 15:05:21, Sasha Levin wrote:
>>>>> ping again?
>>>>>
>>>>> I've been working on it, but don't see an obvious issue.
>>>>>
>>>>> It does look like an access to invalid memory easily doable from
>>>>> userspace, so it should probably get fixed soon...
>>>    Hum, can you maybe dump the name in dentry passed to simple_setattr()? Or
>>> maybe even the whole path using dentry_path() (but not sure if that will
>>> be workable on half-torn-down fs)? Maybe it will give us a hint at which
>>> filesystem to look...
>>
>> It's just garbage, this is why I'm having a hard time making any progress with
>> this bug.
>    OK, but that is strange because we hold a reference to the dentry so
> noone should free it. So dentry->d_name should be valid... Is the rest of
> the dentry also garbage? E.g. does dentry->d_inode still point to the inode
> we call __mark_inode_dirty() on? Is dentry->d_sb == dentry->d_inode->i_sb?
> Also if the inode isn't completely garbage, we can maybe infer something
> from inode->i_op - that should point to some statically allocated
> operations struct so we should be able to guess fs type from that.

It's actually pretty tricky. This issue being a race makes catching it at the right time
difficult.

I've tried catching it in simple_setattr() before calling mark_inode_dirty() by testing
for the poison values inside inode, but they seem to be perfectly fine there and still
show up as bad within mark_inode_dirty().

Then I tried trapping it inside mark_inode_dirty(), but at that point I usually get garbage
inside inode, and have no way to go back to dentry.

Right now I'm just trying to dump everything that goes through simple_setattr() in hopes that
I could easily figure out what went wrong by looking at the log, but that just stops the bug
from reproducing.


Thanks,
Sasha
