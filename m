Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921Ab3CSWE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:04:29 -0400
Received: from relay.parallels.com ([195.214.232.42]:43652 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab3CSWE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:04:28 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<devel@openvz.org>" <devel@openvz.org>,
        "Doug Ledford" <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] mqueue: sys_mq_open: do not call mnt_drop_write() if
 read-only
Thread-Topic: [PATCH] mqueue: sys_mq_open: do not call mnt_drop_write() if
 read-only
Thread-Index: AQHOJOYWgM451JYjsUG/OGs2vTCvnJitTooA
Date: Tue, 19 Mar 2013 22:04:16 +0000
Message-ID: <049D7A4CCB8B694CACDEEB03BE35F306184853A6@MSK-EXCH.sw.swsoft.com>
References: <1363685478-9997-1-git-send-email-vdavydov@parallels.com>
 <20130319140940.fa84e0b678235076815fce64@linux-foundation.org>
In-Reply-To: <20130319140940.fa84e0b678235076815fce64@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.21.126]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D164C0204E6DE640904626FB22539333@sw.swsoft.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 20, 2013, at 1:09 AM, Andrew Morton <akpm@linux-foundation.org>
 wrote:

> On Tue, 19 Mar 2013 13:31:18 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
> 
>> mnt_drop_write() must be called only if mnt_want_write() succeeded,
>> otherwise the mnt_writers counter will diverge.
>> 
>> ...
>> 
>> --- a/ipc/mqueue.c
>> +++ b/ipc/mqueue.c
>> @@ -840,7 +840,8 @@ out_putfd:
>> 		fd = error;
>> 	}
>> 	mutex_unlock(&root->d_inode->i_mutex);
>> -	mnt_drop_write(mnt);
>> +	if (!ro)
>> +		mnt_drop_write(mnt);
>> out_putname:
>> 	putname(name);
>> 	return fd;
> 
> huh, that's been there for a while.  What were the runtime-visible
> effects of the bug?

mnt_writers counters are used to check if remounting FS as read-only is OK, so after an extra mnt_drop_write() call, it would be impossible to remount mqueue FS as read-only. Besides, on umount a warning would be printed like this one:

[  194.714880] =====================================
[  194.719680] [ BUG: bad unlock balance detected! ]
[  194.724488] 3.9.0-rc3 #5 Not tainted
[  194.728159] -------------------------------------
[  194.732958] a.out/12486 is trying to release lock (sb_writers) at:
[  194.739355] [<ffffffff811b177f>] mnt_drop_write+0x1f/0x30
[  194.744851] but there are no more locks to release!

