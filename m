Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaIVHnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:43:00 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34208 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaIVHm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:42:58 -0400
Message-ID: <541FD2FE.3090102@gmail.com>
Date: Mon, 22 Sep 2014 10:42:54 +0300
From: Kari Suvanto <kari.tj.suvanto@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
CC: Hugh Dickins <hughd@google.com>, Sabrina Dubroca <sd@queasysnail.net>,
        Valdis.Kletnieks@vt.edu, Bryan Wu <cooloney@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: 3.17-rc1: leds blink workqueue causes sleeping BUGs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Ew. I'll have a look.

sorry, sending again, first one had html in it..

Any update on this one?

I'm seeing this in every boot. I patched this by changing led_trigger_register and led_trigger_register_simple as macros which creates a static lock_class_key like this:
-extern int led_trigger_register(struct led_trigger *trigger);
+
+extern int __led_trigger_register_key(struct led_trigger *trigger,
+                                     struct lock_class_key *key);
+#ifdef CONFIG_LOCKDEP
+#define led_trigger_register(trigger)                                  \
+({                                                                     \
+       static struct lock_class_key __key;                             \
+                                                                       \
+       __led_trigger_register_key(trigger, &__key);                    \
+})
+#else
+#define led_trigger_register(trigger)                                  \
+       __led_trigger_register_key(trigger, NULL)
+#endif
+


But should every trigger has own key? With my patch all the triggers from vt/keyboard.c are using the same key. Is that a problem? I have not seen any problems with that patch and after that I can see this https://lkml.org/lkml/2014/9/5/462.

-Kari 
