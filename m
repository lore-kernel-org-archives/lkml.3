Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161375AbaDPWDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:03:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57204 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbaDPWDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:03:43 -0400
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
References: <87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
	<87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
	<87lhva5h4k.fsf@x220.int.ebiederm.org>
	<20140413053956.GM18016@ZenIV.linux.org.uk>
	<87zjjp3e7w.fsf@x220.int.ebiederm.org>
	<87ppkl1xb7.fsf@x220.int.ebiederm.org>
	<20140413215242.GP18016@ZenIV.linux.org.uk>
	<87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
Date: Wed, 16 Apr 2014 15:03:14 -0700
In-Reply-To: <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 14 Apr 2014 00:38:47 -0700")
Message-ID: <87ppkhc4pp.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18a3TrzN7p644SF30lOAnPoWItROu0d9yo=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3898]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 0/4] No I/O from mntput
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> There are a lot of ways we could approach this, and I sat down and wrote
> the simplest variant I could think of, so hopefully there are not silly
> bugs that get overlooked.
>
> The code move all cleanup from mntput that would do filesystem I/O into
> work queues.
>
> The code waits in mntput for that I/O to complete if we wait today.
>
> The code has been tested and it works, and it succeeds in running
> deactivate_super in a stack from with just short of 7500 bytes free.
> 7500 bytes should be enough for anybody!
>
> I want to double check that I am using work queues correctly, they used
> to be deadlock prone, and sleep on everything before I commit to a final
> version but this version is probably good enough.

I have confirmed by emperical testing, reading the code and with lockdep
that moving the work of mntput onto the system_wq does not introduce
deadlocks.

I have read through all of fsnotify_vfsmount_delete looking for anything
that might be affected by moving fsnotify_vfsmount_delete into another
context and thankfully there is nothing.  At most audit will log the
removal of a rule, and inotify will log a removal.  But in neither case
is there any information taken from the context of the current process.

> I may be going overboard in the case where we auto close BSD accounting
> files, but at this point I figure better safe than sorry. 

After sleeping on the code I realized that putting a union in mount.h
to keep the size the same as bit to clever.   Otherwise I am satisfied
with the code and have tested it every way I can think of.

I have looked a bit more at the issue of removing the blocking from
mntput and it looks this set of changes can easily serve as an
intermediate step to get there.

Certainly the suggested flush_pending_mntput(fs_type) which is probably
better called flush_filesystem(fs_type) is straight forward to
implement.  The code just needs to wait for fs_type->fs_supers to become
an empty list, after walking fs_supers->s_mounts and force a lazy
unmount on all mounts of the filesystem.

A few stray thoughts, in modules filesystems and error handling. 

- kern_mount from a module is nasty because rmmod is only supported if
  (struct file_system_type).owner == NULL.  So unlike other filesystems
  which we know can not be in use during module unload there are
  no programatic guarantees about a kernel mount.

- Today a module that calls register_filestem or kern_mount and does
  anything else afterward that might fail is problematic.

  We have nothing that would flush or otherwise force a registered
  filesystem to be unmounted.  Ouch.

  kern_mount for anything except debugging is in a similar situation.
  Presumably the filesystem initialization will make something available
  to the kernel at large that will have access to the mount point.

  At which point we can have filesystem reference counts that we can not
  statically account for and we don't have the code to flush them.

Which is a long way of saying it would probably be a good idea to
write and use flush_filesystem even if we never move to a mntput that
doesn't sleep.

Eric
