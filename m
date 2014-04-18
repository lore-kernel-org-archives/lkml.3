Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaDRXxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:53:36 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:41246 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaDRXxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <1397841448-12942-1-git-send-email-dianders@chromium.org>
References: <1397841448-12942-1-git-send-email-dianders@chromium.org>
Date: Fri, 18 Apr 2014 16:53:33 -0700
X-Google-Sender-Auth: 00wJixiLL2wT3byJW-tg1B7DZYc
Message-ID: <CAD=FV=Wfus8noqMUmO5dWELwjO2z1V1XaH5SxQu7WVGRdRsA9g@mail.gmail.com>
Subject: Re: [PATCH] kdb: Put a cr before lf when working w/ a non open
 console port
From: Doug Anderson <dianders@chromium.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Doug Anderson <dianders@chromium.org>,
        kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 18, 2014 at 10:17 AM, Doug Anderson <dianders@chromium.org> wrote:
> In (efe2f29 kgdboc,kdb: Allow kdb to work on a non open console port)
> support was added to directly use the "write_char" functions when
> doing kdb over a non-open console port.  This is great, but it ends up
> bypassing the normal code in uart_console_write() that adds a carriage
> return before any newlines.
>
> Add similar code in kdb so we don't get things like:
> [0]kdb>
>        [0]kdb>
>               [0]kdb>
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  kernel/debug/kdb/kdb_io.c | 6 ++++++
>  1 file changed, 6 insertions(+)

I've been digging through the code and I've finally figured out where
this happens on some other platforms (I'm using samsung/serial
myself).

The 8250 driver has it hardcoded in serial8250_put_poll_char().  Next
week I'll include a removal of that code with v2 of this patch unless
I hear any objections.  I think doing things in kdb_io is nice
because:

* we don't need to duplicate the code in everyone's "put_poll_char" functions.

* we don't end up running the code in kgdb mode, only in kdb mode.

I could also move my change to be in uart_poll_put_char() which
_would_ (I believe) apply to both kdb / kgdb if that was desirable for
some reason.

-Doug
