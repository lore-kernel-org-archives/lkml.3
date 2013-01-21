Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3AUM7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:59:36 -0500
Received: from m50-134.163.com ([123.125.50.134]:37491 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab3AUM7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:59:35 -0500
X-Greylist: delayed 1086 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 07:59:34 EST
Message-ID: <50FD36C5.7060902@163.com>
Date: Mon, 21 Jan 2013 20:38:29 +0800
From: Jason Luan <luanjianhai@163.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: xen-devel@lists.xensource.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V2] xen-netback notify DomU to send ARP.
References: <50EC099D.6020407@oracle.com> <50EC297A02000078000B3BB5@nat28.tlf.novell.com> <1357652541.7989.179.camel@zakaz.uk.xensource.com> <50EC3DFD.8060206@oracle.com> <1357660834.12649.103.camel@dagon.hellion.org.uk> <50ED1EB3.3080605@oracle.com> <50ED4F1D02000078000B3F87@nat28.tlf.novell.com> <50ED6255.7020006@oracle.com> <50ED825802000078000B4113@nat28.tlf.novell.com> <50ED8ED3.8010007@163.com> <50ED9E6502000078000B4220@nat28.tlf.novell.com> <50ED950A.6010203@163.com> <50EDA80002000078000B427B@nat28.tlf.novell.com> <50EDA624.1010008@163.com> <50EE66FF.2020802@oracle.com> <50EF7106.7000302@oracle.com> <50FCED9F.1050708@oracle.com> <50FD3AB202000078000B7CD5@nat28.tlf.novell.com> <1358770987.3279.196.camel@zakaz.uk.xensource.com>
In-Reply-To: <1358770987.3279.196.camel@zakaz.uk.xensource.com>
Content-Type: multipart/mixed;
 boundary="------------010208060107020202060606"
X-CM-TRANSID: DtGowEBpAkbFNv1QNo0jAQ--.7852S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw15Jr18JFy3tr48tFyUAwb_yoW8JFyfpa
	4kta1DCF4DJr4DG3Z2q3WSgF1Yvr1xtryUJry3Gw17Zas0vrnrtFWxKr45Wa40qr45Gw4j
	va1UWasxWayrJFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5nYrUUUUU=
X-CM-SenderInfo: hoxd0yxldqxtrl6rljoofrz/1tbiKwerIE9o3Nl-kwAAsp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010208060107020202060606
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

于 2013年01月21日 20:23, Ian Campbell 写道:
> Which Linux did you test? pvops or something based on the classic-Xen
> patches?
>
> On Mon, 2013-01-21 at 11:55 +0000, Jan Beulich wrote:
>>>>> On 21.01.13 at 08:26, jianhai luan <jianhai.luan@oracle.com> wrote:
>>> +static void notify_front_arping(struct xenbus_device *dev)
>>> +{
>>> +	int err;
>>> +
>>> +	if (dev->state != XenbusStateConnected)
>>> +		return;
>>> +
>>> +	err = xenbus_printf(XBT_NIL, dev->nodename, "state", "%d", dev->state);
>>> +	if (err) {
>>> +		pr_fmt("Error writing the state");
>> What's this? pr_fmt() alone makes no sense at all, and I'd be
>> pretty surprised if the compiler didn't warn about this construct.
>>
>> Further, you probably want to say "re-writing" and include the
>> error code in the message. And of course you want a \n at the
>> end.
>>
>> Finally - no need for the braces ...
>>
>>> +	}
>>> +
>>> +	return;
>> ... nor this "return".
> Agreed on all counts.
>
> Jason, when you resend with these fixes please CC the netdev list and
> folks listed by ./scripts/get-maintainers.pl for the patch.
>
> Ian.

Thank you for your notifying.
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


Thanks,
Jason

--------------010208060107020202060606
Content-Type: text/x-patch;
 name="0001-xen-netback-notify-frontend-to-send-gratuitous-ARP.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-xen-netback-notify-frontend-to-send-gratuitous-ARP.patc";
 filename*1="h"

>From a1acd31b9672d1000549e71a9467b71b1c229d7d Mon Sep 17 00:00:00 2001
From: Jason Luan <jianhai.luan@oracle.com>
Date: Fri, 28 Dec 2012 15:43:06 +0800
Subject: [PATCH] xen-netback notify frontend to send gratuitous ARP.

In the real network environment, some cause will lead
to Active-Backup mode bonding chose new actived port.
After that, the trffic, destinated to DomU by inactived
port (former actived port), will be unreachable at now.
DomU should send gratutious ARP initialtivly to find the
new corrected path.

By netback's Connected->Connected transition, frontend
will watch the change, and send gratuitous ARP.

Signed-off-by: Jason Luan <jianhai.luan@oracle.com>
---
 drivers/net/xen-netback/xenbus.c |   48 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 410018c..844fd86 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -26,6 +26,7 @@ struct backend_info {
 	struct xenvif *vif;
 	enum xenbus_state frontend_state;
 	struct xenbus_watch hotplug_status_watch;
+	struct notifier_block vif_notifier;
 	u8 have_hotplug_status_watch:1;
 };
 
@@ -34,11 +35,54 @@ static void connect(struct backend_info *);
 static void backend_create_xenvif(struct backend_info *be);
 static void unregister_hotplug_status_watch(struct backend_info *be);
 
+/*
+ * By Connected->Connected transition, netfront will watch the change and
+ * send gratuitous ARP.
+ */
+static void notify_front_arping(struct xenbus_device *dev)
+{
+	int err;
+
+	if (dev->state != XenbusStateConnected)
+		return;
+
+	err = xenbus_printf(XBT_NIL, dev->nodename, "state", "%d", dev->state);
+	if (err)
+		pr_warn("NetBack: Failure to notify DomU (err=%d)\n", err);
+}
+
+#define nb_to_backend(nb) container_of(nb, struct backend_info, vif_notifier)
+/**
+ * When network condition of vif change, notify the frontend.
+ */
+static int netback_netdev_event(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct net_device *event_dev = ptr;
+	struct backend_info *be = nb_to_backend(this);
+
+	pr_debug("event_dev: %s, event: %lx\n",
+		 event_dev ? event_dev->name : "None", event);
+
+	if (!be->vif)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_NOTIFY_PEERS:
+		/* Notify frontend to Send gratuitous ARP */
+		notify_front_arping(be->dev);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int netback_remove(struct xenbus_device *dev)
 {
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
 	unregister_hotplug_status_watch(be);
+	unregister_netdevice_notifier(&be->vif_notifier);
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
@@ -129,6 +173,10 @@ static int netback_probe(struct xenbus_device *dev,
 	/* This kicks hotplug scripts, so do it immediately. */
 	backend_create_xenvif(be);
 
+	/* Register Frontend Event Notify */
+	be->vif_notifier.notifier_call = netback_netdev_event;
+	register_netdevice_notifier(&be->vif_notifier);
+
 	return 0;
 
 abort_transaction:
-- 
1.7.9.5


--------------010208060107020202060606--

