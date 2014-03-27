Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaC0Xxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 19:53:37 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63910 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbaC0Xxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 19:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <202482763.23002.1395930610691.JavaMail.zimbra@xes-inc.com>
References: <3217679.sqG7Yrhs8H@daeseok-laptop.cloud.net>
	<1455668003.49319.1395859913516.JavaMail.zimbra@xes-inc.com>
	<CAHb8M2AX_KA3T2--yd3_ia9cjKpoEGUacW8zph6V6e_r_6_nuw@mail.gmail.com>
	<202482763.23002.1395930610691.JavaMail.zimbra@xes-inc.com>
Date: Fri, 28 Mar 2014 08:53:35 +0900
Message-ID: <CAHb8M2Bvb0sY5kLXOLsgARFdZc_dDY2SME7cn+HCe_z4=Unk4g@mail.gmail.com>
Subject: Re: [PATCH] staging: vme: fix memory leak in vme_user_probe()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: martyn welch <martyn.welch@ge.com>,
        manohar vanga <manohar.vanga@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, lisa@xenapiadmin.com,
        yongjun wei <yongjun_wei@trendmicro.com.cn>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-27 23:30 GMT+09:00 Aaron Sierra <asierra@xes-inc.com>:
>
> ----- Original Message -----
>> From: "DaeSeok Youn" <daeseok.youn@gmail.com>
>> Sent: Wednesday, March 26, 2014 8:47:51 PM
>>
>> 2014-03-27 3:51 GMT+09:00 Aaron Sierra <asierra@xes-inc.com>:
>> > ----- Original Message -----
>> >> From: "Daeseok Youn" <daeseok.youn@gmail.com>
>> >> Sent: Tuesday, March 25, 2014 10:01:48 PM
>> >> Subject: [PATCH] staging: vme: fix memory leak in vme_user_probe()
>> >>
>> >>
>> >> If vme_master_request() returns NULL when it failed,
>> >> it need to free buffers for master.
>> >>
>> >> And also removes unreachable code in vme_user_probe().
>> >>
>> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> >> ---
>> >>  drivers/staging/vme/devices/vme_user.c |    9 +++------
>> >>  1 files changed, 3 insertions(+), 6 deletions(-)
>> >
>> > Nice catches Daeseok. I don't maintain this driver, but I have some
>> > suggestions below.
>> >
>> >>
>> >> diff --git a/drivers/staging/vme/devices/vme_user.c
>> >> b/drivers/staging/vme/devices/vme_user.c
>> >> index 7927927..ffb4eee 100644
>> >> --- a/drivers/staging/vme/devices/vme_user.c
>> >> +++ b/drivers/staging/vme/devices/vme_user.c
>> >> @@ -776,7 +776,8 @@ static int vme_user_probe(struct vme_dev *vdev)
>> >>               image[i].kern_buf = kmalloc(image[i].size_buf, GFP_KERNEL);
>> >>               if (image[i].kern_buf == NULL) {
>> >>                       err = -ENOMEM;
>> >> -                     goto err_master_buf;
>> >> +                     vme_master_free(image[i].resource);
>> >> +                     goto err_master;
>> >>               }
>> >>       }
>> >
>> > I think it would be nice to keep all of the cleanup under the err_master
>> > label.
>> Actually, I changed like "err_slave" doing. When it failed to alloc
>> buffer for slave,
>> just called vme_slave_free(image[i].slave) and cleanup under the err_slave.
>
> I do like the error path symmetry provided by your patch.
>
>> >
>> > That could be done by changing the kern_buf allocation in this part to
>> > a devm_kmalloc. Then devm handles the kern_buf freeing entirely.
>> I didn't know about devm_kmalloc(), I will check that function. Thanks!
>>
>> >
>> >>
>> >> @@ -819,8 +820,6 @@ static int vme_user_probe(struct vme_dev *vdev)
>> >>
>> >>       return 0;
>> >>
>> >> -     /* Ensure counter set correcty to destroy all sysfs devices */
>> >> -     i = VME_DEVS;
>> >>  err_sysfs:
>> >>       while (i > 0) {
>> >>               i--;
>> >> @@ -830,12 +829,10 @@ err_sysfs:
>> >>
>> >>       /* Ensure counter set correcty to unalloc all master windows */
>> >>       i = MASTER_MAX + 1;
>> >> -err_master_buf:
>> >> -     for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++)
>> >> -             kfree(image[i].kern_buf);
>> >>  err_master:
>> >>       while (i > MASTER_MINOR) {
>> >>               i--;
>> >> +             kfree(image[i].kern_buf);
>> >>               vme_master_free(image[i].resource);
>> >>       }
>> >
>> > Using devm_kmalloc as mentioned above, the while loop could be
>> > simplified to this:
>> >
>> > err_master:
>> >         while (i >= MASTER_MINOR) {
>> >                 vme_master_free(image[i].resource);
>> >                 i--;
>> >         }
>> It would be nice, but when it failed to vme_master_request() and than
>> go to err_master,
>> image[i].resource must be NULL. So a NULL exception has occurred in
>> vme_master_free().
>>
>> I think vme_master{slave}_free() need to check NULL and it can be
>> possible to change code as your comment.
>> please check for me. :-)
>
> You are correct that vme_master_free() assumes that the resource being
> freed is not NULL. I should have recognized that case. That could easily
> be handled by testing the resource again in the loop, but I see the
> benefit of the symmetry of your change.

OK. I would leave the symmetry of my patch. :-)
Thanks for your reply.

Regards,
Daeseok Youn.
>
> -Aaron
>
>>
>> >
>> > If not moving to devm, this should be safe even though the first
>> > kern_buf may be NULL:
>> >
>> > err_master:
>> >         while (i >= MASTER_MINOR) {
>> >                 kfree(image[i].kern_buf);
>> >                 vme_master_free(image[i].resource);
>> >                 i--;
>> >         }
>> kfree() is ok. But vme_master_free() function has an problem as mentioned
>> above.
>>
>> Thanks for review.
>> Daeseok Youn.
>> >
>> > -Aaron
>> >
>> >>
>> >> --
>> >> 1.7.4.4
>> >>
>> >>
>> >>
>>
