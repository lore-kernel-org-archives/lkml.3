Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbaKAL7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 07:59:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:24044 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaKAL7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 07:59:08 -0400
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Using list_for_each_entry() in place of list_for_each_entry_rcu() ?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201411012059.JHB90633.HtJOSOVLFFQFMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 1 Nov 2014 20:59:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excuse me for FAQ, Paul.
I want to confirm one thing for code optimization in LSM stacking.
( https://marc.info/?l=linux-security-module&m=141481716931982&w=2 )

In the following code, is there race window for seeing invalid
"struct list_head"->next value if we used list_for_each_entry()
in place of list_for_each_entry_rcu() ?

----------
/* Definition and declaration */
DEFINE_SPINLOCK(my_lock);
LIST_HEAD(my_list);
struct my_struct {
    struct list_head list;
    const unsigned long value;
} v1 = { .value = 1 }, v2 = { .value = 2 }, v3 = { .value = 3 };

/* Writer side */
void add_entry(struct my_struct *p) {
    spin_lock(&my_lock);
    list_add_tail_rcu(&p->list, &my_list);
    spin_unlock(&my_lock);
}

void del_entry(struct my_struct *p) {
    spin_lock(&my_lock);
    list_del_rcu(&p->list);
    spin_unlock(&my_lock);
}

/* Reader side */
unsigned long reader(void) {
    struct my_struct *p;
    unsigned long sum = 0;
    list_for_each_entry_rcu(p, &my_list, list)
        sum += p->value;
    return sum;
}
----------

Assumptions are:

  (1) v1, v2, v3 are statically allocated variables inside module,
      while my_lock, my_list, add_entry(), del_entry(), reader()
      are built-in.

  (2) v1, v2, v3 are added to my_list only once upon module load

  (3) v1, v2, v3 might be removed from my_list some time later after
      module was loaded

Regards.
