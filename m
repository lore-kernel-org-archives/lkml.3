Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaE2DCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:02:21 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:62922 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbaE2DCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:02:19 -0400
MIME-Version: 1.0
In-Reply-To: <1401332086.13555.45.camel@localhost>
References: <cover.1401327752.git.luto@amacapital.net> <ff8ecb985119c06510e2c45c078b41cd5df3aaea.1401327752.git.luto@amacapital.net>
 <1401329367.13555.25.camel@localhost> <CALCETrWr+_fo=q+LBT-WLJGXLWK6vEeFa=KC=LSMYehi=c-r4A@mail.gmail.com>
 <1401332086.13555.45.camel@localhost>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 May 2014 20:01:58 -0700
Message-ID: <CALCETrWzuvUD_YDXxvFw_440KNFy9mfGt40T6t126BLeAdJO+g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] audit: Mark CONFIG_AUDITSYSCALL BROKEN and update
 help text
To: Eric Paris <eparis@redhat.com>
Cc: Philipp Kern <pkern@google.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "security@kernel.org" <security@kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-audit@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 7:54 PM, Eric Paris <eparis@redhat.com> wrote:
> On Wed, 2014-05-28 at 19:40 -0700, Andy Lutomirski wrote:
>> On Wed, May 28, 2014 at 7:09 PM, Eric Paris <eparis@redhat.com> wrote:
>> > NAK
>> >
>> > On Wed, 2014-05-28 at 18:44 -0700, Andy Lutomirski wrote:
>> >> Here are some issues with the code:
>> >>  - It thinks that syscalls have four arguments.
>> >
>> > Not true at all.  It records the registers that would hold the first 4
>> > entries on syscall entry, for use later if needed, as getting those
>> > later on some arches is not feasible (see ia64).  It makes no assumption
>> > about how many syscalls a function has.
>>
>> What about a5 and a6?
>
> On the couple of syscalls where a5 and a6 had any state that was
> actually wanted by someone (mainly just the fd on mmap) audit collects
> it later in the actual syscall.
>
>> >>  - It assumes that syscall numbers are between 0 and 2048.
>> >
>> > There could well be a bug here.  Not questioning that.  Although that
>> > would be patch 1/2
>>
>> Even with patch 1, it still doesn't handle large syscall numbers -- it
>> just assumes they're not audited.
>
> That's because we haven't had large syscall numbers.  That's the whole
> point of an arch doing select HAVE_ARCH_AUDITSYSCALL.  If they don't
> meet the requirements, they shouldn't be selecting it....
>
>> >>  - It's unclear whether it's supposed to be reliable.
>> >
>> > Unclear to whom?
>>
>> To me.
>>
>> If some inode access or selinux rule triggers an audit, is the auditsc
>> code guaranteed to write an exit record?  And see below...
>
> This is an honest question:  Do you want to discuss these things, or
> would you be happier if I shut up, fix the bugs you found, and leave
> things be?  I don't want to have an argument, I'm happy to have a
> discussion if you think that will be beneficial...
>

I'm happy to discuss these things.  I'd be happy if you fix things.  I
think that there are two major issues affecting users of auditsc and
that either those issues should be fixed or users of auditsc should
understand and accept these issues.

Issue 1: syscall numbering.  The syscall filters are unlikely to work
well on lots of architectures.

Issue 2: performance.  Until someone fixes it (which is probably
hard), turning this thing on hurts a lot.  Oleg added a hack awhile
ago that lets you do 'auditctl -a task,never' to get rid of the
performance hit for new tasks, but that rather defeats the point.

The scariness of the code can be lived with, but holy cow it's scary.

I'm just not going to fix the issues myself.  I tried and gave up.

--Andy
