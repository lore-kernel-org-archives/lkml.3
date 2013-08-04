Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3HDDuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 23:50:35 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:46585 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3HDDue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 23:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1308040207490.5329@skynet.skynet.ie>
References: <alpine.DEB.2.00.1308040207490.5329@skynet.skynet.ie>
Date: Sat, 3 Aug 2013 20:50:33 -0700
X-Google-Sender-Auth: m5Z40rx3u7uS9pUXjXL8HoKShCA
Message-ID: <CA+55aFwZGzy6GJQn_2pJAnFTMe4LLmzLUpHYNxz-YyJOhmhxFg@mail.gmail.com>
Subject: Re: [git pull] drm build fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 6:08 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> Alex Deucher (1):
>       drm/radeon: fix 64 bit divide in SI spm code

That code is stupid. You're asking for a 64-by-64 divide, when the
divisor is clearly an "int" (100 and 1000 respectively).

Why is it doing "div64_s64()" instead of the simpler and faster "div_s64()"?

A full 64-by-64 divide is _expensive_ on 32-bit architecture (up to
four divide instructions, each potentially expensive in its own
right), which is the whole reason why we have that "math64.h" to begin
with - to make people aware of it.

Now, our lib/div64.c routines do notice that the upper bits of the
divisor are zero and end up using the simpler 64-by-32 divide
functions, but why explicitly ask for those more complex functions to
begin with?

So the code is likely not performance critical, and hey, our library
routines do the simple optimizations to avoid the trivially excessive
divide instructions, so this "doesn't matter". Except for the
annoyance factor of you using a more complicated function for no
reason.

                   Linus
