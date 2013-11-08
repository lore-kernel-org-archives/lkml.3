Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3KHFPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:15:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56582 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab3KHFPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:15:51 -0500
Message-ID: <527C7384.1040103@ti.com>
Date: Fri, 8 Nov 2013 14:15:48 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Bryan Wu <cooloney@gmail.com>, Milo Kim <woogyom.kim@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] leds: lp5521,5523: restore device attributes for
 running LED patterns
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com> <201310251838.32001@pali> <CAK5ve-JrQhpwx9ZG1Kyhuxdc=dqfAaA6YBOMkDWYWrefeoeUxw@mail.gmail.com> <201310252021.51846@pali>
In-Reply-To: <201310252021.51846@pali>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

Sorry for the late reply.

On 10/26/2013 03:21 AM, Pali Rohár wrote:
> On Friday 25 October 2013 19:10:07 Bryan Wu wrote:
>> On Fri, Oct 25, 2013 at 9:38 AM, Pali Rohár
> <pali.rohar@gmail.com> wrote:
>>> On Tuesday 13 August 2013 23:04:14 Bryan Wu wrote:
>>>> On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim
> <woogyom.kim@gmail.com> wrote:
>>>>> This patch-set resolves the application conflict by
>>>>> restoring sysfs files.
>>>>>
>>>>> For LP5521
>>>>>
>>>>>    engine1/2/3_mode
>>>>>    engine1/2/3_load
>>>>>
>>>>> For LP5523
>>>>>
>>>>>    engine1/2/3_mode
>>>>>    engine1/2/3_load
>>>>>    engine1/2/3_leds
>>>>>
>>>>> Those attributes are accessed when LED pattern is run by
>>>>> custom application. Those were removed when LED pattern
>>>>> interface was changed to generic firmware interface.
>>>>> Please refer to commits below.
>>>>>
>>>>>    git commit 9ce7cb170f97f83a78dc948bf7d25690f15e1328
>>>>>    (leds-lp5521: use generic firmware interface)
>>>>>
>>>>>    git commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0
>>>>>    (leds-lp5523: use generic firmware interface)
>>>>>
>>>>> Necessary attributes are restored in this patch-set.
>>>>>
>>>>> (Other changes)
>>>>> New data structure is added for handling values from/to
>>>>> an application. Few code fixes for reducing writing I2C
>>>>> commands.
>>>>> Add LP55xx common macros for code refactoring.
>>>>> Documentation updates.
>>>>>
>>>>> You can also pull from the location below
>>>>> This branch is based on 'for-next' of linux-leds.
>>>>>
>>>>>    https://github.com/milokim/lp55xx.git
>>>>>    resolve-missing-sysfs
>>>>
>>>> Thanks, I've already merged the whole patchset in my -devel
>>>> branch [1].
>>>>
>>>> Pali, could you please help to test it on your hardware?
>>>> Just grab my -devel branch and build then run.
>>>>
>>>> Thanks,
>>>> -Bryan
>>>
>>> Hi, I see that all your patches are part of 3.12-rc5 kernel.
>>>
>>> Now I tested this example led program:
>>>      # Clearing LED-state to be sure
>>>      echo "disabled" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
>>>      "disabled" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo 0
>>>      > /sys/class/leds/lp5523:r/brightness
>>>      echo 0 > /sys/class/leds/lp5523:g/brightness
>>>      echo 0 > /sys/class/leds/lp5523:b/brightness
>>>
>>>      # Setting yellow light pattern and running it
>>>      echo "load" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
>>>      "000001100" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine1_leds echo
>>>      "9d804000427f0d7f7f007f0042000000" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine1_load echo
>>>      "load" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo
>>>      "000000000" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine2_leds echo
>>>      "9d800000" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine2_load echo
>>>      "run" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo
>>>      "run" >
>>>      /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
>>>      20 > /sys/class/leds/lp5523:r/led_current
>>>      echo 2 > /sys/class/leds/lp5523:g/led_current
>>>      echo 0 > /sys/class/leds/lp5523:b/led_current

In the latest LP5523 driver, I just found wrong operation mode setting 
in case of multiple engine used. (please find a patch below)

>>>
>>> All sysfs entries exists and every echo returned 0.
>>>
>>> But led does not start blinking that yellow ligh pattern.
>>> So it not working on 3.12-rc5 kernel :-(
>>
>> OK, great! Do you still remember which kernel version works on
>> you system? Milo, do you have time to take a look? I bet it's
>> a regression somewhere.
>>
>> Thanks,
>> -Bryan
>
> I do not know which version. Now I tried pattern example from
> Documentation/leds/leds-lp55xx.txt which using new API.
>
> echo 2 > /sys/class/i2c-adapter/i2c-2/2-0032/select_engine
> echo 1 > /sys/class/firmware/lp5523/loading
> echo "9d80400004ff05ff437f0000" > /sys/class/firmware/lp5523/data
> echo 0 > /sys/class/firmware/lp5523/loading
> echo 1 > /sys/class/i2c-adapter/i2c-2/2-0032/run_engine
>
> But it failed at second command. In directory /sys/class/firmware/
> I have only one file with name timeout. Nothing more, no lp5523
> folder.

I can't reproduce this issue but I found some duplicated mutex problem.
But in my case, I could found /sys/class/firmware/lp5523 directory.
Is any permission issue? Anyway, I've added fixed mutex code below.

Could you check this patch below?
If it's resolved, then I'll send official patch-set.

-------------------- 8< ---------------- 8< ---------------------------

 From dad27e0d834a5635232116569aaa1fa471ac46bf Mon Sep 17 00:00:00 2001
From: Milo Kim <milo.kim@ti.com>
Date: Fri, 8 Nov 2013 13:43:33 +0900
Subject: [PATCH] leds: lp5523: Fix multiple engine usage bug and remove
  duplicated mutex

Fix multiple engine usage bug:
   Whenever the engine is loaded by the user-application, the operation 
mode is
   reset first. But it has a problem in case of multiple engine used because
   previous engine settings are cleared.
   The driver should update not whole 8bits but each engine bits by masking.

Remove duplicate mutex:
   It can be a problem when a pattern is loaded via the firmware interface.
   LP55xx common driver has already locked the mutex in
   'lp55xx_firmware_loaded()'.
   So it should be deleted.

Signed-off-by: Milo Kim <milo.kim@ti.com>
---
  drivers/leds/leds-lp5523.c |   14 +++++++++-----
  1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index fe3bcbb..c00f55e 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -188,7 +188,15 @@ static void 
lp5523_load_engine_and_select_page(struct lp55xx_chip *chip)

  static void lp5523_stop_engine(struct lp55xx_chip *chip)
  {
-	lp55xx_write(chip, LP5523_REG_OP_MODE, 0);
+	enum lp55xx_engine_index idx = chip->engine_idx;
+	u8 mask[] = {
+		[LP55XX_ENGINE_1] = LP5523_MODE_ENG1_M,
+		[LP55XX_ENGINE_2] = LP5523_MODE_ENG2_M,
+		[LP55XX_ENGINE_3] = LP5523_MODE_ENG3_M,
+	};
+
+	lp55xx_update_bits(chip, LP5523_REG_OP_MODE, mask[idx], 0);
+
  	lp5523_wait_opmode_done();
  }

@@ -336,8 +344,6 @@ static int lp5523_update_program_memory(struct 
lp55xx_chip *chip,
  	if (i % 2)
  		goto err;

-	mutex_lock(&chip->lock);
-
  	for (i = 0; i < LP5523_PROGRAM_LENGTH; i++) {
  		ret = lp55xx_write(chip, LP5523_REG_PROG_MEM + i, pattern[i]);
  		if (ret) {
@@ -346,8 +352,6 @@ static int lp5523_update_program_memory(struct 
lp55xx_chip *chip,
  		}
  	}

-	mutex_unlock(&chip->lock);
-
  	return size;

  err:
-- 
1.7.9.5
-------------------- 8< ---------------- 8< ---------------------------

Best regards,
Milo
