Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3KGAfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:35:21 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48533 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3KGAfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:35:19 -0500
Date: Wed, 6 Nov 2013 16:35:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sameer Nanda <snanda@chromium.org>
cc: Luigi Semenzato <semenzato@google.com>, msb@facebook.com,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>, oleg@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, oom: Fix race when selecting process to kill
In-Reply-To: <CANMivWZhNRGW6DPcqpYiUBjOX23LRZ_kJ9DzzfS7VdRpm075ZA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311061631280.22318@chino.kir.corp.google.com>
References: <1383693987-14171-1-git-send-email-snanda@chromium.org> <alpine.DEB.2.02.1311051715090.29471@chino.kir.corp.google.com> <CAA25o9SFZW7JxDQGv+h43EMSS3xH0eXy=LoHO_Psmk_n3dxqoA@mail.gmail.com> <alpine.DEB.2.02.1311051727090.29471@chino.kir.corp.google.com>
 <CANMivWZrefY1bbgpJgABqcUwKfqOR9HQtGNY6cWdutcMASeo2A@mail.gmail.com> <CAA25o9QG2BOmV5MoXCH73sadKoRD6wPivKq6TLvEem8GhZeXGg@mail.gmail.com> <CAA25o9Q-HvjQ_5pFJgYNeutaCoYgPu=e=k7EHq=6-+jeEuhzoA@mail.gmail.com>
 <CANMivWZhNRGW6DPcqpYiUBjOX23LRZ_kJ9DzzfS7VdRpm075ZA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Sameer Nanda wrote:

> David -- I think we can make the duration that the tasklist_lock is
> held smaller by consolidating the process selection logic that is
> currently split across select_bad_process and oom_kill_process into
> one place in select_bad_process.  The tasklist_lock would then need to
> be held only when the thread lists are being traversed.  Would you be
> ok with that?  I can re-spin the patch if that sounds like a workable
> option.
> 

No, this caused hundreds of machines to hit soft lockups for Google 
because there's no synchronization that prevents dozens of cpus to take 
tasklist_lock in the oom killer during parallel memcg oom conditions and 
never allow the write_lock_irq() on fork() or exit() to make progress.  We 
absolutely must hold tasklist_lock for as little time as possible in the 
oom killer.

That said, I've never actually seen your reported bug manifest in our 
production environment so let's see if Oleg has any ideas.
