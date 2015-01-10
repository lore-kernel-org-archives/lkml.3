Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbbAJC1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:27:40 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:50053 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbbAJC1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:27:39 -0500
MIME-Version: 1.0
In-Reply-To: <20150110003540.GA32037@node.dhcp.inet.fi>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
	<54AE7D53.2020305@redhat.com>
	<20150108134520.GC14200@e104818-lin.cambridge.arm.com>
	<54AEBE84.6090307@redhat.com>
	<20150108173408.GF17290@e104818-lin.cambridge.arm.com>
	<54AED10C.7090305@redhat.com>
	<CA+55aFwpwkjRnTzBe2K0y+2DOH1F=5SpJkYe=P5z8ps5_1PQHQ@mail.gmail.com>
	<20150109232707.GA6325@e104818-lin.cambridge.arm.com>
	<20150110003540.GA32037@node.dhcp.inet.fi>
Date: Fri, 9 Jan 2015 18:27:38 -0800
X-Google-Sender-Auth: O5J4QOZj74IkJlh_pfacZBzy3RM
Message-ID: <CA+55aFz74hjhCcdz5J4r-xK4KW7oqNDA3i=jXHW0prGMMwgMvw@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 4:35 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> With bigger page size there's also reduction in number of entities to
> handle by kernel: less memory occupied by struct pages, fewer pages on
> lru, etc.

Bah. Humbug. You've been listening to HW people too much, but they see
the small details, not the big picture.

Page management was indeed a huge PITA for PAE. But that was because
PAE is garbage.

Really, do the math. 64kB pages waste so much memory due to internal
fragmentation that any other memory use is completely immaterial.

Pretty much the only situation where 64kB pages are fine is when you
have one single meaningful load running on your machine, and that one
single load is likely a database.

Any other time, your filesystem caches will just suck.

Just as an example, look at the kernel tree. Last I did the math
(which is admittedly a long time ago), the median size (not average -
median) of a file was pretty much 4kB.

With a 64kB page, that means that for caching the kernel tree (what,
closer to 50k files by now), you are basically wasting 60kB for most
source files. Say, 60kB * 30k files, or 1.8GB.

Read that again. 1.8 GIGABYTES. Wasted. Completely unused. Thrown
away, with no upside. And that's just from the page cache for the
kernel sources, which would be populated by a single "git grep".

Maybe things have changed, and maybe I did my math wrong, and people
can give a more exact number. But it's an example of why 64kB
granularity is completely unacceptable in any kind of general-purpose
load.

Anybody who brings up TLB costs or costs of maintaining pages is just
jying, or hasn't actually looked at the real issues. Anything you win
in TLB you lose is *lots* and lots of extra IO, because you aren't
using your memory efficiently for caching, and are basically easily
throwing away half your RAM.

Big pages are a bad bad bad idea. They work fine for databases, and
that's pretty much just about it. I'm sure there are some other loads,
but they are few and far between.

4kB works well. 8kB is perfectly acceptable. 16kB is already wasting a
lot of memory. 32kB and up is complete garbage for general-purpose
computing.

And no, source code isn't *that* special. There are lots of other
cases where you have a multitude of small files. And small files are
the things you want to cache - don't tell me about big video files etc
that make a 64kB page size look small, because those files don't
actually tend to be all that relevant for caching.

                                   Linus
