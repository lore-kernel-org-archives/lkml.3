Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaCNNHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:07:18 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34686 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCNNHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:07:16 -0400
Date: Fri, 14 Mar 2014 09:07:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Roman Peniaev <r.peniaev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-ID: <20140314130712.GC12613@htj.dyndns.org>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
 <20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
 <CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
 <CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
 <20140313200119.GB504@quack.suse.cz>
 <20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Mar 13, 2014 at 02:34:56PM -0700, Andrew Morton wrote:
> Jens isn't talking to us.  Tejun, are you able explain REQ_SYNC?

It has nothing to do with data integrity.  It's just a hint telling
the block layer that someone is waiting for the IO so it'd be a good
idea to prioritize it.  For example, nothing visible to userland
really waits for periodic writebacks, so we can delay their processing
to prioritize, for example, READs triggered from a page fault, which
is obviously causing userland visible latency.

Block layer treats all READs as REQ_SYNC and also allows upper layers
to mark some writes REQ_SYNC for cases where somebody is waiting for
the write to complete for cases like flush(2).

> From: Roman Pen <r.peniaev@gmail.com>
> Subject: fs/mpage.c: forgotten WRITE_SYNC in case of data integrity write
> 
> In case of wbc->sync_mode == WB_SYNC_ALL we need to do data integrity
> write, thus mark request as WRITE_SYNC.

So, at least this patch description is very misleading.  WRITE_SYNC
has *NOTHING* to do with data integrity.  The only thing matters is
whether somebody is waiting for its completion or not.

Thanks.

-- 
tejun
