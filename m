Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3BEDlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 22:41:09 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:27859 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3BEDlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:41:07 -0500
Message-ID: <51107F42.1090401@huawei.com>
Date: Tue, 5 Feb 2013 11:40:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 1/4] eventfd: introduce eventfd_signal_hangup()
References: <510CB733.2080904@huawei.com> <510CB744.7000300@huawei.com> <20130202155858.GA13022@shutemov.name> <20130204101521.GA18322@shutemov.name>
In-Reply-To: <20130204101521.GA18322@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/4 18:15, Kirill A. Shutemov wrote:
> On Sat, Feb 02, 2013 at 05:58:58PM +0200, Kirill A. Shutemov wrote:
>> On Sat, Feb 02, 2013 at 02:50:44PM +0800, Li Zefan wrote:
>>> When an eventfd is closed, a wakeup with POLLHUP will be issued,
>>> but cgroup wants to issue wakeup explicitly, so when a cgroup is
>>> removed userspace can be notified.
>>>
>>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Hm.. Looks like it will break eventfd semantics:
> 
> 1. One eventfd can be used for deliver more then one notification from
> one or more cgroups. POLLHUP on removing one of cgroups is not valid.
> 
> 2. It's valid to have eventfd opened only by one userspace application. We
> should not close it, just because cgroup is removed.
> 
> I think problem with multiple threads waiting an event on eventfd should
> be handled in userspace.
> 

I didn't realize this.. and if a cgroup is removed, the woken thread may not
be the thread that is waiting on this cgroup. How crappy.. I don't know how
userspace is going to deal with all these.

And another bug spotted. We can pass fd of memory.usage_in_bytes of cgroup A
to cgroup.event_control of cgroup B, and then we won't get memory usage
notification from A but B! What's worse, if A and B are in different mount
hierarchy, boom!


Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3d21adf..e496359 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3825,6 +3825,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
 	struct cgroup_event *event = NULL;
+	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
 	struct file *efile = NULL;
 	struct file *cfile = NULL;
@@ -3880,6 +3881,16 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 		goto fail;
 	}
 
+	/*
+	 * The file to be monitored must be in the same cgroup as
+	 * cgroup.event_control is.
+	 */
+	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
+	if (cgrp_cfile != cgrp) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	if (!event->cft->register_event || !event->cft->unregister_event) {
 		ret = -EINVAL;
 		goto fail;
-- 
1.8.0.2


