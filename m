Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaJWT2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:28:39 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:64898 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaJWT2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
From: Brian Silverman <bsilver16384@gmail.com>
Date: Thu, 23 Oct 2014 15:28:07 -0400
Message-ID: <CAP01z6LSTyS5FDgZTma96BY5eWycpHgECNwZSy2Afyn2UFH5yA@mail.gmail.com>
Subject: Re: [PATCH] futex: fix a race condition between REQUEUE_PI and task death
To: tglx@linutronix.de
Cc: Austin Schuh <austin.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Brian Silverman <bsilver16384@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the test code:

#define _GNU_SOURCE

#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <assert.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <inttypes.h>
#include <linux/futex.h>

// Whether to use a pthread mutex+condvar or do the raw futex operations. Either
// one will break.
// There's less user-space code involved with the non-pthread version, but the
// syscalls I think are relevant end up the same (except they're FUTEX_PRIVATE
// with the pthread version).
#define PTHREAD_MUTEX 0

// The number of processes that repeatedly call RunTest to fork off.
// Making this big (like 2500) makes it reproduce faster, but I have seen it go
// with as little as 4.
// With big values, `ulimit -u unlimited` (or something big at least) is
// necessary before running it (or do it as root).
#define NUMBER_TESTERS 2500

#if PTHREAD_MUTEX
#include <pthread.h>

typedef struct {
  pthread_mutex_t mutex;
  pthread_cond_t condition;
} Shared;
#else
typedef volatile uint32_t my_futex __attribute__((aligned(sizeof(int))));

void condition_wait(my_futex *c, my_futex *m) {
  syscall(SYS_futex, c, FUTEX_WAIT_REQUEUE_PI, *c, NULL, m);
}

void condition_signal(my_futex *c, my_futex *m) {
  syscall(SYS_futex, c, FUTEX_CMP_REQUEUE_PI, 1, 0, m, *c);
}

typedef struct {
  my_futex mutex;
  my_futex condition;
} Shared;
#endif

void RunTest(Shared *shared) {
#if PTHREAD_MUTEX
  pthread_mutexattr_t mutexattr;
  assert(pthread_mutexattr_init(&mutexattr) == 0);
  assert(pthread_mutexattr_setprotocol(&mutexattr, PTHREAD_PRIO_INHERIT) == 0);
  assert(pthread_mutex_init(&shared->mutex, &mutexattr) == 0);
  assert(pthread_mutexattr_destroy(&mutexattr) == 0);

  assert(pthread_cond_init(&shared->condition, NULL) == 0);
#else
  shared->mutex = shared->condition = 0;
#endif

  pid_t child = fork();
  if (child == 0) {
#if PTHREAD_MUTEX
    pthread_mutex_lock(&shared->mutex);
    pthread_cond_wait(&shared->condition, &shared->mutex);
#else
    condition_wait(&shared->condition, &shared->mutex);
#endif
    _exit(0);
  } else {
    assert(child != -1);
    // This sleep makes it reproduce way faster, but it will still break
    // eventually without it.
    usleep(20000);
#if PTHREAD_MUTEX
    assert(pthread_cond_broadcast(&shared->condition) == 0);
#else
    condition_signal(&shared->condition, &shared->mutex);
#endif
    assert(kill(child, SIGKILL) == 0);
    assert(waitpid(child, NULL, 0) == child);
  }
}

int main() {
  Shared *shared_memory = (Shared *)(mmap(NULL, sizeof(Shared) * NUMBER_TESTERS,
                                          PROT_READ | PROT_WRITE,
                                          MAP_SHARED | MAP_ANONYMOUS,
                                          -1, 0));
  int i;
  for (i = 0; i < NUMBER_TESTERS; ++i) {
    if (fork() == 0) {
      while (1) {
        RunTest(&shared_memory[i]);
      }
    }
  }
}

On Thu, Oct 23, 2014 at 3:22 PM, Brian Silverman <bsilver16384@gmail.com> wrote:
> pi_state_free and exit_pi_state_list both clean up futex_pi_state's.
> exit_pi_state_list takes the hb lock first, and most callers of
> pi_state_free do too. requeue_pi didn't, which causes lots of problems.
> Move the pi_state_free calls in requeue_pi to before it drops the hb
> locks which it's already holding.
>
> I have test code that forks a bunch of processes, which all fork more
> processes that do futex(FUTEX_WAIT_REQUEUE_PI), then do
> futex(FUTEX_CMP_REQUEUE_PI) before killing the waiting processes. That
> test consistently breaks QEMU VMs without this patch.
>
> Although they both make it faster to crash, CONFIG_PREEMPT_RT and lots
> of CPUs are not necessary to reproduce this problem. The symptoms range
> from random reboots to corrupting the test program to corrupting whole
> filesystems to strange BIOS errors. Crashdumps (when they get created at
> all) are usually a mess, to the point of crashing tools used to examine
> them.
>
> Signed-off-by: Brian Silverman <bsilver16384@gmail.com>
> ---
> I am not subscribed to the list so please CC me on any responses.
>
>  kernel/futex.c |   32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 815d7af..dc69775 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -639,6 +639,9 @@ static struct futex_pi_state * alloc_pi_state(void)
>         return pi_state;
>  }
>
> +/**
> + * Must be called with the hb lock held.
> + */
>  static void free_pi_state(struct futex_pi_state *pi_state)
>  {
>         if (!atomic_dec_and_test(&pi_state->refcount))
> @@ -1519,15 +1522,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
>         }
>
>  retry:
> -       if (pi_state != NULL) {
> -               /*
> -                * We will have to lookup the pi_state again, so free this one
> -                * to keep the accounting correct.
> -                */
> -               free_pi_state(pi_state);
> -               pi_state = NULL;
> -       }
> -
>         ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
>         if (unlikely(ret != 0))
>                 goto out;
> @@ -1558,6 +1552,14 @@ retry_private:
>                 ret = get_futex_value_locked(&curval, uaddr1);
>
>                 if (unlikely(ret)) {
> +                       if (flags & FLAGS_SHARED && pi_state != NULL) {
> +                               /*
> +                                * We will have to lookup the pi_state again, so
> +                                * free this one to keep the accounting correct.
> +                                */
> +                               free_pi_state(pi_state);
> +                               pi_state = NULL;
> +                       }
>                         double_unlock_hb(hb1, hb2);
>                         hb_waiters_dec(hb2);
>
> @@ -1617,6 +1619,10 @@ retry_private:
>                 case 0:
>                         break;
>                 case -EFAULT:
> +                       if (pi_state != NULL) {
> +                               free_pi_state(pi_state);
> +                               pi_state = NULL;
> +                       }
>                         double_unlock_hb(hb1, hb2);
>                         hb_waiters_dec(hb2);
>                         put_futex_key(&key2);
> @@ -1632,6 +1638,10 @@ retry_private:
>                          *   exit to complete.
>                          * - The user space value changed.
>                          */
> +                       if (pi_state != NULL) {
> +                               free_pi_state(pi_state);
> +                               pi_state = NULL;
> +                       }
>                         double_unlock_hb(hb1, hb2);
>                         hb_waiters_dec(hb2);
>                         put_futex_key(&key2);
> @@ -1708,6 +1718,8 @@ retry_private:
>         }
>
>  out_unlock:
> +       if (pi_state != NULL)
> +               free_pi_state(pi_state);
>         double_unlock_hb(hb1, hb2);
>         hb_waiters_dec(hb2);
>
> @@ -1725,8 +1737,6 @@ out_put_keys:
>  out_put_key1:
>         put_futex_key(&key1);
>  out:
> -       if (pi_state != NULL)
> -               free_pi_state(pi_state);
>         return ret ? ret : task_count;
>  }
>
> --
> 1.7.10.4
>
