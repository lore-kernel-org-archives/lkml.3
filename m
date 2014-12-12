Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967736AbaLLMvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:51:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967013AbaLLMvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:51:51 -0500
Message-ID: <548AE4E2.5080508@redhat.com>
Date: Fri, 12 Dec 2014 13:51:46 +0100
From: Marian Csontos <mcsontos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        gregkh@linuxfoundation.org, snitzer@redhat.com, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
References: <5484498E.4000202@gmail.com> <20141207200834.GA2322@kroah.com>	<5484C0E9.3060707@gmail.com> <20141209151253.GA17660@debian> <20141210100033.GA21108@debian>
In-Reply-To: <20141210100033.GA21108@debian>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 11:00 AM, Joe Thornber wrote:
> On Tue, Dec 09, 2014 at 03:12:53PM +0000, Joe Thornber wrote:
>> Writeboost is significantly slower than the spindle alone for this
>> very simple test.  I do not understand what is causing the issue.
>
> I started doing the code review and now understand what's going on,
> sadly.
>
> You are splitting all bios up into 4k blocks to simplify the metadata
> layout, and mapping logic.  This murders performance.  File systems
> and the block layer try really hard to submit the largest bio possible
> for a reason.
>
> A simple dd in large chunks across your cache reveals this:
>
> raw spindle:        8.9s
> writeboost type 0:  32.2s
> writeboost type 1:  71.1s
>
> dm-cache and dm-thin do also split io into blocks, but much larger,
> user configurable blocks.  It's still a performance issue for us,
> which is why I'm using range locking to move away from this bio
> splitting (eg, recent cache discard patches).
>
> One of the main advantages of a log based metadata layout is you can
> cope nicely with arbitrarily sized bios.  Unlike dm-cache for
> instance, which has to do a read from the origin if it wants to cache
> a write that partially covers a block (or maintain a 'valid' bit for
> each sector of every cached block).
>
> The writeboost target as it stands will only benefit v. small, random
> io.  It will seriously degrade performance of any other IO profile.
> I'm NACKing this for upstream, and will not be spending any more time
> on it at this point.

Is not that what some databases are doing?

>
> You've put a lot of effort into this so far, so I suggest you redesign
> the log metadata, and drop the io splitting; you'll end up with
> something far better.

Perhaps passing large writes[1] directly to HDD - consumer SSDs and HDDs 
sequential write speeds are IIUC almost identical.

[1]: What is large write? In my mental model fits a "tunable".

>
> Sorry,
>
> - Joe
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

