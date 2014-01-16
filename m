Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaAPMDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:03:41 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39078 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaAPMDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:03:38 -0500
MIME-Version: 1.0
In-Reply-To: <2002335.9x4iUKkcnh@x2>
References: <1389808934-4446-1-git-send-email-wroberts@tresys.com>
	<2708398.uWbqeU3VZe@x2>
	<CAFftDdoi-9KZvuWz4czNMSWE=Y1tPQEhZVAeQb=S+jKQ=m8rZQ@mail.gmail.com>
	<2002335.9x4iUKkcnh@x2>
Date: Thu, 16 Jan 2014 07:03:34 -0500
Message-ID: <CAFftDdqJbMwTDkYn6FbRE=j69F4mE+9i=Sw6aQTTs99hsP0KwA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] audit: Audit proc cmdline value
From: William Roberts <bill.c.roberts@gmail.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, Stephen Smalley <sds@tycho.nsa.gov>,
        William Roberts <wroberts@tresys.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 6:02 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, January 15, 2014 09:08:39 PM William Roberts wrote:
>> >> > Try this,
>> >> >
>> >> > cp /bin/ls 'test test test'
>> >> > auditctll -a always,exit -F arch=b64 -S stat -k test
>> >> > ./test\ test\ test './test\ test\ test'
>> >> > auditctl -D
>> >> > ausearch --start recent --key test
>> >> >
>> >> >> On the event of weird chars, it gets hex escaped.
>> >> >
>> >> > and its all in 1 lump with no escaping to figure out what is what.
>> >>
>> >> Un-escape it. ausearch does this with paths. Then if you need to parse
>> >> it, do it.
>> >
>> > How can you? When you unescape cmdline for the example I gave, you will
>> > have "./test test test ./test test test".  Which program ran and how many
>> > arguments were passed? If we are trying to improve on what comm= provides
>> > by having the full information, I have to be able to find out exactly
>> > what the program name was so it can be used for searching. If that can't
>> > be done, then we don't need this addition in its current form.
>>
>> In your example, you will have an execve record, with it parsed, will you
>> not?
>
> Only if you change your patch.

My patch has nothing to do with the emitting of an execve record. You
will get an
execve record with the arguments parsed out. Its not even really
"parsing" as each
element is in a NULL terminated char * array.

>
>
>> cmdline does not necessarily represent the arguments or process name.
>> Sometimes it does, sometimes it doesn't. Just treat the thing as one
>> string, perhaps do some form of substring matching in a tool.
>
> You are missing the point. The point is that you are trying to place trust in
> something that can be gamed. The audit system is designed such that it cannot
> be fooled very easily. Each piece of the subject and object are separated so
> that programs can be written to analyze events. What I am trying to say is now
> you are making something that concatenates fields with no way to regroup them
> later to reconstruct what really happened,
>
>
>> To make this clear, I am not trying to improve on what comm provides.
>> comm provides
>> 16 chars for per thread name. The key is, its per thread, and can be
>> anything. The
>> "cmdline" value, is an arbitrary spot that is a global entity for the
>> process. So in my change, all things coming into these events will have a
>> similar cmdline audit. Which may help in narrowing down on whats going on
>> in the system
>
> It needs to be more trustworthy than this.

Its as trustworthy as comm, its as trustworthy as path, etc. The audit
subsystem already prints many
untrusted values to aid in narrowing down the process, or to observe a
running processes behavior; this
is no different.
