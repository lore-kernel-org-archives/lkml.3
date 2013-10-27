Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3J0LcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:32:07 -0400
Received: from mail12.copyleft.no ([188.94.218.224]:54543 "EHLO
	mail12.copyleft.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3J0LcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:32:03 -0400
X-Greylist: delayed 1923 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Oct 2013 07:32:03 EDT
MIME-Version: 1.0
In-Reply-To: <20131027092019.GB13149@leaf>
References: <20131024122255.GI9378@mwanda>
	<20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com>
	<20131027013402.GA7146@leaf>
	<526CA7D4.1070904@alum.mit.edu>
	<20131027071407.GA11683@leaf>
	<874n83m8xv.fsf@linux-k42r.v.cablecom.net>
	<20131027092019.GB13149@leaf>
Date: Sun, 27 Oct 2013 11:59:53 +0100
Message-ID: <CALKQrgc7a+p5eebJErcGdA3QDyvdHEaef36RhZocQp9LjDUeeg@mail.gmail.com>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
From: Johan Herland <johan@herland.net>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Rast <tr@thomasrast.ch>, Michael Haggerty <mhagger@alum.mit.edu>,
        Git mailing list <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 10:20 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Sun, Oct 27, 2013 at 09:09:32AM +0100, Thomas Rast wrote:
>> Josh Triplett <josh@joshtriplett.org> writes:
>> > On Sun, Oct 27, 2013 at 06:42:44AM +0100, Michael Haggerty wrote:
>> >> But I don't think that this feature should be given the "-f" short
>> >> option, as (a) -f often means "force"; (b) it will increase the
>> >> confusion with --fixup; (c) it just doesn't strike me as being likely to
>> >> be such a frequently-used option (though if this changes over time the
>> >> "-f" option could always be granted to it later).
>> >
>> > (a) -n often means --dry-run, but for commit it means --no-verify.
>> > Different commands have different options, and commit doesn't have a
>> > --force to abbreviate as -f.
>> >
>> > (b) If anything, I think the existence of a short option will make the
>> > distinction more obvious, since -f and --fixup are much less similar
>> > than --fixes and --fixup.  Most users will never type --fixes, making
>> > confusion unlikely.
>> >
>> > (c) Short option letters tend to be first-come first-serve unless
>> > there's a strong reason to do otherwise.  Why reserve 'f' for some
>> > hypothetical future option that doesn't exist yet?
>>
>> No, lately the direction in Git has been to avoid giving options a
>> one-letter shorthand until they have proven so useful that people using
>> it in the wild start to suggest that it should have one.
>>
>> See e.g.
>>
>>   http://article.gmane.org/gmane.comp.version-control.git/233998
>>   http://article.gmane.org/gmane.comp.version-control.git/168748
>
> Fair enough; easy enough to drop -f if that's the consensus.  However...
>
>> A much better argument would be if it was already clear from the specs
>> laid out for Fixes that n% of the kernel commits will end up having this
>> footer, and thus kernel hackers will spend x amount of time spelling out
>> --fixes and/or confusing it with --fixup to much headache.
>
> ...good suggestion:
>
> ~/src/linux$ git log --grep='stable@' --oneline --since='1 year ago' | wc -l
> 2769
> ~/src/linux$ git log --grep='stable@' --oneline --since='1 year ago' --pretty=format:%an | sort -u | wc -l
> 839
>
> Several thousand commits per year by hundreds of unique people seems
> like enough to justify a short option.

I think this can be solved just as well (if not better) using a
combination of a commit message template (or a prepare-commit-msg
hook) and a commit-msg hook.

The former appends a section of commonly-used RFC822-style headers
(with empty values) to the bottom of the commit message, e.g. some
variation on this:

  Fixes:
  Reported-by:
  Suggested-by:
  Improved-by:
  Acked-by:
  Reviewed-by:
  Tested-by:
  Signed-off-by:

Then the user (in addition to writing the commit message above this
block) may choose to fill in one or more values in this "form", e.g.
like this:

  My commit subject

  This is the commit message body.

  Fixes: 1234beef
  Reported-by: Joe User <j.user@example.com>
  Suggested-by:
  Improved-by: Joe Hacker <j.hacker@example.com>
  Acked-by:
  Reviewed-by:
  Tested-by: Joe Tester <j.tester@example.com>
  Signed-off-by: Myself <myself@example.com>

Then, the commit-msg hook can clean up and transform this into the
final commit message:

  My commit subject

  This is the commit message body.

  Fixes: 1234beef56 (Commit message summmary)
  Reported-by: Joe User <j.user@example.com>
  Improved-by: Joe Hacker <j.hacker@example.com>
  Tested-by: Joe Tester <j.tester@example.com>
  Signed-off-by: Myself <myself@example.com>

Here, the commit-msg hook removes the fields that were not filled in,
and performs additional filtering on the "Fixes" line (Adding commit
message summary). The filtering could also resolve ref names, so that
if you had refs/tags/security-bug pointing at the buggy commit, then:

  Fixes: security-bug

would be expanded/DWIMed into:

  Fixes: 1234beef56 (Commit message summmary)

Obviously, any other fancy processing you want to do into in the
commit-msg hook can be done as well, adding footnotes, checking that
commits are present in the ancestry, etc, etc.

Three good reasons to go this way:

 1. If the user forgets to supply command-line options like -s,
--fixes, etc, there is a nice reminder in the supplied form.

 2. No need to add any command-line options to Git.

 3. The whole mechanism is controlled by the project. The kernel folks
can do whatever they want in their templates/hooks without needing
changes to the Git project.


...Johan

-- 
Johan Herland, <johan@herland.net>
www.herland.net
