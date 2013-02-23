Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab3BWBKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:10:46 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:44560 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab3BWBKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:10:44 -0500
MIME-Version: 1.0
In-Reply-To: <1451742.5dFcotgqBW@vostro.rjw.lan>
References: <20130222085954.GA4352@redhat.com>
	<9798783.W2ijE8Yd31@vostro.rjw.lan>
	<CA+55aFxcqczXZf7zxJ0xjDsnLMbS8uu9Jp5BDOdnR5tqf==nrA@mail.gmail.com>
	<1451742.5dFcotgqBW@vostro.rjw.lan>
Date: Fri, 22 Feb 2013 17:10:43 -0800
X-Google-Sender-Auth: 8-ZAeGo8zeGiZHjlUJ7r0XnbjnA
Message-ID: <CA+55aFywBFO4F+gEmq5h05VBe4unEJLh4RckJwaWPsU67bw44w@mail.gmail.com>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>, Dave Jones <davej@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, tianyu.lan@intel.com,
        Linux ACPI <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 4:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> The problem is, though, that even if bisection turns up something, it doesn't
> automatically mean that this particular commit is the one that caused the
> problem to happen in the first place.

No, I agree. I just react *very* strongly when somebody starts arguing
against reverting.

The fact that the commit that was bisected fixes another bug in a
previous commit does in fact just imply that that *previous* commit
should perhaps be reverted. Of course, I see that that is the first in
the whole series, so I understand the pain, but even so..

And looking at that commit that makes power resources be treated
specially, that looks completely bogus. It's not what the old code did
either, and it seems to be a total hack for the breakage that just
happens to fix that one machine for purely random reasons, as far as I
can tell. The ACPI_BUS_TYPE_POWER case always had match=1 before, no?

The thing that looks to have been dropped somewhere is that

  .acpi_op_start = !!context,

which first became

  device->add_type = context ? ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;

and then somehow that wasn't needed any more, so it became just an unconditional

  device->add_type = ACPI_BUS_ADD_START;

for unexplained reasons (the commit message says that the argument
"context" wasn't used, and renames it not_used to reinforce the point,
but doesn't explain why it can remove the use that was there).

That unconditional "add_type = ACPI_BUS_ADD_START" then later becomes
"flags.match_driver = true", which is where the whole match_driver
thing comes in.

Anyway, I don't see how magically it became about ACPI_BUS_TYPE_POWER.
The code is not exactly obvious, though, so whatever. But that
"context is suddenly not used" commit (e3863094c6f9: "ACPI: Drop the
second argument of acpi_bus_scan()") looks odd.

Maybe "context" was effectively always non-NULL, but it *looks* like
that series of commits is intended to have no semantic changes, and
that's the one that looked very dubious to me.

                   Linus
