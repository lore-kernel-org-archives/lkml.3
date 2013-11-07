Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3KGTfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:35:12 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40506 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3KGTfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:35:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311061631280.22318@chino.kir.corp.google.com>
References: <1383693987-14171-1-git-send-email-snanda@chromium.org>
 <alpine.DEB.2.02.1311051715090.29471@chino.kir.corp.google.com>
 <CAA25o9SFZW7JxDQGv+h43EMSS3xH0eXy=LoHO_Psmk_n3dxqoA@mail.gmail.com>
 <alpine.DEB.2.02.1311051727090.29471@chino.kir.corp.google.com>
 <CANMivWZrefY1bbgpJgABqcUwKfqOR9HQtGNY6cWdutcMASeo2A@mail.gmail.com>
 <CAA25o9QG2BOmV5MoXCH73sadKoRD6wPivKq6TLvEem8GhZeXGg@mail.gmail.com>
 <CAA25o9Q-HvjQ_5pFJgYNeutaCoYgPu=e=k7EHq=6-+jeEuhzoA@mail.gmail.com>
 <CANMivWZhNRGW6DPcqpYiUBjOX23LRZ_kJ9DzzfS7VdRpm075ZA@mail.gmail.com> <alpine.DEB.2.02.1311061631280.22318@chino.kir.corp.google.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Thu, 7 Nov 2013 11:34:43 -0800
X-Google-Sender-Auth: m-7OqlRjQgIEYxDHWxgyWgztBVk
Message-ID: <CANMivWYzp_Eqw3BjeUz5ycQLftBuHjcZ7ZoFEwazekJNY2cJXA@mail.gmail.com>
Subject: Re: [PATCH] mm, oom: Fix race when selecting process to kill
To: David Rientjes <rientjes@google.com>
Cc: Luigi Semenzato <semenzato@google.com>, msb@facebook.com,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>, oleg@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 4:35 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 6 Nov 2013, Sameer Nanda wrote:
>
>> David -- I think we can make the duration that the tasklist_lock is
>> held smaller by consolidating the process selection logic that is
>> currently split across select_bad_process and oom_kill_process into
>> one place in select_bad_process.  The tasklist_lock would then need to
>> be held only when the thread lists are being traversed.  Would you be
>> ok with that?  I can re-spin the patch if that sounds like a workable
>> option.
>>
>
> No, this caused hundreds of machines to hit soft lockups for Google
> because there's no synchronization that prevents dozens of cpus to take
> tasklist_lock in the oom killer during parallel memcg oom conditions and
> never allow the write_lock_irq() on fork() or exit() to make progress.  We
> absolutely must hold tasklist_lock for as little time as possible in the
> oom killer.
>
> That said, I've never actually seen your reported bug manifest in our
> production environment so let's see if Oleg has any ideas.

Is the path you are referring to mem_cgroup_out_of_memory calling
oom_kill_process?  If so, then that path doesn't appear to suffer from
the two step select_bad_process, oom_kill_process race since
mem_cgroup_out_of_memory directly calls oom_kill_process without going
through select_bad_process.  This also means that the patch I sent is
incorrect since it removes the existing tasklist_lock protection in
oom_kill_process.

Respinning patch to take care of this case.

-- 
Sameer
