Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaEZRHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:07:53 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57891 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaEZRHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:07:52 -0400
Message-ID: <538374E4.7010401@lwfinger.net>
Date: Mon, 26 May 2014 12:07:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [staging: r8192ee] WARNING: CPU: 0 PID: 1 at net/mac80211/rate.c:43
 ieee80211_rate_control_register()
References: <538355D5.7010006@intel.com>
In-Reply-To: <538355D5.7010006@intel.com>
Content-Type: multipart/mixed;
 boundary="------------020406010704000200040302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020406010704000200040302
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/26/2014 09:55 AM, Jet Chen wrote:

Jet,

> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git staging-next
> commit 0629f3b8c33899140b48d5897259eab8ebae78ca
> Author:     Larry Finger <Larry.Finger@lwfinger.net>
> AuthorDate: Wed May 21 16:25:36 2014 -0500
> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CommitDate: Fri May 23 11:33:56 2014 +0900
>
>      staging: r8192ee: Turn on build of the new driver
>          In addition, this commit contains a TODO file for this driver
>          Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The splat comes from the driver trying to register a rate-control algorithm that 
is already registered. That could happen because a driver is calling the 
registration routine twice, or because more than one driver is using the same 
routine name. As I think there is code to prevent the former, and I have never 
seen that splat here, I suspect that more than one driver has used the name. On 
my real hardware, I can only have one of these devices in the machine at a time.

Is if possible to test the attached patch to see if it fixes the problem? If 
not, could you get a listing of the loaded modules at the time of the splat? If 
this is not the fix, I will try to duplicate it here.

Thanks,

Larry


--------------020406010704000200040302
Content-Type: text/x-patch;
 name="0001-staging-r8192ee-Fix-kernel-WARN-splat-associated-wit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-staging-r8192ee-Fix-kernel-WARN-splat-associated-wit.pa";
 filename*1="tch"

>From ea453949765b07692e384a1d4fd36b83311e8c80 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 26 May 2014 11:45:52 -0500
Subject: [PATCH] staging: r8192ee: Fix kernel WARN splat associated with rate
 control
To: gregkh@linuxfoundation.org
Cc: netdev@vger.kernel.org,
    devel@driverdev.osuosl.org

The 0day kernel testing robot got the kernel warning caused by trying
to register a particular rate-control algorithm more than once. I believe
that the core already protects against a particular driver doing the
registration more than once, but an analysis of the code reveals that
the identical name is used for the rtlwifi drivers in the regular
wireless tree, and the staging drivers r8192ee and r8821ae. The fix
is to rename the algorithm used in r8192ee.

Reported-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8192ee/rc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192ee/rc.c b/drivers/staging/rtl8192ee/rc.c
index f0ce6a9..c4c34dd 100644
--- a/drivers/staging/rtl8192ee/rc.c
+++ b/drivers/staging/rtl8192ee/rc.c
@@ -267,7 +267,7 @@ static void rtl_rate_free_sta(void *rtlpriv,
 }
 
 static struct rate_control_ops rtl_rate_ops = {
-	.name = "rtl_rc",
+	.name = "rtl_rc_92e",
 	.alloc = rtl_rate_alloc,
 	.free = rtl_rate_free,
 	.alloc_sta = rtl_rate_alloc_sta,
-- 
1.8.4.5


--------------020406010704000200040302--
