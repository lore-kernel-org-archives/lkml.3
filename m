Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaKYLVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:21:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbaKYLVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:21:03 -0500
Message-ID: <5474660B.8070507@redhat.com>
Date: Tue, 25 Nov 2014 12:20:43 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: David Herrmann <dh.herrmann@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Luc Verhaegen <libv@skynet.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
References: <20141117190905.4e96294a@canb.auug.org.au>	<546B5D5A.8020304@ti.com> <CANq1E4SMLHmezfXSENSQ8xUaXptwA8YKQ9Nne=sDCB0gPkPLmA@mail.gmail.com> <5474615F.20407@ti.com>
In-Reply-To: <5474615F.20407@ti.com>
Content-Type: multipart/mixed;
 boundary="------------080806060009090402070508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080806060009090402070508
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Tomi,

On 11/25/2014 12:00 PM, Tomi Valkeinen wrote:
> On 18/11/14 17:07, David Herrmann wrote:
>> Hi
>>
>> On Tue, Nov 18, 2014 at 3:53 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>>> Hi,
>>>
>>> Thanks Stephen!
>>>
>>> Hans, have you had a look at this? kbuild test bot also reported this.
>>
>> The fix from Stephen should not go to main-line. It breaks simplefb on
>> x86 without OF. Imo, linux/clk.h should provide a fallback if OF is
>> not defined (like it already does for of_clk_get() and friends).
>>
>> Hans, any comments?
>
> Hans, ping.

Sorry I somehow missed this thread so far, I did see the kbuild mail, but
it looked like a false positive to me, for the compile error case I already fixed
in the last revision of the patch, adding #ifdef CONFIG_OF around the offending code.

But on closer inspection I see that the entirety of linux/clk-provider.h is wrapped
in one huge #ifdef CONFIG_COMMON_CLK and then later on also has:

#ifdef CONFIG_OF
...
int of_clk_get_parent_count(struct device_node *np);
...
#endif

So we need both CONFIG_OF and CONFIG_COMMON_CLK, the attached patch
should fix this.

Regards,

Hans

--------------080806060009090402070508
Content-Type: text/x-patch;
 name="0001-simplefb-Fix-build-errors-when-CONFIG_COMMON_CLK-is-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-simplefb-Fix-build-errors-when-CONFIG_COMMON_CLK-is-.pa";
 filename*1="tch"

>From 8ba38cd5ab635b67a50f8051ce2bdbcfa79253a2 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Tue, 25 Nov 2014 12:13:30 +0100
Subject: [PATCH v2] simplefb: Fix build errors when CONFIG_COMMON_CLK is not
 defined

Both CONFIG_OF and CONFIG_COMMON_CLK must be defined to be able to use of
clocks.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/video/fbdev/simplefb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/simplefb.c b/drivers/video/fbdev/simplefb.c
index 8be9754..b2ae925 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -169,13 +169,13 @@ static int simplefb_parse_pd(struct platform_device *pdev,
 
 struct simplefb_par {
 	u32 palette[PSEUDO_PALETTE_SIZE];
-#ifdef CONFIG_OF
+#if defined CONFIG_OF && defined CONFIG_COMMON_CLK
 	int clk_count;
 	struct clk **clks;
 #endif
 };
 
-#ifdef CONFIG_OF
+#if defined CONFIG_OF && defined CONFIG_COMMON_CLK
 /*
  * Clock handling code.
  *
-- 
2.1.0


--------------080806060009090402070508--
