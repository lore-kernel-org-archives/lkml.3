Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3AVSPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:15:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3AVSPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:15:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
Date: Tue, 22 Jan 2013 18:13:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Soeren Moch <smoch@web.de>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <201301211855.25455.arnd@arndb.de> <20130121210150.GA9184@kroah.com>
In-Reply-To: <20130121210150.GA9184@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221813.57741.arnd@arndb.de>
X-Provags-ID: V02:K0:LZBaiUurf/9ndAqAk9+J2+DeW5NLjUr4pycdEKBHqwC
 5GCMLLc9KYpo5953RiGWc2U04BU45PYoVrfDp1XPDlDhYt7gPy
 hyv4BRCoTGqRdsy9giBX1+jT76ZfyqbKR5np53iaPXwPlzt8eG
 TOKniVpTtruzLK8DUhBDJomqjmaWEzM+zbQnJCqTMmi2fNFEm5
 AIdFFwjD2udIL3gpa1XbUwBTayP9fWq/PoqSojz0x5i4c5emgV
 cwC8Ok4PUphYIZPP4uXIkEdOmatzweZ7b51jzfZWq3otGnJTx8
 KXdjNeXnM5AlkukXxRqG8ZJAFs6yHsm8tYKX+6OmLvGeb2KzSd
 ShEi4xE6Nngt6wqxnkfs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Greg KH wrote:
> > 
> > I don't know a lot about USB, but I always assumed that this was not
> > a normal condition and that there are only a couple of URBs per endpoint
> > used at a time. Maybe Greg or someone else with a USB background can
> > shed some light on this.
> 
> There's no restriction on how many URBs a driver can have outstanding at
> once, and if you have a system with a lot of USB devices running at the
> same time, there could be lots of URBs in flight depending on the number
> of host controllers and devices and drivers being used.

Ok, thanks for clarifying that. I read some more of the em28xx driver,
and while it does have a bunch of URBs in flight, there are only five
audio and five video URBs that I see simultaneously being submitted,
and then resubmitted from their completion handlers. I think this
means that there should be 10 URBs active at any given time in this
driver, which does not explain why we get 256 allocations.

I also noticed that the initial submissions are all atomic but don't
need to, so it may be worth trying the patch below, which should also
help in low-memory situations. We could also try moving the resubmission
into a workqueue in order to let those be GFP_KERNEL, but I don't think
that will help.

	Arnd

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 2fdb66e..8b789f4 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -177,12 +177,12 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 		struct urb *urb;
 		int j, k;
 
-		dev->adev.transfer_buffer[i] = kmalloc(sb_size, GFP_ATOMIC);
+		dev->adev.transfer_buffer[i] = kmalloc(sb_size, GFP_KERNEL);
 		if (!dev->adev.transfer_buffer[i])
 			return -ENOMEM;
 
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
-		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
+		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_KERNEL);
 		if (!urb) {
 			em28xx_errdev("usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
@@ -212,7 +212,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 	}
 
 	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
-		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
+		errCode = usb_submit_urb(dev->adev.urb[i], GFP_KERNEL);
 		if (errCode) {
 			em28xx_errdev("submit of audio urb failed\n");
 			em28xx_deinit_isoc_audio(dev);
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index bed07a6..c5a2c4b 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1166,7 +1166,7 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 
 	/* submit urbs and enables IRQ */
 	for (i = 0; i < isoc_bufs->num_bufs; i++) {
-		rc = usb_submit_urb(isoc_bufs->urb[i], GFP_ATOMIC);
+		rc = usb_submit_urb(isoc_bufs->urb[i], GFP_KERNEL);
 		if (rc) {
 			em28xx_err("submit of urb %i failed (error=%i)\n", i,
 				   rc);
