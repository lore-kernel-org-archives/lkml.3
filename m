Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaE0AHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:07:11 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35058 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaE0AHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140526105031.GF15585@mwanda>
References: <20140526102347.GA13793@devel.8.8.4.4>
	<20140526105031.GF15585@mwanda>
Date: Tue, 27 May 2014 09:07:07 +0900
Message-ID: <CAHb8M2B8FDWq2jiUO94bqDYGehv1VBP2shjDVYnGZf2+jXKgJA@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: dgap: implement proper error handling in dgap_firmware_load()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan

2014-05-26 19:50 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Mon, May 26, 2014 at 07:23:47PM +0900, Daeseok Youn wrote:
>> When dgap_tty_init() and dgap_tty_register_ports() are failed,
>> these are needed to free some memory properly.
>>
>> It can be handled by calling dgap_tty_uninit() and dgap_cleanup_board().
>> But tty's ports are not registered yet when these function are failed,
>> so brd->nasync set to zero.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/dgap/dgap.c |   21 ++++++++++++++++-----
>>  1 files changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
>> index 60b7d70..db24f70 100644
>> --- a/drivers/staging/dgap/dgap.c
>> +++ b/drivers/staging/dgap/dgap.c
>> @@ -954,19 +954,30 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
>>        * Do tty device initialization.
>>        */
>>       ret = dgap_tty_init(brd);
>> -     if (ret < 0) {
>> -             dgap_tty_uninit(brd);
>> -             return ret;
>> -     }
>> +     if (ret < 0)
>> +             goto err_cleanup;
>>
>>       ret = dgap_tty_register_ports(brd);
>>       if (ret)
>> -             return ret;
>> +             goto err_cleanup;
>>
>>       brd->state = BOARD_READY;
>>       brd->dpastatus = BD_RUNNING;
>>
>>       return 0;
>> +
>> +err_cleanup:
>> +     /*
>> +      * Clear nasync to zero for avoiding to call
>> +      * some destroyer for tty's ports which are not
>> +      * registered yet in dgap_tty_uninit().
>> +      */
>> +     brd->nasync = 0;
>> +
>> +     dgap_tty_uninit(brd);
>> +     dgap_cleanup_board(brd);
>> +     return ret;
>
> Wow.  This is nasty.  We shouldn't have to call dgap_tty_uninit() when
> the init failed.  Can't we clean this up instead of adding
> "brd->nasync = 0;" work arounds?
I think dgap_tty_uninit() should be called when the init failed. It
need to unregister
serial and printer driver and free them.
And I will try to clean this up without that workaround.
Thanks for review.

regards,
Daeseok Youn
>
> regards,
> dan carpenter
>
