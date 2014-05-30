Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaE3CNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:13:31 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:34434 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaE3CNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140530015852.GG14410@dastard>
References: <20140528223142.GO8554@dastard>
	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
	<20140529013007.GF6677@dastard>
	<20140529015830.GG6677@dastard>
	<20140529233638.GJ10092@bbox>
	<CA+55aFyvn_fTnWEmTCSGgfM18c21-YDU_s=FJP=grDDLQe+aDA@mail.gmail.com>
	<20140530002021.GM10092@bbox>
	<CA+55aFxjXf5xLKGFBjUWimn8-=rj0=g3pku9O1MvGSoDUcEQAw@mail.gmail.com>
	<20140530005042.GO10092@bbox>
	<CA+55aFz84toJOqnuphA99c0av1nLzxcxfjiTwhBbxzaNs3J6NQ@mail.gmail.com>
	<20140530015852.GG14410@dastard>
Date: Thu, 29 May 2014 19:13:29 -0700
X-Google-Sender-Auth: w4UhUaUQoATvJ38IEnjSAQgJsLI
Message-ID: <CA+55aFy+Qx2f9SSoy18ou9xehL=TFdro4tc1_64v1jQmpXYKrg@mail.gmail.com>
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

On Thu, May 29, 2014 at 6:58 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> If the patch I sent solves the swap stack usage issue, then perhaps
> we should look towards adding "blk_plug_start_async()" to pass such
> hints to the plug flushing. I'd want to use the same behaviour in
> __xfs_buf_delwri_submit() for bulk metadata writeback in XFS, and
> probably also in mpage_writepages() for bulk data writeback in
> WB_SYNC_NONE context...

Yeah, adding a flag to the plug about what kind of plug it is does
sound quite reasonable. It already has that "magic" field, it could
easily be extended to have a "async" vs "sync" bit to it..

Of course, it's also possible that the unplugging code could just look
at the actual requests that are plugged to determine that, and maybe
we wouldn't even need to mark things specially. I don't think we ever
end up mixing reads and writes under the same plug, so "first request
is a write" is probably a good approximation for "async".

             Linus
