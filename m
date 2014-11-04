Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaKDByL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:54:11 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:43381 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaKDByH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:54:07 -0500
Date: Mon, 3 Nov 2014 17:54:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Using list_for_each_entry() in place of
 list_for_each_entry_rcu() ?
Message-ID: <20141104015403.GV5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201411012059.JHB90633.HtJOSOVLFFQFMO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201411012059.JHB90633.HtJOSOVLFFQFMO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110401-0033-0000-0000-0000028FE27D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 08:59:03PM +0900, Tetsuo Handa wrote:
> Excuse me for FAQ, Paul.

No problem -- this one took some thought.

> I want to confirm one thing for code optimization in LSM stacking.
> ( https://marc.info/?l=linux-security-module&m=141481716931982&w=2 )
> 
> In the following code, is there race window for seeing invalid
> "struct list_head"->next value if we used list_for_each_entry()
> in place of list_for_each_entry_rcu() ?
> 
> ----------
> /* Definition and declaration */
> DEFINE_SPINLOCK(my_lock);
> LIST_HEAD(my_list);
> struct my_struct {
>     struct list_head list;
>     const unsigned long value;
> } v1 = { .value = 1 }, v2 = { .value = 2 }, v3 = { .value = 3 };

OK, v1, v2, and v3 are assigned at compile time.  Therefore, all CPUs
should be aware of their values -- if module loading were to fail
to make this guarantee, lots of things would break.  However, their
initial ->list->next and ->list->prev values are NULL, courtesy of the
C initialization rules.

> /* Writer side */
> void add_entry(struct my_struct *p) {
>     spin_lock(&my_lock);
>     list_add_tail_rcu(&p->list, &my_list);

But we are adding to the tail of the list, so the initial NULL value
for ->list->next is correct anyway -- but only the first time they
are added to the list.  If they were to be added to the list a second
time, and if something had been added after them during their first time
in the list, then the initial ->list->next value would no longer be
guaranteed to be seen as NULL by all other CPUs.

So if you do need to add them to the list a second time, one
way to do so safely is to use list_add_tail_rcu() when adding
and list_for_each_entry_rcu() -- enclosed in rcu_read_lock() and
rcu_read_unlock() -- when traversing.  As always, you need to wait for
a grace period between the time you remove the element from the list
the first time and the time you add it to the list the second time.

Or you could do the following after deleting the element from the list:

o	Wait for a grace period to elapse.

o	NULL the ->list->next pointer.

o	Wait for another grace period to elapse.

Then all CPUs would agree that the value of ->list->next was NULL, so
list_for_each_entry() could be used to traverse the list.  But you would
still need rcu_read_lock() and rcu_read_unlock() around the traversal.

But if you only ever add it to the list that one time, then the
list_for_each_entry_rcu() could become list_for_each_entry(), and
rcu_read_lock() and rcu_read_unlock() are not needed.  Again, this
assumes that the memory is never reused after being removed from the list.

Note that in this case module unload followed by module reload is tricky.
You have to "wait long enough" between unload and load.  Or you need an
orderly teardown of some sort.

>     spin_unlock(&my_lock);
> }
> 
> void del_entry(struct my_struct *p) {
>     spin_lock(&my_lock);
>     list_del_rcu(&p->list);
>     spin_unlock(&my_lock);
> }
> 
> /* Reader side */
> unsigned long reader(void) {
>     struct my_struct *p;
>     unsigned long sum = 0;
>     list_for_each_entry_rcu(p, &my_list, list)
>         sum += p->value;
>     return sum;
> }
> ----------
> 
> Assumptions are:
> 
>   (1) v1, v2, v3 are statically allocated variables inside module,
>       while my_lock, my_list, add_entry(), del_entry(), reader()
>       are built-in.

When you say that my_lock and my_list are built-in, you mean that they
are defined in the base kernel rather than in the module?  (I was assuming
that they were defined in the module.)

>   (2) v1, v2, v3 are added to my_list only once upon module load
> 
>   (3) v1, v2, v3 might be removed from my_list some time later after
>       module was loaded

Again, module unload followed by module load will be a bit dicey.  Other
than that, it should work.

							Thanx, Paul

