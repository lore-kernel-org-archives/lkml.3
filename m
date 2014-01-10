Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaAJF4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 00:56:30 -0500
Received: from mail.efficios.com ([78.47.125.74]:49518 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbaAJF42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 00:56:28 -0500
Date: Fri, 10 Jan 2014 05:56:25 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1593870977.5807.1389333385962.JavaMail.zimbra@efficios.com>
In-Reply-To: <1151498255.5788.1389332631491.JavaMail.zimbra@efficios.com>
Subject: Intel MIC host driver: possible signed underflow (undefined
 behavior) in userspace API
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF26 (Linux)/8.0.5_GA_5839)
Thread-Topic: Intel MIC host driver: possible signed underflow (undefined behavior) in userspace API
Thread-Index: QeCHs/Yx1grPtGsMrULzdh0kKp+bSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at this commit:

commit f69bcbf3b4c4b333dcd7a48eaf868bf0c88edab5
Author: Ashutosh Dixit <ashutosh.dixit@intel.com>
Date:   Thu Sep 5 16:42:18 2013 -0700

    Intel MIC Host Driver Changes for Virtio Devices.

Especially at:

+struct mic_copy_desc {
+#ifdef __KERNEL__
+       struct iovec __user *iov;
+#else
+       struct iovec *iov;
+#endif
+       int iovcnt;
+       __u8 vr_idx;
+       __u8 update_used;
+       __u32 out_len;
+};

Seeing iovcnt being declared as a signed integer seems strange. The
first question would be: why is it signed rather than unsigned ?

Then, looking further into 

drivers/misc/mic/host/mic_virtio.c:_mic_virtio_copy()

We can see that the while() loop iterates until the local variable
iovcnt reaches the value 0 (and iovcnt is also a signed integer). If
user-space passes e.g. INT_MIN as iovcnt field, this loop then appears
to depend on an undefined behavior (signed underflow) to complete.
Wouldn't it be better to use an unsigned integers both in the
userspace API and for the local variable ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
