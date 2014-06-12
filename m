Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaFLVqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:46:21 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:50172 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaFLVqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:46:19 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Per-task wait_queue_t
Organization: D03
References: <CA+55aFyYQES1CbEfYzRkFas_aw=+YNSbDoLRJpjh2sDFxVV3vg@mail.gmail.com>
	<1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140610155037.GG3213@twins.programming.kicks-ass.net>
X-Hashcash: 1:20:140612:michal.simek@xilinx.com::WDXFLy7zPNTCqQV2:000000000000000000000000000000000000000Cvs
X-Hashcash: 1:20:140612:riel@redhat.com::J28rF+BQc0DgFPIw:000Iac
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::AiwToMLNXShb9poo:0000000000000000000000000000000000000K2z
X-Hashcash: 1:20:140612:mingo@redhat.com::5AduebieD9t7rven:00mFv
X-Hashcash: 1:20:140612:peterz@infradead.org::+VngOH4zIT/V2LVE:00000000000000000000000000000000000000000104P
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::DzUTpqQv7d9bjxJ4:0000000000000000000000000000000001wmI
X-Hashcash: 1:20:140612:davidlohr@hp.com::PbkHnj5S+9TdbJOr:01gVw
X-Hashcash: 1:20:140612:ebiederm@xmission.com::izkoz3YKImUgebtw:00000000000000000000000000000000000000002Vjs
X-Hashcash: 1:20:140612:oleg@redhat.com::gGH86hVf8bfhPyCK:002wIR
X-Hashcash: 1:20:140612:torvalds@linux-foundation.org::kVTvHmxCrgylA6uk:000000000000000000000000000000002Wv/
X-Hashcash: 1:20:140612:rientjes@google.com::uBkQtFFnZsSb6M+j:0000000000000000000000000000000000000000009qKT
Date: Thu, 12 Jun 2014 23:46:13 +0200
In-Reply-To: <20140610155037.GG3213@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Tue, 10 Jun 2014 17:50:37 +0200")
Message-ID: <871tutol7e.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Jun 10, 2014 at 02:29:17PM +0200, Rasmus Villemoes wrote:
>> This is an attempt to reduce the stack footprint of various functions
>> (those using any of the wait_event_* macros), by removing the need to
>> allocate a wait_queue_t on the stack and instead use a single instance
>> embedded in task_struct. I'm not really sure where the best place to
>> put it is; I just placed it next to other list bookkeeping fields.
>> 
>> For now, there is a little unconditional debugging. This could later
>> be removed or maybe be made dependent on some CONFIG_* variable. The
>> idea of using ->flags is taken from Pavel [1] (I originally stored
>> (void*)1 into ->private).
>> 
>> Compiles, but not actually tested.
>> 
>
> Doesn't look too bad, would be good to be tested and have some numbers
> on the amount of stack saved etc..

Here are some numbers, and the fact that it only has a positive effect
on 28 functions, together with Oleg's concerns, makes me think that it's
probably not worth it.

(defconfig on x86_64, based on 3.15)

file                 function                       old  new  delta
vmlinux              i915_pipe_crc_read              120  136  +16
vmlinux              try_to_free_pages               144  136   -8
vmlinux              mousedev_read                   112   96  -16
vmlinux              sky2_probe                      192  176  -16
vmlinux              gss_cred_init                   136  120  -16
vmlinux              do_coredump                     296  280  -16
vmlinux              md_do_sync                      360  344  -16
vmlinux              save_image_lzo                  200  168  -32
vmlinux              read_events                     184  152  -32
vmlinux              loop_make_request                96   64  -32
vmlinux              i801_access                     104   72  -32
vmlinux              tty_port_block_til_ready        104   72  -32
vmlinux              loop_thread                     152  120  -32
vmlinux              evdev_read                      136  104  -32
vmlinux              __sb_start_write                 96   64  -32
vmlinux              rfkill_fop_read                 104   72  -32
vmlinux              intel_dp_aux_ch                 152  120  -32
vmlinux              i801_transaction                 96   64  -32
vmlinux              blk_mq_queue_enter               96   64  -32
vmlinux              cypress_send_ext_cmd            152  104  -48
vmlinux              rcu_gp_kthread                  120   72  -48
vmlinux              locks_mandatory_area            264  216  -48
vmlinux              hub_thread                      232  184  -48
vmlinux              start_this_handle               120   72  -48
vmlinux              autofs4_wait                    136   88  -48
vmlinux              fcntl_setlk                     136   88  -48
vmlinux              load_module                     264  216  -48
vmlinux              serport_ldisc_read              144   96  -48
vmlinux              sg_read                         160  112  -48

Rasmus
