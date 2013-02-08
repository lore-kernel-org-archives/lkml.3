Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab3BHDmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:42:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42207 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842Ab3BHDm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:42:29 -0500
MIME-Version: 1.0
Date: Thu, 7 Feb 2013 19:42:28 -0800
Message-ID: <CAOMFOmXiEUnqkoQg6bA4N3jg5ERMKoydOdmn7djkpFyfZk19cg@mail.gmail.com>
Subject: Improving AIO cancellation
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, koverstreet@google.com,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

At Google we have several applications that heavily use asynchronous
IO. One thing that our userspace developers need is effective AIO
cancellation. You might say "sure use io_cancel syscall". Well, while
it cancels AIO requests it does it ineffectively. Currently (I am
looking at linux-next) io_cancel only marks kiocb as cancelled. The
bios still be issued to device even after kiocb was cancelled. Let's
say you have a congested device and want to cancel some AIO requests -
io_cancel will not make situation better. We would like to see more
resource effective AIO cancellation.

I had a discussion with Ted Tso and Kent Overstreet about improving
this situation and would like to share the ideas with you, linux
community.

Once direct async IO is submitted the request can be at several stages:
1) Sitting in kernel request queue of a congested device
2) Sent to device and sitting in device queue (if NCQ is enabled)
3) Executing on device

Ideally if we can cancel an IO request on any of these stages. But
currently we are especially interested in case #1. I do not know if
cancellation at stage #2 and #3 is possible and/or reasonable.

BTW AIO cancellation makes sense only for direct IO. Buffered AIO will
end up in buffer soon and kiocb will be marked as completed. Later
(maybe much later) writeback will flush those buffers to disk, but you
cannot cancel it..

And yet another thing to remember is md/RAID. Some types of raid
support stripes consistency. When md splits a WRITE across disks
either all or no of the child requests should be completed. If we do
partial write then the disk data will become inconsistent.


Ted and Kent suggested following solution: any time when we do forward
progress with request/bio we need to check its status. If user
cancelled the request then just skip this bio. So it covers case #1.

The draft implementation will look like this. struct bio should have
some way to get current status of kiocb that generated bio. So we add
a pointer to bool flag.

struct bio {
  bool *cancelled;
}

in async DIO codepath this pointer will be initialized with bool at
"struct kiocb"
  bio->cancelled = &kiocb->cancelled;
except md. If it is RAID5 and we perform WRITE request then we do not
initialize this pointer.


when we do forward progress with request/bio we check its cancellation status:
if (bio->cancelled && *bio->cancelled)
  goto do_not_process_bio_because_it_cancelled;

So to cancel kiocb we do
kiocb->cancelled = true;
and all bio created from the request will not be send to device anymore.


The solution seems straightforward, but I would like to hear if there
are other solutions to make AIO cancellation better. Does suggested
implementation looks good? Are there better solutions? What about
cancelling requests that are already sent to device?

If the proposal is fine then I start implementing it.
