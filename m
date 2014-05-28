Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaE1WlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:41:13 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:46621 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE1WlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140528223142.GO8554@dastard>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	<20140528223142.GO8554@dastard>
Date: Wed, 28 May 2014 15:41:11 -0700
X-Google-Sender-Auth: 41AMAt8sFO12p4eBxx47N9-vqow
Message-ID: <CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 3:31 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Indeed, the call chain reported here is not caused by swap issuing
> IO.

Well, that's one way of reading that callchain.

I think it's the *wrong* way of reading it, though. Almost dishonestly
so. Because very clearly, the swapout _is_ what causes the unplugging
of the IO queue, and does so because it is allocating the BIO for its
own IO. The fact that that then fails (because of other IO's in
flight), and causes *other* IO to be flushed, doesn't really change
anything fundamental. It's still very much swap that causes that
"let's start IO".

IOW, swap-out directly caused that extra 3kB of stack use in what was
a deep call chain (due to memory allocation). I really don't
understand why you are arguing anything else on a pure technicality.

I thought you had some other argument for why swap was different, and
against removing that "page_is_file_cache()" special case in
shrink_page_list().

                         Linus
