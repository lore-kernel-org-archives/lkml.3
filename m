Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3B0Jqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:46:44 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53584 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3B0Jql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:46:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,746,1355126400"; 
   d="scan'208";a="26381489"
X-IronPort-AV: E=Sophos;i="4.84,746,1355126400"; 
   d="scan'208";a="494782793"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Chen Gang <gang.chen@asianux.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        "netdev@vger.kernel.org >> netdev" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wireless/ath/wil6210: Makefile, only -Werror when no -W* in EXTRA_CFLAGS
Date: Wed, 27 Feb 2013 11:46:37 +0200
Message-ID: <1921426.IqHmmMU5eP@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.9.4 (Linux/3.5.0-25-generic; KDE/4.9.4; x86_64; ; )
In-Reply-To: <512DCA59.4040800@asianux.com>
References: <512DADCA.9040609@asianux.com> <1385870.TegBXpTM9i@lx-vladimir> <512DCA59.4040800@asianux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 27, 2013 04:56:57 PM Chen Gang wrote:
> 于 2013年02月27日 16:45, Vladimir Kondratiev 写道:
> > On Wednesday, February 27, 2013 02:55:06 PM Chen Gang wrote:
> >>
> >>   When make with EXTRA_CFLAGS=-W, it will report error.
> >>   so give a check in Makefile.
> >>
> >> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> >> ---
> >>  drivers/net/wireless/ath/wil6210/Makefile |    4 +++-
> >>  1 files changed, 3 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
> >> index 9396dc9..d288eea 100644
> >> --- a/drivers/net/wireless/ath/wil6210/Makefile
> >> +++ b/drivers/net/wireless/ath/wil6210/Makefile
> >> @@ -9,5 +9,7 @@ wil6210-objs += wmi.o
> >>  wil6210-objs += interrupt.o
> >>  wil6210-objs += txrx.o
> >>  
> >> -subdir-ccflags-y += -Werror
> >> +ifeq (, $(findstring -W,$(EXTRA_CFLAGS)))
> >> +	subdir-ccflags-y += -Werror
> >> +endif
> >>  subdir-ccflags-y += -D__CHECK_ENDIAN__
> >>
> > Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> > 
> > Well, agree; -W triggers lots of warnings, I suspect all other places that use
> > -Werror should be problematic. Worth fixing all others? Quick look for v3.8 raises:
> > 
> 
>   thank you for your suggestion.
>   after this patch applied, I will do for others (let you as signed-of-by, too).

Perhaps, it would be good idea to fight the original problem.

I mean, fix warnings where possible. Example: there are lots of
"unused parameter" ones. Where it is false warning, add __maybe_unused
attribute. Like this:

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c566927..83e43b7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -163,8 +163,9 @@ extern int _cond_resched(void);
 # define might_sleep() \
        do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
 #else
-  static inline void __might_sleep(const char *file, int line,
-                                  int preempt_offset) { }
+  static inline void __might_sleep(const char *file __maybe_unused,
+                                  int line __maybe_unused,
+                                  int preempt_offset __maybe_unused) { }
 # define might_sleep() do { might_resched(); } while (0)
 #endif
 

