Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273Ab3DKUsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:48:43 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:47831 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476Ab3DKUsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Takashi Iwai <tiwai@suse.de>
References: <20130405042932.GB4068@ZenIV.linux.org.uk>
	<20130406050049.GI4068@ZenIV.linux.org.uk>
Date: Thu, 11 Apr 2013 13:48:26 -0700
In-Reply-To: <20130406050049.GI4068@ZenIV.linux.org.uk> (Al Viro's message of
	"Sat, 6 Apr 2013 06:00:49 +0100")
Message-ID: <877gk8vlnp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/lQmty/KBTovm8jG5jDmwJYynVTjV5Gk4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [RFC] revoke(2) and generic handling of things like remove_proc_entry()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Fri, Apr 05, 2013 at 05:29:32AM +0100, Al Viro wrote:
>> 4) nasty semantics issue - mmap() vs. revoke (of any sort, including
>> remove_proc_entry(), etc.).  Suppose a revokable file had been mmapped;
>> now it's going away.  What should we do to its VMAs?  Right now sysfs
>> and procfs get away with that, but only because there's only one thing
>> that has ->mmap() there - /proc/bus/pci and sysfs equivalents.  I've
>> no idea how does pci_mmap_page_range() interact with PCI hotplug (and
>> I'm not at all sure that whatever it does isn't racy wrt device removal),
>> but I suspect that it strongly depends on lack of ->fault() for those
>> VMAs, which makes killing all PTEs pointing to pages in question enough.
>> How generic do we want to make it?  Anybody wanting to add more files
>> that could be mmapped in procfs/sysfs/debugfs deserves to be hurt, but
>> if we start playing with revoke(2), restriction might become inconvenient.
>> I'm not sure what kind of behaviour do we want there - *BSD at least
>> used to have revoke(2) only for character devices that had no mmap()...
>
> Actually, after looking at what sysfs does...   We might get away with
> the following
> 	* new vma flag - VM_REVOKABLE; set by mmap() if ->f_revoke is
> non-NULL.  We are short on spare bits there, but there still are some...
> 	* start_using_vma(vma) that checks the presence of that flag,
> returns true if it's absent and __start_using(vma->vm_file->f_revoke)
> otherwise; a matching stop_using_vma(vma) as well.
> 	* surround vma method calls with start_using_vma/stop_using_vma,
> similar to file ones.  Do what fs/sysfs/bin.c wrappers do for revoked
> ones - VM_FAULT_SIGBUS for ->fault() and ->page_mkwrite(), -EINVAL for
> ->access() and ->set_policy(), vma->vm_policy for ->get_policy(),
> 0 for ->migrate(), "do nothing" for ->open() (and I'm not at all sure that
> this one is correct), hell knows what for ->close().  Note that the *only*
> instance with ->open and without ->close is sysfs pile of wrappers
> itself...

sysfs used to wrap close but nothing used it, and on review it turned to
be impossible to properly call close on all of the vmas on revoke with
all of the proper locks held without help from the mm subsystem.  So now
sysfs refuses a mapping if ->close is implemented.  In practice that
means having an implementation of ->open in sysfs is likely a waste of
space because open and closed are always paired.

My memory is that the sysfs wrappers work for a pretty narrow range of
cases, and are things only work correctly because memory mapping pci
uses none of the sophisticated facilities.

Last time I was looking at this I was noticing that there is a lock
(mmap_sem?) that is held over every ->vm_op->foo() call.  If that is
true today it should be possible to just grab that lock and change
vm_ops.  That makes for a very cheap and easy implementation, except for
the covolutions needed for taking the lock.

> Hell knows...  We have few enough call sites for ->vm_op->foo() to make
> it feasible and overhead would be trivial.  OTOH, I'm not sure what's the
> right behaviour for mmap of something like drm after revoke(2) - leaving
> writable pages there looks wrong...

I'm not certain of the peculiarities of drm.  In general the correct
semantics of a revoked memory area is that of what we do with a mmap
area on truncate.  Retaining the vma with no pages mapped and generating
SIGBUS on an access.

> BTW, snd_card_disconnect() doesn't do anything to existing mappings; smells
> like a bug, and there we do have ones with non-trivial ->mmap().  Could
> ALSA folks comment?

uio might be worth considering as well.  As some uio devices are
actually hotpluggable..

> One note about the mockup implementation upthread - __release_revoke() should
> suck in a bit more than just ->release() - turning fasync off should also go
> there.

If we can do add useful support at the fs and mm layers without
affecting performance I am all for it.  I remember that tends to make
things easier.  As an alternative let me suggest what I had intended to
do if/when I ever got back to working on revoke.

Make a library like libfs that can be used for files that want to
implement revoke support.

In that library implement what can be implemented reliably and correctly
and error on the sophisticated cases we can't support.

With the semantics and the basic users figured out move what bits we can
into the vfs or the mm subsystem to make things easier.

With a library at the very least we have one implementation that we can
debug and work with instead of a different implementation of revoke for
each different kind of file.

Eric
