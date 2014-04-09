Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042AbaDIRcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:32:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37889 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaDIRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:32:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<874n3n7czm.fsf_-_@xmission.com>
	<87wqezl5df.fsf_-_@x220.int.ebiederm.org>
	<20140409023027.GX18016@ZenIV.linux.org.uk>
	<20140409023947.GY18016@ZenIV.linux.org.uk>
Date: Wed, 09 Apr 2014 10:32:14 -0700
In-Reply-To: <20140409023947.GY18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 9 Apr 2014 03:39:47 +0100")
Message-ID: <87sipmbe8x.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+Dx1RrGmXHeKRvO5U1M+Du/D8Vrsc/wJA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1919]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Apr 09, 2014 at 03:30:27AM +0100, Al Viro wrote:
>
>> > When renaming or unlinking directory entries that are not mountpoints
>> > no additional locks are taken so no performance differences can result,
>> > and my benchmark reflected that.
>> 
>> It also means that d_invalidate() now might trigger fs shutdown.  Which
>> has bloody huge stack footprint, for obvious reasons.  And d_invalidate()
>> can be called with pretty deep stack - walk into wrong dentry while
>> resolving a deeply nested symlink and there you go...
>
> PS: I thought I actually replied with that point back a month or so ago,
> but having checked sent-mail...  Looks like I had not.  My deep apologies.
>
> FWIW, I think that overall this thing is a good idea, provided that we can
> live with semantics changes.  The implementation is too optimistic, though -
> at the very least, we want this work done upon namespace_unlock() held
> back until we are not too deep in stack.  task_work_add() fodder,
> perhaps?

Hmm.

Just to confirm what I am dealing with I have proceeded to measure the
amount of stack used by these operations.

For resolving a deeply nested symlink that hits the limit of 8 nested
symlinks, I find 4688 bytes left on the stack.  Which means we use
roughly 3504 bytes of stack when stating a deeply nested symlink.

For umount I had a little trouble measuring as typically the work done
by umount was not the largest stack consumer, but I found for a small
ext4 filesystem after the umount operation was complete there were
5152 bytes left on the stack, or umount used roughly 3040 bytes.

3504 + 3040 = 6544 bytes of stack used or 1684 bytes of stack left
unused.  Which certainly isn't a lot of margin but it is not overflowing
the kernel stack either. 

Is there a case that see where umount uses a lot more kernel stack?  Is
your concern an architecture other than x86_64 with different
limitations?

I am quite happy to change my code to avoid stack overflow but I want to
make certain I understand where the stack usage is coming from so that I
actually fix them issue.

Eric

