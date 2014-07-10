Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaGJRwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:52:00 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39137 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaGJRv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140710114222.GE2970@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-2-git-send-email-hskinnemoen@google.com>
	<20140709191747.GB5249@pd.tnic>
	<CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
	<20140710114222.GE2970@pd.tnic>
Date: Thu, 10 Jul 2014 10:51:57 -0700
Message-ID: <CAFQmdRZ1D4OWqkL-zpsiEjuGQaSBBmk36HqSw=q+hHNCRWZCKQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 4:42 AM, Borislav Petkov <bp@alien8.de> wrote:
> + linux-edac.
>
> On Wed, Jul 09, 2014 at 02:24:31PM -0700, Havard Skinnemoen wrote:
>> > > The CMCI poll interval was updated to pick the minimum interval between
>> > > the original 30 seconds and the check_interval divided by 8 (minimum of
>> > > 3 polls).
>> >
>> > Why min 3 polls? How do you come up with exactly that frequency?
>>
>> The idea is that if we make it equal to check_interval, it might
>> bounce back and forth a lot. So we need to divide by something, and 8
>> seems like a nice, safe value, and it seems to work well. We're not
>> opposed to considering other values, of course (e.g. 2 and 4 might
>> work well too, but with somewhat higher risk of ping-ponging).
>
> Yep, this is exactly why I'm asking about your use case. Because if we
> set it to any number, someone down the line will appear and say that
> this doesn't suit her/his needs.

Note that if check_interval is left at its default setting, this patch
doesn't change anything. But I admit it might change things
unnecessarily for values of 1-4 minutes.

> So, I'm thinking more in the direction of controlling it settings, maybe
> even restricting check_interval and the CMCI poll interval, relative to
> each other maybe, but still configurable with the max flexibility.
>
> For that we'll need to answer questions like
>
> * Which min value is sane?

What's the typical interrupt rate during a storm? We should make it
significantly less frequent than that, otherwise there's no point
switching to polling.

IIRC we've seen at least several hundred CMCIs per second, so perhaps
100 ms would be a reasonable minimum? Or perhaps 10 ms, which is the
current minimum polling interval enforced by mce_timer_fn.

> * Do check_interval and CMCI poll interval need to be related at all?

CMCI poll interval can't be higher than check_interval, or the storm
handling will break. I don't recall if making them equal causes things
to break or if it's just suboptimal. Apart from that, we probably
shouldn't enforce any relationship.

If we export both knobs, we could make it the user's responsibility to
keep a sensible relationship between them, but it would require some
documentation work, I think.

> * Which max value makes sense?

I think it only needs to be limited by check_interval. Though I don't
think we'll hurt anyone by reducing the current 30-second cap --
you're still getting substantial savings vs a CMCI storm even if you
turn it down to a second or even less.

> * What about check_interval, do we want to touch that too?

If we're going to enforce a relationship between that and
CMCI_POLL_INTERVAL, I guess we'll have to?

> ...
>
> Just throwing out a bunch of questions, off the top of my head, to get
> some opinions/rants, etc.
>
>> I'm not entirely sure. At some point, it ended up that way, and it
>> broke in non-obvious ways, so we wanted to fix it.
>
> Right, so if we restrict it, the fix is even simpler. Unless you have a
> more valid use than "[a]t some point, it ended up that way... " :-)

Well, we've tried turning it all the way down to 5 seconds and nothing
broke except for the CMCI storm handling. We could probably turn it
down even further before it becomes prohibitively expensive. I don't
think the implementation-specific interaction with a hard-coded
30-second CMCI poll interval is a good reason to restrict it, though
I'll admit it would make things simpler.

A short polling interval is useful for detecting problems early, and
to see quicker results when experimenting.

Havard
