Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaANV0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:26:52 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:42243 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaANV0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:26:47 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrWRWnbiX+fpeXmn7ZKVvCpb+h99R01o8jchmx4=fgb0QA@mail.gmail.com>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
 <1389277187-18211-14-git-send-email-jlayton@redhat.com> <52CF05B5.5080700@amacapital.net>
 <20140109194930.1692fbbe@tlielax.poochiereds.net> <CALCETrXp-G2t9Lfd+tbyzWtXeBw+vLHWE4M7-297HQzyFDVU_g@mail.gmail.com>
 <20140114192713.GA22262@fieldses.org> <CALCETrWmOu-RVXNYmL--RMaiOiOMYVv5qd1+jfY0j8GZHh0rWg@mail.gmail.com>
 <20140114211009.GA23999@fieldses.org> <039101cf116e$56c2de80$04489b80$@mindspring.com>
 <CALCETrWRWnbiX+fpeXmn7ZKVvCpb+h99R01o8jchmx4=fgb0QA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Jan 2014 13:26:26 -0800
Message-ID: <CALCETrVRe2koQAwEiR7p10LqSi4durr9s6uo-1iv_aG-ZNGSkg@mail.gmail.com>
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
To: Frank Filz <ffilzlnx@mindspring.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[grr, gmail -- I didn't actually intend to send that.]

On Tue, Jan 14, 2014 at 1:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Jan 14, 2014 at 1:19 PM, Frank Filz <ffilzlnx@mindspring.com> wrote:
>>>       process 2 requests a write lock, gets -EDEADLK, unlocks and
>>>       requests a new read lock.  That request succeeds because there
>>>       is no conflicting lock.  (Note the lock manager had no
>>>       opportunity to upgrade 1's lock here thanks to the conflict with
>>>       3's lock.)
>>
>> As I understand write lock priority, process 2 requesting a new read lock
>> would block, once there is a write lock waiter, no further read locks would
>> be granted that would conflict with that waiting write lock.
>
> ...which reminds me -- if anyone implements writer priority, please
> make it optional (either w/ a writer-priority-ignoring read lock or a
> non-priority-granting write lock).  I have an application for which
> writer priority would be really annoying.
>
> Even better: Have read-lock-and-wait-for-pending-writers be an explicit new operation.
>
> (Writer priority a

Writer priority can introduce new deadlocks.  Suppose that a reader
(holding a read lock) starts a subprocess that takes a new read lock
and waits for that subprocess.  Throw an unrelated process in that
tries to take a write lock and you have an instant deadlock.

--Andy
