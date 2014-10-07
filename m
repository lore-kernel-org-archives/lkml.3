Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaJGVi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:38:29 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:51016 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaJGVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <87siizshav.fsf@x220.int.ebiederm.org>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk> <20141007133339.GH7996@ZenIV.linux.org.uk>
 <87r3yjy64e.fsf@x220.int.ebiederm.org> <CALCETrXgssZfi3BirQ=K7-vrPyEh5AzFX2pF+yj76Ngi0sf7Yw@mail.gmail.com>
 <87siizshav.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 7 Oct 2014 14:38:06 -0700
Message-ID: <CALCETrWfZwbGCxnUAg0PnM=tN8MGRQkHrJVC42bVF7sdJKXLmw@mail.gmail.com>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 2:26 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> Why should MNT_LOCKED on submounts be enforced?
>>
>> Is it because, if you retain a reference to the detached tree, then
>> you can see under the submounts?
>
> Yes. MNT_DETACH is a recursive operation that detaches all of the mount
> and all of it's submounts.  Which means you can see under the submounts
> if you have a reference to a detached mount.
>
>> If so, let's fix *that*.  Because
>> otherwise the whole model of pivot_root + detach will break.
>
> I am not certain what you are referring to.  pivot_root doesn't
> manipulate the mount tree so you can see under anything.
>
> What I believe is the appropriate fix is to fail umount2(...,MNT_DETACH)
> if there are any referenced mount points being detached that have a
> locked submount.

Most of the container-using things do, roughly:

Unshare userns and mountns
Mount some new stuff
pivot_root to the new stuff
MNT_DETACH the old.

That last step will almost always fail if you make this change.

--Andy
