Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3IRTId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:08:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab3IRTID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:08:03 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/8] Audit backlog queue fixes related to soft lockup
Date: Wed, 18 Sep 2013 15:06:45 -0400
Message-Id: <cover.1379530867.git.rgb@redhat.com>
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset covers a number of issues surrounding the audit backlog queue.
The original trigger was a bug in a patch to fix code that produced negative
sleep times (commit 82919919).  This bug caused soft lockups.  There were a
number of other issues raised surrounding this bug which have been attempted
to be addressed in this patchset.

The first patch fixes this obvious bug.

The 2nd fixes the lack of reset to the original wait time that was set to
zero under error conditions should the system recover from the conditions that
tickled the first bug.

The 3rd makes use of the remaining timeout to avoid re-checking the loop
conditions on error.

The 4th and 5th are efficiency fixes for waking up waiting processes only when
necessary.

The 6th adds a boot parameter to temporarily override the backlog queue length
in case more buffers are needed before auditd is available.

The 7th and 8th are to add a config option to make the backlog wait time
configurable from the hard-coded default.


Richard Guy Briggs (8):
  audit: avoid soft lockup due to audit_log_start() incorrect loop
    termination
  audit: reset audit backlog wait time after error recovery
  audit: make use of remaining sleep time from wait_for_auditd
  audit: efficiency fix 1: only wake up if queue shorter than backlog
    limit
  audit: efficiency fix 2: request exclusive wait since all need same
    resource
  audit: add boot option to override default backlog limit
  audit: clean up AUDIT_GET/SET local variables and future-proof API
  audit: add audit_backlog_wait_time configuration option

 include/uapi/linux/audit.h |    2 +
 kernel/audit.c             |  111 +++++++++++++++++++++++++++++++-------------
 2 files changed, 80 insertions(+), 33 deletions(-)

