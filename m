Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaAQRbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:31:15 -0500
Received: from nautica.notk.org ([91.121.71.147]:34313 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaAQRbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:31:12 -0500
From: Dominique Martinet <dominique.martinet@cea.fr>
To: Eric Van Hensbergen <ericvh@gmail.com>, linux-fsdevel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Cc: Dominique Martinet <dominique.martinet@cea.fr>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/1] 9P: Add memory barriers to protect request fields over cb/rpc threads handoff
Date: Fri, 17 Jan 2014 18:30:59 +0100
Message-Id: <1389979860-7821-1-git-send-email-dominique.martinet@cea.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch addresses the race I'm describing below.
It currently mostly affects trans_rdma, but the fix has to go in the
common part of the code.
virtio and tcp really aren't consciously protected though, so I believe
this can't hurt. They *might* be safe at the moment because other
changes to req are made within an unrelated spin lock and the
unlocking does a write barrier... But I wouldn't bet much on it.


Short version:
9P/RDMA stops having odd crashes about null dereferences in
p9_parse_header once every few hours of heavy use.


Long version:
Null deref in here:
...
    [exception RIP: p9_parse_header+37]
    RIP: ffffffffa07477d7  RSP: ffff88105b8bf8c8  RFLAGS: 00010292
    RAX: 0000000000000000  RBX: 0000000000000000  RCX: 0000000000000000
    RDX: ffff88105b8bf94b  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff88105b8bf918   R8: 0000000000000000   R9: 000000000000000c
    R10: ffff88082fc00020  R11: 0000000000000000  R12: 0000000000000000
    R13: ffff88105b8bf94b  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff88105b8bf920] p9_client_rpc at ffffffffa074841b [9pnet]
#10 [ffff88105b8bfa00] p9_client_getattr_dotl at ffffffffa0749278
#[9pnet]
#11 [ffff88105b8bfad0] v9fs_inode_from_fid_dotl at ffffffffa0763562 [9p]
#12 [ffff88105b8bfb10] v9fs_get_new_inode_from_fid at ffffffffa0762630
#[9p]
...

Looking at the disassembly/full bt, p9_parse_header's first argument
(req->rc) is indeed NULL, but looking for req in the stack, it's 'rc'
member isn't.


Illustrating for the rdma code, I'm looking at two threads:
First, in net/9p/client.c, we have:
------------------------------------------------------------------------
p9_client_rpc(...)
{
...
	err = c->trans_mod->request(c, req);
...
	err = wait_event_interruptible(*req->wq,
				       req->status >= REQ_STATUS_RCVD);
...
	/* stuff using req->rc: p9_check_errors() is inlined in and
	calls: p9_parse_header(req->rc, NULL, &type, NULL, 0); */
...
}
------------------------------------------------------------------------

Second, in the rdma side of the code:
------------------------------------------------------------------------
handle_recv(...)
{
...
	req = p9_tag_lookup(client, tag);
...
	req->rc = c->rc;
	req->status = REQ_STATUS_RCVD;
	p9_client_cb(client, req);
...
}

where p9_client_cb() is back in client.c:
void p9_client_cb(struct p9_client *c, struct p9_req_t *req)
{
	p9_debug(P9_DEBUG_MUX, " tag %d\n", req->tc->tag);
	wake_up(req->wq);
	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc->tag);
}
------------------------------------------------------------------------



So, basically, one thread sends a message and waits till a reply is
received, another thread receives messages, fills appropriate structures
and wakes up the first thread.


Now let's look at this (albeit unlikely) possible timing:

      Thread 1                     |        Thread 2 
                                   |
send request                       |
/* scheduled off somewhere */      |
                                   | receives reply
                                   | set req->rc
                                   | set req->status
                                   | wake_up()
                                   | /* nothing to wake up, no write
                                   |    barrier */
                                   | cpu cache flushes req->status
                                   | before req->rc
                                   |
wait_event_interruptible           |
 -> nothing to wait for,           |
    since status is good:          |
     no read barrier               |
                                   |
potential incorrect use of req->rc |


Now I read in Documentation/memory-barrier.txt that
wait_event_interruptible implies a general memory barrier, but looking
at the code if the condition is already fulfilled then it does not; so
we need an explicit read barrier after the wait.
(a scheduling should also do a barrier, so arguably if the condition is
filled directly then there should be that one, but it doesn't feel safe
timing-wise)

I also read that wake_up does a write barrier if and only if it wakes
another thread up.. But I'm not sure about that either, and it actually
wouldn't be strong enough for us.
Thanks to Peter Zijlstra for helping me sort this out :)

What we need is:
[w] req->rc, 1          [r] req->status, 1
wmb                     rmb
[w] req->status, 1      [r] req->rc

Where the wmb ensures that rc gets written before status,
and the rmb ensures that if you observe status == 1, rc is the new value.



Anyway, this patch does this in the tidiest way I could come up with.
I'm not sure it would be a good idea not to do the barriers for
TCP/virtio, but if one of you *want* to and have a clean way to, feel
free to suggest a patch that adds barrier to RDMA only.

(FWIW, I didn't try virtio, but for tcp I actually noticed better
performances for some reason. I'm not sure of why, but I'd need to run
more tests...)

I'm also interested in any comment to make the commit message better; I
tried to sum this whole thing up but I'm not sure I made it clear enough
(the whole reason I need a 0/1 patch message!)

Thank you for your time if you have read this far! :)

Dominique Martinet (1):
  9P: Add memory barriers to protect request fields over cb/rpc threads
    handoff

 include/net/9p/client.h |  2 +-
 net/9p/client.c         | 16 +++++++++++++++-
 net/9p/trans_fd.c       | 15 ++++++---------
 net/9p/trans_rdma.c     |  3 +--
 net/9p/trans_virtio.c   |  3 +--
 5 files changed, 24 insertions(+), 15 deletions(-)

-- 
1.8.1.4
