Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaE2ARM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 20:17:12 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57461 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaE2ARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 20:17:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140528101153.GU15585@mwanda>
References: <20140527070937.GA21621@devel.8.8.4.4>
	<20140527102002.GI17724@mwanda>
	<CAHb8M2AceJeFv-KonF+bAFJ-+xssFxx5ytEKhMNZ1c3xm2jvZA@mail.gmail.com>
	<20140528070233.GP17724@mwanda>
	<CAHb8M2ABVCaoNR0m5mLmWv-ei60PDRu462QTqDgEJwAf63oteg@mail.gmail.com>
	<20140528101153.GU15585@mwanda>
Date: Thu, 29 May 2014 09:17:09 +0900
Message-ID: <CAHb8M2C-+1OexGdb7EUMVJ3Vq+M3bWSkCgkXX-O9OFj4=Dr=oQ@mail.gmail.com>
Subject: Re: [PATCH V2] staging: dgap: implement proper error handling in dgap_firmware_load()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel <devel@driverdev.osuosl.org>, Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mark Hounschell <markh@compro.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan.

2014-05-28 19:11 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, May 28, 2014 at 06:29:38PM +0900, DaeSeok Youn wrote:
>> > In your patch it has:
>> > +       dgap_tty_uninit(brd, false);
>> >
>> > But it should only be "false" if dgap_tty_init() failed.  If
>> > dgap_tty_register_ports() fails then it should be "true".  Another
>> Yes, you're right. There were no error handle for tty_port_register_device() and
>> dgap_create_tty_sysfs() in dgap_tty_register_ports(). I didn't catch it. :-(
>> It need to add error handlers for them, right?
>
> Eventually, yes.  But I don't see a simple way to fix
> dgap_firmware_load() until after the code is cleaned up.
>
>>
>> > problem is that as you say, the earlier function are allocating
>> > resources like dgap_tty_register() but only the last two function calls
>> > have a "goto err_cleanup;" so the error handling is incomplete.
>> So remove "goto" in dgap_firmware_load() and add error handler in
>> dgap_tty_init()
>
> In the current code there isn't a goto in dgap_firmware_load().  Remove
> the call to dgap_tty_uninit() and add error handling in dgap_tty_init().
Yes. I will try to fix it.
>
> That will clean up the code, and fix some NULL dereference bugs inside
> dgap_tty_uninit().
>
>> and dgap_tty_register_ports(), right?
>
> Inside dgap_tty_register_ports(), then we should add a
> kfree(brd->serial_ports) if the "brd->printer_ports" allocation fails.
> That is not a complete fix, but it is a part fix and it is clean.
Actually, I sent a patch which is removing "kfree(brd->serial_ports)" and pushed
into staging-next branch.
see the 0ade4a34fd43 staging: dgap: remove unneeded kfree() in
dgap_tty_register_ports()
Because I think dgap_tty_uninit() will free "brd->serial_ports" with this patch.

Can I send a patch after revert "0ade4a34fd43" commit?
>
>>
>> I have a question of this. In case of this, how to complete the error handling?
>
> [patch 1/x] staging: dgap: remove useless dgap_probe1() function
> [patch 2/x] staging: dgap: unwind on error in dgap_found_board()
> [patch 3/x] staging: dgap: remove bogus null test in dgap_tty_init()
>         The ->channels[] were set to null in dgap_found_board().
> [patch 4/x] staging: dgap: unwind on error in dgap_tty_init()
>         This also removes the call to dgap_tty_uninit() in
>         dgap_firmware_load()
> [patch 5/x] staging: dgap: unwind on error in dgap_tty_register_ports()
> [patch 6/x] staging: dgap: make dgap_config_buf a local buffer
> [patch 7/x] staging: dgap: pass "dgap_numboards" to dgap_found_board()
>         instead of using a global variable
> [patch 8/x] staging: dgap: pass "brd" to dgap_after_config_loaded()
>         instead of passing "dgap_numboards" and looking up brd again.
> [patch 9/x] staging: dgap: rename dgap_finalize_board_init() to dgap_request_irq()
>
> In the end, I hate dgap_tty_uninit() because it doesn't match
> dgap_tty_init() at all.  It's poorly named.  We should rename it and
> make another dgap_tty_init() which just sets the ->channels[] to NULL.
>
> [patch x/x] staging: dgap: introduce dgap_tty_unregister()
>         This is currently done in dgap_tty_uninit(), which is the wrong
>         place.
oh.. too many patches for cleanup. :o
Can I send part of these for cleanup?

Thanks.

regards,
Daeseok Youn
>
> I have started using a new todo list tag in my emails.  So I'm adding
> this stuff to the todo list.
>
> TODO-list: 2014-05-28: dgap: cleanups and bug fixes.
>
> regards,
> dan carpenter
>
>
