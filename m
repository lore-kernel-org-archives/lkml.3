Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbbAHJGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:06:32 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:53287 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbbAHJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:06:28 -0500
MIME-Version: 1.0
In-Reply-To: <20150106162915.7edb5620999641ebdc7a74e6@linux-foundation.org>
References: <1416828199-3414-1-git-send-email-drysdale@google.com>
 <1416828199-3414-2-git-send-email-drysdale@google.com> <20150106162915.7edb5620999641ebdc7a74e6@linux-foundation.org>
From: David Drysdale <drysdale@google.com>
Date: Thu, 8 Jan 2015 09:06:07 +0000
Message-ID: <CAHse=S8Ht-JcgBqHKttaJTrzp9d8-j=-uRDRoSW+Gwx8hkHkyQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] vfs: renumber FMODE_NONOTIFY and add to uniqueness check
To: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        David Miller <davem@davemloft.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 12:29 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 24 Nov 2014 11:23:19 +0000 David Drysdale <drysdale@google.com> wrote:
>
>> Fix clashing values for O_PATH and FMODE_NONOTIFY on sparc.
>> The clashing O_PATH value was added in 5229645bdc35f1cc43eb ("vfs: add
>> nonconflicting values for O_PATH") but this can't be changed as it
>> is user-visible.
>>
>> FMODE_NONOTIFY is only used internally in the kernel, but it is in
>> the same numbering space as the other O_* flags, as indicated by the
>> comment at the top of include/uapi/asm-generic/fcntl.h (and its use
>> in fs/notify/fanotify/fanotify_user.c).  So renumber it to avoid
>> the clash.
>>
>> All of this has happened before (12ed2e36c98aec6c4155, "fanotify:
>> FMODE_NONOTIFY and __O_SYNC in sparc conflict"), and all of this
>> will happen again -- so update the uniqueness check in fcntl_init()
>> to include __FMODE_NONOTIFY.
>
> What are the user-visible runtime effects of the bug?
>
> Please always include this info when fixing bugs, so people can work
> out which kernel version(s) need the fix.

I don't know for sure what the user-visible effects are -- I noticed
the problem from the source and I don't have a sparc system (the only
affected architecture) to test with.  But I'd guess that...

The likely user-visible effect (on sparc) of the clash would be that:
- Filesystem activity on files opened with O_PATH does not get
  reported via the fanotify(7) API.
- The file descriptors for accessed objects reported via the
  fanotify(7) API will effectively have O_PATH set, and so will
  have the limitations described for O_PATH in the open(2) manpage.

However, we'd need some intersection of sparc/fanotify folk to verify
those guesses -- Eric / David, any thoughts?

Thanks,
David
