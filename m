Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965442AbaCUCYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:24:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:5488 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965355AbaCUCYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:24:07 -0400
Date: Thu, 20 Mar 2014 22:23:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com, Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Message-ID: <20140320222343.4faaa137@gandalf.local.home>
In-Reply-To: <20140320170239.51d20a0e@tlielax.poochiereds.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 17:02:39 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> Eventually the server should just allow the read to complete even if
> the client doesn't respond to the oplock break. It has to since clients
> can suddenly drop off the net while holding an oplock. That should
> allow everything to unwedge eventually (though it may take a while).
> 
> If that's not happening then I'd be curious as to why...

The problem is that the data is being filled in the page and the reader
is waiting for the page lock to be released. The kworker for the reader
will issue the complete() and unlock the page to wake up the reader.

But because the other workqueue callback calls down_read(), and there
can be a down_write() waiting for the reader to finish, this
down_read() will block on the lock as well (rwsems are fair locks).
This blocks the other workqueue callback from issuing the complete and
page_unlock() that will wake up the reader that is holding the rwsem
with down_read().

DEADLOCK.


-- Steve
