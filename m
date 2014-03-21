Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbaCUIc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:32:26 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49092 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbaCUIcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:32:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140320222343.4faaa137@gandalf.local.home>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
	<20140320222343.4faaa137@gandalf.local.home>
Date: Fri, 21 Mar 2014 12:32:12 +0400
X-Google-Sender-Auth: VnXSxgGsa_ORncoF3WJuqjcRmiw
Message-ID: <CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work queues
From: Pavel Shilovsky <piastry@etersoft.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeff Layton <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-21 6:23 GMT+04:00 Steven Rostedt <rostedt@goodmis.org>:
> On Thu, 20 Mar 2014 17:02:39 -0400
> Jeff Layton <jlayton@redhat.com> wrote:
>
>> Eventually the server should just allow the read to complete even if
>> the client doesn't respond to the oplock break. It has to since clients
>> can suddenly drop off the net while holding an oplock. That should
>> allow everything to unwedge eventually (though it may take a while).
>>
>> If that's not happening then I'd be curious as to why...
>
> The problem is that the data is being filled in the page and the reader
> is waiting for the page lock to be released. The kworker for the reader
> will issue the complete() and unlock the page to wake up the reader.
>
> But because the other workqueue callback calls down_read(), and there
> can be a down_write() waiting for the reader to finish, this
> down_read() will block on the lock as well (rwsems are fair locks).
> This blocks the other workqueue callback from issuing the complete and
> page_unlock() that will wake up the reader that is holding the rwsem
> with down_read().
>
> DEADLOCK.

Thank you for reporting and clarifying the issue!

Read and write codepaths both obtain lock_sem for read and then wait
for cifsiod_wq to complete and release lock_sem. They don't do any
lock_sem operations inside their work task queued to cifsiod_wq. But
oplock code can obtain/release lock_sem in its work task. So, that's
why I agree with Jeff and suggest to move the oplock code to a
different work queue (cifsioopd_wq?) but leave read and write
codepaths use cifsiod_wq.

-- 
Best regards,
Pavel Shilovsky.
