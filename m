Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaDIARV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:17:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:24222 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaDIARR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:17:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,820,1389772800"; 
   d="scan'208";a="509621706"
From: "Brown, Len" <len.brown@intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/urgent] x86 idle: Repair large-server 50-watt
 idle-power regression
Thread-Topic: [tip:x86/urgent] x86 idle: Repair large-server 50-watt
 idle-power regression
Thread-Index: AQHPQj/VSN0qte0zpESrqfzfjeQLU5sIXnZg
Date: Tue, 8 Apr 2014 21:43:54 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C94845CA12EC@fmsmsx115.amr.corp.intel.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	 <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
	 <tip-40e2d7f9b5dae048789c64672bf3027fbb663ffa@git.kernel.org>
 <1395102010.2474.21.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1395102010.2474.21.camel@buesod1.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s390HSqW015428

Davidlohr,

Thanks for the note.

Ideally (on Linux in general, and on servers, in particular) we strive
for the performance impact of power saving features to be small enough
to be considered in "measurement noise".

Your report for 160 core Westmere AIM numbers being hit at 10-25%
shows 15% measurement noise?  But even if true, this looks bad.

Any chance you can re-run, with the following two tweaks,
one at a time?

I'd be curious if you can wrap the invocation in turbostat -v
and capture that output to how what states we are seeing
during the benchmark run.

thanks,
-Len



#1: skip flush for C1
	
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index f80b700..6027d06 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -377,7 +377,7 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	if (!current_set_polling_and_test()) {
 
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+		if ((eax > 0) && this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);


#2: skip flush for C1 and C1E
	
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index f80b700..6027d06 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -377,7 +377,7 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	if (!current_set_polling_and_test()) {
 
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+		if ((eax > 1) && this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
