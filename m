Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3J1L3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:29:41 -0400
Received: from mail12.copyleft.no ([188.94.218.224]:59690 "EHLO
	mail12.copyleft.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3J1L3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <526E283A.1070801@alum.mit.edu>
References: <20131024122255.GI9378@mwanda>
	<20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com>
	<20131027013402.GA7146@leaf>
	<526CA7D4.1070904@alum.mit.edu>
	<20131027071407.GA11683@leaf>
	<526E283A.1070801@alum.mit.edu>
Date: Mon, 28 Oct 2013 12:29:32 +0100
Message-ID: <CALKQrgfsk3fjyF77XL9+CPyJ_s-AfzkNAj4Eaj1LT-G0Ph=bfg@mail.gmail.com>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
From: Johan Herland <johan@herland.net>
To: Michael Haggerty <mhagger@alum.mit.edu>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Git mailing list <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 10:02 AM, Michael Haggerty <mhagger@alum.mit.edu> wrote:
> On 10/27/2013 08:14 AM, Josh Triplett wrote:
>> On Sun, Oct 27, 2013 at 06:42:44AM +0100, Michael Haggerty wrote:
>>> On 10/27/2013 02:34 AM, Josh Triplett wrote:
>>> I wonder if the two features could
>>> be combined in some way?
>>>
>>> The main difference between the two features is how they are intended to
>>> be used: --fixup is to fix a commit that hasn't been pushed yet (where
>>> the user intends to squash the commits together), whereas --fixes is to
>>> mark a commit as a fix to a commit that has already been pushed (where
>>> the commits will remain separate).  But there seems to be a common
>>> concept here.
>>>
>>> For example, what happens if a --fixes commit is "rebase -i"ed at the
>>> same time as the commit that it fixes?  It might make sense to do the
>>> autosquash thing just like with a --fixup/--squash commit.  (Otherwise
>>> the SHA-1 in the "Fixes:" line will become invalid anyway.)
>>
>> Most definitely not, no, at least not without an explicit option to
>> enable that.  Consider the case of backporting a series of patches and
>> preserving the relative history of those patches, to make it easier to
>> match up a set of patches.  At most, it might be a good idea for
>> cherry-pick or similar to provide an updated Fixes tag for the new hash
>> of the older commit.  Personally, I'd argue against doing this even with
>> --autosquash.  I could see the argument for an --autosquash-fixes, but I
>> can't think of a real-world scenario where what would come up.
>>
>> Generally, if history is still editable, you should just squash in the
>> fix to the original commit, and if history is no longer editable (which
>> is the use case for "Fixes:" lines), the squash case simply won't come
>> up, offering little point to adding special support for that case.
>
> In your last paragraph you explain exactly why these two features are
> similar and why it is thinkable to make the way that they are handled
> depend on the context.  Exactly because one would never rebase a
> "Fixes:" commit and the commit it is fixing at the same time, they would
> never be squashed together.  And ISTM that in most cases whenever they
> *are* being rebased at the same time, then one would want to squash them
> together.  So it might be possible to mark both types of commits the
> same way and then squash/not squash them depending on the context and
> the --autosquash option.

In general, we should be careful with introducing features that
exhibit different consequences based on the context in which they are
used, but in this case, I believe I agree with you. The existence of
"Fixes:" in a commit should be a just as valid hint to --autosquash as
a commit message starting with "fixup!" or "squash!" (obviously, the
"Fixes:" commit should be handled like a "squash!" and not like a
"fixup!", so that we don't haphazardly discard the commit message
accompanying "Fixes:").

>>> I see that there a consistency check that the --fixes argument is a
>>> valid commit.  But is there/should there be a check that it is an
>>> ancestor of the commit being created?  Is there/should there be a check
>>> that both of these facts remain true if the the commit containing it is
>>> rebased, cherry-picked, etc?
>>
>> That sounds like a nice future enhancement, sure.  I don't have any plans to
>> add such a check myself, though.  Also note that --fixup and --squash
>> don't have such a check either; if you want to add one, you should add
>> it for all three options at once.
>
> A hook-based solution could do this.  But a built-in "all-purpose"
> handler like "footer.Fixes.arg=commit", which was intended to be
> reusable, wouldn't be able to do such footer-specific extra work without
> having to create new special cases in git each time.

Which begs the question (posed to all, not specifically to you): Why
would we want solve this issue in config instead of in hooks? The
hooks will always be more flexible and less dependent on making
changes in git.git. (...a suitably flexible hook could even use the
config options discussed above as input...) In both cases, we need the
user to actively enable the functionality (either installing hooks, or
setting up config), and in both cases we could bundle Git with
defaults that solve the common cases, so that is not a useful
differentiator between the two approaches. I would even venture to
ask: If we end up solving this problem in config and not in hooks,
then why do we bother having hooks in the first place?

...Johan

-- 
Johan Herland, <johan@herland.net>
www.herland.net
