Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3JAQbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:31:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57374 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3JAQba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:31:30 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-2f-524af8c122b5
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Ramprasad C <ramprasad.ch@gmail.com>
Cc: axboe@kernel.dk, abhansali@stec-inc.com, jmoyer@redhat.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        osengineering@stec-inc.com, Amit.Phansalkar@hgst.com
Subject: Re: [PATCH 14/14] skd: remove skd_bio code
Date: Tue, 01 Oct 2013 18:30:54 +0200
Message-id: <3898812.vf7OgV5Y6P@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CACbH579bNVcSMiWKexxNG=E3BXF1yoEDttHf3A94ZQyNpdM7Cg@mail.gmail.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
 <1380547556-17719-15-git-send-email-b.zolnierkie@samsung.com>
 <CACbH579bNVcSMiWKexxNG=E3BXF1yoEDttHf3A94ZQyNpdM7Cg@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd2DP7yCDF7NU7fo7TnJbrFzYyuT
	xeq7/WwWZ39dZbE42/SG3eLyrjlsFgc+v2e1eNd7n9WBw2PnrLvsHqfu72LxuHy21OP9vqts
	Hn1bVjF63Dn3gcnj8ya5APYoLpuU1JzMstQifbsEroxrSzvZC06JVXy7eJSpgXGpUBcjJ4eE
	gInE/ofHmCBsMYkL99azdTFycQgJLGKUeNKwGsppYZI4cb6VBaSKTcBKYmL7KkYQW0RAQ+L4
	0+fMIEXMAhsZJc58ecIGkhAWMJZ4fu00O4jNIqAq8WTXYiCbg4NXQFNi8mk9kLCogKfEp0lL
	mUFsToFgiY7tu8BsIYHzjBLLbpSC2LwCghI/Jt8D28ssIC+xb/9UVghbR2J/6zS2CYwCs5CU
	zUJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwTHwTHoH46oGi0OMAhyMSjy8
	Eg+9goRYE8uKK3MPMUpwMCuJ8NqfBQrxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5Y
	kpqdmlqQWgSTZeLglGpgLL33cleI2Y+18Tv6V6Vcnhm6OuNs4hE/z16O9Mdr5wat0HMrmv/6
	uKpK4eevSrcDPU+YqlWyuy/l4Yld8O1A7u4bkn7WX4x5f3zvUO75uEYl1uXvqr7XnsLxdkHS
	G391ub8UKspbv4fxWNwu/ybhnTm663ie1LFqZ/mrVGR9XsplJj4nl/elEktxRqKhFnNRcSIA
	e7hlB30CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ramprasad,

On Tuesday, October 01, 2013 06:46:00 PM Ramprasad C wrote:
> Hi Bartlomiej,
> 
> Thank for your contributions to skd driver.
> 
> The reason why skd driver has two code paths is:-
> 1. For some workloads, Bio code path (skd_bio=1) performs better as
> compared to default code, like random r/w, high queue depths, direct i/o
> etc. In Bio code path, driver bypasses linux block elevator + scheduler
> layers and 'struct bio' comes directly to driver through make_request_fn().

Have you tried using "noop" I/O scheduler to alleviate the issue?

You need the kernel compiled with CONFIG_IOSCHED_NOOP=y (it is enabled by
default) and then do i.e. "echo noop > /sys/block/skd0/queue/scheduler" to
enable "noop" I/O scheduler for the skd0 block device.

> 2. For some workloads like buffered mode (app) i/o, the default code path
> performs much better. Hence, both the code paths are kept with module
> parameter. We would prefer to have both code paths.

It would be very useful to see some numbers for skd_bio=1 and skd_bio=0
(with "noop" I/O scheduler enabled) for the affected workloads to see what
kind of improvement is offered by skd_bio=1.

If the block layer queuing code is a problem even with "noop" I/O scheduler
it would be much better try to identify and fix (if possible) the problem
parts in the generic block layer code. This would benefit all SSD hardware
used on Linux not only the one supported by skd driver.

Also it is very inflexible to require the driver re-load just to optimize
it for some workload. I believe that a better solution (runtime selection
of the mode of operation at the block layer level) can be provided if
really necessary.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Regards,
> Ramprasad
> 
> 
> 
> On Mon, Sep 30, 2013 at 6:55 PM, Bartlomiej Zolnierkiewicz <
> b.zolnierkie@samsung.com> wrote:
> 
> > skd_bio feature adds a possibility to use the internal bio list to process
> > requests instead of using the normal block layer queueing functionality.
> > Its potential advantages are unclear and if there are any it is better to
> > identify and fix the block layer code deficiences instead. Moreover it
> > introduces separate code-paths through the whole driver which are difficult
> > to test properly and maintain in the long-term. Since it is currently not
> > used unless explicitly enabled by module parameter just remove it.
> >
> > Cc: Akhil Bhansali <abhansali@stec-inc.com>
> > Cc: Jeff Moyer <jmoyer@redhat.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/block/skd_main.c | 605
> > ++++++-----------------------------------------
> >  1 file changed, 76 insertions(+), 529 deletions(-)

