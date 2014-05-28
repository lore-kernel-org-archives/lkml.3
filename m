Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaE1OOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:14:09 -0400
Received: from mx2.comprocs.com ([12.186.155.30]:61126 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753286AbaE1OOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:14:07 -0400
X-BYPSHEADER: 2487585
X-SMScore: -400
Message-ID: <5385EF2B.1000003@compro.net>
Date: Wed, 28 May 2014 10:14:03 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>
CC: devel <devel@driverdev.osuosl.org>, Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V2] staging: dgap: implement proper error handling in
 dgap_firmware_load()
References: <20140527070937.GA21621@devel.8.8.4.4> <20140527102002.GI17724@mwanda> <CAHb8M2AceJeFv-KonF+bAFJ-+xssFxx5ytEKhMNZ1c3xm2jvZA@mail.gmail.com> <20140528070233.GP17724@mwanda> <CAHb8M2ABVCaoNR0m5mLmWv-ei60PDRu462QTqDgEJwAf63oteg@mail.gmail.com> <1203682594.1176349.1401271946432.JavaMail.root@mx2.compro.net>
In-Reply-To: <1203682594.1176349.1401271946432.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 06:11 AM, Dan Carpenter wrote:
> On Wed, May 28, 2014 at 06:29:38PM +0900, DaeSeok Youn wrote:
>>> In your patch it has:
>>> +       dgap_tty_uninit(brd, false);
>>>
>>> But it should only be "false" if dgap_tty_init() failed.  If
>>> dgap_tty_register_ports() fails then it should be "true".  Another
>> Yes, you're right. There were no error handle for tty_port_register_device() and
>> dgap_create_tty_sysfs() in dgap_tty_register_ports(). I didn't catch it. :-(
>> It need to add error handlers for them, right?
> 
> Eventually, yes.  But I don't see a simple way to fix
> dgap_firmware_load() until after the code is cleaned up.
> 
>>
>>> problem is that as you say, the earlier function are allocating
>>> resources like dgap_tty_register() but only the last two function calls
>>> have a "goto err_cleanup;" so the error handling is incomplete.
>> So remove "goto" in dgap_firmware_load() and add error handler in
>> dgap_tty_init()
> 
> In the current code there isn't a goto in dgap_firmware_load().  Remove
> the call to dgap_tty_uninit() and add error handling in dgap_tty_init().
> 
> That will clean up the code, and fix some NULL dereference bugs inside
> dgap_tty_uninit().
> 
>> and dgap_tty_register_ports(), right?
> 
> Inside dgap_tty_register_ports(), then we should add a
> kfree(brd->serial_ports) if the "brd->printer_ports" allocation fails.
> That is not a complete fix, but it is a part fix and it is clean.
> 
>>
>> I have a question of this. In case of this, how to complete the error handling?
> 
> [patch 1/x] staging: dgap: remove useless dgap_probe1() function
> [patch 2/x] staging: dgap: unwind on error in dgap_found_board()
> [patch 3/x] staging: dgap: remove bogus null test in dgap_tty_init()
> 	The ->channels[] were set to null in dgap_found_board().
> [patch 4/x] staging: dgap: unwind on error in dgap_tty_init()
> 	This also removes the call to dgap_tty_uninit() in
> 	dgap_firmware_load()
> [patch 5/x] staging: dgap: unwind on error in dgap_tty_register_ports()
> [patch 6/x] staging: dgap: make dgap_config_buf a local buffer
> [patch 7/x] staging: dgap: pass "dgap_numboards" to dgap_found_board()
> 	instead of using a global variable
> [patch 8/x] staging: dgap: pass "brd" to dgap_after_config_loaded()
> 	instead of passing "dgap_numboards" and looking up brd again.
> [patch 9/x] staging: dgap: rename dgap_finalize_board_init() to dgap_request_irq()
> 
> In the end, I hate dgap_tty_uninit() because it doesn't match
> dgap_tty_init() at all.  It's poorly named.  We should rename it and
> make another dgap_tty_init() which just sets the ->channels[] to NULL.
> 
> [patch x/x] staging: dgap: introduce dgap_tty_unregister()
> 	This is currently done in dgap_tty_uninit(), which is the wrong
> 	place.
> 
> I have started using a new todo list tag in my emails.  So I'm adding
> this stuff to the todo list.
> 
> TODO-list: 2014-05-28: dgap: cleanups and bug fixes.
> 

I can think of some more things that could be added to that TODO-list.

All the configuration file stuff needs to go away. As Greg previously
said, we don't read configurations files in kernel modules. I'm pretty
sure all cards supported have unique device IDs, even though notes and
code in this driver imply otherwise. As long as they all do, with the
exception of those cards that use port extenders, I think this could be
done. Maybe we will never be able to support "port extenders". Unclear
yet. When we do this, the useintr and altpin configuration file stuff
will need converted to module options.

There was also some ioctl code removed entirely before the driver was
merged into staging. It was specific to the dgap_mgmt device (currently
dead as a result) that allowed userland some real-time monitoring and
configuration changes. These userland utilities were part of the
original Digi package and I'm sure are used by some. I personally never
used them, but...

Then there are some things you recommended in a previous email that I
haven't got to yet?

Is that TODO-list going to be commited?

Regards
Mark

