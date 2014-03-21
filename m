Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276AbaCUCTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:19:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:5540 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965106AbaCUCTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:19:19 -0400
Date: Thu, 20 Mar 2014 22:19:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Message-ID: <20140320221913.104b275d@gandalf.local.home>
In-Reply-To: <20140320195346.0876e175@tlielax.poochiereds.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320195346.0876e175@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 19:53:46 -0400
Jeff Layton <jlayton@redhat.com> wrote:
 
> Wait...why does the work running on CPU1 end up blocked on down_read()?
> Is it really getting stuck on the down_write you mention?
> 

rwsems are fair locks. Readers will not block on a reader lock unless
there's a writer waiting. That's the key. As soon as a writer blocks on
a lock that is held by a reader (or multiple readers), new readers
coming in will also block to let the writer get a chance. Otherwise, it
is a unfair lock and the readers can starve the writer.

But people tend to forget that a waiting writer causes readers to block
on each other, and if the reader locks can deadlock each other, they
will deadlock with a writer waiting.

-- Steve

