Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaIYIj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:39:27 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39260 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIYIjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:39:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140925075033.GH5865@mwanda>
References: <20140923002236.GA20782@devel>
	<20140924094530.GC5811@mwanda>
	<CAHb8M2A82yFT9dWqz=Ad_VoPY0c+UF5-VxbBOH-VNUjLnfJ1jA@mail.gmail.com>
	<20140925075033.GH5865@mwanda>
Date: Thu, 25 Sep 2014 17:39:21 +0900
Message-ID: <CAHb8M2BNu9VNKbosiG5M7wzuyK2=hSxkjp5WQHFMDamOE0YzYg@mail.gmail.com>
Subject: Re: [PATCH 3/3] staging: dgap: use dgap_release_remap() in dgap_cleanup_board()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-25 16:50 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Thu, Sep 25, 2014 at 09:26:47AM +0900, DaeSeok Youn wrote:
>> Hi,
>>
>> 2014-09-24 18:45 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
>> > On Tue, Sep 23, 2014 at 09:22:36AM +0900, Daeseok Youn wrote:
>> >>  static void dgap_release_remap(struct board_t *brd)
>> >>  {
>> >> -     release_mem_region(brd->membase, 0x200000);
>> >> -     release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
>> >> -     iounmap(brd->re_map_membase);
>> >> -     iounmap(brd->re_map_port);
>> >> +     if (brd->re_map_membase) {
>> >
>> > I hate this if conditions.  Let's not complicate dgap_release_remap(),
>> > let's fix the callers instead.  Especially dgap_init_module() is a
>> > totally sucky function with bad unwinding.
>> ok. then,
>>    if (brd->re_map_membase && brd->re_map_port)
>>         dgap_release_remap(brd);
>>
>> right?
>
> What I'm saying is there should be no if statement because we should
> only call this function after the memory has been remapped so there
> should be no if conditions in this function at all.
OK. I got this. remove "if" statement in dgap_release_remap().

>
> The problem is that dgap_init_module() doesn't unwind, it just tries to
> free every variable without considering whether or not it was allocated.
> It's the "One Err" approach to error handling where you just have one
> error label that calls free on every single thing in the world.  It
> *should* look more like this:
>
> static int dgap_init_module(void)
> {
>         int rc;
>
>         pr_info("%s, Digi International Part Number %s\n", DG_NAME, DG_PART);
>
>         rc = dgap_start();
>         if (rc)
>                 return rc;
>
>         rc = pci_register_driver(&dgap_driver);
>         if (rc)
>                 goto err_stop;
>
>         rc = dgap_create_driver_sysfiles(&dgap_driver);
>         if (rc)
>                 goto err_unregister;
>
>         dgap_driver_state = DRIVER_READY;
>
>         return 0;
>
> err_unregister:   // <- note that the label names reflect where the label
>                   //    is not where the goto is.  dgap_start() uses
>                   //    wrong/confusing label names.
>         pci_unregister_driver(&dgap_driver);
> err_stop:
>         dgap_stop();  // <- mirror image of dgap_start();
>
>         return rc;
> }
>
> dgap_stop() is easy to write because it's based on the error handling
> in dgap_start().
>
> static void dgap_start(void)
> {
>         spin_lock_irqsave(&dgap_poll_lock, lock_flags);
>         dgap_poll_stop = 1;
>         spin_unlock_irqrestore(&dgap_poll_lock, lock_flags);
>
>         del_timer_sync(&dgap_poll_timer);
>
>         device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
>         class_destroy(dgap_class);
>         unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
> }
>
> The existing dgap_init_module() "free every single thing in the entire
> universe" approach is buggy because it tries to delete the sysfs files
> before they have been allocated.  This is called a "One Err Bug" because
> having just one error label makes the code too complicated for anyone to
> understand.  You have to add all kinds of if conditions everywhere and
> it's a mess.
thanks for kind explanation.

I will send patches as your comments.

regards,
Daeseok Youn.
>
> regards,
> dan carpenter
>
