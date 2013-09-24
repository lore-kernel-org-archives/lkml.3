Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab3IXIuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:50:00 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:37814 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3IXIt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:49:56 -0400
Message-ID: <5241522D.10008@colorfullife.com>
Date: Tue, 24 Sep 2013 10:49:49 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>, Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com> <1379625742.2145.19.camel@buesod1.americas.hpqcorp.net> <1379700524.5434.22.camel@flatline.rdu.redhat.com> <1379788235.2145.48.camel@buesod1.americas.hpqcorp.net> <CA+55aFwQp6Fm9-Zrn3uue9bFe9tERCbVv5Z-z9r4ZgOmS0VB+Q@mail.gmail.com> <1379918525.2231.0.camel@buesod1.americas.hpqcorp.net> <CA+55aFzVnivKb=nwzeTjGvi=LvnBLGnr=NZE+Ns6kLSm=WCN4w@mail.gmail.com> <1379981085.2060.18.camel@buesod1.americas.hpqcorp.net> <CA+55aFxLi7PNP-4-ouoPJYjOhRCttsP6YxbCHgE2+PNee3hVGg@mail.gmail.com>
In-Reply-To: <CA+55aFxLi7PNP-4-ouoPJYjOhRCttsP6YxbCHgE2+PNee3hVGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 09/24/2013 03:22 AM, Linus Torvalds wrote:
> On Mon, Sep 23, 2013 at 5:04 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> Ok, so here's the code - again I've tested it with LTP on the resources
>> I have.
> This looks good to me.
>
> Manfred, mind giving this a look-over and see if this resolves your
> race concerns too?
All race concerns with regards to code outside ipc are resolved.

My current list of open issues:

https://bugzilla.kernel.org/show_bug.cgi?id=61351
     Fix is in mm tree (ipc-semc-fix-race-in-sem_lock.patch)

https://bugzilla.kernel.org/show_bug.cgi?id=61321
https://bugzilla.kernel.org/show_bug.cgi?id=61331
https://bugzilla.kernel.org/show_bug.cgi?id=61341
     All 3 are fixed by Davidlohr's patch

https://bugzilla.kernel.org/show_bug.cgi?id=61361
https://bugzilla.kernel.org/show_bug.cgi?id=61371
     Both still open. The fix is trivial:
     Sprinkle a fair amount of "if (perm.deleted) return -EIDRM;" after 
ipc_lock.

And now new:
1) ipc/namespace.c:
     free_ipcs() still assumes the "old style" free calls:
     rcu_lock and ipc_lock dropped within the callback.

     freeary() was converted - but free_ipcs was not updated.

     Thus:
     Closing a namespace with sem arrays and threads that are waiting on 
the array with semtimedop() and bad timing can deadlock the semtimedop 
thread.
     (i.e.: spin_lock() waiting forever).

2) ipc/sem.c:
     The proc interface calls ipc_lock() directly - thus the exclusion 
of simple semop's is missing with sysvipc_sem_proc_show().
     A "sem_wait_array()" might be added as the first line into 
sysvipc_sem_proc_show().

     It's more a correctness thing: Nothing breaks if get_semotime() is 
called in parallel with simple ops.

3) The missing update of sem_otime for simple ops that Jia He found
http://marc.info/?l=linux-kernel&m=137981594522009&w=2

--
     Manfred
