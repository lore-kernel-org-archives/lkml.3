Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaHMRXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:23:46 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58045 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaHMRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:23:44 -0400
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
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
References: <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
	<87ppkhc4pp.fsf@x220.int.ebiederm.org>
	<87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
	<20140417202237.GA18016@ZenIV.linux.org.uk>
	<87tx9rwsz4.fsf@x220.int.ebiederm.org>
	<20140417221203.GC18016@ZenIV.linux.org.uk>
	<20140420054108.GQ18016@ZenIV.linux.org.uk>
	<20140511164530.GB18016@ZenIV.linux.org.uk>
	<20140809093412.GA23108@ZenIV.linux.org.uk>
	<87ha1ic8rd.fsf@x220.int.ebiederm.org>
	<20140813131831.GY18016@ZenIV.linux.org.uk>
Date: Wed, 13 Aug 2014 10:18:59 -0700
In-Reply-To: <20140813131831.GY18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 13 Aug 2014 14:18:31 +0100")
Message-ID: <87sil0z4sc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18//K73k4UhIVqpZ9B+pDN9LeT/RwmAv7g=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2871]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Tue, Aug 12, 2014 at 03:17:10AM -0700, Eric W. Biederman wrote:
>> I have rebased my changes against vfs.git#for-eric and my changes work
>> just fine on top of the base you have built.  The changes are avaiable
>> in user-namespace.git#vfs-detach-mounts10 so you just be able to just
>> pull the changes in.
>> 
>> Reading your pile #1 pull request to Linus it sounds like you are
>> planning to suck all of this into the vfs tree.
>
> I am.  Questions:
> 	* is there any reason why we need list instead of hlist for
> per-mountpoint list of mounts?  Looks like hlist would do just as
> well, and it's a bit less noise

I can't think of a reason we can't use a hlist_head in for m_list in
struct mountpoint.

Hmm.  I do use list_add_tail in mnt_set_mountpoint but other than good
hygiene that does not seem for any particular reason because
__detach_mounts processes all of the list entries.  So going from newest
to oldest or oldest to newest shouldn't matter.

We do need it to be a doubly linked list so umount_tree and detach_mount
remain constant time operations.  But both list and hlist satisfy that
requirement.

So as far as I can tell the only reason I used a list is because every
list through the mounts at the time I added the code was a list and
later it has not been important enough to matter.

> 	* __d_unalias() change looks rather odd.  What we do there
> is _not_ "avoid leaking mounts", it's "don't get a bunch of existing
> mounts suddenly relocate".  What's up with that one?

The change to __d_unalias is semantically the same as the change
vfs_rename with the d_mountpoint tests going away.

The user space visible behavior change is to allow rename in one mount
namespace even if there is a mount on that directory in another mount
namespace.  In the case of __d_unalias the mount namespace the rename
happened in is on a remote computer or otherwise not part of the vfs.

Allowing renames and unlinks in one mount namespace even when there is a
mount point in another mount namespace is important to avoid breaking
unix semantics and to prevent unprivileged users from causing unlink or
rename of more privileged users in other mount namespaces to fail by
placing mounts on the more privileged users files and directories.

"avoid leaking mounts" is simply what had to be implemented so that
we could support arbitrary unlinks.

>From an implementation standpoint allowing the rename means that
filesystems no longer have to be concerned with a vfs cache that is out
of sync with the actual filesystem.

I agree that mount points moving is a weird semantic, but it is not a
particularly new semantic.  We already allow this in 3.16 and before if
we rename the parent directory of a mount point.

When we discussed what to do with renames of mounts in the review of the
patch no examples could be found where we actually cared (it appears no
one is silly enough to put a mount point where someone else could rename
it), and the alternative of keeping some kind of overlay mount structure
so we could keep a mount in the same place even after the underlying
mountpoint was renamed was decided to be more trouble than it was worth.

All of the mechanisms for avoiding trouble when a mount point is renamed
already exist and fusermount already uses them.

I truly hope the due dilligence of research and public discussion
(i.e. https://lwn.net/Articles/570338/) and retaining the existing
semantics in a single mount namespace of what we are doing with
renames is sufficient to avoid breaking some weird usespace application.
Breaking peoples applications sucks.

Eric
