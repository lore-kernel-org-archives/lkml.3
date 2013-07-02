Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3GBQNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:13:45 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:57586 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3GBQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:13:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130702140508.GB31770@quack.suse.cz>
References: <20130627125218.GB32195@dastard>
	<20130627152151.GA11551@redhat.com>
	<20130628011301.GC32195@dastard>
	<20130628035825.GC29338@dastard>
	<20130628102819.GA4725@quack.suse.cz>
	<20130629033924.GK32195@dastard>
	<20130701120037.GA6196@quack.suse.cz>
	<20130702062954.GA14996@dastard>
	<20130702081937.GA31770@quack.suse.cz>
	<20130702123835.GF14996@dastard>
	<20130702140508.GB31770@quack.suse.cz>
Date: Tue, 2 Jul 2013 09:13:43 -0700
X-Google-Sender-Auth: fhlyRrjGV9mLQsRV9mu6j-gsTXI
Message-ID: <CA+55aFwZHOUCYvojbP9q3D5MDgCH7GttkUGiJerra9uyduFLKw@mail.gmail.com>
Subject: Re: frequent softlockups with 3.10rc6.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 7:05 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 02-07-13 22:38:35, Dave Chinner wrote:
>>
>> IOWs, sync is 7-8x faster on a busy filesystem and does not have an
>> adverse impact on ongoing async data write operations.
>   The patch looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Ok, I'm going to take this patch asap. Should we also mark it for
stable? It doesn't look like a regression in that particular code, but
it sounds like it might be a regression when paired with the way the
flusher threads interact. Or is this really some long-time performance
problem?

I'm also wondering if we should just change all callers - remove that
"wait for writeback to complete" from writeback_one_inode()
completely, and just make sure that *all* callers that use WB_SYNC_ALL
do the "wait for writeback" in a separate stage, the way "sync()"
already does? That whole

        if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {

test doesn't really look all that sane (..so thanks Dave for adding a
comment above it)

               Linus
