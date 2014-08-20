Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaHTQvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaHTQvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:51:36 -0400
Date: Wed, 20 Aug 2014 18:49:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Ungerer <gerg@uclinux.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/2] make /proc/PID/*maps* namespace friendly
Message-ID: <20140820164922.GA17589@redhat.com>
References: <20140805194627.GA30693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Lets continue the boring proc/maps cleanups.

Eric, I do agree that the tgid vs pid logic looks strange, but I didn't
even try to change it. Let's at least fix the namespace problems first.
This is minor, but it is shame that /proc/pid/maps still shows the pid
from the global namespace. And this is preparation for the next change.

With this change the only user of proc_maps_private->task is
hold_task_mempolicy/release_task_mempolicy. I believe this code is buggy
and should die, but this needs the changes in mm/mempolicy.c.

After that we can kill priv->task. task_nommu.c can be updated right now,
but it would be better to change it along with task_mmu.c (we have a small
complication with -ESRCH).

Oleg.

 fs/proc/internal.h   |    2 +-
 fs/proc/task_mmu.c   |   29 +++++++++++++++++++++++------
 fs/proc/task_nommu.c |   25 ++++++++++++++++++++++---
 include/linux/mm.h   |    4 ++--
 mm/util.c            |   23 ++++++++---------------
 5 files changed, 56 insertions(+), 27 deletions(-)

