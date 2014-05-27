Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaE0XgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:36:13 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:46069 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaE0XgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140527102002.GI17724@mwanda>
References: <20140527070937.GA21621@devel.8.8.4.4>
	<20140527102002.GI17724@mwanda>
Date: Wed, 28 May 2014 08:36:11 +0900
Message-ID: <CAHb8M2AceJeFv-KonF+bAFJ-+xssFxx5ytEKhMNZ1c3xm2jvZA@mail.gmail.com>
Subject: Re: [PATCH V2] staging: dgap: implement proper error handling in dgap_firmware_load()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mark Hounschell <markh@compro.net>,
        driverdev-devel@linuxdriverproject.org,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan.

2014-05-27 19:20 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> The "brd->nasync = 0;" was wrong, yes, but my main complaint was that
> you are writing complicated error handling.  This v2 patch makes the
> error handling even more complicated.  If dgap_tty_init() fails it
> should free the things it allocates itself, instead of the caller
> handling errors for it.
Yes, I knew dgap_tty_init() do only allocate some memory for channel.
But if one of function in dgap_firmware_load() is failed, it seems to
need all of resources in board.
Calling functions before calling dgap_tty_init() has memory
allocations and registration of tty related so when dgap_tty_init()
failed, all of resource in a board need to free and unregister.

And also, in dgap_cleanup_board() will free channels, so I called
dgap_cleanup_board() in err_cleanup label.

I understood your explanation but I didn't get why dgap_tty_uninit()
is not needed. Because If dgap_tty_init() is failed, and then
dgap_firmware_load() returns failure. That means it need to cleanup
previous allocation or registration before dgap_tty_init() is called.
example, dgap_tty_register() function.

If I'm wrong, please let me know.
Thanks.

regards,
Daeseok Youn.
>
> It's not actually that hard.  The only error handling we need to do in
> dgap_tty_init() is if the kzalloc() fails:
>
>   1374          /*
>   1375           * Allocate channel memory that might not have been allocated
>   1376           * when the driver was first loaded.
>   1377           */
>   1378          for (i = 0; i < brd->nasync; i++) {
>   1379                  if (!brd->channels[i]) {
>   1380                          brd->channels[i] =
>   1381                                  kzalloc(sizeof(struct channel_t), GFP_KERNEL);
>   1382                          if (!brd->channels[i])
>   1383                                  return -ENOMEM;
>
> Instead of returning directly here we should free the previous
> allocations.
>
>   1384                  }
>   1385          }
>
> The code is confusing because which ones did we allocate and which ones
> were already non-NULL at the start of the function?  In other words
> the "if (!brd->channels[i]) {" test?
>
> The answer is that the comment and the test seem to be wrong they were
> all NULL at the start of the function.  Just add a:
>
> free_chan:
>         while (--i >= 0) {
>                 kfree(brd->channels[i]);
>                 brd->channels[i] = NULL;
>         }
>         return ret;
>
> Actually, for these I would introduce an "int chan" variable just for
> that loop instead of "i" which we re-use.
>
> So then we remove the call to dgap_tty_uninit() from
> dgap_firmware_load().
>
> regards,
> dan carpenter
>
