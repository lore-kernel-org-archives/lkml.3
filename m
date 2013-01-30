Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3A3Pvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:51:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3A3Pvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:51:31 -0500
Date: Wed, 30 Jan 2013 10:51:21 -0500
From: Don Zickus <dzickus@redhat.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: Mike Lykov <combr@yandex.ru>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma
 initramfs on slow cpu
Message-ID: <20130130155121.GF98867@redhat.com>
References: <5107D1D3.6040105@yandex.ru>
 <20130129153348.GR98867@redhat.com>
 <1359479907.1641.161.camel@anish-Inspiron-N5050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359479907.1641.161.camel@anish-Inspiron-N5050>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:48:27PM +0530, anish kumar wrote:
> Sorry for digressing from the topic but I think there is something wrong
> with my understanding or something wrong with the code.So I guess Don
> can clarify this.
> If I pass this below parameter during boot i.e. setting watchdog_enabled
> to zero.
> __setup("nowatchdog", nowatchdog_setup);
> 
> Now I use sysctl to enable the watchdog then wouldn't the below code
> will hinder enabling the watchdog?
> 
> static void watchdog_enable_all_cpus(void)
> {//snip
>         if (watchdog_disabled) {  /* this is zero ?? */
>                 watchdog_disabled = 0;
> //snip
> }
> 
> Should watchdog_disabled be set to 1?Or is it that we always disable the
> watchdog and then enable it?

It seems like a bug, so does something like this fix it?  There is
probably a better way to handle the internal representation of the
watchdog state (watchdog_disable) and the procfs version
(watchdog_enable), but I just can't think of something right now. :-(

Cheers,
Don


diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..d287726 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -82,6 +82,7 @@ __setup("softlockup_panic=", softlockup_panic_setup);
 static int __init nowatchdog_setup(char *str)
 {
 	watchdog_enabled = 0;
+	watchdog_disabled =1;
 	return 1;
 }
 __setup("nowatchdog", nowatchdog_setup);
