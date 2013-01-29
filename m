Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3A2PeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:34:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab3A2Pd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:33:59 -0500
Date: Tue, 29 Jan 2013 10:33:48 -0500
From: Don Zickus <dzickus@redhat.com>
To: Mike Lykov <combr@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma
 initramfs on slow cpu
Message-ID: <20130129153348.GR98867@redhat.com>
References: <5107D1D3.6040105@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5107D1D3.6040105@yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, Jan 29, 2013 at 05:42:43PM +0400, Mike Lykov wrote:
> 
> So my questions:
> 
> 1. Are there a BUG in soft lockup detection mechanizm? Changing
> watchdog_thresh to 30 have a side effect in production - D-state
> userspace processes will be detected slowly. Are there a need to
> detecting soft lockups at boot time? Maybe it need after initramfs
> boot only when userspace processes begin to work?

The softlockup mechanism works scheduling a high priority task that kicks
the softlockups.  If the unzip thread is taking too long, it could
accidentally trip the detection.

Seeing that you are running on a 600 MHz machine, it could be possible.
Though I am not entirely sure how the scheduling works for decompressing
the initramfs.  I wouldn't think it is that high of a priority.

> 
> 2. How to change watchdog_thresh parameter at boot without patching
> sources? If it necessary (with it side effects) maybe implement it
> as commandline parameter or config compile time parameter?

I attached a patch below that allows you to set it a boot time.  Let me
know if this works for you, then I can clean it up and post it properly.

Cheers,
Don


diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..e448d63 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -79,6 +79,14 @@ static int __init softlockup_panic_setup(char *str)
 }
 __setup("softlockup_panic=", softlockup_panic_setup);
 
+static int __init watchdog_thresh_setup(char *str)
+{
+	watchdog_thresh = simple_strtoul(str, NULL, 0);
+
+	return 1;
+}
+__setup("watchdog_thresh=", watchdog_thresh_setup);
+
 static int __init nowatchdog_setup(char *str)
 {
 	watchdog_enabled = 0;
