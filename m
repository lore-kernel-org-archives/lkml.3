Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3HBH70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:59:26 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:39889 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3HBH7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <51FB5826.80305@intel.com>
References: <1375400042-989-1-git-send-email-felipe.contreras@gmail.com>
	<51FB137D.7070000@gmail.com>
	<CAMP44s1A+z4=DGJLK1qf5LPc1vbYvtJwjFiMt17vzyZFRU0qmg@mail.gmail.com>
	<51FB35CD.7040709@intel.com>
	<CAMP44s1honSdnoMnmpEcsXtdkJuPYgQgnLwcN+oxs5f=a+3Stg@mail.gmail.com>
	<51FB3C9C.6070002@intel.com>
	<CAMP44s1RkwTfxdoiARHgREy-fwLuRu2tKbM-4kB3+Xf3Sme5Uw@mail.gmail.com>
	<51FB5826.80305@intel.com>
Date: Fri, 2 Aug 2013 02:59:22 -0500
Message-ID: <CAMP44s3+L8ZY9tcUbNhia8sRx+KJ1w44Jn7n=RMdPfeQqvPaqw@mail.gmail.com>
Subject: Re: [PATCH] acpi: video: fix reversed indexed BQC
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 1:56 AM, Aaron Lu <aaron.lu@intel.com> wrote:
> On 08/02/2013 02:44 PM, Felipe Contreras wrote:

>> The initial _BCM commands don't work, so the level remains at 100%.
>> Since the level is max_level, acpi_video_bqc_quirk() tries with the
>> first level, which is 0, and 0 happens to be the index of 100.
>>
>> So _BQC is returning 100, which is not the index of 0 (what we tested
>> for), but actually 100.
>>
>> I think the current code is correct, but acpi_video_bqc_quirk() should
>> be testing br->levels[3], or anything other than 0/100 which can be
>> easily confused.
>>
>> If so, the code would find that _BQC doesn't work on this machine (in
>> win8 mode)... at least initially. My guess is that it only starts to
>> work after acpi_video_bus_start_devices() is called.
>>
>> Forcing br->flags._BQC_use_index = 0 seems to work.
>
> Seems ASUS machines tend to have this issue:
> https://bugzilla.kernel.org/show_bug.cgi?id=52951
> https://bugzilla.kernel.org/show_bug.cgi?id=56711

I don't see any real solution for the ACPI driver.

> I have a patch to enhance the quirk some time ago:
> https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9

I think this is unnecessarily complicated; the comment makes it clear
that the purpose is to find out if _BQC is working, and this does the
trick:

>From 2bfa401b0a50fcde292ac0eb60cb6f857caf2fc6 Mon Sep 17 00:00:00 2001
From: Felipe Contreras <felipe.contreras@gmail.com>
Date: Fri, 2 Aug 2013 02:27:44 -0500
Subject: [PATCH] acpi: video: improve quirk check

If the _BCL package is descending, the first level (br->levels[2]) will
be 0, and if the number of levels matches the number of steps, we might
confuse a returned level to mean the index.

For example:

  current_level = max_level = 100
  test_level = 0
  returned level = 100

In this case 100 means the level, not the index, and _BCM failed. But if
the _BCL package is descending, the index of level 0 is also 100, so we
assume _BQC is indexed, when it's not.

The solution is simple; test anything other than the first level (e.g.
1).

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 0ec434d..e1284b8 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -689,7 +689,7 @@ static int acpi_video_bqc_quirk(struct
acpi_video_device *device,
 	 * Some systems always report current brightness level as maximum
 	 * through _BQC, we need to test another value for them.
 	 */
-	test_level = current_level == max_level ? br->levels[2] : max_level;
+	test_level = current_level == max_level ? br->levels[3] : max_level;

 	result = acpi_video_device_lcd_set_level(device, test_level);
 	if (result)
-- 
1.8.3.4

-- 
Felipe Contreras
