Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaD2Xgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:36:32 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39272 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaD2Xg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:36:26 -0400
Date: Tue, 29 Apr 2014 16:36:22 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin LaHaise <bcrl@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aio: change exit_aio() to load mm->ioctx_table once
 and avoid rcu_read_lock()
Message-ID: <20140429233622.GA7480@kmo-pixel>
References: <20140429183915.GA32513@redhat.com>
 <20140429183930.GA32521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429183930.GA32521@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 08:39:30PM +0200, Oleg Nesterov wrote:
> 1. We can read ->ioctx_table only once and we do not read rcu_read_lock()
>    or even rcu_dereference().
> 
>    This mm has no users, nobody else can play with ->ioctx_table. Otherwise
>    the code is buggy anyway, if we need rcu_read_lock() in a loop because
>    ->ioctx_table can be updated then kfree(table) is obviously wrong.
> 
> 2. Update the comment. "exit_mmap(mm) is coming" is the good reason to avoid
>    munmap(), but another reason is that we simply can't do vm_munmap() unless
>    current->mm == mm and this is not true in general, the caller is mmput().

I'm pretty sure you're analysis is all correct. IIRC there's other things in the
shutdown path we still have to be carefull with synchronization wise, but unless
I've forgotten something you're right about ioctx_table.

If I wrote that code (I'd have to check git blame), I'd say I just wrote it that
way because I prefer to be consistent about how things like RCU protected
pointers are accessed, even if it's not strictly necessary. Feels less tricky to
me. But I don't have a strong preference one way or the other.

w.r.t. ioctx->dead, yes, no need for it to be atomic. a regular int and xchg()
is probably more correct anyways since xchg() implies memory barriers and
atomic_xchg() does not.
