Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaJOPsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:48:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5072 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaJOPr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:47:59 -0400
From: "Denis V. Lunev" <den@openvz.org>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Raushaniya Maksudova <rmaksudova@parallels.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 0/2] shrink virtio baloon on OOM in guest
Date: Wed, 15 Oct 2014 19:47:42 +0400
Message-Id: <1413388064-5354-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.9.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excessive virtio_balloon inflation can cause invocation of OOM-killer, when
Linux is under severe memory pressure. Various mechanisms are responsible for
correct virtio_balloon memory management. Nevertheless it is often the case
that these control tools does not have enough time to react on fast changing
memory load. As a result OS runs out of memory and invokes OOM-killer.
The balancing of memory by use of the virtio balloon should not cause the
termination of processes while there are pages in the balloon. Now there is
no way for virtio balloon driver to free memory at the last moment before
some process get killed by OOM-killer.

This does not provide a security breach as baloon itself is running
inside guest OS and is working in the cooperation with the host. Thus
some improvements from guest side should be considered as normal.

To solve the problem, introduce a virtio_balloon callback which is expected
to be called from the oom notifier call chain in out_of_memory() function.
If virtio balloon could release some memory, it will make the system to
return and retry the allocation that forced the out of memory killer to run.

Patch 1 of this series adds support for implementation of virtio_balloon
callback, so now leak_balloon() function returns number of freed pages.
Patch 2 implements virtio_balloon callback itself.

Changes from v2:
- added feature bit to control OOM baloon behavior from host
Changes from v1:
- minor cosmetic tweaks suggested by rusty@

Signed-off-by: Raushaniya Maksudova <rmaksudova@parallels.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Michael S. Tsirkin <mst@redhat.com>

