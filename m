Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3JCTgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:36:12 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53987 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3JCTgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:36:10 -0400
MIME-Version: 1.0
In-Reply-To: <20131003182311.GI13318@ZenIV.linux.org.uk>
References: <20131003163411.GA17101@www.outflux.net>
	<20131003175824.GH13318@ZenIV.linux.org.uk>
	<CAGXu5j+8sxc8vc4bwv14nGNiOhq-ey2nxAK99LgMKO+Qmh1L6A@mail.gmail.com>
	<20131003182311.GI13318@ZenIV.linux.org.uk>
Date: Thu, 3 Oct 2013 12:36:08 -0700
X-Google-Sender-Auth: ngcIzsiUG38HMJv9OXDCl1ARX7M
Message-ID: <CAGXu5j+4NUKfgKiAK+w2MrsqRxHiYc62LBMx4UsfxUBSxNwNJA@mail.gmail.com>
Subject: Re: [PATCH] fs: make sure we do not read beyond allocation
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 11:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Oct 03, 2013 at 11:03:07AM -0700, Kees Cook wrote:
>
>> > When you start a port to a 512-bit architecture, you'll have much nastier
>> > problems than this one...
>>
>> Well, this is simply taking advantage of this particular allocator's
>> behavior. Instead of depending on this side-effect, why not change the
>> allocation so that we never risk a potentially broken read? (Even SLOB
>> notes that it may have as low as 2-byte granularity.)
>
> Oh, for fuck sake!  "Hardening", indeed...
>
> Kees, try to think for a minute[1].  Really.  We have general-purpose
> ...
> [1] yes, yes, I know - the mere mention of security should've prevented such
> arrogant requests.  It's an imperfect universe.

I want to attempt to disassemble what you've communicating here:

a) I'm not thinking.
b) Requesting that someone think when they mention security is arrogant.

I would say that "a" is not true. We simply disagree, but you want to
tell me I'm not thinking rather than discuss the technical merits or
flaws of the change I have proposed. I am pointing out an assumption
being made in this code, and you seem to feel it is not worth fixing.
I don't think it's useful to tell me I should think harder. We just
think differently. We have different immediate goals, but share the
common goal of making Linux fantastic. I'm thinking just fine.

Your statement "b" is much more interesting. I see it as a sarcastic
comment about your opinion of "security" work in the kernel. To me
this comes across as a "them" vs "us" interpretation; one where you
may believe "people mentioning security" are condescending about
anyone questioning them. I could read into this that you think I am
part of "them" instead of part of "us". I find that rather insulting,
given our common goals. Additionally, I don't think I've been
condescending.

All of this, of course, made me go check my original email carefully.
There is no mention of "hardening" in my email nor the KASAN link. The
only mention of "security" in either place is in my email signature,
since that is a reflection of my job role working on Chrome OS. I did
not attempt to Cc stable, and there is no CVE mentioned in the email.
So, I can only assume that you have read into this bug and already
understand that this kind of out-of-bounds reading of heap is
sometimes considered a security problem. That's fair, but you appear
to be lashing out at me for this patch on the basis that it is a
"meaningless" security fix. Since I didn't actually bring "security"
up at all, it additionally makes me think you've defined me as part of
"them" doing security work. Again, that's fair, most of my patches are
security related, but we are not on different teams. Saying things
like this attempts to push me away and draw a boundary that does not
exist.

We're all trying to make Linux greater than it already is. Neither
this patch in particular, or any security efforts in general, seek to
destroy Linux.

Continued below, but this change seeks to make things easier for tools
that are trying to find "real" security flaws in the kernel. This one
is unlikely to be anything but theoretical, but it is clearly doing
something against the "contract" of the heap allocation API.

> allocator.  Asked to give us something considerably bigger than one
> word.  How do you call a situation when it returns something with
> the end of requested object crossing the page boundary if rounded
> up to nearest multiple of word size?
>
> That's right, FUBAR.  Because for that to happen it would have to
> have given you an address that would not be word-aligned.  In response
> to request to allocate something wider than a word.  Remember the
> words along the lines of "the pointer returned if the allocation
> succeeds is properly aligned..."?
>
> It's not a behaviour of this particular allocator.  It's something that
> will have to be guaranteed by *any* general-purpose allocator.

No such allocator exists today, sure. I can imagine some kind of
crazy-town allocator that tried to do really fancy storage and might
end up cramming oddly sized allocations at the end of pages, but it
likely doesn't help to ponder this.

What the patch does help with, though, is dynamic analysis tools that
are looking for out-of-bound reads, which this clearly is. It should
be considered a violation of the API to attempt to access a range
beyond what was requested for the allocation. Fixing this means lots
of noise vanishes from such analysis of the allocation API, letting
other tools besides just KASAN do work to find other more serious
problems in heap usage.

Does fixing this to help dynamic analysis tools somehow make the
kernel worse? I think that fixing this makes it easier to find further
bugs that might be much more serious.

-Kees

-- 
Kees Cook
Chrome OS Security
