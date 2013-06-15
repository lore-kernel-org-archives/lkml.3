Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3FOHaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 03:30:15 -0400
Received: from mout.gmx.net ([212.227.15.19]:50184 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3FOHaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 03:30:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Y8Ps3sxKYTE6xH90Um7WCchNXsb0FuVjNCqrHC7
	4Bmov9ZqTlL3z0
Message-ID: <1371281407.5789.24.camel@marge.simpson.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Jun 2013 09:30:07 +0200
In-Reply-To: <1371275319.5789.13.camel@marge.simpson.net>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
	 <51BB38FA.6080607@colorfullife.com>
	 <1371236750.5796.54.camel@marge.simpson.net>
	 <51BBFB34.20206@colorfullife.com>
	 <1371275319.5789.13.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-15 at 07:48 +0200, Mike Galbraith wrote: 
> On Sat, 2013-06-15 at 07:27 +0200, Manfred Spraul wrote:
> 
> > Assume there is one op (semctl(), whatever) that acquires the global 
> > lock - and a continuous stream of simple ops.
> > - spin_is_locked() returns true due to the semctl().
> > - then simple ops will switch to spin_lock(&sma->sem_perm.lock).
> > - since the spinlock is acquired, the next operation will get true from 
> > spin_is_locked().
> > 
> > It will stay that way around - as long as there is at least one op 
> > waiting for sma->sem_perm.lock.
> > With enough cpus, it will stay like this forever.
> 
> Yup, pondered that yesterday, scratching my head over how to do better.
> Hints highly welcome.  Maybe if I figure out how to scratch dual lock
> thingy properly for -rt, non-rt will start acting sane too, as that spot
> seems to be itchy in both kernels.

Gee, just trying to flip back to a single semaphore lock mode if you had
to do the global wait thing fixed up -rt.  10 consecutive sem-waitzero 5
8 64 runs with the 3.8-rt9 kernel went like so, which is one hell of an
improvement.

Result matrix:
  Thread   0: 20209311
  Thread   1: 20255372
  Thread   2: 20082611
...
  Thread  61: 20162924
  Thread  62: 20048995
  Thread  63: 20142689

I must have screwed up something :)

static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
                              int nsops)
{
        struct sem *sem;
        int locknum;

        if (nsops == 1 && !sma->complex_count) {
                sem = sma->sem_base + sops->sem_num;

                /*
                 * Another process is holding the global lock on the
                 * sem_array; we cannot enter our critical section,
                 * but have to wait for the global lock to be released.
                 */
                if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
                        spin_lock(&sma->sem_perm.lock);
                        if (sma->complex_count)
                                goto wait_array;

                        /*
                         * Acquiring our sem->lock under the global lock
                         * forces new complex operations to wait for us
                         * to exit our critical section.
                         */
                        spin_lock(&sem->lock);
                        spin_unlock(&sma->sem_perm.lock);
                } else {
                        /* Lock just the semaphore we are interested in. */
                        spin_lock(&sem->lock);

                        /*
                         * If sma->complex_count was set prior to acquisition,
                         * we must fall back to the global array lock.
                         */
                        if (unlikely(sma->complex_count)) {
                                spin_unlock(&sem->lock);
                                goto lock_array;
                        }
                }

                locknum = sops->sem_num;
        } else {
                int i;
                /*
                 * Lock the semaphore array, and wait for all of the
                 * individual semaphore locks to go away.  The code
                 * above ensures no new single-lock holders will enter
                 * their critical section while the array lock is held.
                 */
 lock_array:
                spin_lock(&sma->sem_perm.lock);
 wait_array:
                for (i = 0; i < sma->sem_nsems; i++) {
                        sem = sma->sem_base + i;
#ifdef CONFIG_PREEMPT_RT_BASE
                        if (spin_is_locked(&sem->lock))
#endif
                        spin_unlock_wait(&sem->lock);
                }
                locknum = -1;

                if (nsops == 1 && !sma->complex_count) {
                        sem = sma->sem_base + sops->sem_num;
                        spin_lock(&sem->lock);
                        spin_unlock(&sma->sem_perm.lock);
                        locknum = sops->sem_num;
                }
        }
        return locknum;
}

Not very pretty, but it works markedly better.

