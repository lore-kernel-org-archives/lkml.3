Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423589Ab3CVXBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 19:01:08 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:64496 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423377Ab3CVXBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 19:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <1363809337-29718-8-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<1363809337-29718-8-git-send-email-riel@surriel.com>
Date: Fri, 22 Mar 2013 16:01:05 -0700
Message-ID: <CANN689FT6LGtFykOScV29MzZp2qeooaXZSeFp6_HhEF20g7ZMg@mail.gmail.com>
Subject: Re: [PATCH 7/7] ipc,sem: fine grained locking for semtimedop
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@surriel.com>
Cc: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, lwoodman@redhat.com,
        chegu_vinod@hp.com, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply; I've been swamped and am behind on my upstream mail.

On Wed, Mar 20, 2013 at 12:55 PM, Rik van Riel <riel@surriel.com> wrote:
> +static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
> +                             int nsops)
> +{
> +       int locknum;
> +       if (nsops == 1 && !sma->complex_count) {
> +               struct sem *sem = sma->sem_base + sops->sem_num;
> +
> +               /* Lock just the semaphore we are interested in. */
> +               spin_lock(&sem->lock);
> +
> +               /*
> +                * If sma->complex_count was set while we were spinning,
> +                * we may need to look at things we did not lock here.
> +                */
> +               if (unlikely(sma->complex_count)) {
> +                       spin_unlock(&sma->sem_perm.lock);

I believe this should be spin_unlock(&sem->lock) instead ?

> +                       goto lock_all;
> +               }
> +               locknum = sops->sem_num;
> +       } else {
> +               int i;
> +               /* Lock the sem_array, and all the semaphore locks */
> + lock_all:
> +               spin_lock(&sma->sem_perm.lock);
> +               for (i = 0; i < sma->sem_nsems; i++) {

Do we have to lock every sem from the array instead of just the ones
that are being operated on in sops ?
(I'm not sure either way, as I don't fully understand the queueing of
complex ops)

If we want to keep the loop as is, then we may at least remove the
sops argument to sem_lock() since we only care about nsops.

> +                       struct sem *sem = sma->sem_base + i;
> +                       spin_lock(&sem->lock);
> +               }
> +               locknum = -1;
> +       }
> +       return locknum;
> +}

That's all I have. Very nice test results BTW!

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
