Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab3DIXRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:17:07 -0400
Received: from ispconfig2.arios.fr ([176.31.95.19]:54097 "EHLO
	ispconfig2.arios.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3DIXRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:17:05 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2013 19:17:05 EDT
Message-ID: <51649EFE.7050304@chauveau-central.net>
Date: Wed, 10 Apr 2013 01:06:38 +0200
From: Stephane Chauveau <stephane@chauveau-central.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: patch to make drivers/media/rc/ir-rc5-decoder more responsive
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently installed a linux based media-center (using XBMC) and I was 
quite disappointed but the IR remote. It feels slugish and not very 
reliable (unexpected key repeats, ...).

I studied the whole infrastructure (kernel, xorg, xbmc, ...) and found 
issues a bit everywhere but the main culprit seems to be the rc decoder 
modules.

I focussed on the RC-5 protocol because it is quite simple. Most of the 
information below should also be applicable to other decoders. The RC-6 
decoder clearly suffers from the same problems.

Here is a patch for the ir-rc5-decoder module with the following 
characteristics:
   - The keydown event occurs after decoding the first half of the last 
bi-phase bit.
   - An explicit keyup event is sent (if possible) by the rc5 decoder 
instead of waiting for the 250ms timeout in rc-main.

Compared to the original decoder, the first keydown event occurs 100ms 
to 200ms earlier and the final keyup event occurs 200ms to 250ms earlier.

The patch is for linux 3.5.0 (sorry that is my current kernel on ubuntu).

A more complete analysis of the problems is after the patch

======================================

--- drivers/media/rc/ir-rc5-decoder.c.old    2013-04-10 
00:34:08.000000000 +0200
+++ drivers/media/rc/ir-rc5-decoder.c    2013-04-10 00:33:00.000000000 +0200
@@ -30,11 +30,16 @@
  #define RC5_BIT_START        (1 * RC5_UNIT)
  #define RC5_BIT_END        (1 * RC5_UNIT)
  #define RC5X_SPACE        (4 * RC5_UNIT)
+#define RC5_UP_DELAY        114000000 /* ns */
+
+#define VERB 0

  enum rc5_state {
      STATE_INACTIVE,
      STATE_BIT_START,
      STATE_BIT_END,
+    STATE_LAST_START,
+    STATE_LAST_END,
      STATE_CHECK_RC5X,
      STATE_FINISHED,
  };
@@ -52,8 +57,8 @@ static int ir_rc5_decode(struct rc_dev *
      u8 toggle;
      u32 scancode;

-        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5))
-                return 0;
+    if (!(dev->raw->enabled_protocols & RC_TYPE_RC5))
+        return 0;

      if (!is_timing_event(ev)) {
          if (ev.reset)
@@ -99,8 +104,8 @@ again:
          if (!is_transition(&ev, &dev->raw->prev_ev))
              break;

-        if (data->count == data->wanted_bits)
-            data->state = STATE_FINISHED;
+        if (data->count == data->wanted_bits-1)
+            data->state = STATE_LAST_START;
          else if (data->count == CHECK_RC5X_NBITS)
              data->state = STATE_CHECK_RC5X;
          else
@@ -109,22 +114,16 @@ again:
          decrease_duration(&ev, RC5_BIT_END);
          goto again;

-    case STATE_CHECK_RC5X:
-        if (!ev.pulse && geq_margin(ev.duration, RC5X_SPACE, RC5_UNIT / 
2)) {
-            /* RC5X */
-            data->wanted_bits = RC5X_NBITS;
-            decrease_duration(&ev, RC5X_SPACE);
-        } else {
-            /* RC5 */
-            data->wanted_bits = RC5_NBITS;
-        }
-        data->state = STATE_BIT_START;
-        goto again;
-
-    case STATE_FINISHED:
-        if (ev.pulse)
+    case STATE_LAST_START:
+        if (!eq_margin(ev.duration, RC5_BIT_START, RC5_UNIT / 2))
              break;

+        data->bits <<= 1;
+        if (!ev.pulse)
+            data->bits |= 1;
+        data->count++;
+        data->state = STATE_LAST_END;
+
          if (data->wanted_bits == RC5X_NBITS) {
              /* RC5X */
              u8 xdata, command, system;
@@ -152,6 +151,42 @@ again:
          }

          rc_keydown(dev, scancode, toggle);
+
+        return 0;
+
+    case STATE_LAST_END:
+        if (!is_transition(&ev, &dev->raw->prev_ev))
+            break;
+
+        data->state = STATE_FINISHED;
+
+        decrease_duration(&ev, RC5_BIT_END);
+        goto again;
+
+    case STATE_CHECK_RC5X:
+        if (!ev.pulse
+            && geq_margin(ev.duration, RC5X_SPACE, RC5_UNIT/2)) {
+            /* RC5X */
+            data->wanted_bits = RC5X_NBITS;
+            decrease_duration(&ev, RC5X_SPACE);
+        } else {
+            /* RC5 */
+            data->wanted_bits = RC5_NBITS;
+        }
+        data->state = STATE_BIT_START;
+        goto again;
+
+    case STATE_FINISHED:
+        if (ev.pulse)
+            break;
+
+        /* The message is repeated  RC5_UP_DELAY ns after the 1st pulse
+         * so a blank of RC5_UP_DELAY ns after the last pulse shall be
+         * enough to assume that the message is not repeated.
+         */
+        if (ev.duration > RC5_UP_DELAY)
+            rc_keyup(dev) ;
+
          data->state = STATE_INACTIVE;
          return 0;
      }

Signed-off-by: Stephane Chauveau <stephane@chauveau-central.net>

========================================


I added a few printk in the module to obtain some detailed timings.

  - DECODE is emited once at the begining of each call of 
ir_rc5_decode() to describe the associated event
  - FINISHED is emited during the last STATE_BIT_END when setting the 
state to STATE_FINISHED
  - KEYDOWN is emited just before calling rc_keydown()
  - KEYUP is emited by ir_do_keyup() in rc-main.c

Here are the timings for a single even RC-5 message (last bit is 0 so a 
blank followed by a pulse) using the original module:

  [507703.409737] DECODE +20  (1788us)
  [507703.412097] DECODE -19  (1762us)
  [507703.413282] DECODE +20  (1788us)
  [507703.415622] DECODE -19  (1762us)
  [507703.416822] DECODE +19  (1762us)
  [507703.419159] DECODE -20  (1788us)
  [507703.420357] DECODE +20  (1779us)
  [507703.421523] DECODE -9   (885us)
  [507703.422691] DECODE +10  (894us)
  [507703.423869] DECODE -19  (1771us)
  [507703.426239] DECODE +20  (1788us)
  [507703.427406] DECODE -19  (1762us)
  [507703.428639] DECODE +10  (894us)
  [507703.429772] DECODE -9   (877us)
  [507703.429779] DECODE +10  (894us)
  [507703.430946] DECODE -9   (885us)
  [507703.432131] DECODE +10  (894us)
  [507703.432138] FINISHED
  [507703.631331] DECODE -2255  (200317us)
  [507703.631338] KEYDOWN
  [507703.880020] KEYUP


The last DECODE of 200ms seems to be caused the timeout in the IR driver 
(see ITE_IDLE_TIMEOUT in ite_cir.h).

The final STATE_BIT_END is processed before that long event is received 
but, because of the test after the 'goto again', the final 
STATE_FINISHED is delayed until the 200ms blank is received.

The timings are similar for an odd RC-5 code (last bit is 1 so a pulse 
followed by a blank)

  [508157.054735] DECODE +19  (1762us)
  [508157.055906] DECODE -10  (929us)
  [508157.057098] DECODE +9   (868us)
  [508157.057107] DECODE -10  (911us)
  [508157.058259] DECODE +9   (842us)
  [508157.060730] DECODE -20  (1823us)
  [508157.061800] DECODE +19  (1762us)
  [508157.064167] DECODE -20  (1788us)
  [508157.065341] DECODE +19  (1727us)
  [508157.066507] DECODE -10  (937us)
  [508157.067686] DECODE +9   (868us)
  [508157.068932] DECODE -19  (1771us)
  [508157.071227] DECODE +20  (1779us)
  [508157.072423] DECODE -20  (1797us)
  [508157.073588] DECODE +9   (842us)
  [508157.074759] DECODE -10  (929us)
  [508157.075937] DECODE +19  (1736us)
  [508157.275149] DECODE -2252  (200039us)
  [508157.275156] FINISHED
  [508157.275159] KEYDOWN
  [508157.524021] KEYUP

Here, the final STATE_BIT_END is a blank so it is processed as part of 
the final timeout.

In any cases, the KEYDOWN in STATE_FINISHED occurs after the 200ms 
timeout so about 220ms after the first pulse.

Finally, the KEYUP occurs 250ms after the KEYDOWN because of the timeout 
in rc-main.c (see IR_KEYPRESS_TIMEOUT)

The situation is slightly different when the button remains pressed 
because the remote repeats the message after 113ms as required by the 
RC-5 protocol:

  [507866.803970] DECODE +20  (1831us)
  [507866.805169] DECODE -9   (825us)
  [507866.806330] DECODE +10  (894us)
  [507866.806339] DECODE -10  (911us)
  [507866.807511] DECODE +10  (955us)
  [507866.809874] DECODE -19  (1736us)
  [507866.811043] DECODE +19  (1701us)
  [507866.813413] DECODE -21  (1875us)
  [507866.814893] DECODE +18  (1675us)
  [507866.815758] DECODE -10  (937us)
  [507866.817038] DECODE +9   (868us)
  [507866.818110] DECODE -20  (1823us)
  [507866.820479] DECODE +20  (1788us)
  [507866.821646] DECODE -19  (1762us)
  [507866.822818] DECODE +9   (816us)
  [507866.823989] DECODE -10  (937us)
  [507866.823994] DECODE +9   (842us)
  [507866.825244] DECODE -10  (963us)
  [507866.826358] DECODE +9   (868us)
  [507866.826364] FINISHED
  [507866.915932] DECODE -1009  (89664us)
  [507866.915938] KEYDOWN
  [507866.917121] DECODE +19  (1753us)
  [507866.918286] DECODE -10  (963us)
  [507866.919463] DECODE +9   (842us)
  [507866.920685] DECODE -10  (911us)
  [507866.920696] DECODE +10  (894us)
  [507866.922999] DECODE -20  (1797us)
  [507866.924181] DECODE +19  (1727us)
  [507866.926530] DECODE -20  (1797us)
  [507866.927705] DECODE +20  (1840us)
  [507866.928912] DECODE -9   (825us)
  [507866.930067] DECODE +9   (842us)
  [507866.931238] DECODE -20  (1823us)
  [507866.933611] DECODE +20  (1788us)
  [507866.934778] DECODE -19  (1762us)
  [507866.935954] DECODE +9   (868us)
  [507866.937150] DECODE -10  (937us)
  [507866.938305] DECODE +9   (816us)
  [507866.938310] DECODE -10  (963us)
  [507866.939484] DECODE +10  (894us)
  [507866.939488] FINISHED
  [507867.139873] DECODE -2264  (201081us)
  [507867.139880] KEYDOWN
  [507867.388021] KEYUP

The long 200ms blank is replaced by a 90ms blank so the first DECODE 
occurs earlier and repeats itself every 113ms as long as the remote 
keeps sending messages.

The last message is processed as a single message and takes about 470ms:
    - about 20ms for decoding the message itself.
    - 200ms for the ITE_IDLE_TIMEOUT timeout until KEYDOWN.
    - 250ms for the IR_KEYPRESS_TIMEOUT timeout until KEYUP.

To summarize, the first KEYDOWN occurs 113ms or 220ms after the first 
pulse and the final KEYUP occurs 450ms after the last pulse. This is 
qite bad!

The delay between the first KEYDOWN and final KEYUP is about 470ms for a 
double message and 580ms for a triple message.

I found that triple messages are quite common and they are likely to 
cause at least one key repeat on most systems: the key repeat delay is 
hard-coded to 500ms in XBMC which makes the remove almost unusable. This 
is also the current key-repeat value on my XFCE desktop.

My patch improves those timings using 2 techniques.

First, the KEYDOWN is sent immediately after receiving the first half of 
the last bit.

Second, ITE_IDLE_TIMEOUT=200ms is longer than the required delay for 
repeated messages in RC5 (113ms) so it is possible to explicitly send 
the KEYUP event as soon as a long blank is received. This is controlled 
by the macro RC5_UP_DELAY. An even better approach could be to 
accumulate the duration of all pulses and space until 113ms is reached 
but in practice waiting for a long blank seems to be good enough.

With my patch, the timings for a single event look like that

  [503403.889246] DECODE +19  (1753us)
  [503403.890415] DECODE -11  (990us)
  [503403.890421] DECODE +8   (790us)
  [503403.891603] DECODE -10  (955us)
  [503403.893012] DECODE +9   (816us)
  [503403.895133] DECODE -20  (1849us)
  [503403.896326] DECODE +19  (1701us)
  [503403.898669] DECODE -20  (1849us)
  [503403.899885] DECODE +19  (1701us)
  [503403.901041] DECODE -10  (963us)
  [503403.902201] DECODE +9   (807us)
  [503403.903375] DECODE -21  (1884us)
  [503403.905749] DECODE +18  (1675us)
  [503403.906912] DECODE -20  (1849us)
  [503403.908099] DECODE +9   (816us)
  [503403.909281] DECODE -10  (963us)
  [503403.909289] DECODE +9   (816us)
  [503403.910440] DECODE -10  (963us)
  [503403.910444] KEYDOWN
  [503403.911660] DECODE +10  (894us)
  [503403.911670] FINISHED
  [503404.110830] DECODE -2255  (200256us)
  [503404.110842] KEYUP

The KEYDOWN and the KEYUP respectively occur 20ms and 220ms after the 
first pulse (versus 220ms and 470ms with the original module)

For a double message the timings are

  [503489.269908] DECODE +20  (1788us)
  [503489.271076] DECODE -9   (877us)
  [503489.271081] DECODE +9   (868us)
  [503489.272268] DECODE -10  (911us)
  [503489.273443] DECODE +10  (894us)
  [503489.275785] DECODE -20  (1797us)
  [503489.276990] DECODE +19  (1727us)
  [503489.279317] DECODE -19  (1771us)
  [503489.280640] DECODE +19  (1753us)
  [503489.281686] DECODE -10  (937us)
  [503489.282855] DECODE +9   (842us)
  [503489.284050] DECODE -20  (1849us)
  [503489.286406] DECODE +19  (1701us)
  [503489.287569] DECODE -21  (1875us)
  [503489.288766] DECODE +9   (816us)
  [503489.289929] DECODE -9   (877us)
  [503489.289935] DECODE +10  (894us)
  [503489.291108] DECODE -10  (911us)
  [503489.291112] KEYDOWN
  [503489.292308] DECODE +9   (868us)
  [503489.292316] FINISHED
  [503489.381904] DECODE -1009  (89682us)
  [503489.383064] DECODE +20  (1779us)
  [503489.384235] DECODE -10  (911us)
  [503489.385408] DECODE +9   (868us)
  [503489.386574] DECODE -10  (911us)
  [503489.386579] DECODE +9   (868us)
  [503489.388960] DECODE -20  (1823us)
  [503489.390121] DECODE +19  (1701us)
  [503489.392594] DECODE -21  (1901us)
  [503489.393658] DECODE +18  (1675us)
  [503489.394830] DECODE -10  (929us)
  [503489.396039] DECODE +9   (816us)
  [503489.397205] DECODE -20  (1823us)
  [503489.399547] DECODE +19  (1727us)
  [503489.400747] DECODE -20  (1849us)
  [503489.401909] DECODE +9   (816us)
  [503489.403074] DECODE -10  (963us)
  [503489.404268] DECODE +9   (816us)
  [503489.404278] DECODE -11  (990us)
  [503489.404284] KEYDOWN
  [503489.405456] DECODE +8   (781us)
  [503489.405465] FINISHED
  [503489.604647] DECODE -2252  (200031us)
  [503489.604659] KEYUP


The 2 KEYDOWNs and the KEYUP event respectively occur 21ms, 134ms and 
334ms after the first pulse (versus 111ms, 335ms and 584ms)

The KEYUP occurs 200ms after the last pulse (versus 450ms).

For a double message, the delay between the first KEYDOWN and the final 
KEYUP is around 310ms (vs 470ms).
For a triple message, the delay is 420ms (vs 580) which is still below 
the key-repeat delay of 500ms used by XBMC and most desktops.

So my patch makes the remote a lot more responsive and greatly reduces 
the probably to have a key repeat by mistake.

The timeout in the IR driver could be reduced from 200ms to any value 
above 93ms in order to make the IR remote even more responsive.




