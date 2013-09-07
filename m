Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab3IGHbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 03:31:48 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41571 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3IGHbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 03:31:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130907032240.GA1256@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
	<20130906202022.GA353@x4>
	<CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
	<CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
	<506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com>
	<CA+55aFzLy+-VF022ORuyWk-qQO7gDSQ1LZES1+bEUxz0QxrH-g@mail.gmail.com>
	<20130907032240.GA1256@core.coreip.homeip.net>
Date: Sat, 7 Sep 2013 09:31:45 +0200
Message-ID: <CANq1E4Q85ewwKs7VoooZVapC7-Cvy6-Xp4rGL1-1Ee7w1EcT6w@mail.gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
From: David Herrmann <dh.herrmann@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Sep 7, 2013 at 5:22 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Sep 06, 2013 at 06:00:29PM -0700, Linus Torvalds wrote:
>> On Fri, Sep 6, 2013 at 5:58 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> >
>> > The patch still had problems so I'd revert it and wii bits and try again later.
>>
>> Ok. Mind giving me a list of commits, so that I don't have to do a
>> trial-and-error thing? I know the primary commit that causes problems,
>> but there are commits that seem to depend on it..
>
>
> Sorry for the delay. I believe you need to revert:
>
> 73f8645 HID: wiimote: add support for Guitar-Hero drums
> 61e0065 Input: introduce BTN/ABS bits for drums and guitars
>
> Hmm... there also was "HID: wiimote: add support for Guitar-Hero
> guitars" but I do not see it...

The commits to revert are:

commit 61e00655e9cb82e034eb72b95a51072e718d14a7
Author: David Herrmann <dh.herrmann@gmail.com>
Date:   Mon Aug 26 19:14:46 2013 +0200

    Input: introduce BTN/ABS bits for drums and guitars

commit 73f8645db1913ab2475ec3c1cee8d5f748963aa7
Author: David Herrmann <dh.herrmann@gmail.com>
Date:   Mon Aug 26 19:14:47 2013 +0200

    HID: wiimote: add support for Guitar-Hero drums

commit 8e22ecb603c88b7397ab2e80b7b0811b8a1318f5
Author: Nicolas Adenis-Lamarre <nicolas.adenis.lamarre@gmail.com>
Date:   Mon Aug 26 19:14:48 2013 +0200

    HID: wiimote: add support for Guitar-Hero guitars

Last one is not from me, so I guess that's why Dmitry missed it. And
sorry for the delay, stupid UTC+1..
The bug only occurs for multi-touch devices (their ABS_* bits are
>0x1f), that's why I didn't see it happening during my tests..

If you didn't revert it, yet, attached (and inlined) is a patch which
reverts the ABS_MAX change and just moves the new identifiers in
between the others. On top of 3.12-rc1, this should fix all issues. If
you already reverted the patches, I guess we will just push it in
linux-next again and wait for 3.13?

Thanks
David

(Inlined patch below, also attached to mail as gmail hates long lines)

>From 13d549489b4bd2eade719cf2ec8c37724be6e640 Mon Sep 17 00:00:00 2001
From: David Herrmann <dh.herrmann@gmail.com>
Date: Sat, 7 Sep 2013 09:17:11 +0200
Subject: [PATCH] Revert/Fix "Input: introduce BTN/ABS bits for drums and
 guitars"

commit 61e00655e9cb82e034eb72b95a51072e718d14a7
Author: David Herrmann <dh.herrmann@gmail.com>
Date:   Mon Aug 26 19:14:46 2013 +0200

    Input: introduce BTN/ABS bits for drums and guitars

This introduced several new identifiers for drums/guitar devices. However,
it also increased ABS_MAX. Unfortunately, 0x3f is already the maximum we
can use for ABS_MAX due to the limited EVIOCSABS ioctl.

Revert this commit and move the new identifiers somewhere in between. We
need to figure out some other way to add new identifiers for the future.
To avoid this happening again, I added a small comment.

This also fixes an issue where xf86-input-evdev failed on EVIOCGABS() due
to ABS_MAX not being a full mask.

Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 include/linux/mod_devicetable.h |  2 +-
 include/uapi/linux/input.h      | 33 ++++++++++++++++++---------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 329aa30..45e9214 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -277,7 +277,7 @@ struct pcmcia_device_id {
 #define INPUT_DEVICE_ID_KEY_MIN_INTERESTING 0x71
 #define INPUT_DEVICE_ID_KEY_MAX 0x2ff
 #define INPUT_DEVICE_ID_REL_MAX 0x0f
-#define INPUT_DEVICE_ID_ABS_MAX 0x4f
+#define INPUT_DEVICE_ID_ABS_MAX 0x3f
 #define INPUT_DEVICE_ID_MSC_MAX 0x07
 #define INPUT_DEVICE_ID_LED_MAX 0x0f
 #define INPUT_DEVICE_ID_SND_MAX 0x07
diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index 76457ee..12c33f8 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -819,8 +819,24 @@ struct input_keymap_entry {

 #define ABS_VOLUME 0x20

+/* Drums and guitars (mostly toys) */
+#define ABS_TOM_FAR_LEFT 0x21
+#define ABS_TOM_LEFT 0x22
+#define ABS_TOM_RIGHT 0x23
+#define ABS_TOM_FAR_RIGHT 0x24
+#define ABS_CYMBAL_FAR_LEFT 0x25
+#define ABS_CYMBAL_LEFT 0x26
+#define ABS_CYMBAL_RIGHT 0x27
+
 #define ABS_MISC 0x28

+/* Drums and guitars continued */
+#define ABS_CYMBAL_FAR_RIGHT 0x29
+#define ABS_BASS 0x2a
+#define ABS_HI_HAT 0x2b
+#define ABS_FRET_BOARD 0x2c /* Guitar fret board, vertical pos */
+#define ABS_WHAMMY_BAR 0x2d /* Guitar whammy bar (or vibrato) */
+
 #define ABS_MT_SLOT 0x2f /* MT slot being modified */
 #define ABS_MT_TOUCH_MAJOR 0x30 /* Major axis of touching ellipse */
 #define ABS_MT_TOUCH_MINOR 0x31 /* Minor axis (omit if circular) */
@@ -837,21 +853,8 @@ struct input_keymap_entry {
 #define ABS_MT_TOOL_X 0x3c /* Center X tool position */
 #define ABS_MT_TOOL_Y 0x3d /* Center Y tool position */

-/* Drums and guitars (mostly toys) */
-#define ABS_TOM_FAR_LEFT 0x40
-#define ABS_TOM_LEFT 0x41
-#define ABS_TOM_RIGHT 0x42
-#define ABS_TOM_FAR_RIGHT 0x43
-#define ABS_CYMBAL_FAR_LEFT 0x44
-#define ABS_CYMBAL_LEFT 0x45
-#define ABS_CYMBAL_RIGHT 0x46
-#define ABS_CYMBAL_FAR_RIGHT 0x47
-#define ABS_BASS 0x48
-#define ABS_HI_HAT 0x49
-#define ABS_FRET_BOARD 0x4a /* Guitar fret board, vertical pos */
-#define ABS_WHAMMY_BAR 0x4b /* Guitar whammy bar (or vibrato) */
-
-#define ABS_MAX 0x4f
+/* EVIOCSABS() does not support ABS_MAX > 0x3f */
+#define ABS_MAX 0x3f
 #define ABS_CNT (ABS_MAX+1)

 /*
-- 
1.8.4
