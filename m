Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3KLUJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:09:16 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34457 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3KLUJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:09:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131112200156.GA9820@redhat.com>
References: <20131109151639.GB14249@redhat.com> <1384215717-2389-1-git-send-email-snanda@chromium.org>
 <20131112200156.GA9820@redhat.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Tue, 12 Nov 2013 12:08:44 -0800
X-Google-Sender-Auth: dGa8csmMTtrWbT6PFMCZEc0e1sg
Message-ID: <CANMivWZFXYGB_95WqToKEUyMsKMS2nQ4p5a_-Lte-=bhCC5u2g@mail.gmail.com>
Subject: Re: [PATCH v4] mm, oom: Fix race when selecting process to kill
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Luigi Semenzato <semenzato@google.com>, murzin.v@gmail.com,
        dserrg@gmail.com, "msb@chromium.org" <msb@chromium.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 12:01 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 11/11, Sameer Nanda wrote:
>>
>> The selection of the process to be killed happens in two spots:
>> first in select_bad_process and then a further refinement by
>> looking for child processes in oom_kill_process. Since this is
>> a two step process, it is possible that the process selected by
>> select_bad_process may get a SIGKILL just before oom_kill_process
>> executes. If this were to happen, __unhash_process deletes this
>> process from the thread_group list. This results in oom_kill_process
>> getting stuck in an infinite loop when traversing the thread_group
>> list of the selected process.
>>
>> Fix this race by adding a pid_alive check for the selected process
>> with tasklist_lock held in oom_kill_process.
>
> OK, looks correct to me. Thanks.
>
>
> Yes, this is a step backwards, hopefully we will revert this patch soon.
> I am starting to think something like while_each_thread_lame_but_safe()
> makes sense before we really fix this nasty (and afaics not simple)
> problem with with while_each_thread() (which should die).

Looking forward to a real fix for the nasty problems with
while_each_thread.  In the meanwhile, let me float one more
(hopefully, the last) version of this patch that should address
Michal's concern.  Thanks for your feedback!

>
> Oleg.
>



-- 
Sameer
