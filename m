Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaHLQVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:21:22 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35440 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaHLQVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:21:20 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Tue, 12 Aug 2014 12:21:16 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 0/5] locks: move most locks_release_private calls
 outside of i_lock
Message-ID: <20140812122116.5e047c3d@tlielax.poochiereds.net>
In-Reply-To: <20140812153229.GA15922@infradead.org>
References: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
	<20140812153229.GA15922@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014 08:32:29 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> Btw, I might be missing something here, but wouldn't it be better
> to reference count the file_lock structure and grab a reference to
> it where we currently call (__)locks_copy_lock?
> 

It's not really possible with the way this code works at the moment.
The problem there is that struct file_lock can represent any of:

- a lock request (copied from userland into a kernel structure)
- a lock record (that lives on the i_flock list)
- a conflicting lock record (returned by GETLK-type request)

In many cases we call (__)locks_copy_lock to copy from one "use-type" of
struct file_lock to another, and doing that with refcounts makes that a
bit difficult to manage.

If I were designing this code from scratch, I'd have probably made each
use-type a distinct structure. Maybe we should do that anyway at
some point -- I'm not sure.

Now, all that said...I think we will end up needing to do some sort of
refcounting to fix the leasing code at some point. Currently,
->setlease operations can't block, which is a significant impediment to
adding leases to clustered filesystems and the like. It would be nice
to lift that limitation and that may require making leases be
refcounted (or maybe RCU-managed).

-- 
Jeff Layton <jlayton@primarydata.com>
