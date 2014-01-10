Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaAJDVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:21:10 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:39423 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJDVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:21:05 -0500
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] percpu-ida/iscsi-target: Address connection reset starved tag hang
Date: Fri, 10 Jan 2014 03:00:44 +0000
Message-Id: <1389322847-6570-1-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This short series addresses a bug in >= v3.12 iscsi-target code where
a connection reset occuring once percpu_ida_alloc() goes into starved
tag uninterruptible sleep mode causes an indefinate hang, due to the
SIGINT being ignored that normally forces the sleeping rx thread into
connection cleanup state.

This includes modifying existing percpu_ida_alloc() to allow an state
to be passed so that TASK_INTERRUPTIBLE may be optionally set to
address this particular case with iscsi-target, and also includes a
simple backwards compatibility wrapper for existing consumers.

It also bumps the number of pre-allocated tags by double the allowed
per session CmdSN queue_depth in order to avoid the percpu_ida_alloc()
straved tags slow path during normal ExpStatSN acknowledgement if at
all possible.

Thank you,

--nab

Kent Overstreet (1):
  percpu_ida: Add tag alloc interface for interruptible sleep

Nicholas Bellinger (2):
  iscsi-target: Fix connection reset hang with percpu_ida_alloc
  iscsi-target: Pre-allocate more tags to avoid ack starvation

 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 drivers/target/iscsi/iscsi_target_util.c |    8 ++++++--
 include/linux/percpu_ida.h               |   11 ++++++++++-
 lib/percpu_ida.c                         |   13 +++++++++----
 4 files changed, 26 insertions(+), 8 deletions(-)

-- 
1.7.10.4

