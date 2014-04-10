Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935704AbaDJTvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:51:08 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:37206 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaDJTvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:51:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140407181331.GA15012@mail.hallyn.com>
References: <5266BEA3.6020008@execulink.com> <20131022193718.GA18463@ac100>
 <874n89rsoc.fsf@xmission.com> <20140402172049.GA13240@sergelap>
 <20140402173248.GA22804@mail.hallyn.com> <533EF65E.6050508@mit.edu>
 <20140404183022.GA6728@sergelap> <CALCETrUki+k+NsaAYTbvaUqFTwH_AUDtwLv0XRYx+zA=c3zACw@mail.gmail.com>
 <20140404191000.GA13496@sergelap> <CALCETrW-M9QoqzkKyk9gRPLfx1fiTzs8_oAhdK6_kk=17PQc0Q@mail.gmail.com>
 <20140407181331.GA15012@mail.hallyn.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 10 Apr 2014 12:50:43 -0700
Message-ID: <CALCETrULqdffvHZMV_4hobs8=YX6hRSagkvR4opycBKsfTaTtg@mail.gmail.com>
Subject: Re: [lxc-devel] Kernel bug? Setuid apps and user namespaces
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sean Pajot <sean.pajot@execulink.com>,
        lxc-devel@lists.linuxcontainers.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 11:13 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> I'm starting to think that we need to extend dumpable to something
>> much more general like a list of struct creds that someone needs to be
>> able to ptrace, *in addition to current creds* in order to access
>> sensitive /proc files, coredumps, etc.  If you get started as setuid,
>
> Hm, yeah, this sort of makes sense.
>
>> then you start with two struct creds in the list (or maybe just your
>> euid and uid).  If you get started !setuid, then your initial creds
>> are in the list.  It's possible that few or no things will need to
>> change that list after execve.
>>
>> If all of the entries and current->cred are in the same user_ns, then
>> we can dump as userns root.  If they're in different usernses, then we
>> dump as global root or maybe the common ancestor root.
>> setuid(getuid()) and other such nastiness may have to empty the list,
>> or maybe we can just use a prctl for that.
>
> A few questions,
>
> 1. is there any other action which would trigger adding a new cred to
> the ist?

I don't think so.  Anyone who can ptrace you from the start can
corrupt you such that you leak rights even if some future action
prevents new ptracers from attaching.

OTOH, it might be nice for something like an HTTPS server to be able
to fork and shove its private key into the child, while preventing
anyone from ptracing the child.  But doing this securely without help
from someone with a different uid might be impossible anyway.

>
> 2. would execve clear (and re-init) the list of creds?

Probably.  Thoughts?

We could have a way to ask execve not to reinit the list.  Such a
mechanism would have to require no_new_privs to prevent a
straightforward attack on any setuid binary.

We's also want PR_SET_DUMPABLE or a new prctl to be able reset the
list to contain just current-.cred, I think.

--Andy
