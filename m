Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3IJRjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:39:21 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53001 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3IJRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:39:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
	<CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
Date: Tue, 10 Sep 2013 13:39:18 -0400
Message-ID: <CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Josh Boyer <jwboyer@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <Waiman.Long@hp.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        moneta.mace@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 1:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Sep 10, 2013 at 10:14 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>
>> We've had a user report a backtrace from hitting the
>> BUG_ON(!ret->d_lockref.count) added with the lockref infrastructure
>> (commit 98474236f72) on rawhide today[1].  I've grabbed the backtrace
>> below.  The user has btrfs, NFS, and sshfs in usage with this oops.
>>
>> I've not seen anything similar, but I could have missed it.  Does this
>> look familiar to anyone?
>
> Nope. And the dget_parent() case itself hasn't even changed - that
> BUG_ON() wasn't really added by the lockref code, it's just a
> search-and-replace change of a BUG_ON(!d_count) to
> BUG_ON(!d_lockref.count). The BUG_ON() existed before.
>
> That whole "dget_parent()" thing is also in the _simple_ case (not RCU
> mode), and the BUG_ON is for when the dentry is properly locked, so
> that's all "safe" code. The refcount must have gotten corrupted
> earlier.
>
> Do you have the mainline git ID of that rawhide kernel? Because there
> *was* a real bug in d_rcu_to_refcount. I don't see how it could
> trigger that particular issue, but it could trigger scheduling while
> in the rcu-protected region and that in turn could result in odd
> things down the line, so..
>
> That particular bug exists between commits 15570086b590 ("vfs:
> reimplement d_rcu_to_refcount() using lockref_get_or_lock()") that
> introduced it, and e5c832d55588 ("vfs: fix dentry RCU to refcounting
> possibly sleeping dput()") that should have fixed it. But I don't know
> what mainline kernel that "kernel-3.12.0-0.rc0.git16.2.fc21.x86_64" is
> based on. I'm sure that information exists somewhere..

The subject says v3.11-7890-ge5c832d, which is the git-describe output
of the mainline kernel for that Fedora build.  Sorry, I should have
made that clearer.  So according to that, it should be based on the
actual commit you identified as the fix.

I have your latest tree as of this morning (v3.11-8716-g26b0332)
building right now and have asked Moneta to test it.

josh
