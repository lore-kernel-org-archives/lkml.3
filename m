Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbaD2Qcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:32:46 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52487 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaD2Qcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140428133908.GE24913@ubuntumail>
References: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
 <87ha5h42va.fsf@x220.int.ebiederm.org> <CALCETrX3GjNkhKkST9Nw4sk2ETt=MRUWcc+bNXnGFTXn7ve-ww@mail.gmail.com>
 <20140428133908.GE24913@ubuntumail>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Apr 2014 09:32:24 -0700
Message-ID: <CALCETrUPCXmfJFs71T4jLSMS6XOBEb15SdQDz37t_6Whf2DWWA@mail.gmail.com>
Subject: Re: pid ns feature request
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 6:39 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> On Fri, Apr 25, 2014 at 12:37 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>> > Andy Lutomirski <luto@amacapital.net> writes:
>> >
>> >> Unless I'm missing some trick, it's currently rather painful to mount
>> >> a namespace /proc.  You have to actually be in the pid namespace to
>> >> mount the correct /proc instance, and you can't unmount the old /proc
>> >> until you've mounted the new /proc.  This means that you have to fork
>> >> into the new pid namespace before you can finish setting it up.
>> >
>> > Yes.  You have to be inside just about all namespaces before you can
>> > finish setting them up.
>> >
>> > I don't know the context in which needed to be inside the pid namespace
>> > is a burden.
>>
>> I'm trying to sandbox myself.  I unshare everything, setup up new
>> mounts, pivot_root, umount the old stuff, fork, and wait around for
>> the child to finish.
>>
>> This doesn't work: the parent can't mount the new /proc, and the child
>> can't either because it's too late.
>
> I'm probably not thinking it through enough...  But can't the parent, before
> forking, do
>
>         mkdir -p /childproc/proc
>         mount --bind /childproc /childproc
>         mount --make-rshared /childproc
>
> then the child mounts its proc under /childproc/proc and have that show
> up in the parent's tree?

Yes, and the --make-rshared /childproc isn't necessary.  This is still
a bit annoying, since the parent now needs to wait for the child to
set up mounts if it wants to do anything that requires all the mounts
to be fully set up.

This issue certainly isn't a show-stopper, but it might be nice to
address if anyone ever adds options to proc to do other sensible
namespacy things (e.g. turning off sysctls).

--Andy
