Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaIXLAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:00:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58500 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaIXLAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:00:48 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-3c-5422a45eb56d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, naushad@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] kobject: fix NULL pointer derefernce in kobj_child_ns_ops
Date: Wed, 24 Sep 2014 16:25:54 +0530
Message-id: <1411556154-14464-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWyRsSkVjduiVKIwdEF8hbNi9ezWVzeNYfN
	4tPR/6wWi7Z+YXdg8dg/dw27R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGWsO7aEsaBPqOLS
	u/uMDYwX+LsYOTkkBEwk7n2bxQZhi0lcuLceyObiEBJYyigx7cMRJpiiFx29rBCJ6YwSv18t
	YYFwJjBJvG1ezw5SxSagK/Hk/VxmEFtEQEFic+8zVhCbWSBOYs6bd2C2sICXxM17yxlBbBYB
	VYnl67rAbF4BD4m+yU+AajiAtilIzJlkAzJfQuA2m8Tmxh5miHoBiW+TD7FA1MhKbDrADHGc
	pMTBFTdYJjAKLmBkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGISn/z2bsIPx3gHrQ4wC
	HIxKPLwTxJVChFgTy4orcw8xmgJtmMgsJZqcDwz1vJJ4Q2MzIwtTE1NjI3NLMyVx3tdSP4OF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MPYYfbczqfdS21bt+KJj+un65r+nX+06wfn0ZeAX
	1wJ7XlWNqyfW93y977fgur7akYpJj4UPNC0QO9EQK5O782v8iw6Hhe7MtWopMz+5utfdZHsu
	fvvgUtvIhjcS0emGkooeHm7RYsusRXIP/rSMCwk+ffKteouJ+rGAkgudcRwHX//yzhPwVGIp
	zkg01GIuKk4EAMpZmqc9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jQd24JUohBt/6JSyaF69ns7i8aw6b
	xaej/1ktFm39wu7A4rF/7hp2j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMWHdsCWNBn1DFpXf3GRsYL/B3MXJySAiYSLzo6GWFsMUkLtxbz9bFyMUh
	JDCdUeL3qyUsEM4EJom3zevZQarYBHQlnryfywxiiwgoSGzufQbWzSwQJzHnzTswW1jAS+Lm
	veWMIDaLgKrE8nVdYDavgIdE3+QnQDUcQNsUJOZMspnAyL2AkWEVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRnCIP5PawbiyweIQowAHoxIP742FSiFCrIllxZW5hxglOJiVRHhf9QCFeFMS
	K6tSi/Lji0pzUosPMZoCLZ/ILCWanA+Mv7ySeENjE3NTY1NLEwsTM0slcd4DrdaBQgLpiSWp
	2ampBalFMH1MHJxSDYwL2N46SwnFFzC9vbBW6eKbr11Ofl81JorOZHo7201JfPWJ1/tMr3ee
	4L8SZ1BZGlT4m+GR1yUhg82+feWam7/wX7pze3rRhg75KrVrDG+MLKTWllbPP3xw5/O5b04s
	D02YPnOqq11Lb75E+t2ls149vNgx6d2ipINq3lvmxm05c8d9tZ5yB8NaJZbijERDLeai4kQA
	6wDPRocCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will hit NULL pointer dereference if we call
platform_device_register_simple or platform_device_add at very early
stage. I have observed following crash when called platform_device_add
from "init_irq" hook of machine_desc. This patch fixes this issue and
let system handle this case gracefully instead of kernel panic.

[0.000000] Unable to handle kernel NULL pointer dereference at
virtual address 0000000c
[0.000000] pgd = c0004000
[0.000000] [0000000c] *pgd=00000000
[0.000000] Internal error: Oops: 5 [#1] PREEMPT ARM
[0.000000] Modules linked in:
[0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W
3.17.0-rc6-00198-ga1603f1-dirty #319
[0.000000] task: c05b23f0 ti: c05a8000 task.ti: c05a8000
[0.000000] PC is at kobject_namespace+0x18/0x58
[0.000000] LR is at kobject_add_internal+0x90/0x2ec
[snip]
[0.000000] [<c01b1df0>] (kobject_namespace) from [<c01b2338>]
(kobject_add_internal+0x90/0x2ec)
[0.000000] [<c01b2338>] (kobject_add_internal) from [<c01b2728>]
(kobject_add+0x4c/0x98)
[0.000000] [<c01b2728>] (kobject_add) from [<c0226274>]
(device_add+0xe8/0x51c)
[0.000000] [<c0226274>] (device_add) from [<c0229c70>]
(platform_device_add+0xb4/0x214)
[0.000000] [<c0229c70>] (platform_device_add) from [<c022a338>]
(platform_device_register_full+0xb8/0xdc)
[0.000000] [<c022a338>] (platform_device_register_full) from
[<c0570214>] (exynos_init_irq+0x90/0x9c)
[0.000000] [<c0570214>] (exynos_init_irq) from [<c056c18c>]
(init_IRQ+0x2c/0x78)
[0.000000] [<c056c18c>] (init_IRQ) from [<c0569a54>]
(start_kernel+0x22c/0x378)
[0.000000] [<c0569a54>] (start_kernel) from [<40008070>]
(0x40008070)
[0.000000] Code: e590000c e3500000 0a00000e e5903014 (e593300c)

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 lib/kobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 58751bb..03d4ab3 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -976,7 +976,7 @@ const struct kobj_ns_type_operations *kobj_child_ns_ops(struct kobject *parent)
 {
 	const struct kobj_ns_type_operations *ops = NULL;
 
-	if (parent && parent->ktype->child_ns_type)
+	if (parent && parent->ktype && parent->ktype->child_ns_type)
 		ops = parent->ktype->child_ns_type(parent);
 
 	return ops;
-- 
1.7.9.5

