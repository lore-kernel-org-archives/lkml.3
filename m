Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaDKWL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:11:58 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:34152 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaDKWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140411215228.GA27354@mail.hallyn.com>
References: <874n89rsoc.fsf@xmission.com> <20140402172049.GA13240@sergelap>
 <20140402173248.GA22804@mail.hallyn.com> <533EF65E.6050508@mit.edu>
 <20140404183022.GA6728@sergelap> <CALCETrUki+k+NsaAYTbvaUqFTwH_AUDtwLv0XRYx+zA=c3zACw@mail.gmail.com>
 <20140404191000.GA13496@sergelap> <CALCETrW-M9QoqzkKyk9gRPLfx1fiTzs8_oAhdK6_kk=17PQc0Q@mail.gmail.com>
 <20140407181331.GA15012@mail.hallyn.com> <CALCETrULqdffvHZMV_4hobs8=YX6hRSagkvR4opycBKsfTaTtg@mail.gmail.com>
 <20140411215228.GA27354@mail.hallyn.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 11 Apr 2014 15:11:36 -0700
Message-ID: <CALCETrW-o=ivJeZw4aC4o-8+qGZF0Fid36FJ7EtUBC9=5CrT4A@mail.gmail.com>
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

On Fri, Apr 11, 2014 at 2:52 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> On Mon, Apr 7, 2014 at 11:13 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> > Quoting Andy Lutomirski (luto@amacapital.net):
>> >> I'm starting to think that we need to extend dumpable to something
>> >> much more general like a list of struct creds that someone needs to be
>> >> able to ptrace, *in addition to current creds* in order to access
>> >> sensitive /proc files, coredumps, etc.  If you get started as setuid,
>> >
>> > Hm, yeah, this sort of makes sense.
>> >
>> >> then you start with two struct creds in the list (or maybe just your
>> >> euid and uid).  If you get started !setuid, then your initial creds
>> >> are in the list.  It's possible that few or no things will need to
>> >> change that list after execve.
>> >>
>> >> If all of the entries and current->cred are in the same user_ns, then
>> >> we can dump as userns root.  If they're in different usernses, then we
>> >> dump as global root or maybe the common ancestor root.
>> >> setuid(getuid()) and other such nastiness may have to empty the list,
>> >> or maybe we can just use a prctl for that.
>> >
>> > A few questions,
>> >
>> > 1. is there any other action which would trigger adding a new cred to
>> > the ist?
>>
>> I don't think so.  Anyone who can ptrace you from the start can
>> corrupt you such that you leak rights even if some future action
>> prevents new ptracers from attaching.
>>
>> OTOH, it might be nice for something like an HTTPS server to be able
>> to fork and shove its private key into the child, while preventing
>> anyone from ptracing the child.  But doing this securely without help
>> from someone with a different uid might be impossible anyway.
>>
>> >
>> > 2. would execve clear (and re-init) the list of creds?
>>
>> Probably.  Thoughts?
>
> Yeah it seems to me it should be re-initialized, with a cred added
> to the list for every open fd.

What do you mean "every fd"?

It seems odd to me that execve of anything that isn't setuid would add
anything to the list -- attackers can always ptrace before the execve
happens.

>
>> We could have a way to ask execve not to reinit the list.  Such a
>> mechanism would have to require no_new_privs to prevent a
>> straightforward attack on any setuid binary.
>
> If we don't add a cred for every open fd, then I think we need this.  If
> we do, then I'm not sure this makes sense.

See above.  I think I'm misunderstanding you.

>
>> We's also want PR_SET_DUMPABLE or a new prctl to be able reset the
>> list to contain just current-.cred, I think.
>
> Yeah PR_SET_DUMPABLE should reset it, agreed.
>
> -serge

--Andy
