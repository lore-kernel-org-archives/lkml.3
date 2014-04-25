Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaDYLCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:02:18 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41130 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaDYLCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140425092607.GH26890@mwanda>
References: <20140425070459.GA9155@devel>
	<20140425092607.GH26890@mwanda>
Date: Fri, 25 Apr 2014 20:02:14 +0900
Message-ID: <CAHb8M2Ay22vh-zuGgKhjr0DCJ-ajVPiPmYDRu159HF9N0CDEpg@mail.gmail.com>
Subject: Re: [PATCH] staging: dgap: implement error handling in dgap_tty_register()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Hounschell <markh@compro.net>, Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan.

2014-04-25 18:26 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> Mark, maybe you should add yourself to the MAINTAINERS entry for this
> driver?
>
> On Fri, Apr 25, 2014 at 04:04:59PM +0900, Daeseok Youn wrote:
>> @@ -1263,7 +1277,8 @@ static int dgap_tty_register(struct board_t *brd)
>>               /* Register tty devices */
>>               rc = tty_register_driver(brd->SerialDriver);
>>               if (rc < 0)
>> -                     return rc;
>> +                     goto free_print_ttys;
>> +
>>               brd->dgap_Major_Serial_Registered = TRUE;
>>               dgap_BoardsByMajor[brd->SerialDriver->major] = brd;
>>               brd->dgap_Serial_Major = brd->SerialDriver->major;
>> @@ -1273,13 +1288,29 @@ static int dgap_tty_register(struct board_t *brd)
>>               /* Register Transparent Print devices */
>>               rc = tty_register_driver(brd->PrintDriver);
>>               if (rc < 0)
>> -                     return rc;
>> +                     goto unregister_serial_drv;
>> +
>>               brd->dgap_Major_TransparentPrint_Registered = TRUE;
>>               dgap_BoardsByMajor[brd->PrintDriver->major] = brd;
>>               brd->dgap_TransparentPrint_Major = brd->PrintDriver->major;
>>       }
>>
>>       return rc;
>> +
>> +unregister_serial_drv:
>> +     tty_unregister_driver(brd->SerialDriver);
>
> We only register the ->SerialDriver if someone else hasn't registered it
> first?  So this should be:
>
>         if (we_were_the_ones_who_registered_the_serial_driver)
>                 tty_unregister_driver(brd->SerialDriver);
>
> I haven't followed looked at this.  Who else is registering the serial
> driver?  You have looked at this, what do you think?  Or Mark.

I think brd struct is from dgap_Board array as global static variable
when this function is
called. So brd->dgap_Major_Serial_Registered is always "false".
If dgap_NumBoards is less than MAXBOARDS, brd->SerialDriver should be
registered.

I'm not sure..

Thanks.

Regards,
Daeseok Youn.

>
> regards,
> dan carpenter
>
