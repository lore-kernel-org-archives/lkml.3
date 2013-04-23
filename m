Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3DWQFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:05:31 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60956 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3DWQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130423155212.GI31170@thunk.org>
References: <CA+55aFwpLu0qNms=hkQr43yqD0K9DgESNm91OEWKT1ZuT8MU6Q@mail.gmail.com>
	<CA+55aFy0jPr5udwJx8cZ-QFs-OgZzQ_NJm_VSj_cS7tsKUn3Kw@mail.gmail.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B71EF@saturn3.aculab.com>
	<CA+55aFwogFL=nm=YHwARcz9OTRBdWEDPG0xcqM-H3k-VZTOZPQ@mail.gmail.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B71F2@saturn3.aculab.com>
	<CA+55aFxvpcF7+dyy5d3+JP4Wfv90zPsRVtEhNG9Pky5gWTm_Pg@mail.gmail.com>
	<20130423155212.GI31170@thunk.org>
Date: Tue, 23 Apr 2013 09:05:24 -0700
X-Google-Sender-Auth: uuR18cmc0qE6C4PCj9FM8MN7Mx8
Message-ID: <CA+55aFwmgotLczo56Xu1eSvLogR9hRwU4ts3B2oAkOUfYMkNuw@mail.gmail.com>
Subject: Re: Unsigned widening casts of binary "not" operations..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 8:52 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Maybe it's worth creating a magic helper function, called something
> like mask_out() that handles the casting automatically, and it makes
> it clear to a reader what you're trying to do?

We have that for some things. Like the aligning code (see
include/{uapi/}linux/kernel.h). We have that whole ALIGN()
infrastructure that casts the alignment to the result type, exactly
because people got things wrong so often (and exactly the "& ~mask"
thing in particular).

But doing so becomes *less* readable when the types already match, and
it's another extra complication in kernel programming to know all the
"oh, don't use the standard C &~ constructs because it has some subtle
type handling under *some* circumstances". So for aligning things up,
we've been able to do it, because people hate doing that duplicated "
(val + mask) & ~mask" thing anyway (especially since "mask" tends to
be something like "size-1". IOW, having a helper function/macro ends
up solving more than just the type issue. But if it's just the type,
it ends up being very inconvenient.

We don't have the equivalent "align down" macro, for example, exactly
because aligning things down is *just* the logical mask, and so in
most cases it's actually just more pain to have a macro helper. So
ALIGN() only aligns upwards, even though it doesn't even say so in the
name. Inconsistent? Unclear? Yes, but there's a reason for it.

                  Linus
