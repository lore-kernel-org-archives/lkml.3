Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaCCJpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:45:31 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:33786 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaCCJp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:45:28 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-de-53144f36397a
Date: Mon, 03 Mar 2014 06:45:21 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 4/6] media: em28xx-input - implement em28xx_ops:
 suspend/resume hooks
Message-id: <20140303064521.4261b374@samsung.com>
In-reply-to: <20140301104835.631c65bb@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
 <5dc00d657718dfefedb35b055abd13997afd6979.1393027856.git.shuah.kh@samsung.com>
 <20140301104835.631c65bb@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t/hEF1zf5Fgg5fRFpd3zWGz6NmwldXi
	y2cui68/HRxYPHbOusvu0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBkXr95nL+hQq9gz+xtL
	A+Ne+S5GTg4JAROJ+5+72SFsMYkL99azdTFycQgJLGGU6Nk/iQ0kISTQwySx/Wo1iM0ioCqx
	/MpXJhCbTcBI4lVjCyuILSJgJbH3802wOLOArUTHoU4WEFtYIFFi0/PrQDYHB6+AocS/Bw4g
	YU6g1hWrJjFD7NrAKNG/eCIrxBFOEq9eTwabwysgKPFj8j0WiJnqEpPmLWKGsLUlnry7wDqB
	UWAWkrJZSMpmISlbwMi8ilG0tDi5oDgpPddQrzgxt7g0L10vOT93EyMkWIt2MD7bYHWIUYCD
	UYmH98Yi4WAh1sSy4srcQ4wSHMxKIrz5y4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGFNPrmey
	XnpXxzvxRVPd27nTPM66RqXu+BS2K9favWJmV+m+O9pfOq8ue3nL89UdbuaD9/6yWjntOJLH
	O62I63rNJ/mXvTz7hGsu5J9Z/SftkNnTCF6V7Z/vLhKYse11TIjHk/x+KQctsQPWbn/i6784
	RPnLz3etn1cp/sj1n2WZxdL77ocuqCmxFGckGmoxFxUnAgBj9jwHNAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 01 Mar 2014 10:48:35 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Fri, 21 Feb 2014 17:50:16 -0700
> Shuah Khan <shuah.kh@samsung.com> escreveu:
> 
> > Implement em28xx_ops: suspend/resume hooks. em28xx usb driver will
> > invoke em28xx_ops: suspend and resume hooks for all its extensions
> > from its suspend() and resume() interfaces.
> > 
> > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-input.c | 35 +++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> > 
> > diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> > index 18f65d8..1227309 100644
> > --- a/drivers/media/usb/em28xx/em28xx-input.c
> > +++ b/drivers/media/usb/em28xx/em28xx-input.c
> > @@ -827,11 +827,46 @@ static int em28xx_ir_fini(struct em28xx *dev)
> >  	return 0;
> >  }
> >  
> > +static int em28xx_ir_suspend(struct em28xx *dev)
> > +{
> > +	struct em28xx_IR *ir = dev->ir;
> > +
> > +	if (dev->is_audio_only)
> > +		return 0;
> > +
> > +	em28xx_info("Suspending input extension");
> > +	cancel_delayed_work_sync(&ir->work);
> > +	cancel_delayed_work_sync(&dev->buttons_query_work);
> > +	/* is canceling delayed work sufficient or does the rc event
> > +	   kthread needs stopping? kthread is stopped in
> > +	   ir_raw_event_unregister() */
> > +	return 0;
> > +}
> > +
> > +static int em28xx_ir_resume(struct em28xx *dev)
> > +{
> > +	struct em28xx_IR *ir = dev->ir;
> > +
> > +	if (dev->is_audio_only)
> > +		return 0;
> > +
> > +	em28xx_info("Resuming input extension");
> > +	/* if suspend calls ir_raw_event_unregister(), the should call
> > +	   ir_raw_event_register() */
> > +	schedule_delayed_work_sync(&ir->work);
> 
> This causes a compilation breakage:
> 
> drivers/media/usb/em28xx/em28xx-input.c: In function ‘em28xx_ir_resume’:
> drivers/media/usb/em28xx/em28xx-input.c:856:2: error: implicit declaration of function ‘schedule_delayed_work_sync’ [-Werror=implicit-function-declaration]
>   schedule_delayed_work_sync(&ir->work);
> 

Ok, I reworked it fixing the above compilation bug, and added a test to
be sure that IR is enabled before using ir->work.

Patch enclosed.

This series look OK on my eyes with this change, and it worked fine
here with PCTV 80e, so I'll be merging it. In any case, this won't
cause any regressions, as suspending before those patches on those 
devices make the machine to hang.

Regards,
Mauro

From: Shuah Khan <shuah.kh@samsung.com>
Date: Fri, 21 Feb 2014 21:50:16 -0300
Subject: [PATCH] [media] em28xx-input: implement em28xx_ops: suspend/resume
 hooks

Implement em28xx_ops: suspend/resume hooks. em28xx usb driver will
invoke em28xx_ops: suspend and resume hooks for all its extensions
from its suspend() and resume() interfaces.

[m.chehab@samsung.com: Fix a breakage caused by calling a non-existing
 function call: schedule_delayed_work_sync(), and test if IR was defined
 at suspend/resume]
Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 048e5b680499..47a2c1dcccbf 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -827,11 +827,48 @@ static int em28xx_ir_fini(struct em28xx *dev)
 	return 0;
 }
 
+static int em28xx_ir_suspend(struct em28xx *dev)
+{
+	struct em28xx_IR *ir = dev->ir;
+
+	if (dev->is_audio_only)
+		return 0;
+
+	em28xx_info("Suspending input extension");
+	if (ir)
+		cancel_delayed_work_sync(&ir->work);
+	cancel_delayed_work_sync(&dev->buttons_query_work);
+	/* is canceling delayed work sufficient or does the rc event
+	   kthread needs stopping? kthread is stopped in
+	   ir_raw_event_unregister() */
+	return 0;
+}
+
+static int em28xx_ir_resume(struct em28xx *dev)
+{
+	struct em28xx_IR *ir = dev->ir;
+
+	if (dev->is_audio_only)
+		return 0;
+
+	em28xx_info("Resuming input extension");
+	/* if suspend calls ir_raw_event_unregister(), the should call
+	   ir_raw_event_register() */
+	if (ir)
+		schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
+	if (dev->num_button_polling_addresses)
+		schedule_delayed_work(&dev->buttons_query_work,
+			       msecs_to_jiffies(dev->button_polling_interval));
+	return 0;
+}
+
 static struct em28xx_ops rc_ops = {
 	.id   = EM28XX_RC,
 	.name = "Em28xx Input Extension",
 	.init = em28xx_ir_init,
 	.fini = em28xx_ir_fini,
+	.suspend = em28xx_ir_suspend,
+	.resume = em28xx_ir_resume,
 };
 
 static int __init em28xx_rc_register(void)



-- 

Cheers,
Mauro
