Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab3GOJdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:33:53 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:55328 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754622Ab3GOJdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:33:51 -0400
Message-ID: <51E3BFF1.5060104@st.com>
Date: Mon, 15 Jul 2013 10:25:05 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, alipowski@interia.pl,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com
Subject: Re: [PATCH RFC] media: lirc: Allow lirc dev to talk to rc device
References: <1373619328-14376-1-git-send-email-srinivas.kandagatla@st.com> <20130712124627.GA18177@pequod.mess.org>
In-Reply-To: <20130712124627.GA18177@pequod.mess.org>
Content-Type: multipart/mixed;
 boundary="------------000106050906010809020401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000106050906010809020401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thanks Sean for the comments,
On 12/07/13 13:46, Sean Young wrote:
> On Fri, Jul 12, 2013 at 09:55:28AM +0100, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> The use case is simple, if any rc device has allowed protocols =
>> RC_TYPE_LIRC and map_name = RC_MAP_LIRC set, the driver open will be never
>> called. The reason for this is, all of the key maps except lirc have some
>> KEYS in there map, so during rc_register_device process these keys are
>> matched against the input drivers and open is performed, so for the case
>> of RC_MAP_EMPTY, a tty/vt/keyboard is matched and the driver open is
>> performed.
>>
>> In case of lirc, there is no match and result is that there is no open
>> performed, however the lirc-dev will go ahead and create a /dev/lirc0
>> node. Now when lircd/mode2 opens this device, no data is available
>> because the driver was never opened.
> 
> The rc device gets opened via the input interface. If the input device is
> never opened (e.g. embedded with no console) then the rc open is never 
> called and lirc will not work either. So that's another case.

Yes, this might be another case to add to the list.

>> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
>> index e456126..d5ad27f 100644

>> +	rc_dev = ir->d.rc_dev;
>> +	if (rc_dev && rc_dev->open) {
>> +		retval = rc_dev->open(rc_dev);
>> +		if (retval)
>> +			goto error;
>> +	}
>> +
> 
> Now the rc device can have its open called twice; once via the input 
> system and then (while it is already opened) via lirc. The rc drivers do
> not expect this.
I did think about this, and I thought managing this would be much easy
in the actual driver itself.

But given the generic nature, add this logic to rc infrastructure makes
much sense,
What I have done is added a users to rc_dev which will track howmany
users are actively using this device.
Here is the new patch, with the users count.
> 
>>  	cdev = ir->cdev;
>>  	if (try_module_get(cdev->owner)) {
>>  		ir->open++;
>> @@ -499,6 +508,7 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
>>  {
>>  	struct irctl *ir = irctls[iminor(inode)];
>>  	struct cdev *cdev;
>> +	struct rc_dev *rc_dev;
>>  
>>  	if (!ir) {
>>  		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
>> @@ -511,6 +521,10 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
>>  
>>  	WARN_ON(mutex_lock_killable(&lirc_dev_lock));
>>  
>> +	rc_dev = ir->d.rc_dev;
>> +	if (rc_dev && rc_dev->close)
>> +		rc_dev->close(rc_dev);
>> +
> 
> iguanair, nuvoton and ene_ir will disable the ir receiver when their close
> function is called. If the device was also opened via the input interface,
> the input interface will receive no new ir activity.
> 
> I think there should be some sort of (atomic) use counter so that the 
> rc device open or close only gets called once, whether opened via the 
> input interface or via lirc. 
new patch should address this using a users a use counter.

Thanks,
srini

--------------000106050906010809020401
Content-Type: text/x-patch;
 name="0001-media-lirc-Allow-lirc-dev-to-talk-to-rc-device-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-media-lirc-Allow-lirc-dev-to-talk-to-rc-device-v2.patch"

>From 06435a6ebd2374b500fbd0037e16a0451668f193 Mon Sep 17 00:00:00 2001
From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Date: Fri, 12 Jul 2013 09:07:37 +0100
Subject: [PATCH RFC] media: lirc: Allow lirc dev to talk to rc device

The use case is simple, if any rc device has allowed protocols =
RC_TYPE_LIRC and map_name = RC_MAP_LIRC set, the driver open will be never
called. The reason for this is, all of the key maps except lirc have some
KEYS in there map, so during rc_register_device process these keys are
matched against the input drivers and open is performed, so for the case
of RC_MAP_EMPTY, a vt/keyboard is matched and the driver open is
performed.

In case of lirc, there is no match and result is that there is no open
performed, however the lirc-dev will go ahead and create a /dev/lirc0
node. Now when lircd/mode2 opens this device, no data is available
because the driver was never opened.

lirc_dev seems to have no link with actual rc device w.r.t open/close.
This patch adds rc_dev pointer to lirc_driver structure for cases like
this, so that it can do the open/close of the real driver in accordance
to lircd/mode2 open/close.

Without this patch its impossible to open a rc device which has
RC_TYPE_LIRC ad RC_MAP_LIRC set.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/rc/ir-lirc-codec.c |    1 +
 drivers/media/rc/lirc_dev.c      |   16 ++++++++++++++++
 drivers/media/rc/rc-main.c       |   11 +++++++++--
 include/media/lirc_dev.h         |    1 +
 include/media/rc-core.h          |    1 +
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index e456126..d5ad27f 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -375,6 +375,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
 	drv->fops = &lirc_fops;
 	drv->dev = &dev->dev;
+	drv->rc_dev = dev;
 	drv->owner = THIS_MODULE;
 
 	drv->minor = lirc_register_driver(drv);
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 8dc057b..249e6ab 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -35,6 +35,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 
+#include <media/rc-core.h>
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
@@ -437,6 +438,7 @@ EXPORT_SYMBOL(lirc_unregister_driver);
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
 	struct irctl *ir;
+	struct rc_dev *rc_dev;
 	struct cdev *cdev;
 	int retval = 0;
 
@@ -467,6 +469,15 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 		goto error;
 	}
 
+	rc_dev = ir->d.rc_dev;
+	if (!rc_dev->users++ && rc_dev && rc_dev->open) {
+		retval = rc_dev->open(rc_dev);
+		if (retval) {
+			rc_dev->users--;
+			goto error;
+		}
+	}
+
 	cdev = ir->cdev;
 	if (try_module_get(cdev->owner)) {
 		ir->open++;
@@ -499,6 +510,7 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
 	struct irctl *ir = irctls[iminor(inode)];
 	struct cdev *cdev;
+	struct rc_dev *rc_dev;
 
 	if (!ir) {
 		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
@@ -511,6 +523,10 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 
 	WARN_ON(mutex_lock_killable(&lirc_dev_lock));
 
+	rc_dev = ir->d.rc_dev;
+	if (rc_dev && !--rc_dev->users && rc_dev->close)
+		rc_dev->close(rc_dev);
+
 	ir->open--;
 	if (ir->attached) {
 		ir->d.set_use_dec(ir->d.data);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1cf382a..e800b96 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -702,15 +702,22 @@ EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 static int ir_open(struct input_dev *idev)
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
+	int rval = 0;
 
-	return rdev->open(rdev);
+	if (!rdev->users++)
+		rval = rdev->open(rdev);
+
+	if (rval)
+		rdev->users--;
+
+	return rval;
 }
 
 static void ir_close(struct input_dev *idev)
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
 
-	 if (rdev)
+	 if (rdev && !--rdev->users)
 		rdev->close(rdev);
 }
 
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 168dd0b..96dccb6 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -139,6 +139,7 @@ struct lirc_driver {
 	struct lirc_buffer *rbuf;
 	int (*set_use_inc) (void *data);
 	void (*set_use_dec) (void *data);
+	struct rc_dev *rc_dev;
 	const struct file_operations *fops;
 	struct device *dev;
 	struct module *owner;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 06a75de..b42016a 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -101,6 +101,7 @@ struct rc_dev {
 	bool				idle;
 	u64				allowed_protos;
 	u64				enabled_protocols;
+	u32				users;
 	u32				scanmask;
 	void				*priv;
 	spinlock_t			keylock;
-- 
1.7.6.5


--------------000106050906010809020401--
