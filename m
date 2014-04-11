Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaDKU2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:28:35 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:14379 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbaDKU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:28:33 -0400
X-AuditID: cbfec37b-b7f8f6d000007030-fc-5348507007c4
Message-id: <5348506C.6000604@samsung.com>
Date: Fri, 11 Apr 2014 14:28:28 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: tj@kernel.org, rafael.j.wysocki@intel.com, linux@roeck-us.net,
        toshi.kani@hp.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <20140409191740.GA10748@kroah.com> <5345CD32.8010305@samsung.com>
 <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
 <20140410083841.488f9c43@samsung.com>
 <20140410124653.64aeb06d@alan.etchedpixels.co.uk>
 <20140410113949.7de1312b@samsung.com>
In-reply-to: <20140410113949.7de1312b@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.251]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+wr25BgEewwflJghaTpvxls2hevJ7N
	4vKuOWwWPRu2slo8WXiGyeLxirfsFl9/Olj8Wn6U0WLbrYUsDpweO2fdZffYtW0nk8fiPS+Z
	PDat6mTz2D93DbtH68lNrB47vzewe3zeJBfAEcVlk5Kak1mWWqRvl8CVcfDjdeaC0+YVM+6p
	NTAe1+pi5OSQEDCRaPoyiRXCFpO4cG89WxcjF4eQwDJGian/LjNCOL1MEj8PfmOFcLYxSrx4
	+5MdpIVXQEviUddHRhCbRUBVonH3WbA4m4C6xOfXO8BsIQE5iaYlq5lBbFGBCIlXZyeyQPQK
	SvyYfI8FZKiIQA+jxL2uA+wgDrPAaUaJnrX3wDqEBWwk9l+7wgKxejOTxOtZ7WDXcgoYSZzr
	2cAGYjMLWEusnLSNEcKWl9i85i0zxGpliT+XTzF1MXIAfacscftr2ARGkVlIls9C0j0LSfcC
	RuZVjGKlxckFxUnpqRVGesWJucWleel6yfm5mxgh0Ve9g/HuV5tDjAIcjEo8vB80PIKFWBPL
	iitzDzFKcDArifA+MwYK8aYkVlalFuXHF5XmpBYfYmTi4JRqYLS2mSf4/dib6qgXWfsSH5U8
	P6nn/yB+qsbXkyZGJ9QVXrDOdphzJ6tdVN/KUKhcYOOdgOMLGdVnGUlWHp6TKeLm76MTaLZY
	5abgZ3+bm95vnivGnzr6w9Jhzmar5JciVtdP/Iz54fnk4olPW+ft9NihdtlbUcY2muvEUX+R
	rMlu1hkhm/axCSixFGckGmoxFxUnAgDj6/ROnAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an example driver use-case for this token resource: This is not 
polished, but should give an idea on this new token resource is intended 
to be used:

- create token resources in em28xx_usb_probe() right before the required 
modules are loaded. It creates tuner, video and audio tokens to use as a 
large grain lock on tuner, video DMA engine, and audio DMA engine 
respectively.

- lock video token in em28xx_init_usb_xfer()
- unlock in em28xx_uninit_usb_xfer()

- destroy token in em28xx_release_resources()


I did some hotplug testing with this:

dmesg | grep token
[  771.613332] usb 8-1: devm_token_create(): created token: 
tuner:8-1-0000:00:10.1-0
[  771.613335] em2874 #0: devm_token_create() returned 0
[  771.613340] usb 8-1: devm_token_create(): created token: 
video:8-1-0000:00:10.1
[  851.202931] usb 8-1: devm_token_release(): release token
[  851.202936] usb 8-1: devm_token_release(): release token
[ 1775.052273] usb 8-2: devm_token_create(): created token: 
tuner:8-2-0000:00:10.1-0
[ 1775.052276] em2874 #0: devm_token_create() returned 0
[ 1775.052285] usb 8-2: devm_token_create(): created token: 
video:8-2-0000:00:10.1
shuah@anduin:~$ dmesg | grep token
[  771.613332] usb 8-1: devm_token_create(): created token: 
tuner:8-1-0000:00:10.1-0
[  771.613335] em2874 #0: devm_token_create() returned 0
[  771.613340] usb 8-1: devm_token_create(): created token: 
video:8-1-0000:00:10.1
[  851.202931] usb 8-1: devm_token_release(): release token
[  851.202936] usb 8-1: devm_token_release(): release token
[ 1775.052273] usb 8-2: devm_token_create(): created token: 
tuner:8-2-0000:00:10.1-0
[ 1775.052276] em2874 #0: devm_token_create() returned 0
[ 1775.052285] usb 8-2: devm_token_create(): created token: 
video:8-2-0000:00:10.1
[ 1799.610007] usb 8-2: devm_token_release(): release token
[ 1799.610013] usb 8-2: devm_token_release(): release token


diff --git a/drivers/media/usb/em28xx/em28xx-cards.c 
b/drivers/media/usb/em28xx/em28xx-cards.c
index 50aa5a5..3305250 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2428,6 +2428,51 @@ static struct em28xx_hash_table em28xx_i2c_hash[] = {
  };
  /* NOTE: introduce a separate hash table for devices with 16 bit 
eeproms */

+/* interfaces to create and destroy token resources */
+static int em28xx_create_token_resources(struct em28xx *dev)
+{
+       int rc = 0;
+
+       /* create token devres for tuner */
+       snprintf(dev->tuner_tkn_id, sizeof(dev->tuner_tkn_id),
+               "tuner:%s-%s-%d",
+               dev_name(&dev->udev->dev),
+               dev->udev->bus->bus_name,
+               dev->tuner_addr);
+
+       rc = devm_token_create(&dev->udev->dev, dev->tuner_tkn_id);
+       em28xx_info("devm_token_create() returned %d\n", rc);
+
+       if (dev->has_video || dev->board.has_dvb) {
+               snprintf(dev->video_tkn_id, sizeof(dev->video_tkn_id),
+                       "video:%s-%s",
+                       dev_name(&dev->udev->dev),
+                       dev->udev->bus->bus_name);
+               rc = devm_token_create(&dev->udev->dev, dev->video_tkn_id);
+       }
+       if (dev->audio_mode.has_audio) {
+               snprintf(dev->audio_tkn_id, sizeof(dev->audio_tkn_id),
+                       "audio:%s-%s",
+                       dev_name(&dev->udev->dev),
+                       dev->udev->bus->bus_name);
+               rc = devm_token_create(&dev->udev->dev, dev->audio_tkn_id);
+       }
+       return rc;
+}
+
+static int em28xx_destroy_token_resources(struct em28xx *dev)
+{
+       int rc = 0;
+
+       devm_token_destroy(&dev->udev->dev, dev->tuner_tkn_id);
+       if (dev->has_video || dev->board.has_dvb)
+               rc = devm_token_destroy(&dev->udev->dev, dev->video_tkn_id);
+       if (dev->audio_mode.has_audio)
+               rc = devm_token_destroy(&dev->udev->dev, dev->audio_tkn_id);
+
+       return rc;
+}

  int em28xx_tuner_callback(void *ptr, int component, int command, int arg)
  {
         struct em28xx_i2c_bus *i2c_bus = ptr;
@@ -2949,6 +2994,10 @@ static void em28xx_release_resources(struct 
em28xx *dev)
                 em28xx_i2c_unregister(dev, 1);
         em28xx_i2c_unregister(dev, 0);

+       /* destroy token resources */
+       if (em28xx_destroy_token_resources(dev))
+               em28xx_info("Error destroying token resources\n");
+
         usb_put_dev(dev->udev);

         /* Mark device as unused */
@@ -3431,6 +3480,10 @@ static int em28xx_usb_probe(struct usb_interface 
*interface,

         kref_init(&dev->ref);

+       /* create token resources before requesting for modules */
+       if (em28xx_create_token_resources(dev))
+               em28xx_info("Error creating token resources\n");
+
         request_modules(dev);

         /* Should be the last thing to do, to avoid newer udev's to
diff --git a/drivers/media/usb/em28xx/em28xx-core.c 
b/drivers/media/usb/em28xx/em28xx-core.c
index 523d7e9..8129a9c 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -824,6 +824,9 @@ void em28xx_uninit_usb_xfer(struct em28xx *dev, enum 
em28xx_mode mode)
         usb_bufs->num_bufs = 0;

         em28xx_capture_start(dev, 0);
+
+       /* unlock token */
+       devm_token_unlock(&dev->udev->dev, dev->video_tkn_id);
  }
  EXPORT_SYMBOL_GPL(em28xx_uninit_usb_xfer);

@@ -993,6 +996,11 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum 
em28xx_mode mode,
         em28xx_isocdbg("em28xx: called em28xx_init_usb_xfer in mode %d\n",
                        mode);

+       /* lock token */
+       rc = devm_token_lock(&dev->udev->dev, dev->video_tkn_id);
+       if (rc)
+               return rc;
+
         dev->usb_ctl.urb_data_copy = urb_data_copy;

         if (mode == EM28XX_DIGITAL_MODE) {
diff --git a/drivers/media/usb/em28xx/em28xx.h 
b/drivers/media/usb/em28xx/em28xx.h
index 2051fc9..b13ec6e 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -34,6 +34,7 @@
  #include <linux/mutex.h>
  #include <linux/kref.h>
  #include <linux/videodev2.h>
+#include <linux/token_devres.h>

  #include <media/videobuf2-vmalloc.h>
  #include <media/v4l2-device.h>
@@ -547,6 +548,11 @@ struct em28xx {
         int devno;              /* marks the number of this device */
         enum em28xx_chip_id chip_id;

+       /* token resources */
+       char tuner_tkn_id[64]; /* tuner token id */
+       char video_tkn_id[64]; /* video dma engine token */
+       char audio_tkn_id[64]; /* audio dma engine token id */
+
         unsigned int is_em25xx:1;       /* em25xx/em276x/7x/8x family 
bridge */
         unsigned char disconnected:1;   /* device has been diconnected */
         unsigned int has_video:1;

thanks
-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
