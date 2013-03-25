Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab3CYVOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:14:25 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:42593 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab3CYVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:14:24 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, linaro-kernel@lists.linaro.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "open list\:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for !CONFIG_KVM
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
	<1363823921.25034.35@snotra> <20130321072955.GO3889@redhat.com>
	<87ppyshlq5.fsf@linaro.org> <1363891354.31522.17@snotra>
	<20130321191600.GG9382@redhat.com> <1363894393.31522.20@snotra>
	<20130321211736.GI9382@redhat.com>
	<CAFTL4hz2=VJBLG1w31JSPDtRdobcmL5oY6XkR46vi3zS904VGA@mail.gmail.com>
	<20130324140114.GV3889@redhat.com>
Date: Mon, 25 Mar 2013 14:14:20 -0700
In-Reply-To: <20130324140114.GV3889@redhat.com> (Gleb Natapov's message of
	"Sun, 24 Mar 2013 16:01:14 +0200")
Message-ID: <87txnz9o7n.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

> On Sun, Mar 24, 2013 at 02:44:26PM +0100, Frederic Weisbecker wrote:
>> 2013/3/21 Gleb Natapov <gleb@redhat.com>:
>> > Isn't is simpler for kernel/context_tracking.c to define empty
>> > __guest_enter()/__guest_exit() if !CONFIG_KVM.
>> 
>> That doesn't look right. Off-cases are usually handled from the
>> headers, right? So that we avoid iffdeffery ugliness in core code.
> Lets put it in linux/context_tracking.h header then.

Here's a version to do that.

Kevin

>From d9d909394479dd7ff90b7bddb95a564945406719 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Mon, 25 Mar 2013 14:12:41 -0700
Subject: [PATCH v2] ontext_tracking: fix !CONFIG_KVM compile: add stub guest
 enter/exit

When KVM is not enabled, or not available on a platform, the KVM
headers should not be included.  Instead, just define stub
__guest_[enter|exit] functions.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 include/linux/context_tracking.h | 7 +++++++
 kernel/context_tracking.c        | 1 -
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 365f4a6..9d0f242 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,6 +3,13 @@
 
 #include <linux/sched.h>
 #include <linux/percpu.h>
+#if IS_ENABLED(CONFIG_KVM)
+#include <linux/kvm_host.h>
+#else
+#define __guest_enter()
+#define __guest_exit()
+#endif
+
 #include <asm/ptrace.h>
 
 struct context_tracking {
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 65349f0..85bdde1 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/context_tracking.h>
-#include <linux/kvm_host.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/hardirq.h>
-- 
1.8.2

