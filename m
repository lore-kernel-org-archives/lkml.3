Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaIVOa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:30:56 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:43500 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaIVOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140922101221.4bf46809@lwn.net>
References: <cover.1410810247.git.milosz@adfin.com>
	<cover.1410983998.git.milosz@adfin.com>
	<20140919104204.3b0bb762@lwn.net>
	<CANP1eJEhHyA93kDUCz_=0vDjdPXz7g0x1SmW+q060fntQAbrYA@mail.gmail.com>
	<20140922101221.4bf46809@lwn.net>
Date: Mon, 22 Sep 2014 10:30:52 -0400
Message-ID: <CANP1eJF6dt59eEtyGu5YzLj4zt876cqy=a32wFNSh13Rho7Gag@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:12 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Fri, 19 Sep 2014 13:33:14 -0400
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> >  - Non-blocking I/O has long been supported with a well-understood set
>> >    of operations - O_NONBLOCK and fcntl().  Why do we need a different
>> >    mechanism here - one that's only understood in the context of
>> >    buffered file I/O?  I assume you didn't want to implement support
>> >    for poll() and all that, but is that a good enough reason to add a
>> >    new Linux-specific non-blocking I/O technique?
>>
>> I realized that I didn't answer this question well in my other long
>> email. O_NONBLOCK doesn't work on files under any commonly used OS,
>> and people have gotten use to this behavior so I doubt we could change
>> that without breaking a lot of folks applications.
>
> So I'm not contesting this, but I am genuinely curious: do you think
> there are applications out there requesting non-blocking behavior on
> regular files that will then break if they actually get non-blocking
> behavior?  I don't suppose you have an example?
>
> Thanks,
>
> jon

Earlier in this thread Jeff pointed (
https://lkml.org/lkml/2014/9/15/942 ) to a bug in RH bugzilla (
https://bugzilla.redhat.com/show_bug.cgi?id=136057 ) when an
application (squid) reads regular disk files started returning EAGAIN
when read from (provided that they were open with O_NONBLOCK) and
since that doesn't cause readhead it spins on it forever. As far as I
know O_NONBLOCK for regular files in Linux is undefined behavior as
non of the man pages I looked at (esp. fnctl, 2 open, 3 open) specify
what happens in the case of non-network, non-fifo case (some of them
refer to file descriptors that support non-blocking operation, which
is pretty vague).

So even if squid is wrong in it's behavior (since it's undefined), a
quick google search reveals lots of mailing lists / forum posts of
people essentially describing the behavior to date. Eg. O_NONBLOCK on
regular files blocks, with select/poll/epoll always returning a ready
behavior. Based on that anecdotical evidence, I assume a decent chunk
of user apps would beak.

- Milosz

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
