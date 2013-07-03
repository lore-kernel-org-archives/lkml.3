Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3GCD2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 23:28:45 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:62755 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3GCD2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 23:28:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130703030759.GG14996@dastard>
References: <20130628102819.GA4725@quack.suse.cz>
	<20130629033924.GK32195@dastard>
	<20130701120037.GA6196@quack.suse.cz>
	<20130702062954.GA14996@dastard>
	<20130702081937.GA31770@quack.suse.cz>
	<20130702123835.GF14996@dastard>
	<20130702140508.GB31770@quack.suse.cz>
	<CA+55aFwZHOUCYvojbP9q3D5MDgCH7GttkUGiJerra9uyduFLKw@mail.gmail.com>
	<20130702165752.GA12179@quack.suse.cz>
	<CA+55aFxSY76aWEC04yREjFObPF3ZJFMHdczoT=yGmSpsg5hhyg@mail.gmail.com>
	<20130703030759.GG14996@dastard>
Date: Tue, 2 Jul 2013 20:28:42 -0700
X-Google-Sender-Auth: X0HLycIzfUnwOrgRnSK3UgNo6AY
Message-ID: <CA+55aFxN2-qZwBywE3b+RYyPLg1-ru5ZwJLHLohy0KJ0fD0vqA@mail.gmail.com>
Subject: Re: frequent softlockups with 3.10rc6.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 8:07 PM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> Then that test would become
>>
>>         if (wbc->sync_mode == WB_SYNC_SINGLE) {
>>
>> instead, and now "sync_mode" would actually describe what mode of
>> syncing the caller wants, without that hacky special "we know what the
>> caller _really_ meant by looking at *which* caller it is".
>
> The problem is that all the code that currently looks for
> WB_SYNC_ALL for it's behavioural cue during writeback now has
> multiple different modes they have to handle.  IOWs, it's not a
> straight forward conversion process. WB_SYNC_ALL reaches right down
> into filesystem ->writepages implementations and they all need to be
> changed if we make up a new sync_mode behaviour.

I have to admit that I absolutely detest our current "sync_mode" to
begin with, so I'd personally be happy to see some major surgery in
this area.

For example, maybe we'd be much better off with something that has
various behavioral flags rather than distinct "mode values".  So
instead of being an enum of different reasons for syncing, it would be
a set of bitmasks for specific sync behavior. We have a much better
sync model in our sync_file_range() model, where we have flags like
SYNC_FILE_RANGE_WAIT_xxx (where xxx is BEFORE, WRITE, AFTER to
describe whether you should wait for old writes, start new writes, or
wait after the newly started writes).

That's a very powerful model, and it's also much more easy to think
about. So the above test could become

        if (wbc->sync_mode & WB_SYNC_AFTER) {
                int err = filemap_fdatawait(mapping);
                ....

in that kind of model, and the code actually looks sensible. It reads
like "if the caller asked us to synchronize after writing, then we do
an fdatawait on the mapping".

So I think something like that might make sense. And there aren't
_that_ many users of WB_SYNC_xxx, and the patch should be pretty
straightforward. WB_SYNC_NONE semantics would presumably be "just
start writeout" (so it would become WB_SYNC_WRITE), while WB_SYNC_ALL
would become (WB_SYNC_BEFORE | WB_SYNC_WRITE | WB_SYNC_AFTER), but
then the "for_sync" case would remove WB_SYNC_AFTER, because it does
its own waiting after.

Sounds fairly sensible and straightforward to me. Much more
self-explanatory than the current "WB_SYNC_NONE/ALL" distinction,
methinks (well, you'd still have to explain what the point of
BEFORE/AFTER is, and how it interacts with starting writeout, but
especially since we already have that concept for file_sync_range(), I
think that's not too bad).

                          Linus
