Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaKDLSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:18:14 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:27665 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaKDLSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:18:11 -0500
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Using list_for_each_entry() in place of list_for_each_entry_rcu() ?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201411012059.JHB90633.HtJOSOVLFFQFMO@I-love.SAKURA.ne.jp>
	<20141104015403.GV5718@linux.vnet.ibm.com>
In-Reply-To: <20141104015403.GV5718@linux.vnet.ibm.com>
Message-Id: <201411042018.FBG60918.JOMOLOtHFQSVFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 4 Nov 2014 20:18:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> But if you only ever add it to the list that one time, then the
> list_for_each_entry_rcu() could become list_for_each_entry(), and
> rcu_read_lock() and rcu_read_unlock() are not needed.  Again, this
> assumes that the memory is never reused after being removed from the list.

That is what I wanted to confirm. v1, v2, v3 are added to the list only
once, and mymodule.ko containing v1, v2, v3 are not unload-able.

> Note that in this case module unload followed by module reload is tricky.
> You have to "wait long enough" between unload and load.  Or you need an
> orderly teardown of some sort.

Yes, I'm aware of that.

> > Assumptions are:
> > 
> >   (1) v1, v2, v3 are statically allocated variables inside module,
> >       while my_lock, my_list, add_entry(), del_entry(), reader()
> >       are built-in.
> 
> When you say that my_lock and my_list are built-in, you mean that they
> are defined in the base kernel rather than in the module?  (I was assuming
> that they were defined in the module.)

I meant built-in as built into vmlinux. That is, my_lock, my_list,
add_entry(), del_entry(), reader() are defined in vmlinux , and v1, v2, v3
are defined in mymodule.ko .

> 
> >   (2) v1, v2, v3 are added to my_list only once upon module load
> > 
> >   (3) v1, v2, v3 might be removed from my_list some time later after
> >       module was loaded
> 
> Again, module unload followed by module load will be a bit dicey.  Other
> than that, it should work.
> 
> 							Thanx, Paul
> 

If someone really needs to implement unload-able modules, he/she can
split such modules into non unload-able component and unload-able
component.

-------- non unload-able component --------
static DEFINE_SRCU(my_srcu_lock);
static int (*do_getvalue)(void);

static int mywrapper_getvalue(void)
{
    const int idx = srcu_read_lock(&my_srcu_lock);
    const typeof(do_getvalue) func = do_getvalue;
    const int ret = func ? func() : 0;
    srcu_read_unlock(&my_srcu_lock, idx);
    return ret;
}

void mywrapper_register(typeof(do_getvalue) func)
{
    do_getvalue = func;
}
EXPORT_SYMBOL_GPL(mywrapper_register);

void mywrapper_unregister(void)
{
    do_getvalue = NULL;
    synchronize_srcu(&my_srcu_lock);
}
EXPORT_SYMBOL_GPL(mywrapper_unregister);

struct my_struct {
    struct list_head list;
    const int (*func)(void);
} v1 = { .func = mywrapper_getvalue };

static int __init mywrapper_init(void)
{
    add_entry(&v1);
    return 0;
}
module_init(mywrapper_init);
-------- non unload-able component --------

-------- unload-able component --------
static int do_getvalue(void)
{
    return (...snipped...);
}

static int __init mymodule_init(void)
{
    mywrapper_register(do_getvalue);
    return 0;
}
module_init(mymodule_init);

static void mymodule_exit(void)
{
    mywrapper_unregister();
}
module_exit(mymodule_exit);
-------- unload-able component --------

Thank you.
