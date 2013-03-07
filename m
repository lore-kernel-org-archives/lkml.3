Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab3CGRqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:46:15 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59246 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3CGRqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:46:14 -0500
Message-ID: <1362678371.15793.218.camel@edumazet-glaptop>
Subject: Re: 3.9-rc1 NULL pointer crash at find_pid_ns
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: ebiederm@xmission.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Date: Thu, 07 Mar 2013 09:46:11 -0800
In-Reply-To: <5138D001.8000409@oracle.com>
References: <611667212.10748821.1362649031475.JavaMail.root@redhat.com>
	 <513860E8.4080807@huawei.com> <876213wmwt.fsf@xmission.com>
	 <5138D001.8000409@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 12:36 -0500, Sasha Levin wrote:

> Looks like the hlist change is probably the issue, though it specifically
> uses:
> 
> 	#define hlist_entry_safe(ptr, type, member) \
>         	(ptr) ? hlist_entry(ptr, type, member) : NULL
> 
> I'm still looking at the code in question and it's assembly, but I can't
> figure out what's going wrong. I was also trying to see what's so special
> about this loop in find_pid_ns as opposed to the rest of the kernel code
> that uses hlist_for_each_entry_rcu() but couldn't find out why.
> 
> Is it somehow possible that if we rcu_dereference_raw() the same thing twice
> inside the same rcu_read_lock() section we'll get different results? That's
> really the only reason for this crash that comes to mind at the moment, very
> unlikely - but that's all I have right now.
> 

Yep

#define hlist_entry_safe(ptr, type, member) \
	(ptr) ? hlist_entry(ptr, type, member) : NULL

Is not safe, as ptr can be evaluated twice, and thats not good at all...


> Is this bug reproducible easily on your setup? I've managed to reproduce it
> exactly 3 times in the past month or so, twice when I reported it and only
> once since then - at some point I thought that it was a freak compiler issue
> that went away when the code changed but since you're reporting it again
> I guess that it isn't the case.
> 
> 
> Paul, any chance you can give hlist_for_each_entry_rcu() a second look please?
> I know you've already acked it before, but is it possible I missed a subtle
> detail with RCU that causes this?
> 


