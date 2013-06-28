Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3F1Waa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:30:30 -0400
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:14970 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab3F1Wa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:30:29 -0400
To: rostedt@goodmis.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org
Message-Id: <cover.1372457176.git.jbaron@akamai.com>
Subject: [PATCH 0/3] static keys: fix test/set races
Date: Fri, 28 Jun 2013 22:30:28 +0000 (GMT)
From: jbaron@akamai.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As pointed out by Andi Kleen, some static key users can be racy because they
check the value of the key->enabled, and then subsequently update the branch
direction. A number of call sites have 'higher' level locking that avoids this
race, but the usage in the scheduler features does not. See:
http://lkml.indiana.edu/hypermail/linux/kernel/1304.2/01655.html

Thus, introduce a new API that does the check and set under the
'jump_label_mutex'. This should also allow to simplify call sites a bit.

Users of static keys should use either the inc/dec or the set_true/set_false
API.

Thanks,

-Jason


Jason Baron (3):
  static_keys: Add a static_key_slow_set_true()/false() interface
  sched: fix static keys race in sched_feat
  udp: make use of static_key_slow_set_true() interface

 Documentation/static-keys.txt |    8 ++++++++
 include/linux/jump_label.h    |   30 ++++++++++++++++++++++++++++++
 kernel/jump_label.c           |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c           |   12 +++++-------
 kernel/sched/sched.h          |   10 +++++-----
 net/ipv4/udp.c                |    9 ++++-----
 net/ipv6/udp.c                |    9 ++++-----
 7 files changed, 96 insertions(+), 22 deletions(-)

-- 
1.7.9.5

