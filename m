Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab3J1AtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 20:49:23 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38554 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3J1AtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 20:49:22 -0400
Message-ID: <526DB494.8000703@gmail.com>
Date: Sun, 27 Oct 2013 17:49:24 -0700
From: Jim Hill <gjthill@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>, git@vger.kernel.org
CC: Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes:
 line
References: <20131024122255.GI9378@mwanda> <20131024122512.GB9534@mwanda> <20131026181709.GB10488@kroah.com> <20131027013402.GA7146@leaf>
In-Reply-To: <20131027013402.GA7146@leaf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/13 18:34, Josh Triplett wrote:
> Linux Kernel ... "Fixes:" line ... containing an abbreviated commit hash

<!-- -->
> This helps people (or automated tools) determine how far to backport

I beg pardon if I'm rehearsing an old debate, but it seems to me it 
would be better and worthwhile to bring more of git to bear by adding 
`reference` links as follows from considering this proposed sequence:

     #  ...G---B---...    history-with-bug-at-B

     Gprime=`git commit-tree --reference G`
     Bprime=`git commit-tree --reference B -p $Gprime`

     #   ...G---B---...   history-with-bug-at-B
     #      :   :         # <-- `:`'s are `reference` links
     #      G'--B'        $Bprime is a mergeable cherry-pick for B

`reference` links have no enforced semantics. Teach all current logic to 
ignore them (fetch doesn't fetch through them, fsck doesn't care, etc.). 
  Elaborating some of the good parts:

* If the author and committer data are left untouched when 
`commit-tree`'s tree and message arguments are defaulted, as above, to 
the referenced commit's tree and message, the resulting commit is unique.

* Bullet-proof cherry-pick creation becomes easy and idempotent:

         git-make-cherry-pick() {
             local picked=$1
             set -- `git rev-list --parents $picked^!`
             shift
             local parents
             local parent
             local p2
             for parent; do
                     p2="$p2 -p `git commit-tree --reference $parent`"
             done
             git commit-tree --reference $picked $parents`
         }

* Which makes the created commit id a fully-implemented _change-id_ for 
the referenced commit:

         git merge $(git-make-cherry-pick $B)

     can be done from anywhere, merge won't have to rely on patch-id's 
to detect cherry-picks done this way.

* A bugged commit gets fixed by fixing its reference commit and merging 
normally, worry-free:

         ...G---B ... -F   Merge fix X for a bug in B
            :   :     /
            G'--B'---X     X's commit message is the `Fixes:` equivalent

    Bugfix commit X can be safely merged anywhere.  Worst case, `git 
merge -s ours --no-commit X` and do whatever you would have done otherwise.

`merge` might usefully be updated to warn about merging from a commit 
with only a reference parent, I think merging from `G'` would probably 
be a mistake.

---
So, this is as far as I've gotten with this, is there reason to think it 
should or shouldn't be pursued?
