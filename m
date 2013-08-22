Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3HVQ43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:56:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59355 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3HVQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:56:28 -0400
Message-ID: <521642A8.2020103@kernel.dk>
Date: Thu, 22 Aug 2013 10:56:08 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com> <1375896905-6074-5-git-send-email-kmo@daterainc.com> <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com> <20130807183345.GA11612@kmo-pixel> <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com> <20130807195733.GB11612@kmo-pixel> <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com> <1377033546.32763.4.camel@haakon3.risingtidesystems.com> <00000140a14ae6bb-f0fca267-cdd6-4039-8c6b-f715999a83c5-000000@email.amazonses.com> <20130821134945.16b32c045e28272c5b0ba610@linux-foundation.org> <00000140a6e964d2-03ac778f-13ff-415d-bbfa-93cb2fddcaa5-000000@email.amazonses.com>
In-Reply-To: <00000140a6e964d2-03ac778f-13ff-415d-bbfa-93cb2fddcaa5-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 10:44 AM, Christoph Lameter wrote:
> On Wed, 21 Aug 2013, Andrew Morton wrote:
> 
>> The lock is needed so that one cpu can steal tags from another cpu's cache.
>> See (the needlessly inlined!) steal_tags().
> 
> Stealing tags could also be done via IPIs or some other things.

That is actually the approach I took for blk-mq tagging. But that isn't
free either. I think it pretty much boils down to how much stealing you
expect. If the tag space is sufficiently large, you would not expect a
lot of stealing. And then it doesn't really matter if you use a lock or
an IPI, since it's the rare case - the lock cacheline isn't going to be
shared across processors anyway. The ticket locks aren't exactly free on
their own, however, so that cost is still paid. But I'd be surprised if
it was much of an issue.

If the tag space isn't large enough (common case), then yes, it matters
a lot what kind of mechanism is used. It's on my TODO to compare the two
under realistic scenarios and see how they fare.

-- 
Jens Axboe

