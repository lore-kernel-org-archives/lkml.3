Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaIPX4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:56:18 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:61381 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaIPX4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:56:17 -0400
MIME-Version: 1.0
Date: Tue, 16 Sep 2014 16:56:16 -0700
Message-ID: <CAM_iQpVNzx1r8x-bP5CoiCX8PFk15JYHw_XfpYvJGgdkFHj8Gw@mail.gmail.com>
Subject: Kernel crash in cgroup_pidlist_destroy_work_fn()
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a11333dc84687730503377fa7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11333dc84687730503377fa7
Content-Type: text/plain; charset=UTF-8

Hi, Tejun


We saw some kernel null pointer dereference in
cgroup_pidlist_destroy_work_fn(), more precisely at
__mutex_lock_slowpath(), on 3.14. I can show you the full stack trace
on request.

Looking at the code, it seems flush_workqueue() doesn't care about new
incoming works, it only processes currently pending ones, if this is
correct, then we could have the following race condition:

cgroup_pidlist_destroy_all():
        //...
        mutex_lock(&cgrp->pidlist_mutex);
        list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links)
                mod_delayed_work(cgroup_pidlist_destroy_wq,
&l->destroy_dwork, 0);
        mutex_unlock(&cgrp->pidlist_mutex);

        // <--- another process calls cgroup_pidlist_start() here
since mutex is released

        flush_workqueue(cgroup_pidlist_destroy_wq); // <--- another
process adds new pidlist and queue work in pararell
        BUG_ON(!list_empty(&cgrp->pidlists)); // <--- This check is
passed, list_add() could happen after this


Therefore, the newly added pidlist will point to a freed cgroup, and
when it is freed in the delayed work we will crash.

The attached patch (compile test ONLY) could be a possible fix, since
it will check and hold a refcount on this cgroup in
cgroup_pidlist_start(). But I could very easily miss something here
since there are many cgroup changes after 3.14 and I don't follow
cgroup development.

What do you think?

Thanks.

--001a11333dc84687730503377fa7
Content-Type: text/plain; charset=US-ASCII; name="cgroup.diff"
Content-Disposition: attachment; filename="cgroup.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i05wdl4n0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAuYyBiL2tlcm5lbC9jZ3JvdXAuYwppbmRleCA5NDBh
Y2VkLi4yMjA2MTUxIDEwMDY0NAotLS0gYS9rZXJuZWwvY2dyb3VwLmMKKysrIGIva2VybmVsL2Nn
cm91cC5jCkBAIC00MDg0LDYgKzQwODQsOSBAQCBzdGF0aWMgdm9pZCAqY2dyb3VwX3BpZGxpc3Rf
c3RhcnQoc3RydWN0IHNlcV9maWxlICpzLCBsb2ZmX3QgKnBvcykKIAlpbnQgaW5kZXggPSAwLCBw
aWQgPSAqcG9zOwogCWludCAqaXRlciwgcmV0OwogCisJaWYgKCFjZ3JvdXBfdHJ5Z2V0KGNncnAp
KQorCQlyZXR1cm4gTlVMTDsKKwogCW11dGV4X2xvY2soJmNncnAtPnBpZGxpc3RfbXV0ZXgpOwog
CiAJLyoKQEAgLTQxMzIsMTMgKzQxMzUsMTUgQEAgc3RhdGljIHZvaWQgKmNncm91cF9waWRsaXN0
X3N0YXJ0KHN0cnVjdCBzZXFfZmlsZSAqcywgbG9mZl90ICpwb3MpCiAKIHN0YXRpYyB2b2lkIGNn
cm91cF9waWRsaXN0X3N0b3Aoc3RydWN0IHNlcV9maWxlICpzLCB2b2lkICp2KQogeworCXN0cnVj
dCBjZ3JvdXAgKmNncnAgPSBzZXFfY3NzKHMpLT5jZ3JvdXA7CiAJc3RydWN0IGtlcm5mc19vcGVu
X2ZpbGUgKm9mID0gcy0+cHJpdmF0ZTsKIAlzdHJ1Y3QgY2dyb3VwX3BpZGxpc3QgKmwgPSBvZi0+
cHJpdjsKIAogCWlmIChsKQogCQltb2RfZGVsYXllZF93b3JrKGNncm91cF9waWRsaXN0X2Rlc3Ry
b3lfd3EsICZsLT5kZXN0cm95X2R3b3JrLAogCQkJCSBDR1JPVVBfUElETElTVF9ERVNUUk9ZX0RF
TEFZKTsKLQltdXRleF91bmxvY2soJnNlcV9jc3MocyktPmNncm91cC0+cGlkbGlzdF9tdXRleCk7
CisJbXV0ZXhfdW5sb2NrKCZjZ3JwLT5waWRsaXN0X211dGV4KTsKKwljZ3JvdXBfcHV0KGNncnAp
OwogfQogCiBzdGF0aWMgdm9pZCAqY2dyb3VwX3BpZGxpc3RfbmV4dChzdHJ1Y3Qgc2VxX2ZpbGUg
KnMsIHZvaWQgKnYsIGxvZmZfdCAqcG9zKQo=
--001a11333dc84687730503377fa7--
