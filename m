Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaDZSwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 14:52:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23763 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaDZSv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 14:51:58 -0400
Date: Sat, 26 Apr 2014 21:48:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Mark Hounschell <markh@compro.net>, devel <devel@driverdev.osuosl.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: dgap: implement error handling in
 dgap_tty_register()
Message-ID: <20140426184721.GL26890@mwanda>
References: <20140425070459.GA9155@devel>
 <20140425092607.GH26890@mwanda>
 <875455568.760649.1398423734122.JavaMail.root@mx2.compro.net>
 <535A5535.6000701@compro.net>
 <1016949935.761818.1398430870736.JavaMail.root@mx2.compro.net>
 <535A7402.1060305@compro.net>
 <CAHb8M2AgDzTzABys5Ec=tjg4xDaAORjPpVcjXykgWFKPtPnCMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2AgDzTzABys5Ec=tjg4xDaAORjPpVcjXykgWFKPtPnCMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 11:39:38AM +0900, DaeSeok Youn wrote:
> Hi,
> 
> please check below my comments.
> 
> 2014-04-25 23:41 GMT+09:00 Mark Hounschell <markh@compro.net>:
> > On 04/25/2014 08:59 AM, Dan Carpenter wrote:
> >> On Fri, Apr 25, 2014 at 08:29:41AM -0400, Mark Hounschell wrote:
> >>> On 04/25/2014 07:02 AM, DaeSeok Youn wrote:
> >>>> Hi, Dan.
> >>>>
> >>>> 2014-04-25 18:26 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> >>>>> Mark, maybe you should add yourself to the MAINTAINERS entry for this
> >>>>> driver?
> >>>>>
> >>>
> >>> I'll look into this. I am clueless on what that would actually mean.
> >>>
> >>
> >> Just add your name with Lidza in the MAINTAINERS file so that people
> >> will CC you on all the patches.
> >>
> >> DIGI EPCA PCI PRODUCTS
> >> M:      Lidza Louina <lidza.louina@gmail.com>
> >> L:      driverdev-devel@linuxdriverproject.org
> >> S:      Maintained
> >> F:      drivers/staging/dgap/
> >>
> >> You don't have to do it if you don't want to, but you seem to be working
> >> on this driver and I'm going to refer questions to you either way.  :P
> >>
> >>>>> On Fri, Apr 25, 2014 at 04:04:59PM +0900, Daeseok Youn wrote:
> >>>>>> @@ -1263,7 +1277,8 @@ static int dgap_tty_register(struct board_t *brd)
> >>>>>>               /* Register tty devices */
> >>>>>>               rc = tty_register_driver(brd->SerialDriver);
> >>>>>>               if (rc < 0)
> >>>>>> -                     return rc;
> >>>>>> +                     goto free_print_ttys;
> >>>>>> +
> >>>>>>               brd->dgap_Major_Serial_Registered = TRUE;
> >>>>>>               dgap_BoardsByMajor[brd->SerialDriver->major] = brd;
> >>>>>>               brd->dgap_Serial_Major = brd->SerialDriver->major;
> >>>>>> @@ -1273,13 +1288,29 @@ static int dgap_tty_register(struct board_t *brd)
> >>>>>>               /* Register Transparent Print devices */
> >>>>>>               rc = tty_register_driver(brd->PrintDriver);
> >>>>>>               if (rc < 0)
> >>>>>> -                     return rc;
> >>>>>> +                     goto unregister_serial_drv;
> >>>>>> +
> >>>>>>               brd->dgap_Major_TransparentPrint_Registered = TRUE;
> >>>>>>               dgap_BoardsByMajor[brd->PrintDriver->major] = brd;
> >>>>>>               brd->dgap_TransparentPrint_Major = brd->PrintDriver->major;
> >>>>>>       }
> >>>>>>
> >>>>>>       return rc;
> >>>>>> +
> >>>>>> +unregister_serial_drv:
> >>>>>> +     tty_unregister_driver(brd->SerialDriver);
> >>>>>
> >>>>> We only register the ->SerialDriver if someone else hasn't registered it
> >>>>> first?  So this should be:
> >>>>>
> >>>>>         if (we_were_the_ones_who_registered_the_serial_driver)
> >>>>>                 tty_unregister_driver(brd->SerialDriver);
> >>>>>
> >>>>> I haven't followed looked at this.  Who else is registering the serial
> >>>>> driver?  You have looked at this, what do you think?  Or Mark.
> >>>>
> >>>
> >>> registering the brd->XxxxxDriver is only done when a board is detected
> >>> and only during the firmware_load process. If we fail to
> >>> tty_register_driver do we _need_ to tty_unregister_driver? Isn't that
> >>> like freeing after an alloc failure?
> >>
> >> The allocation is conditional so the free should be conditional.  If we
> >> didn't allocate it, then we shouldn't free it.
> >>
> >> It wouldn't have even been a question except I'm not sure the allocation
> >> is *really* conditional because brd->dgap_Major_Serial_Registered might
> >> always be "false" like you guys seem to be saying.
> >>
> >>>
> >>>> I think brd struct is from dgap_Board array as global static variable
> >>>> when this function is
> >>>> called. So brd->dgap_Major_Serial_Registered is always "false".
> >>>> If dgap_NumBoards is less than MAXBOARDS, brd->SerialDriver should be
> >>>> registered.
> >>>>
> >>>> I'm not sure..
> >>>>
> >>>
> >>> I don't see any check for (dgap_NumBoards <  MAXBOARDS), which I think I
> >>> probably should, but I do see we are calling dgap_tty_register, which
> >>> can fail, without actually checking the return value. Also, yes,
> >>> dgap_Major_Xxxx_Registered seems to be always "false" until registered,
> >>> and it looks like dgap_Major_Xxxxx_Registered flags could be removed
> >>> because the only places we can unregister is at module_cleanup or
> >>> "after" it is already registered.
> >>>
> >>> What is the driver _supposed_ to do if we fail something on the second
> >>> or later board? Is the driver supposed to cleanup and exit or are we
> >>> supposed to stay loaded for the board/boards that are usable?
> >>
> >> Stay loaded.
> >>
> >
> > Then these tests on brd->dgap_Major_Serial_Registered need to stay in
> > there. If I have 3 boards and the second fails in some way, if I rmmod
> > the driver they will protect from unregistering a never registered one.
> > At least in the unregister code path. There is probably no need for them
> > in the register code path. I'll work up a patch for this.
> 
> Should I update my patch?
> 
> I think "if (!brd->dgap_Major_XXX_Registered)" line can be removed in this
> function, because if tty_register_driver() is failed just set "false"
> to "dgap_Major_XXX_Registered".

Mark sent a patch to remove the check.  Could you redo your patch based
on his?

regards,
dan carpenter

