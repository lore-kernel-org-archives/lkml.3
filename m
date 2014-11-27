Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaK0Fqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 00:46:38 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52088 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaK0Fqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 00:46:36 -0500
From: "Dudley Du" <dudley.dulixin@gmail.com>
To: "'Jeremiah Mahler'" <jmmahler@gmail.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "Dudley Du" <dudl@cypress.com>
References: <20141124085059.GA15770@hudson.localdomain> <20141125100703.GA9287@hudson.localdomain> <af603da34acc4caca630ca58eda7eb1e@BN1PR06MB070.namprd06.prod.outlook.com> <20141126200238.GB27014@hudson.localdomain>
In-Reply-To: <20141126200238.GB27014@hudson.localdomain>
Subject: RE: [BUG] [PATCH] next: cyapa: fix inop touchpad after resume on Acer C720
Date: Thu, 27 Nov 2014 13:45:49 +0800
Message-ID: <000d01d00a05$7ffe4970$7ffadc50$@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000E_01D00A48.8E2C85F0"
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLRI7JC94tyVTJgY+eGfVWVB5Bb4JpwMGzQgAAIl1CAAOdzAIAAoTkA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_000E_01D00A48.8E2C85F0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit

Jeremiah,

I didn't make the special patch for the linux-next before, so I don't know why
this patch is there and have issue.
Based on current code in the linux-next, I made below patch to fix this issue.
Could you please try again with attached patch fix.

Thanks,
Dudley

> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: 2014?11?27? 4:03
> To: Dudley Du
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [BUG] [PATCH] next: cyapa: fix inop touchpad after resume on Acer
> C720
> 
> Dudley,
> 
> On Wed, Nov 26, 2014 at 06:16:00AM +0000, Dudley Du wrote:
> > More info: I did all testings based on kernel 3.14.0 on Acer C70.
> >
> 
> I am testing with linux-next 3.18-rc6 on an Acer C720.
> 
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
> 
> > Thanks,
> > Dudley
> >
> []
> 
> --
> - Jeremiah Mahler

>From bb717b1c1525ef6b889f0ef735d920eed9e76e72 Mon Sep 17 00:00:00 2001
From: Dudley Du <dudley.dulixin@gmail.com>
Date: Thu, 27 Nov 2014 13:35:09 +0800
Subject: [PATCH] input: cyapa: fix irq error issue in cyapa_resume
To: dmitry.torokhov@gmail.com,
    jmmahler@gmail.com
Cc: bleung@google.com,
    linux-input@vger.kernel.org

This patch is aimed to fix the irq error happened on cyapa_resume when
doing suspend/resume testing.
The root cause of this issue is that the cyapa->irq has been removed but
still used in the driver.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index c84a9eb..caaba7b 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -938,7 +938,7 @@ static int __maybe_unused cyapa_suspend(struct device *dev)
 			 power_mode, error);
 
 	if (device_may_wakeup(dev))
-		cyapa->irq_wake = (enable_irq_wake(cyapa->irq) == 0);
+		cyapa->irq_wake = (enable_irq_wake(cyapa->client->irq) == 0);
 
 	mutex_unlock(&input->mutex);
 
@@ -956,7 +956,7 @@ static int __maybe_unused cyapa_resume(struct device *dev)
 	mutex_lock(&input->mutex);
 
 	if (device_may_wakeup(dev) && cyapa->irq_wake)
-		disable_irq_wake(cyapa->irq);
+		disable_irq_wake(cyapa->client->irq);
 
 	power_mode = input->users ? PWR_MODE_FULL_ACTIVE : PWR_MODE_OFF;
 	error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
@@ -964,7 +964,7 @@ static int __maybe_unused cyapa_resume(struct device *dev)
 		dev_warn(dev, "resume: set power mode to %d failed: %d\n",
 			 power_mode, error);
 
-	enable_irq(cyapa->irq);
+	enable_irq(cyapa->client->irq);
 
 	mutex_unlock(&input->mutex);
 
-- 
1.9.1

------=_NextPart_000_000E_01D00A48.8E2C85F0
Content-Type: application/octet-stream;
	name="input-cyapa-fix-irq-error-issue-in-cyapa_resume.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="input-cyapa-fix-irq-error-issue-in-cyapa_resume.patch"

>From bb717b1c1525ef6b889f0ef735d920eed9e76e72 Mon Sep 17 00:00:00 2001=0A=
From: Dudley Du <dudley.dulixin@gmail.com>=0A=
Date: Thu, 27 Nov 2014 13:35:09 +0800=0A=
Subject: [PATCH] input: cyapa: fix irq error issue in cyapa_resume=0A=
To: dmitry.torokhov@gmail.com,=0A=
    jmmahler@gmail.com=0A=
Cc: bleung@google.com,=0A=
    linux-input@vger.kernel.org=0A=
=0A=
This patch is aimed to fix the irq error happened on cyapa_resume when=0A=
doing suspend/resume testing.=0A=
The root cause of this issue is that the cyapa->irq has been removed but=0A=
still used in the driver.=0A=
=0A=
Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>=0A=
---=0A=
 drivers/input/mouse/cyapa.c | 6 +++---=0A=
 1 file changed, 3 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c=0A=
index c84a9eb..caaba7b 100644=0A=
--- a/drivers/input/mouse/cyapa.c=0A=
+++ b/drivers/input/mouse/cyapa.c=0A=
@@ -938,7 +938,7 @@ static int __maybe_unused cyapa_suspend(struct =
device *dev)=0A=
 			 power_mode, error);=0A=
 =0A=
 	if (device_may_wakeup(dev))=0A=
-		cyapa->irq_wake =3D (enable_irq_wake(cyapa->irq) =3D=3D 0);=0A=
+		cyapa->irq_wake =3D (enable_irq_wake(cyapa->client->irq) =3D=3D 0);=0A=
 =0A=
 	mutex_unlock(&input->mutex);=0A=
 =0A=
@@ -956,7 +956,7 @@ static int __maybe_unused cyapa_resume(struct device =
*dev)=0A=
 	mutex_lock(&input->mutex);=0A=
 =0A=
 	if (device_may_wakeup(dev) && cyapa->irq_wake)=0A=
-		disable_irq_wake(cyapa->irq);=0A=
+		disable_irq_wake(cyapa->client->irq);=0A=
 =0A=
 	power_mode =3D input->users ? PWR_MODE_FULL_ACTIVE : PWR_MODE_OFF;=0A=
 	error =3D cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);=0A=
@@ -964,7 +964,7 @@ static int __maybe_unused cyapa_resume(struct device =
*dev)=0A=
 		dev_warn(dev, "resume: set power mode to %d failed: %d\n",=0A=
 			 power_mode, error);=0A=
 =0A=
-	enable_irq(cyapa->irq);=0A=
+	enable_irq(cyapa->client->irq);=0A=
 =0A=
 	mutex_unlock(&input->mutex);=0A=
 =0A=
-- =0A=
1.9.1=0A=
=0A=

------=_NextPart_000_000E_01D00A48.8E2C85F0--

