Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3CVACU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:02:20 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33944 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3CVACT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:02:19 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Scott Wood <scottwood@freescale.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list\:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for !CONFIG_KVM
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
	<1363823921.25034.35@snotra> <20130321072955.GO3889@redhat.com>
	<87ppyshlq5.fsf@linaro.org> <1363891354.31522.17@snotra>
	<20130321191600.GG9382@redhat.com> <1363894393.31522.20@snotra>
	<20130321211736.GI9382@redhat.com>
Date: Thu, 21 Mar 2013 17:02:15 -0700
In-Reply-To: <20130321211736.GI9382@redhat.com> (Gleb Natapov's message of
	"Thu, 21 Mar 2013 23:17:36 +0200")
Message-ID: <878v5ggv3s.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

> On Thu, Mar 21, 2013 at 02:33:13PM -0500, Scott Wood wrote:
>> On 03/21/2013 02:16:00 PM, Gleb Natapov wrote:
>> >On Thu, Mar 21, 2013 at 01:42:34PM -0500, Scott Wood wrote:
>> >> On 03/21/2013 09:27:14 AM, Kevin Hilman wrote:
>> >> >Gleb Natapov <gleb@redhat.com> writes:
>> >> >
>> >> >> On Wed, Mar 20, 2013 at 06:58:41PM -0500, Scott Wood wrote:
>> >> >>> Why can't the entirety kvm_host.h be included regardless of
>> >> >>> CONFIG_KVM, just like most other feature-specific headers?  Why
>> >> >>> can't the if/else just go around the functions that you want to
>> >> >stub
>> >> >>> out for non-KVM builds?
>> >> >>>
>> >> >> Kevin,
>> >> >>
>> >> >>  What compilation failure this patch fixes? I presume
>> >something ARM
>> >> >> related.
>> >> >
>> >> >Not specficially ARM related, but more context tracking related
>> >since
>> >> >kernel/context_tracking.c pulls in kvm_host.h, which attempts to
>> >> >pull in
>> >> ><asm/kvm*.h> which may not exist on some platforms.
>> >> >
>> >> >At least for ARM, KVM support was added in v3.9 so this patch can
>> >> >probably be dropped since the non-KVM builds on ARM now work.
>> >But any
>> >> >platform without the <asm/kvm*.h> will still be broken when
>> >trying to
>> >> >build the context tracker.
>> >>
>> >> Maybe other platforms should get empty asm/kvm*.h files.  Is there
>> >> anything from those files that the linux/kvm*.h headers need to
>> >> build?
>> >>
>> >arch things. kvm_vcpu_arch, kvm_arch_memory_slot, kvm_arch etc.
>> 
>> Could define them as empty structs.
>> 
> Isn't is simpler for kernel/context_tracking.c to define empty
> __guest_enter()/__guest_exit() if !CONFIG_KVM.

I proposed something like that in an earlier version but Frederic asked
me to propose a fix to the KVM headers instead.

Just in case fixing the context tracking subsystem is preferred, 
the patch below fixes the problem also.

Kevin

>From f22995a262144d0d61705fa72134694d911283eb Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Thu, 21 Mar 2013 16:57:14 -0700
Subject: [PATCH] context_tracking: fix !CONFIG_KVM compile: add stub guest
 enter/exit

When KVM is not enabled, or not available on a platform, the KVM
headers should not be included.  Instead, just define stub
__guest_[enter|exit] functions.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 kernel/context_tracking.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 65349f0..64b0f80 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -15,12 +15,18 @@
  */
 
 #include <linux/context_tracking.h>
-#include <linux/kvm_host.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/hardirq.h>
 #include <linux/export.h>
 
+#if IS_ENABLED(CONFIG_KVM)
+#include <linux/kvm_host.h>
+#else
+#define __guest_enter()
+#define __guest_exit()
+#endif
+
 DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE
 	.active = true,
-- 
1.8.2

